
post(){
    if [[ "${copytoclipboard}" == "true" ]]
    then
        copy ${1}
    fi

    output=''

    if [[ "${temporary}" == "true" ]]
    then
        output=`temporary "" "${1}"`
    else
        read -r filepath linkpath <<< `save "" "${1}"`
        output="${filepath}"

        [[ -n "${linkpath}" ]] && output="${output}\n${linkpath}"
    fi

    if [[ "${silent}" == "false" ]]
    then
        echo -e "${output}"
    else
        if [[ "${stdio}" == "true" ]]
        then
            if [[ ! -t 1 ]]
            then
                cat "${1}"
            else
                cat >&2 <<EOF
Refusing to output file to terminal.
--output should only be used when redirecting files
EOF
            fi
        fi
    fi

    ## We're done here. Let's clean up, boys.

    rm ${1}
}

