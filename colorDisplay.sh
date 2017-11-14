#!/bin/bash
mode2header(){
    #### For 16 Million colors use \e[0;38;2;R;G;Bm each RGB is {0..255}
    printf '\e[mR\n' # reset the colors.
    printf '\n\e[m%59s\n' "Some samples of colors for r;g;b. Each one may be 000..255"
    printf '\e[m%59s\n'   "for the ansi option: \e[0;38;2;r;g;bm or \e[0;48;2;r;g;bm :"
}
mode2colors(){
    # foreground or background (only 3 or 4 are accepted)
    local fb="0"
    if [[ $1 = fg ]] ; then
        fb=3
    elif [[ $1 = bg ]] ; then
        fb=4
    else
        echo >&2 "Error in usage"
        exit 1
    fi
    local samples=(0 63 98 128 255)
    for         r in "${samples[@]}"; do
        for     g in "${samples[@]}"; do
            for b in "${samples[@]}"; do
                printf '\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d ' "$fb" "$r" "$g" "$b" "$r" "$g" "$b"
            done; printf '\e[m\n'
        done; printf '\e[m'
    done; printf '\e[mReset\n'
}
# Take a hex color or colors and display what it looks like in fg and bg
# 1: hex code for color, optionally starts with "#" or "0x"
# 2: hex code for bg color
# If only 1 is set, it's displayed as a fg and bg color
# If both 1 and 2 are set, one display with the set is displayed
mode2colorsSingle(){
    local fgNum=`echo "$1" | sed -E 's/^(#|0x)([0-9a-zA-Z]{6})$/\2/g'`
    if [ ! -u $2 ] ; then
        local bgNum=`echo "$2" | sed -E 's/^(#|0x)([0-9a-zA-Z]{6})$/\2/g'`
    else
        local bgNum=$fgNum
    fi
    local rf=$((16#`echo "$fgNum" | cut -c 1-2`))
    local gf=$((16#`echo "$fgNum" | cut -c 3-4`))
    local bf=$((16#`echo "$fgNum" | cut -c 5-6`))
    local rb=$((16#`echo "$bgNum" | cut -c 1-2`))
    local gb=$((16#`echo "$bgNum" | cut -c 3-4`))
    local bb=$((16#`echo "$bgNum" | cut -c 5-6`))
    if [ ! -u $2 ] ; then
        printf '\e[0;%s8;2;%s;%s;%sm\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d;%03d;%03d;%03d ' "3" "$rf" "$gf" "$bf" "4" "$rb" "$gb" "$bb" "$rf" "$gf" "$bf" "$rb" "$gb" "$bb"
        printf '\e[m\n'
        printf '\e[m'
    else
        #foreground
        printf '\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d ' "3" "$rf" "$gf" "$bf" "$rf" "$gf" "$bf"
        printf '\e[m\n'
        printf '\e[m'
        #background
        printf '\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d ' "4" "$rb" "$gb" "$bb" "$rb" "$gb" "$bb"
        printf '\e[m\n'
        printf '\e[m'
    fi
}

if [ -u $1 ] ; then
    mode2header
    mode2colors fg
    mode2colors bg
else
    mode2colorsSingle $@
fi
