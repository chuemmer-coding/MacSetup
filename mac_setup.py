#!/usr/bin/python

import os

setup = input("Press 1 for just school setup, 2 for personal and school")

if (setup == 1 or setup == 2):
#class setup
    os.system("/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"")

    os.system("brew install ocaml opam rust graphviz")

    os.system("sudo gem install sqlite3 sinatra")

    os.system("opam init")

    os.system("ocaml -version")

    value = input("\nIs the version 4.0.4? if yes hit 1, otherwise hit any other key\n")

    if value != 1 :
        os.system("opam switch 4.04.0")
        os.system("eval `opam config env`")

        os.system("opam init")
        os.system("source ~/.bash_profile -y")
        os.system("opam install ocamlfind ounit utop dune -y")

if setup == 2:
    os.system("brew install git")
    os.system("brew cask install iterm2")
    os.system("brew install node")
    os.system("npm install --global pokemon-terminal")
    os.system("brew install wget")
    os.system("vim /usr/local/pokemon")
    os.system("brew cask install emacs")
    os.system("wget ter.ps/chumsetup -O init.el")
    os.system("mv init.el ~/.emacs.d/")
    os.system("brew cask install google-chrome")
    os.system("brew cask install marshallofsound-google-play-music-player")
    os.system("git clone https://github.com/chuemmer-coding/MacSetup.git")
