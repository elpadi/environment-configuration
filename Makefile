SHELL = /bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

BUILD_DIR := $(shell python -c 'import os,sys;print os.path.realpath(sys.argv[1])' `dirname $(mkfile_path)`)/build

HOSTNAME := $(shell hostname)

.PHONY: all variables vim zsh

all:
	@echo "You must specify a target."

build/variables.txt: src/variables/$(HOSTNAME).txt
	cp $^ $@

variables: build/variables.txt

vim:
	cp -r src/vim/config-dirs/* $(BUILD_DIR)/vim
	[ ! -e ~/.vim ] && cd ~ && ln -s $(BUILD_DIR)/vim .vim
	$(eval REPOS := $(shell cat src/vim/bundles.txt))
	cd $(BUILD_DIR)/vim/bundle; for r in $(REPOS); do dir=`echo $$r | perl -pe 's/.*\/([^\/]*).git$$/\1/'`; if [ -d $$dir ]; then cd $$dir; git pull; cd ..; else git clone $$r; fi done || [ $$? -eq 1 ]

build/shell/zshrc.txt: src/shell/* src/shell/zshell/*
	echo 'source $(BUILD_DIR)/variables.txt' > $@
	find src/shell/zshell -type f | xargs cat >> $@
	find src/shell -maxdepth 1 -type f | xargs cat >> $@
	echo 'source $(BUILD_DIR)/shell/zshrc.txt' > ~/.zshrc

zsh: build/shell/zshrc.txt

