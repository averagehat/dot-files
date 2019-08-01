# dot-files
Install
---------

```bash
# install neovim
curl -kLO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage
cp ./nvim.appimage $HOME/bin/nvim  # or somewhere in PATH

# make sure you're using a virtual environment or miniconda

# setup plugins
git clone https://github.com/averagehat/dot-files
mkdir -p ~/.config/nvim/
cp -r dot-files/.config/nvim/init.vim ~/.config/nvim
curl -kfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# python dependencies
pip intall git+https://github.com/python/mypy 
pip install pylint
pip install pynvim
pip install jedi 

# install plugins
# in neovim (launch with nvim):
:PlugInstall
```
