#/bin/sh

# /zrajm, 2024-06-29

set -e
DAT_GUI_VERSION="0.7.9"
THREE_VERSION="0.166.0"
CDN_URL="https://cdn.jsdelivr.net/npm/"

for FILE in three.js orbitcontrols.js dat.gui.js; do
    case "$FILE" in
        three.js)
            URL="$CDN_URL/three@$THREE_VERSION/build/three.module.js"
            OUTNAME="three" ;;
        orbitcontrols.js)
            URL="$CDN_URL/three@$THREE_VERSION/examples/jsm/controls/OrbitControls.js"
            OUTNAME="three-orbit-controls" ;;
        dat.gui.js)
            URL="$CDN_URL/dat.gui@$DAT_GUI_VERSION/build/dat.gui.module.js"
            OUTNAME="dat-gui" ;;
    esac
    MINFILE="$OUTNAME.min.js"
    MAPFILE="$MINFILE.map"
    printf '%-16s ' "$FILE"

    printf '%s' "fetching... "
    wget --quiet "$URL" --output-document="$FILE"

    case "$FILE" in
        orbitcontrols.*)
            printf '%s' "modifying... "
            perl -pi -e "s#(?<=from ([\"']))three(?=\1)#./three.min.js#g" "$FILE"
    esac

    printf '%s' "minifying... "
    uglifyjs.terser --module --compress drop_console --mangle --source-map "url='$MAPFILE'" "$FILE" --output "$MINFILE"

    printf '%s' "removing original... "
    rm "$FILE"

    printf '%s\n' "[DONE]"
done

#[eof]
