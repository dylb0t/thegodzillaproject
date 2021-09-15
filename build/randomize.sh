#!/bin/bash

# function to insert resources into the final gltf
# expected argument is the path to the resource
# expected local file named tempFile
insertresource() {
cat <<-EOF >> tempfile
        loader.load( '$1', function ( gltf ) {
        gltf.scene.traverse( function ( child ) {
            if ( child.isMesh ) {
                child.castShadow = true; 
            }
        } );
        gltf.scene.position.y += 9.4
        scene.add( gltf.scene );
        render();
        } );
EOF
}

# iterate through all resource directories to populate resource arrays
# for filename in $(ls ../webgl/models/bodies); do
#     filenames[i]="/bodies/$filename"
#     let i=i+1
# done

let i=0
for filename in $(ls ../webgl/models/face); do
    faces[i]="/face/$filename"
    let i=i+1
done
faces[i]="NONE"

let i=0
for filename in $(ls ../webgl/models/glasses); do
    glasses[i]="/glasses/$filename"
    let i=i+1
done
glasses[i]="NONE"

let i=0
for filename in $(ls ../webgl/models/hats); do
    hats[i]="/hats/$filename"
    let i=i+1
done
hats[i]="NONE"


# Every pig needs a body... So we will do the randomization for every single body
# And we will just do pignumbers from zero
let pigNumber=0
for filename in $(ls ../webgl/models/bodies); do

    echo $filename
    for face in "${faces[@]}"; do
        for glass in "${glasses[@]}"; do
            for hat in "${hats[@]}"; do
                #insert the header of the file
                cat ./topfile > tempfile

                #print the body to the tempfile
                insertresource "/bodies/$filename"

                #Write the face covering, if present
                if [ "$face" != "NONE" ]
                then
                    insertresource $face
                fi

                #Write the glasses, if present
                if [ "$glass" != "NONE" ]
                then
                    insertresource $glass
                fi

                #Write the hat, if present
                if [ "$hat" != "NONE" ]
                then
                    insertresource $hat
                fi

                #insert the footer of the file
                cat ./footerfile >> tempfile

                #finally publish the tempfile to the pig output
                cat ./tempfile > ../webgl/html/pig$pigNumber.html

                #increment the pig number
                let "pigNumber++"
                echo $pigNumber
            done        
        done
    done

done

