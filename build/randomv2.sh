#!/bin/bash

# trap '{ echo "Ctrl-C caught." ;sed -i '$ d' metadata; echo -e "\t}\n]" >> metadata; end=`date +%s`; runtime=$((end-start)); echo "Script executed, randomized and compiled $zillaNumber 3D zillas in $runtime seconds..."; exit 1; }' INT
#trap 'echo "Ctrl-C caught.";sed -i '$ d' metadata; exit 1' INT
# TODO
#
# (DONE) maybe do a clean and change the html folder to RandomizedJS folder or something
# 
# Run webpack compiler. You can use awk or sed to modify a webpack config before running webpack on that particular directory. Just set the entry there
# will need to modify output to output to a particular folder as well
# Will also need to test the files to make sure everything is accessible before compilation to make sure it will end up with the appropriate resources.
# example entry /src/html/0/filename.js output [hash] will go to dist then copy all or you can perhaps just set the output directory to the new directory
#
# create html file at the end of the js bulding loop
# just list the contents of the folder in question for *.js and reference that js. You can use sed. Also put the zilla number in the page title
#

# model itself could use a loading page
# Also perhaps some more chunking
# Also perhaps some more optimizations

start=`date +%s`

#For finishing up when interrupt is caught
exitfn () {
    trap SIGINT              # Restore signal handling for SIGINT
    echo
    echo "Ctrl-C caught." 
    sed -i '$ d' metadata
    echo -e "\t}\n]" >> metadata; end=`date +%s`
    runtime=$((end-start))
    echo "Script executed, randomized and compiled $zillaNumber 3D zillas in $runtime seconds..."
    exit 

}

trap "exitfn" INT
# function to insert resources into the final gltf
# expected argument is the path to the resource
# expected local file named tempFile
# expected count of gltf model in collection
insertresource() {
    #First, add the gltf to the top of the file so it will get included when webpack is run
    #The count is so we make sure each one is unique
    echo -e "import gltfPath$2 from '../../../src/models$1'; \n$(cat tempfile)" > tempfile
    
cat <<-EOF >> tempfile
        loader.load( gltfPath$2, function ( gltf ) {
        gltf.scene.position.y += .5
        scene.add( gltf.scene );
        render();
        } );
EOF
}

insertshadowresource() {
    #First, add the gltf to the top of the file so it will get included when webpack is run
    #The count is so we make sure each one is unique
    echo -e "import gltfPath$2 from '../../../src/models$1'; \n$(cat tempfile)" > tempfile
    
cat <<-EOF >> tempfile
        loader.load( gltfPath$2, function ( gltf ) {
        gltf.scene.traverse( function ( child ) {
            if ( child.isMesh ) {
                child.castShadow = true; 
            }
        } );
        gltf.scene.position.y += .5
        scene.add( gltf.scene );
        render();
        } );
EOF
}

# iterate through all resource directories to populate resource arrays
# Note that we are adding a final "None" option, as that is an option too

let i=0
for filename in $(ls ../src/models/wings); do
    wings[i]="/wings/$filename"
    let i=i+1
done

let i=0
mouths[i]="NONE"
let "i++"
for filename in $(ls ../src/models/mouths); do
    mouths[i]="/mouths/$filename"
    let i=i+1
done

let i=0
for filename in $(ls ../src/models/eyebrows); do
    eyebrows[i]="/eyebrows/$filename"
    let i=i+1
done

let i=0
horntips[i]="NONE"
let "i++"
for filename in $(ls ../src/models/horntips); do
    horntips[i]="/horntips/$filename"
    let i=i+1
done

let i=0
necklaces[i]="NONE"
let "i++"
for filename in $(ls ../src/models/necklaces); do
    necklaces[i]="/necklaces/$filename"
    let i=i+1
done

let i=0
for filename in $(ls ../src/models/horns); do
    horns[i]="/horns/$filename"
    let i=i+1
done

let i=0
for filename in $(ls ../src/models/bodies); do
    bodies[i]="/bodies/$filename"
    let i=i+1
