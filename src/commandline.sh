
longoptions="help,silent,temporary,copy,fullscreen,monitor,output,purge"
shortoptions="h,s,t,c,f,m,i,p"

## Configuration variables
longoptions="${longoptions},selection-method:"
longoptions="${longoptions},screenshot-directory:,screencast-directory"
longoptions="${longoptions},organization-policy:,linking-policy:"
## Screenshot & record
longoptions="${longoptions},screenshot,record"

getopt_opts="--options=${shortoptions} --longoptions=${longoptions}"

parsed=`getopt ${getopt_opts} --name "$0" -- "$@"`
eval set -- "${parsed}"

action=''

setaction(){
    [[ ! -z "${action}" ]] && \
        echo 'Only a single action can be done at a time.' && exit 1
    action="$1"
}

while true
do
    case "$1" in
        -h|--help)
            saveourship
            ;;
        -s|--silent)
            silent=true
            shift
            ;;
        -t|--temporary)
            temporary=true
            shift
            ;;
        -c|--copy)
            copytoclipboard=true
            shift
            ;;
        -f|--fullscreen)
            fullscreen=true
            shift
            ;;
        -m|--monitor)
            focused_monitor=true
            shift
            ;;
        -i|--output)
            silent=true
            stdio=true
            shift
            ;;
        -p|--purge)
            ## not yet implemented
            shift
            ;;
        ##config variables
        --selection-method)
            SELECTION_METHOD=${2:-${SELECTION_METHOD}}
            shift 2
            ;;
        --screenshot-directory)
            SCREENSHOT_DIRECTORY=${2:-${SCREENSHOT_DIRECTORY}}
            shift 2
            ;;
        --screencast-directory)
            SCREENCAST_DIRECTORY=${2:-${SCREENCAST_DIRECTORY}}
            shift 2
            ;;
        --organization-policy)
            ORGANIZATION_POLICY=${2:-${ORGANIZATION_POLICY}}
            shift 2
            ;;
        --linking-policy)
            LINKING_POLICY=${2:-${LINKING_POLICY}}
            shift 2
            ;;
        ## Screenshot
        --screenshot)
            setaction 'capture'
            shift
            ;;
        ## Record
        --record)
            setaction 'record'
            shift
            ;;
        --)
            shift
            break
            ;;

    esac
done

if [[ ! -z "${action}" ]]
then

    if [[ "$fullscreen" == "true" && \
        "$focused_monitor" == "true" ]]
    then
        echo "Only one selection mode can be specified at once."
        exit 1
    fi

    if [[ "$fullscreen" == "true" ]]
    then
        action="${action}_fullscreen"
    elif [[ "$focused_monitor" == "true" ]]
    then
        action="${action}_monitor"
    else
        action="${action}_region"
    fi

    $action

else
    echo "No action set."
    exit 1
fi
