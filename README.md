# Mac-Bootkey

Create an boot usbkey for Windows & for ubuntu/Raspbian/Manjaro For Mac users.
Bash


## Installation

Download zip with file or copy/cut in sources in a file.sh


## Use

```bash
sudo bash bootkey.sh
```

## Pipe Viewer

If you want to see progressbar :
Install homebrew :
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
```
Next install pipe Viewver :
```bash
brew install pv
```
Next,uncomment the line with pv(l17) & comment the line on below(l18).
```bash
#pv $1.iso | dd of=/dev/$diskfl
sudo dd if=$1.iso of=/dev/$diskfl bs=1m
```
