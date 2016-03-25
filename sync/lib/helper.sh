
is_osx() {
    test `uname` = "Darwin" && return 0 || return 1
}

has() {
    which $1 > /dev/null
}

hasnot() {
    has $1 && return 1 || return 0
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
