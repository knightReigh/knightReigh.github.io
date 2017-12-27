---
title: Github & Linux Tips
date: 2017-09-07 00:00
categories: ['programming']
tags:
  - Github
  - webdev
  - linux
---


Github Page provides a fast and easy way to set up a static website/blog. Since it is managed as a code repository rather than a website, I figure that it is useful to provide some commonly needed tips for a Github newbee like me so that the job can be done efficiently with minimum distraction. So here we go. 

<!-- more -->

## Using multiple Github accounts
1. [Git config for multiple GitHub accounts](http://tommaso.pavese.me/2014/07/08/git-config-for-multiple-github-accounts/)

    A comprehensive guide on using multiple github accounts on terminal

2. [Set up push credentials](http://tommaso.pavese.me/2014/07/08/git-config-for-multiple-github-accounts/)

    A short snipet on how to push without entering username everytime 1. Set up SSH for each account, [link1](https://gist.github.com/jexchan/2351996), [link2](https://code.tutsplus.com/tutorials/quick-tip-how-to-work-with-github-and-multiple-accounts--net-22574)
    2. Make Sure `.ssh/config` file is correctly configured
    3. Set up `--local` push configuration: `git config --local user.name "Name Surname"`, `git config --local user.email "name.surname@company.com"`
    4. Set remote url: `git remote set-url origin git@work-github.com:account_name/repo_name.git`


## Remove old git commits

What if commits went wrong?

1. [Remove all commit history and re-create current repository](https://stackoverflow.com/questions/13716658/how-to-delete-all-commit-history-in-github)

```
    1.Checkout: git checkout --orphan latest_branch

    2.Add all the files: git add -A

    3.Commit the changes: git commit -am "commit message"

    4.Delete the branch: git branch -D master

    5.Rename the current branch to master: git branch -m master

    6.Finally, force update your repository: git push -f origin master
```

2. [Remove old git commits](https://stackoverflow.com/questions/9725156/remove-old-git-commits)

    Use `git rebase -i HEAD~4` command

&nbsp;

## [Kramdown Syntax](https://kramdown.gettalong.org/syntax.html)

  *A quick reference on writing with Github page*

## Configure Vim 8.0 with Python, Python3, Ruby and Lua support on Ubuntu 16.04

`Ref: https://gist.github.com/odiumediae/3b22d09b62e9acb7788baf6fdbb77cf8`

```
sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common
 
sudo apt-get install liblua5.1-dev luajit libluajit-5.1 python-dev python3-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev

#Optional: so vim can be uninstalled again via `dpkg -r vim`
sudo apt-get install checkinstall

sudo rm -rf /usr/local/share/vim /usr/bin/vim

cd ~
git clone https://github.com/vim/vim
cd vim
git pull && git fetch

#In case Vim was already installed
cd src
make distclean
cd ..

./configure \
--enable-multibyte \
--enable-perlinterp=dynamic \
--enable-rubyinterp=dynamic \
--with-ruby-command=/usr/bin/ruby \
--enable-pythoninterp=dynamic \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
--enable-luainterp \
--with-luajit \
--enable-cscope \
--enable-gui=auto \
--with-features=huge \
--with-x \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="yourname" \
--enable-fail-if-missing

make && sudo make install
```

Tips:
1. check ruby version and ruby path: mine is `/usr/bin/ruby` instead of `usr/local/bin/ruby`
2. to compile with pyhton, you need to install `-dev` package for each version
3. checek `with-compiledby=yourname`

