
saveourship(){
    cat << EOF
Nougat - screenshot wrapper created to help organize screenshots
 -h - Saves our ship.
 -i - Output image to stdout. This implies -s (silent).
 -s - Silent. By default, nougat will output the path to the file to STDOUT.
              This is to make it easier to implement into other file uploaders.
 -t - Places screenshot into /tmp
      (useful if you only need a quick screenshot to send to a friend)
 -f - Takes a full screen screenshot (default is select area)
 -m - Takes a full screen screenshot of the currently focused monitor.
      \`xdotool\` is required (\`nougat\` fallsback to a regular fullscreen screenshot without it).

 -c - Puts the screenshot into your clipboard
 -p - Cleans the link directory of Nougat based on the linking policy.
              Particularly useful as it cleans any links that no
              longer point to a screenshot (i.e. deleted screeenshot).
EOF
    exit
}

temporary=false
clean=false
silent=false
stdout=false
fullscreen=false
focused_monitor=false
copytoclipboard=false

getconfigdir(){
    CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
    echo "$CONFIG_DIR"
}


configfile="`getconfigdir`/nougat/config.sh"

if [[ -f "${configfile}" ]]
then
    source "${configfile}"
else
#include "backcompat.sh"
fi

unset configfile

#include "config.sh"

getconfiguration(){
    echo "${!1}"
}

require(){
    command -v "$1" &> /dev/null || {
        echo "$1 is not installed and is required."
        exit 1
    }
}

maketemp(){
    path=`mktemp`
    mv ${path} ${path}.$1
    echo ${path}.$1
}

getmime(){
    file --mime-type --brief $1
}