done

let i=0
for filename in $(ls ../src/models/eyes); do
    eyes[i]="/eyes/$filename"
    let i=i+1
done

# Metadata human readable names
hrNames=("Body" "Eyebrows" "Eyes" "Horn" "Wings" "Mouth" "Necklace" "Horn Tip")
arNames=("bodies" "eyebrows" "eyes" "horns" "wings" "mouths" "necklaces" "horntips")
# Every zilla needs a body... So we will do the randomization for every single body
# And we will just do zillanumbers from zero
let zillaNumber=0
#start metadata
echo "[" > metadata

#LOOP START
while [ true ]
do
    dig[0]=$(( $RANDOM % (${#bodies[@]}) ))
    dig[1]=$(( $RANDOM % (${#eyebrows[@]}) ))
    dig[2]=$(( $RANDOM % (${#eyes[@]}) ))
    dig[3]=$(( $RANDOM % (${#horns[@]}) ))
    dig[4]=$(( $RANDOM % (${#wings[@]}) ))
    dig[5]=$(( $RANDOM % (${#mouths[@]}) ))
    dig[6]=$(( $RANDOM % (${#necklaces[@]}) ))
    dig[7]=$(( $RANDOM % (${#horntips[@]}) ))

    #echo ${dig[0]}${dig[1]}${dig[2]}${dig[3]}${dig[4]}${dig[5]}${dig[6]}${dig[7]}

    # build number from array
    serialNumber=${dig[0]}${dig[1]}${dig[2]}${dig[3]}${dig[4]}${dig[5]}${dig[6]}${dig[7]}
    echo $serialNumber
    # see if number was already drawn
    if [[ " ${serialNumbers[*]} " =~ " ${serialNumber} " ]]; then
        # whatever you want to do when array contains value
        echo "OH MY GOD A DUPLICATE!"
        echo $serialNumber
    else

        serialNumbers=( "${serialNumbers[@]}" "$serialNumber" )
        
        echo -e "\t{\n\t\t\"serialNumber\": \"$serialNumber\"," >> metadata 

        #Reset GLTF counter
        let gltfCount=0
        #insert the header of the file
        cat ./topfile.js > tempfile

        let i=0
        # for each type of model
        for i in {0..7}; do
            #echo $i
            rando=${dig[$i]}

            # https://stackoverflow.com/questions/16553089/dynamic-variable-names-in-bash
            declare -n index=${arNames[$i]}
            # declare -n is required in linux, trying IFS method for mac. Typeset didn't work, also printf didn't work.
            #typeset index=${arNames[$i]}
            #printf -v "$index" `%s` ${arNames[$i]}
            #IFS= read -r "$index" <<< ${arNames[$i]}
            # echo "index $index"
            # echo "index [rando] ${index[$rando]}"
            # echo "arnames [i] ${arNames[$i]}"
            modelPath=${index[$rando]}
            if [modelPath = 'NONE']
            then
                echo -e "\t\t\"${hrNames[$i]}\": \"None\"," >> metadata
            else
                modelBase=$(basename ${index[$rando]} .gltf)
                echo -e "\t\t\"${hrNames[$i]}\": \"$modelBase\"," >> metadata
                insertresource $modelPath $gltfCount
            fi
            #echo $modelPath
            let "gltfCount++"

        done
        echo -e "\t\t\"tokenId\": \"$zillaNumber\"\n\t}," >> metadata
        
        #insert the footer of the file
        cat ./bottomfile.js >> tempfile

        #finally publish the tempfile to the zilla output
        mkdir -p ./output/$zillaNumber
        cat ./tempfile > ./output/$zillaNumber/index.js

        npm start -- --env zillaNumber=$zillaNumber

        end=`date +%s`
        runtime=$((end-start))

        #increment the zilla number
        let "zillaNumber++"
        echo "New Model Number $zillaNumber"

        echo "Script prgress: Randomized and compiled $zillaNumber New Models in $runtime seconds..."
    fi
 

done





