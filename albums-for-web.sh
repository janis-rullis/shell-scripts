#!/bin/bash

## Make globally available with:
# sudo ln -s ~/Desktop/www/shell-scripts/albums-for-web.sh /usr/local/bin/albums-for-web
# sudo chmod a+x /usr/local/bin/albums-for-web
# https://github.com/Janis-Rullis-IT/shell-scripts/issues/2#issuecomment-608466590

# Define error reporting level, file seperator, and init direcotry.
function init(){
    set -Eeuo pipefail; # set -o xtrace;
    IFS=$'\n\t'
    DIR=$PWD;
    ROOT_DIR="$(dirname "${DIR}")";
      echo "" > "${DIR}/albums-for-web.log";
}
init

echo "== Prepare multiple image albums for publishing in the web - make responsive images, generate videos, HTML, XML, JSON ==
Example
albums-for-web
";

# #3 Get the total image count and pass it to the HTML generator.
FOUND_SCRIPTS=`find . -maxdepth 2 -name 'gen.sh'`
FOUND_SCRIPTS_ARR=($FOUND_SCRIPTS)
FOUND_SCRIPT_CNT=${#FOUND_SCRIPTS_ARR[@]} 
PROCESSED_DIR="${DIR}/Processed";
GROUP_FORMATS[0]='html';
GROUP_FORMATS[1]='xml';
GROUP_FORMATS[2]='mp4';

# #4 Will store processed albums here.
if [[ ! -d $PROCESSED_DIR ]]; then
  mkdir $PROCESSED_DIR;
  echo "Created $PROCESSED_DIR";
fi

for i in "${!FOUND_SCRIPTS_ARR[@]}"
do
  f=${FOUND_SCRIPTS_ARR[$i]};
  dir=$(dirname $f);
  echo $dir >> "${DIR}/albums-for-web.log";

  cd "${dir}";

  if [[ -r 'renamed' ]]; then
    echo "Skipping because there's already a generated content." >> "${DIR}/albums-for-web.log";
  else
    ./gen.sh
    echo "Completed." >> "${DIR}/albums-for-web.log";
  fi

  cd ${DIR};

  # #4 Move the album to Processed.
  mv "${dir}" "${PROCESSED_DIR}";
done

# #4 Group HTML, XML, videos.
for GROUP_FORMAT in ${GROUP_FORMATS[@]}; do

  GROUP_FORMAT_DIR="${PROCESSED_DIR}/${GROUP_FORMAT}";
  if [[ ! -d $GROUP_FORMAT_DIR ]]; then
    mkdir $GROUP_FORMAT_DIR;
    echo "Created ${GROUP_FORMAT_DIR}";
  fi

  for f in `find ${PROCESSED_DIR}/. -type f -name "*.${GROUP_FORMAT}"` 
  do
          echo $f;

          # #4 https://stackoverflow.com/a/9392784
          cp -n "${f}" "${GROUP_FORMAT_DIR}/.";
  done
done

echo "Done! See ${DIR}/albums-for-web.log";