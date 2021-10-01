#!/bin/bash


# TODO
# create html file at the end of the js bulding loop
# just list the contents of the folder in question for *.js and reference that js. You can use sed. Also put the pig number in the page title
#
# Run webpack compiler. You can use awk or sed to modify a webpack config before running webpack on that particular directory. Just set the entry there
# will need to modify output to output to a particular folder as well
# Will also need to test the files to make sure everything is accessible before compilation to make sure it will end up with the appropriate resources.



# function to insert resources into the final gltf
# expected argument is the path to the resource
# expected local file named tempFile
# expected count of gltf model in collection
insertresource() {
    #First, add the gltf to the top of the file so it will get included when webpack is run
    #The count is so we make sure each one is unique
    echo -e "import gltfPath$2 from '../../models$1'; \n$(cat tempfile)" > tempfile
    
cat <<-EOF >> tempfile
        loader.load( \$gltfPath$2, function ( gltf ) {
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
for filename in $(ls ../src/models/face); do
    faces[i]="/face/$filename"
    let i=i+1
done
faces[i]="NONE"

let i=0
for filename in $(ls ../src/models/glasses); do
    glasses[i]="/glasses/$filename"
    let i=i+1
done
glasses[i]="NONE"

let i=0
for filename in $(ls ../src/models/hats); do
    hats[i]="/hats/$filename"
    let i=i+1
done
hats[i]="NONE"


# Every pig needs a body... So we will do the randomization for every single body
# And we will just do pignumbers from zero
let pigNumber=0
#start metadata
echo "[" > metadata
for filename in $(ls ../src/models/bodies); do

    echo $filename
    for face in "${faces[@]}"; do
        for glass in "${glasses[@]}"; do
            for hat in "${hats[@]}"; do
                #insert the header of the file
                cat ./topfile > tempfile
                let gltfCount=0
                #print the body to the tempfile
                insertresource "/bodies/$filename" $gltfCount

                let "gltfCount++"

                # Insert body into metadata
                echo -e "\t{\n\t\t\"Body\": \"$(basename $filename .gltf)\"," >> metadata

                #Write the face covering, if present
                if [ "$face" != "NONE" ]
                then
                    echo -e "\t\t\"Face\": \"$(basename $face .gltf)\"," >> metadata
                    insertresource $face $gltfCount
                    let "gltfCount++"
                else
                    echo -e "\t\t\"Face\": \"None\"," >> metadata
                fi
                

                #Write the glasses, if present
                if [ "$glass" != "NONE" ]
                then
                    basename $glass
                    echo -e "\t\t\"Glasses\": \"$(basename $glass .gltf)\"," >> metadata
                    insertresource $glass $gltfCount
                    let "gltfCount++"
                else
                    echo -e "\t\t\"Glasses\": \"None\"," >> metadata
                fi

                #Write the hat, if present
                if [ "$hat" != "NONE" ]
                then
                    basename $hat
                    echo -e "\t\t\"Hat\": \"$(basename $hat .gltf)\"," >> metadata
                    insertresource $hat $gltfCount
                    let "gltfCount++"
                else
                    echo -e "\t\t\"Hat\": \"None\"," >> metadata
                fi

                #insert the footer of the file
                cat ./footerfile >> tempfile

                #Final line in metadata
                echo -e "\t\t\"tokenId\": \"$pigNumber\"\n\t}," >> metadata
                #finally publish the tempfile to the pig output
                mkdir -p ../src/html/$pigNumber
                cat ./tempfile > ../src/html/$pigNumber/index.js

                #increment the pig number
                let "pigNumber++"
                echo $pigNumber
                if [ $pigNumber == 10 ]
                then
                    #exit early
                    exit
                fi
            done        
        done
    done

done

#finish metadata
cat "]\n" > metadata

