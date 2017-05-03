SHELL = /bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

BUILD_DIR := $(shell python -c 'import os,sys;print os.path.realpath(sys.argv[1])' `dirname $(mkfile_path)`)/build

HOSTNAME := $(shell hostname)

.PHONY: all variables vim vim-bundles zsh

all:
	@echo "You must specify a target."

build/variables.txt: src/variables/$(HOSTNAME).txt
	mkdir -p build
	cp $^ $@

variables: build/variables.txt

vim: build/vim/.vimrc vim-bundles

build/vim/.vimrc: src/vim/vimrc.txt src/vim/config-dirs
	mkdir -p build/vim/{bundle,undodir,swap}
	cp -r src/vim/config-dirs/* build/vim
	cp src/vim/vimrc.txt $@

vim-bundles: src/vim/bundles.txt
	$(eval REPOS := $(shell cat $^))
	cd build/vim/bundle; for r in $(REPOS); do dir=`echo $$r | perl -pe 's/.*\/([^\/]*).git$$/\1/'`; if [ -d $$dir ]; then cd $$dir; git pull; cd ..; else git clone $$r; fi done || [ $$? -eq 1 ]

build/shell/.zshrc: build/variables.txt src/shell/*.txt src/shell/zshell/*.txt
	mkdir -p build/shell
	cat $^ > $@

zsh: build/shell/.zshrc

