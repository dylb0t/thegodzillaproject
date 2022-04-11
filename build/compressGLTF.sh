#! /bin/bash


for directory in $(find ../src/models/* -type d);do
    echo $directory | cut -d / -f4-
    dirName=$(echo $directory | cut -d / -f4-)
    for file in $(find $directory -type f); do
        filName=$(echo $file | cut -d / -f5-)
        echo Making backup of $file if it does not already exist
        mkdir -p ../backup/$dirName
        cp $file ../backup/$dirName
        echo Compressing...
        gltf-pipeline -i $file -o $directory/$filName.temp.gltf -d
        echo Removing original...
        rm $file
        echo Replacing...
        mv $directory/$filName.temp.gltf $directory/$filName
    done
done