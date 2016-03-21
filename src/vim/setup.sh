setup vim:
	extract vim.tar.gz to $ENV_DIR
	ln -s $ENV_DIR/vim $HOME/.vim 
	cd $ENV_DIR/vim/bundle; for repo in $(cat bundle.txt);do git clone $repo;done
