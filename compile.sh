#! /bin/bash
for file in src/*.asm ; do
    outputName=$(echo "$file" | cut -f 1 -d '.')
    outputName=$(echo "$outputName" | cut -f 2 -d '/')
    outputName="output/${outputName}.o"
    ca65 $file -o $outputName
done

ld65 output/*.o -C nes.cfg -o output/rom/main.nes
