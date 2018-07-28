
getcanonicalpaths(){
    read -r year month day hour minute second <<< `date +'%Y %B %d %H %M %S'`
    suffix="${1}"
    extension="${2}"

    if [[ "${3}" == "image" ]]
    then
        base_path="`getconfiguration SCREENSHOT_DIRECTORY`"
    elif [[ "${3}" == "video" ]]
    then
        base_path="`getconfiguration SCREENCAST_DIRECTORY`"
    fi

    org_fullpath="${base_path}/`getconfiguration ORGANIZATION_POLICY`"
    org_fullpath="${org_fullpath}${suffix}.${extension}"

    if [[ -n "`getconfiguration LINKING_POLICY`" ]]
    then
        link_fullpath="${base_path}/`getconfiguration LINKING_POLICY`"
        link_fullpath="${link_fullpath}${suffix}.${extension}"
    else
        link_fullpath=''
    fi

    org_fullpath="`eval echo "${org_fullpath}"`"
    link_fullpath="`eval echo "${link_fullpath}"`"

    echo `dirname "${org_fullpath}"` `basename "${org_fullpath}"` \
        `dirname "${link_fullpath}"` `basename "${link_fullpath}"`
}

temporary(){
    filename=`date +'%Y-%B-%d-%H:%M:%S'`
    suffix="${1}"

    mime=`getmime $2`
    _IFS=$IFS
    IFS='/'
    read -r filetype extension <<< "${mime}"
    IFS=$_IFS

    filename="${filename}${suffix}.${extension}"

    cp "${2}" "/tmp/${filename}"

    echo "/tmp/${filename}"
}

save(){
    mime=`getmime $2`
    _IFS=$IFS
    IFS='/'
    read -r filetype extension <<< "${mime}"
    IFS=$_IFS

    read -r fullpath filename linkpath linkname \
        <<< `getcanonicalpaths "${1}" "${extension}" "${filetype}"`

    [[ "${linkpath}" == "." ]] && linkpath=""

    mkdir -p "${fullpath}"
    cp "${2}" "${fullpath}/${filename}"

    output="${fullpath}/${filename}"

    [[ -n "${linkpath}" ]] && \
        mkdir -p "${linkpath}" && \
        ln -s "${fullpath}/${filename}" "${linkpath}/${linkname}" && \
        output="${output} ${linkpath}/${linkname}"

    echo "${output}"
}

copy(){
    require xclip

    mime=`getmime $1`

    xclip -selection clipboard -t ${mime} ${1}
}
