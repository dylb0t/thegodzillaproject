#!/bin/bash

# trap '{ echo "Ctrl-C caught." ;sed -i '$ d' metadata; echo -e "\t}\n]" >> metadata; end=`date +%s`; runtime=$((end-start)); echo "Script executed, randomized and compiled $pigNumber 3D Pigs in $runtime seconds..."; exit 1; }' INT
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
# just list the contents of the folder in question for *.js and reference that js. You can use sed. Also put the pig number in the page title
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
    echo "Script executed, randomized and compiled $pigNumber 3D Pigs in $runtime seconds..."
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
        gltf.scene.traverse( function ( child ) {
            if ( child.isMesh ) {
                child.castShadow = true; 
            }
        } );
        gltf.scene.position.y += 10.2
        scene.add( gltf.scene );
        render();
        } );
EOF
}

# iterate through all resource directories to populate resource arrays
# Note that we are adding a final "None" option, as that is an option too

let i=0
faces[i]="NONE"
let "i++"
for filename in $(ls ../src/models/face); do
    faces[i]="/face/$filename"
    let i=i+1
done


let i=0
glasses[i]="NONE"
let "i++"
for filename in $(ls ../src/models/glasses); do
    glasses[i]="/glasses/$filename"
    let i=i+1
done

let i=0
hats[i]="NONE"
let "i++"
for filename in $(ls ../src/models/hats); do
    hats[i]="/hats/$filename"
    let i=i+1
done

let i=0
accessories[i]="NONE"
let "i++"
for filename in $(ls ../src/models/accessories); do
    accessories[i]="/accessories/$filename"
    let i=i+1
done

let i=0
necklaces[i]="NONE"
let "i++"
for filename in $(ls ../src/models/necklace); do
    necklaces[i]="/necklace/$filename"
    let i=i+1
done

let i=0
shirts[i]="NONE"
let "i++"
for filename in $(ls ../src/models/shirts); do
    shirts[i]="/shirts/$filename"
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
hrNames=("Body" "Accessory" "Face" "Glasses" "Hat" "Necklace" "Shirt" "Eyes")
arNames=("bodies" "accessories" "faces" "glasses" "hats" "necklaces" "shirts" "eyes")
# Every pig needs a body... So we will do the randomization for every single body
# And we will just do pignumbers from zero
let pigNumber=0
#start metadata
echo "[" > metadata

#LOOP START
while [ true ]
do
    dig[0]=$(( $RANDOM % (${#bodies[@]}) ))
    dig[1]=$(( $RANDOM % (${#accessories[@]}) ))
    dig[2]=$(( $RANDOM % (${#faces[@]}) ))
    dig[3]=$(( $RANDOM % (${#glasses[@]}) ))
    dig[4]=$(( $RANDOM % (${#hats[@]}) ))
    dig[5]=$(( $RANDOM % (${#necklaces[@]}) ))
    dig[6]=$(( $RANDOM % (${#shirts[@]}) ))
    dig[7]=$(( $RANDOM % (${#eyes[@]}) ))

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
        for i in {0..7}; do
            #echo $i
            rando=${dig[$i]}
            if [ $rando -eq 0 ] && [ $i -ne 0 ] # Zeros are always "NONE", except when a body
            then
                echo -e "\t\t\"${hrNames[$i]}\": \"None\"," >> metadata
                # if hats are none, hair is none too
                if [ $i -eq 4 ]
                then
                    echo -e "\t\t\"Hair\": \"None\"," >> metadata
                fi
            else
                declare -n index=${arNames[$i]}
                modelPath=${index[$rando]}
                modelBase=$(basename ${index[$rando]} .gltf)
                #if its a hat then we have to see if its hair
                if [ $i -eq 4 ]
                then
                    #echo $modelBase
                    case $modelBase in
                    *cut)
                        echo -e "\t\t\"Hair\": \"$modelBase\"," >> metadata
                        echo -e "\t\t\"Hat\": \"None\"," >> metadata
                    ;;
                    *)
                        echo -e "\t\t\"Hair\": \"None\"," >> metadata
                        echo -e "\t\t\"Hat\": \"$modelBase\"," >> metadata
                    ;;
                    esac
                else
                echo -e "\t\t\"${hrNames[$i]}\": \"$modelBase\"," >> metadata
                fi
                insertresource $modelPath $gltfCount
                #echo $modelPath
                let "gltfCount++"
            fi
        done
        echo -e "\t\t\"tokenId\": \"$pigNumber\"\n\t}," >> metadata
        
        #insert the footer of the file
        cat ./bottomfile.js >> tempfile

        #finally publish the tempfile to the pig output
        mkdir -p ./output/$pigNumber
        cat ./tempfile > ./output/$pigNumber/index.js

        npm start -- --env pigNumber=$pigNumber

        end=`date +%s`
        runtime=$((end-start))
        echo "Script prgress: Randomized and compiled $pigNumber 3D Pigs in $runtime seconds..."

        #increment the pig number
        let "pigNumber++"
        echo "Pig Number $pigNumber"
    fi
 

done





