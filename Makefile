SHELL = /bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))

BUILD_DIR := $(shell python -c 'import os,sys;print os.path.realpath(sys.argv[1])' `dirname $(mkfile_path)`)/build

HOSTNAME := $(shell hostname)

.PHONY: all build_dirs apache vim vim-bundles zsh ftp

all:
	@echo "You must specify a target."

build_dirs:
	@mkdir -p build
	@mkdir -p build/vim
	@mkdir -p build/vim/{bundle,undodir,swap}
	@mkdir -p build/apache
	@mkdir -p build/shell

ftp: ~/.config/lftp/rc

vim: build_dirs build/vim/.vimrc vim-bundles

zsh: build_dirs build/shell/.zshrc

apache: build_dirs build/apache/server.conf build/apache/vhosts.conf build/apache/hosts.txt

vim-bundles: src/vim/bundles.txt
	$(eval REPOS := $(shell cat $^))
	cd build/vim/bundle; for r in $(REPOS); do dir=`echo $$r | perl -pe 's/.*\/([^\/]*).git$$/\1/'`; if [ -d $$dir ]; then cd $$dir; git pull; cd ..; else git clone $$r; fi done || [ $$? -eq 1 ]

build/vim/.vimrc: src/vim/vimrc.txt src/vim/config-dirs
	mkdir -p build/vim/{bundle,undodir,swap}
	cp -r src/vim/config-dirs/* build/vim
	cp src/vim/vimrc.txt $@

build/shell/.zshrc: $(sort $(wildcard src/shell/*.txt)) $(wildcard src/shell/zshell/*.txt)
	cat $^ > $@

build/apache/server.conf: src/apache/server.conf
	sed -e "s,%SITES_DIR%,$$SITES_DIR,g" $^ > $@

build/apache/vhosts.conf: $(wildcard src/apache/vhosts/*.conf)
	cat $^ | sed -e "s,DocumentRoot ,DocumentRoot $$SITES_DIR," -e "s/ServerName LOCAL_HOSTNAME/ServerName $(HOSTNAME)/" > $@

build/apache/hosts.txt: $(wildcard src/apache/vhosts/*.conf)
	cat $^ | grep 'ServerName' | awk '{ print "127.0.0.1\t" $$2; }' > $@

~/.config/lftp/rc: src/ftp/lftp-rc.txt
	cat $^ > $@
