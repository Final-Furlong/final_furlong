#!/bin/bash

# Grep through modified files for forbidden words and reject commit if found

# Separate more file types with pipes here
FILE_PATTERN='\.(js|html|rb|yml)(\..+)?$'

# Separate more forbidden strings with spaces here
FORBIDDEN=( console.log puts byebug debugger binding.pry )

for i in "${FORBIDDEN[@]}"
do
  git diff --cached --name-only | \
        grep -E $FILE_PATTERN | \
        GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n $i && \
        echo 'Debugger code found:'  $i 'Please remove them before committing' && exit 1
done

exit 0