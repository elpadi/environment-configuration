SHELL = /bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

BUILD_DIR := $(shell python -c 'import os,sys;print os.path.realpath(sys.argv[1])' `dirname $(mkfile_path)`)/build

HOSTNAME := $(shell hostname)

.PHONY: all variables vim zsh

all:
	@echo "You must specify a target."

build/variables.txt: src/variables/$(HOSTNAME).txt
	mkdir -p build
	cp $^ $@

variables: build/variables.txt

vim:
	mkdir -p $(BUILD_DIR)/vim/{bundle,undodir,swap}
	cp -r src/vim/config-dirs/* $(BUILD_DIR)/vim
	if [ ! -e ~/.vim ]; then cd ~; ln -s $(BUILD_DIR)/vim .vim; fi
	$(eval REPOS := $(shell cat src/vim/bundles.txt))
	cd $(BUILD_DIR)/vim/bundle; for r in $(REPOS); do dir=`echo $$r | perl -pe 's/.*\/([^\/]*).git$$/\1/'`; if [ -d $$dir ]; then cd $$dir; git pull; cd ..; else git clone $$r; fi done || [ $$? -eq 1 ]

build/shell/zshrc.txt: src/shell/* src/shell/zshell/*
	mkdir -p $(BUILD_DIR)/shell
	echo 'source $(BUILD_DIR)/variables.txt' > $@
	find src/shell/zshell -type f | xargs cat >> $@
	find src/shell -maxdepth 1 -type f | xargs cat >> $@

$(HOME)/.zshrc: build/shell/zshrc.txt
	cp $^ $@

zsh: variables $(HOME)/.zshrc

