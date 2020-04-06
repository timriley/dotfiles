# Tim’s dotfiles & personal computing environment

Used in conjunction with [cultureamp/web-team-dotfiles][web-team-dotfiles].

[web-team-dotfiles]: http://github.com/cultureamp/web-team-dotfiles

## Installation

Install the team’s shared dotfiles via our [brew command][cmd]:

```sh
brew tap cultureamp/web-team-devtools
brew bootstrap-developer-system
```

Then install mine on top and run my personal setup script:

```sh
git clone https://github.com/timriley/dotfiles.git ~/.dotfiles
~/.dotfiles/script/setup
```

[cmd]: https://github.com/cultureamp/homebrew-web-team-devtools#bootstrap-developer-system

## Credits

Thanks to Thoughtbot for [their dotfiles][thoughtbot-dotfiles] and [rcm][rcm].
Thanks also to Mike McQuaid for his [dotfiles][mike-dotfiles].

[thoughtbot-dotfiles]: https://github.com/thoughtbot/dotfiles
[rcm]: https://github.com/thoughtbot/rcm
[mike-dotfiles]: https://github.com/MikeMcQuaid/dotfiles
