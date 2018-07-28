
select_default(){
    require slop
    slop -of '%w %h %x %y'
}

select_dark(){
    require slop
    slop -c 0,0,0,0.35 -o -l -f '%w %h %x %y'
}

select_light(){
    require slop
    slop -c 1,1,1,0.25 -o -l -f '%w %h %x %y'
}

select_root_window(){
    require xrandr

    xrandr="$(xrandr --nograb | grep -E 'current [0-9]+ x [0-9]+')"
    sed -r "s/^.*current ([0-9]+) x ([0-9]+),.*$/\1 \2 0 0/" <<< "$xrandr"
}

select_focused_monitor(){
    require xdotool
    require xrandr

    xrandr="$(xrandr --nograb | grep -E 'connected (primary )?[0-9]+x[0-9]+\+[0-9]+\+[0-9]+')"
    [[ -z "$xrandr" ]] && return 1

    eval "$(xdotool getmouselocation --shell)"

    monitor_index=0
    while read -r width height xoff yoff
    do
        if [[
            "${X}" -ge "${xoff}" && \
            "${Y}" -ge "${yoff}" && \
            "${X}" -lt "$(($xoff+$width))" && \
            "${Y}" -lt "$(($yoff+$height))"
            ]]
        then
            echo "${width} ${height} ${xoff} ${yoff}"
            return 0
        fi

        ((monitor_index++))
    done <<< "$(sed -r "s/^([^ ]*).*\b([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+).*$/\2 \3 \4 \5/" <<< "$xrandr" | sort -nk4,5)"

    return 1
}

