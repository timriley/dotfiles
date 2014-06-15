# Tim’s dotfiles

Used in conjunction with [icelab/dotfiles](http://github.com/icelab/dotfiles).

## Installation

```sh
brew tap thoughtbot/formulae
brew install rcm

git clone https://github.com/icelab/dotfiles.git ~/.dotfiles-icelab
git clone https://github.com/timriley/dotfiles.git ~/.dotfiles-personal

rcup -d ~/.dotfiles-personal ~/.dotfiles-icelab  -x README.md -x LICENSE
```

## Credits

Thanks to Zach Holman for sharing [his dotfiles](https://github.com/holman/dotfiles), which formed the basis of the previous incarnation of this repository. Thanks to Thoughtbot for [their dotfiles](https://github.com/thoughtbot/dotfiles) and [rcm](https://github.com/thoughtbot/rcm).
