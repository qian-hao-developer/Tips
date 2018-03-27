# install powerline @Ubuntu
## 1. install pip
    sudo apt install python-pip
    (maybe need to install python at all, try sudo apt install python)
## 2. install powerline
    sudo pip install powerline-status
    (binary will be at /usr/local/lib/python2.7/powerline/dist-packages/.....)

    $ powerline-daemon
    to confirm if powerline installed successfully
## 3. install fonts
    git clone https://github.com/powerline/fonts.git && cd fonts && sh ./install.sh

---

# install powerline @macOS
## 1. install python with brew
    brew install python@2
    (this will install override python2.x with system-in python)

    or

    brew install python
    (this will install python3)
## 2. check pip
    pip --version

    or

    pip3 --version
## 3. install powerline
    sudo pip install powerline-status

    or 

    sudo pip3 install powerline-status
    (binary will be at /usr/local/lib/python3.5/powerline/site-packages/....)

    if use --user option like sudo pip install --user powerline-status
    it will be installed at ~/Library/Python/....
    not recommand to use it
## 4. install fonts
    git clone https://github.com/powerline/fonts.git && cd fonts && sh ./install.sh

## 5. add LC_ALL to .bashrc
    export LC_ALL="en_US.UTF-8"

---

# add to .rc file
## .vimrc
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

## .bashrc
if [ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q
    source /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
fi

## .zshrc
if [[ -r /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    powerline-daemon -q
    source /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh
fi

## .tmux.conf
source /usr/local/lib/python2.7/dist-packages/powerline/bindings/tmux/powerline.conf
set-option -g default-terminal "screen-256color"

---

# set powerline fonts
    change powerline in preference both in Ubuntu or macOS' terminal

    use "Roboto Mono for Powerline Regular 10" @Ubuntu
    use "Meslo LG S DZ Regular for Powerline 11" @macOS

---

# optional -- powerline-shell
    you can use powerline-shell directlly without installing or configing
    but theme will be a little different

## 1. install fonts
    see upon

## 2. install powerline-shell
### use pip
    pip install powerline-shell
### use repository
    git clone https://github.com/b-ryan/powerline-shell
    cd powerline-shell
    python setup.py install

## 3. add .rc
### bash
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

### zsh
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

## 4. config
    powerline-shell --generate-config > ~/.powerline-shell.json

## reference
    https://github.com/b-ryan/powerline-shell