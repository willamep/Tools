#!/bin/bash

source ./help.sh
source ./arg.sh
source ./name_gen.sh

# gen_stop() {
# 
# }
# 
# log() {
# 
# }

gen_dir letters_dir

for dir in "$path"*/; do
    gen_file ${dir} letters_file
done
