# nougat
Screenshot wrapper for scrot and maim

# How it works
Whenever you take a screenshot using nougat, it will organize the screenshot into a subdirectory of the directory specified in the NOUGAT_SCREENSHOT_DIRECTORY variable. This is done to organize screenshots in a humane manner. Then a symbolic link is created to the screenshot in the "all" subdirectory. This helps find screenshots quickly rather than having to go through all subdirectories.

To specify the NOUGAT_SCREENSHOT_DIRECTORY variable, add the following line to either your shell's rc file or the profile of your shell.

```
export NOUGAT_SCREENSHOT_DIRECTORY="$HOME/screenshots"
```

Once nougat is run, it will create any subdirectories that it needs. For example, the first time it is run, it will create ./all. This is where all symlinks are kept. The link names differ slightly from the file names in that it specifies the whole date and time, rather than just time.

Subdirectories are also created based on the date. For example, since today is September 5th, 2017 (or rather the time I am writing this, it's Sep 5th), it will create a "2017" subdirectory if one doesn't exist, then within "2017" it will create a "September" subdirectory, again, if it doesn't exist, and then an "05" subdirectory within "September".

# Command-line options

`-f` - Takes a fullscreen screenshot. By default, nougat will use the select-area option provided by scrot.

`-t` - Places screenshot in `/tmp/` rather than the `$NOUGAT_SCREENSHOT_DIRECTORY`.

`-s` - Does not output the file's path. By default, nougat outputs the files path to aid implementation of file uploaders.

`-S` - Selects images from the `$NOUGAT_SCREENSHOT_DIRECTORY`. To select images, use the following string structure: `YEAR-MONTH-DAY+HOUR:MINUTE:SECOND`. You can use an asterisk (`*`) as a wildcard.

`-b` - Specifies the backend for nougat to use. Currently only `scrot` and `maim`. nougat will auto-detect which of these backends exist on the system if the backend is not specified, if both exist, nougat will prefer maim to scrot.

`-c` - Copies the output to the clipboard. This is not yet implemented.

`-p` - Cleans `$NOUGAT_SCREENSHOT_DIRECTORY/all` of any symbolic links that lead to nowhere.

`-h` - Shows the nougat help dialog.

# Dependencies

`scrot` or `maim` - One or the other. nougat will use `maim` if both are on the system.
`xclip` - Copying images to the clipboard (`-c`)
