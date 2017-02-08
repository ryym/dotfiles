## Translate selected text

1. Execute AppleScript (or JavaScript)
    - return input
1. Run the following shell script

```bash
# TODO: re-implement using JavaScript

# Encode text and open Google Translate
open https://translate.google.co.jp/?hl=ja#en/ja/$(echo "$1" | sed s/%/%25/g | sed s/+/%2B/g | sed 's/ /+/g' | sed s/’/%E2%80%99/g | sed s/\!/%21/g | sed s/*/%2A/g | sed -e "s/'/%27/g" | sed s/\(/%28/g | sed s/\)/%29/g | sed s/\;/%3B/g | sed s/:/%3A/g | sed s/@/%40/g | sed s/\&/%26/g | sed s/=/%3D/g | sed 's/\$/%24/g' | sed s/,/%2C/g | sed s:/:%2F:g | sed s/?/%3F/g | sed s/#/%23/g | sed 's/\[/%5B/g' | sed 's/\]/%5D/g')
```
