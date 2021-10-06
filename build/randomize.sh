#!/bin/bash


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

# let i=0
# for filename in $(ls ../src/models/hair); do
#     hairs[i]="/hair/$filename"
#     let i=i+1
# done
# hairs[i]="NONE"

let i=0
for filename in $(ls ../src/models/accessories); do
    accessories[i]="/accessories/$filename"
    let i=i+1
done
accessories[i]="NONE"

let i=0
for filename in $(ls ../src/models/necklace); do
    necklaces[i]="/necklace/$filename"
    let i=i+1
done
necklaces[i]="NONE"

let i=0
for filename in $(ls ../src/models/shirts); do
    shirts[i]="/shirts/$filename"
    let i=i+1
done
shirts[i]="NONE"

# Every pig needs a body... So we will do the randomization for every single body
# And we will just do pignumbers from zero
let pigNumber=0
#start metadata
echo "[" > metadata
for filename in $(ls ../src/models/bodies); do

    
    for face in "${faces[@]}"; do
        for glass in "${glasses[@]}"; do
            for hat in "${hats[@]}"; do
                for accessory in "${accessories[@]}"; do
                    for shirt in "${shirts[@]}"; do
                        for necklace in "${necklaces[@]}"; do
                            #insert the header of the file
                            cat ./topfile.js > tempfile
                            let gltfCount=0
                            #print the body to the tempfile
                            insertresource "/bodies/$filename" $gltfCount

                            let "gltfCount++"
                            echo "Body: $filename"
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
                                case $(basename $hat .gltf) in
                                hair*)
                                    echo -e "\t\t\"Hair\": \"$(basename $hat .gltf)\"," >> metadata
                                    echo -e "\t\t\"Hat\": \"None\"," >> metadata
                                ;;
                                *)
                                    echo -e "\t\t\"Hair\": \"None\"," >> metadata
                                    echo -e "\t\t\"Hat\": \"$(basename $hat .gltf)\"," >> metadata
                                ;;
                                esac
                                insertresource $hat $gltfCount
                                let "gltfCount++"

                            else
                                echo -e "\t\t\"Hat\": \"None\"," >> metadata
                                echo -e "\t\t\"Hair\": \"None\"," >> metadata
                            fi

                            #Write the hair, if present
                            # if [ "$hair" != "NONE" ] && [ "$hat" == "HAIR" ]
                            # then
                            #     basename $hair
                            #     echo -e "\t\t\"Hair\": \"$(basename $hair .gltf)\"," >> metadata
                            #     insertresource $hair $gltfCount
                            #     let "gltfCount++"
                            # else
                            #     echo -e "\t\t\"Hair\": \"None\"," >> metadata
                            # fi

                            if [ "$necklace" != "NONE" ]
                            then
                                basename $necklace
                                echo -e "\t\t\"Necklace\": \"$(basename $necklace .gltf)\"," >> metadata
                                insertresource $necklace $gltfCount
                                let "gltfCount++"
                            else
                                echo -e "\t\t\"Necklace\": \"None\"," >> metadata
                            fi

                            if [ "$shirt" != "NONE" ]
                            then
                                basename $shirt
                                echo -e "\t\t\"Shirt\": \"$(basename $shirt .gltf)\"," >> metadata
                                insertresource $shirt $gltfCount
                                let "gltfCount++"
                            else
                                echo -e "\t\t\"Shirt\": \"None\"," >> metadata
                            fi

                            #insert the footer of the file
                            cat ./bottomfile.js >> tempfile

                            #Final line in metadata
                            echo -e "\t\t\"tokenId\": \"$pigNumber\"\n\t}," >> metadata
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
                            # if [ $pigNumber == 10 ]
                            # then
                            #     #exit early
                            #     end=`date +%s`

                            #     runtime=$((end-start))

                            #     echo "Script executed in $runtime seconds."
                            #     exit
                            # fi
                        done
                    done
                done
            done        
        done
    done

done

#finish metadata
#forget fancy rules and regex, this is faster. Just delete the last line and print a new one
sed -i '$ d' metadata
echo -e "\t}\n]" >> metadata

#Finish runtime calculation
end=`date +%s`
runtime=$((end-start))
echo "Script executed, randomized and compiled $pigNumber 3D Pigs in $runtime seconds..."