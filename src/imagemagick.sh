#ifndef ENABLE_IMAGEMAGICK
#define ENABLE_IMAGEMAGICK 1
#endif

#if ENABLE_IMAGEMAGICK == 1
require import

capture_region(){
    path=`maketemp png`

    case `getconfiguration SELECTION_METHOD` in
        dark)
            geometry=`select_dark`
            ;;
        light)
            geometry=`select_light`
            ;;
        *)
            geometry=`select_default`
            ;;
    esac

    [[ "${geometry}" == "0 0 0 0" ]] && exit 0

    read -r width height x y <<< ${geometry}
    geometry="${width}x${height}+${x}+${y}"

    import -window root -crop ${geometry} ${path}

    post ${path}
}

capture_fullscreen(){
    path=`maketemp png`

    import -window root ${path}

    post ${path}
}

capture_focused_monitor(){
    path=`maketemp png`

    geometry=`select_focused_monitor`
    read -r width height x y <<< ${geometry}
    geometry="${width}x${height}+${x}+${y}"

    import -window root -crop ${geometry} ${path}

    post ${path}
}

#else
capture_region(){
    return 0
}
capture_fullscreen(){
    return 0
}
capture_focused_monitor(){
    return 0
}
#endif

