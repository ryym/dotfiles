
# In the first time, load utility commands and constants.
set +u
if [ -z $__helper_loaded ]; then
    export PATH="$DOTPATH/bin:$PATH"
    source "$DOTPATH/CONST.sh"
fi
set -u
__helper_loaded=1

# Source the specified file from $DOTPATH/sync.
load() {
    source "$DOTPATH/sync/$1"
}

detect_osname() {
    if is_osx; then
        echo 'osx'
    elif is_debian; then
        echo 'debian'
    fi
}

is_osx() {
    return $(test $(uname) == 'Darwin')
}

is_debian() {
    return $(test -f /etc/debian_version)
}

# http://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-unix-shell-scripting
contains() {
    local string="$1"
    local substring="$2"
    if [ "${string#*$substring}" != "$string" ]; then
        return 0
    else
        return 1
    fi
}
