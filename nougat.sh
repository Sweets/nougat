#!/bin/bash

# Nougat version 2

# All features from nougat 1
# ~/.config/nougat

saveourship(){

   echo -e  "Nougat - screenshot wrapper created to help organize screenshots\n"
   echo -e  " -h - Saves our ship.\n"
   echo     " -s - Silent. By default, nougat will output the path to the file to STDOUT."
   echo -e  "              This is to make it easier to implement into other file uploaders.\n"
   echo     " -t - Places screenshot into /tmp"
   echo -e  "      (useful if you only need a quick screenshot to send to a friend)\n"
   echo -e  " -f - Takes a full screen screenshot (default is select area)\n"
   echo -e  " -c - Puts the screenshot into your clipboard\n"
   echo     " -b - Select backend to use"
   echo -e  "              Supported backends are \`maim', \`scrot', and \`imagemagick'."
   echo -e  "              nougat will detect available backends if -b"
   echo -e  "              is not specified. nougat prefers maim to scrot and imagemagick.\n"
   echo     " -p - Cleans the link directory of Nougat based on the linking policy."
   echo     "              Particularly useful as it cleans any links that no"
   echo -e  "              longer point to a screenshot (i.e. deleted screeenshot).\n"

}

temporary=false
silent=false
fullscreen=false
copytoclipboard=false
backend=""

backends=('maim' 'scrot' 'imagemagick')

### BACKENDS

maimbackend(){
    require maim

    maimopts=''

    [[ "${fullscreen}" == 'false' ]] && maimopts='-s'
    maimopts="${maimopts} -u"

    command maim ${maimopts} /tmp/nougat_temp.png
}

scrotbackend(){
    require scrot
    
    scrotopts=''

    [[ "${fullscreen}" == 'false' ]] && scrotopts='-s'

    command scrot ${scrotopts} /tmp/nougat_temp.png
}

imagemagickbackend(){
    require import

    importopts=''

    if [[ "$fullscreen" == 'false' ]]
    then
        require slop

        slop=`command slop -qof '%wx%h+%x+%y'`

        [[ "$slop" != '' ]] && importopts="-crop ${slop}"
    fi

    command import -window root ${importopts} /tmp/nougat_temp.png
}

### END BACKENDS

nobackend(){
    if [[ "${backend}" == '' ]]
    then
        return 0
    else
        return 1
    fi
}

testfor() {
    command -v $1 > /dev/null
    return $?
}

require(){
    command -v $1 > /dev/null
    if [[ "$?" != '0' ]]
    then
        echo "$1 is not installed and is required"
        exit 1
    fi
}

getcanonicals(){

    read year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`

    suffix=''
    if [[ "${fullscreen}" == 'true' ]]
    then
        suffix='_full'
    fi

    source "$HOME/.config/nougat"

    ORG_FULLPATH="${NOUGAT_SCREENSHOT_DIRECTORY}/${NOUGAT_ORGANIZATION_POLICY}"
    LINK_FULLPATH="${NOUGAT_SCREENSHOT_DIRECTORY}/${NOUGAT_LINKING_POLICY}"

    echo `dirname "${ORG_FULLPATH}"` \
        `basename "${ORG_FULLPATH}"` \
        `dirname "${LINK_FULLPATH}"` \
        `basename "${LINK_FULLPATH}"`

}

init() {
    if [[ ! -f "$HOME/.config/nougat" ]]
    then
        mkdir -p "$HOME/.config"

        if [[ "${NOUGAT_SCREENSHOT_DIRECTORY}" != '' ]]
        then
            # Support for V1 configurations
            echo 'NOUGAT_SCREENSHOT_DIRECTORY="'"${NOUGAT_SCREENSHOT_DIRECTORY}"'"' > "$HOME/.config/nougat"
        else
            echo 'NOUGAT_SCREENSHOT_DIRECTORY="$HOME/Screenshots"' > "$HOME/.config/nougat"
        fi

        cat >> "$HOME/.config/nougat" << EOF
NOUGAT_ORGANIZATION_POLICY="\${year}/\${month}/\${day}/\${hour}:\${minute}:\${second}\${suffix}"
NOUGAT_LINKING_POLICY="All/\${year}-\${month}-\${day}.\${hour}:\${minute}:\${second}\${suffix}"
EOF
    fi

    while getopts 'hstfcpu b:S:' option
    do
        case $option in
            h)
                saveourship
                exit 0
                ;;
            b)
                setbackend $OPTARG
                ;;
            # Hide cursor
            p)
                clean
                ;;
            s)
                silent=true
                ;;
            t)
                temp=true
                ;;
            c)
                copytoclipboard=true
                ;;
            f)
                fullscreen=true
                ;;
        esac
    done

    nobackend && \
        testfor maim && backend='maim'

    nobackend && \
        testfor scrot && backend='scrot'

    nobackend && \
        testfor import && backend='imagemagick'

}

setbackend(){

    supported=false

    for (( index=0; index<${#backends}; index++ ))
    do
        if [[ "${backends[$index]}" == "$1" ]]
        then
            supported=true
            break
        fi
    done

    if [[ "$supported" == 'false' ]]
    then
        echo "Unsupported backend $1"
        exit 1
    fi

    cmd="$1"

    [[ "$cmd" == "imagemagick" ]] && cmd="import"

    testfor $cmd && \
        backend="$1"

}

runbackend(){
    case $backend in
        maim)
            maimbackend
            ;;
        scrot)
            scrotbackend
            ;;
        imagemagick)
            imagemagickbackend
            ;;
        *)
            echo 'No supported backend found'
            exit 1
            ;;
    esac

    [[ ! -f '/tmp/nougat_temp.png' ]] && exit 0
}

organize(){

    read fullpath filename linkpath linkname <<< `getcanonicals`

    if [[ "${copytoclipboard}" == 'true' ]]
    then
        require xclip
        xclip -selection clipboard -t image/png /tmp/nougat_temp.png
    fi

    if [[ "${temp}" == "true" ]]
    then
        [[ "${silent}" == 'false' ]] && \
            echo "/tmp/${linkname}.png"
        mv /tmp/nougat_temp.png "/tmp/${linkname}.png"
        return
    fi

    mkdir -p "$fullpath"
    mkdir -p "$linkpath"

    mv /tmp/nougat_temp.png "$fullpath/$filename.png"
    ln -s "$fullpath/$filename.png" "$linkpath/$linkname.png"

    [[ "${silent}" == 'false' ]] && \
        echo "$fullpath/$filename.png"

}

clean(){
    source ~/.config/nougat

    linkdir=`dirname "${NOUGAT_SCREENSHOT_DIRECTORY}/${NOUGAT_LINKING_POLICY}"`
    echo "$linkdir"

    for file in `ls ${linkdir}`
    do

        echo "$linkdir/$file"

        link=`readlink -f "$linkdir/$file"`

        [[ ! -f "$link" ]] && rm "$link"

    done
}

screenshot(){
    runbackend
    organize
}

init $@
screenshot
