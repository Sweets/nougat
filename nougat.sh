
#!/bin/bash

# Nougat
# Scrot wrapper
# Helps organize screenshots

saveourship(){

   echo "Nougat - scrot wrapper created to help organize screenshots"
   echo "Options:"
   echo " -h - Saves our ship."
   echo " -s - Silent. By default, nougat will output the path to the file to STDOUT."
   echo "              This is to make it easier to implement into other file uploaders."
   echo " -t - Places screenshot into /tmp"
   echo "      (useful if you only need a quick screenshot to send to a friend)"
   echo " -f - Takes a full screen screenshot (default is select area)"
   echo " -c - Puts the screenshot into your clipboard"
   echo "Important:"
   echo " Be sure to configure your screenshot directory."
   echo " This can be done by exporting \$NOUGAT_SCREENSHOT_DIRECTORY."
   echo " Place the export statement in your shell's profile."
   echo " Do not leave a trailing slash (e.g. use /directory rather than /directory/)"
   echo " Example:"
   echo "  export NOUGAT_SCREENSHOT_DIRECTORY=$HOME/Screenshots"

}

temp=false
fullscreen=false
silent=false
copytoclipboard=false

scrotopts='"nougat_temp.png" -e '"'"'mv $f /tmp'"'"

scrotpls(){

    if [[ "$temp" == "true" ]]
    then
        scrotopts='"%F.%H_%M_%S.png" -e '"'"'mv $f /tmp; xclip -selection clipboard -t image/png /tmp/$f; echo /tmp/$f'"'"
    else
        scrotopts='"nougat_temp.png" -e '"'"'mv $f /tmp'"'"
    fi

    if [[ "$fullscreen" == "false" ]]
    then

        scrotopts="-s $scrotopts"

    fi

    echo "scrot $scrotopts" | /bin/bash

    if [[ "$temp" == "true" ]]
    then # Stops nougat from continuing and moving a non-existant file
        exit 0
    fi

    year=$(date +"%Y")
    month=$(date +"%B") # Nice and readable
    day=$(date +"%d")

    dir="$NOUGAT_SCREENSHOT_DIRECTORY/$year/$month/$day"
    mkdir -p $dir

    if [[ "$fullscreen" == "true" ]]
    then
        name=$(date +"%H_%M_%S_full.png")
    else
        name=$(date +"%H_%M_%S.png")
    fi

    mv /tmp/nougat_temp.png $dir/$name

    linkname="$year-$month-$day.$name"

    ln -s $dir/$name $NOUGAT_SCREENSHOT_DIRECTORY/all/$linkname

    if [[ "$copytoclipboard" == "true" ]]
    then
        xclip -selection clipboard -t image/png $dir/$name
    fi

    if [[ "$silent" == "false" ]]
    then
        echo $dir/$name
    fi

}

while getopts "hstfc" opt
do
    case $opt in
        h)
            saveourship
            exit 0
            ;;
        s)
            silent=true
            ;;
        t)
            temp=true
            ;;
        f)
            fullscreen=true
            ;;
        c)
            copytoclipboard=true
            ;;
    esac
done

if [[ "$NOUGAT_SCREENSHOT_DIRECTORY" == "" && "$temp" == "false" ]]
then
    echo "Screenshot directory unset. View nougat.sh -h"
    exit 1
elif [[ ! -d "$NOUGAT_SCREENSHOT_DIRECTORY" && "$temp" == "false" ]]
then
    echo "$NOUGAT_SCREENSHOT_DIRECTORY variable is not set to a directory."
    exit 1
else

    if [[ ! -d "$NOUGAT_SCREENSHOT_DIRECTORY/all" ]]
    then
        mkdir "$NOUGAT_SCREENSHOT_DIRECTORY/all"
    fi

    scrotpls

fi
