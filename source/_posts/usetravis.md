---
title: Use Travis-ci To Automate Github-page Build Process
date: 2017-11-08 00:00
categories: ['programming']
tags:
  - webdev
  - hexo
  - travis-ci
---

> For Github-page users who build their website with static website generator other than the natively-supported Jekyll, it is usually troublesome to have to re-build their entire website on a configured environment every time they want to make some minor changes or just to publish a new post. It is especially annoying when you have some exciting ideas to share but have no access to a computer that is set up with whatever static website generator you are using. 
>
> Here, I am going to share a very basic workflow setup that allows you to use [*Prose.io*](prose.io) as your online post writer and [*Travis-ci*](travis-ci.org) as your automation deployment worker for on-the-go Github blog publication.

<!-- more -->

# Prerequisite

A website hosted with [Github page](https://pages.github.com/) service. 

For demo: [Scattered Notes on Web-Dev](https://fredhdx.github.io/) built with [Hexo](https://hexo.io/).

Demo repository structure

`master branch: HTML files`

`source branch: hexo source files`



#Using [Prose.io](prose.io)

## About

Prose.io is an on-line content editor designed for [Github](Github.com) repositories. It provides a simple text-editor like interface for Github users to add, edit, and delete files directly to their Github repositories. 

Prose.io can be set up directly with Github account.

Prose.io automatically detects [markdown](https://daringfireball.net/projects/markdown/syntax) content and provides syntax highlighting, formatting tool bar and draft preview [^1]. So it is an ideal tool to write markdown style posts directly on-line.

If your Github page is hosted with [Jekyll](https://jekyllrb.com/), Prose.io also allows you to use a custom configuration file *_config.yml* to direct your Prose.io log in directly to the website's source directory, for example, the *_posts* [^2].

##Usage

You don't need to do anything to use Prose.io. Just,

1. Log in [Prose.io](Prose.io) with your Github account
2. Choose the repository
3. Edit the file and commit



#Using [Travis-ci](travis-ci.org)

## About

[Travis-ci](travis-ci.org) is a hosted, distributed continuous integration service used to build and test software projects hosted at [Github](github.com) [^3]. It frees developers from tedious building and testing processes by deploying those tasks to [Travis-ci](travis-ci.org) hosted service with custom scripts, so the developers can focus solely on writing codes. 

Travis-ci supports up-to-date languages including C, C++, Python, Java, PHP, Scala, node-js etc. 

Travis-ci can be activated either by commits only or by commits and pull requests.

## General Concepts

Continuous Integration:

> `User Commits -> Detected by Travis-ci -> Run build script -> Return and Log`

Building lifecycle:

> `Install (install required softwares) -> script (building scripts) -> after_script or deployment (post-processing scripts for deployment or logging or debugging)`

Errors vs. Failures:

> `Error: non-zero return value from a before_install, install or before_script command. Job stops immediately`
>
> `Failure:non-zero return value from a script command. Job continues till the end. after_success or after_failure script can be appended.`

For more core concepts, visit [Core Concepts for Beginners/Customizing Your Build](https://docs.travis-ci.com/user/for-beginners/).

##Prerequisite

- Github login
- Working repository set up with Hexo

> In our example: 
>
> `repo: yourname/yourname.github.io`
>
> `master branch: HTML files for github page, referred as HTML branch`
>
> `source branch: hexo source files, referred as SOURCE branch`
>
> `You can set up HTML/SOURCE branches however you like, even in two different repositories`

##Set up

1. Log in [Travis-ci](travis-ci.org) using your Github account

2. Choose the working repository: `yourname/yourname.github.io`

3. Click on **Settings**
   1. Under **General**: Click on **Build only if .travis.yml is present**
   2. Under **General**: Click on **Build branch updates**
   3. Optional: *Build pull request updates*, *Auto cancellation*

4. Configure **Access Token**

  > You need to configure *Github access token* to allow *Travis* modify your Github repository

  1. Log on [Github](github.com), under **Personal settings -> Developer settings -> Personal access tokens**

  2. **Generate new token**, give it a name

  3. Select **some scopes**: at least `repo, admin:public_key` 

  4. Copy the **token** and save it

  5. Return to [Travis-ci](travis-ci.org), under **Settings**, add the access token as `Environmental Variables`, give it a name (GH_TOKEN). 

     > *Now you have granted Travis-ci the access to operate on your repository*.

5. Configure **.travis.yml**

  > `.travis.yml is used as a configuration script to lay out the build process`
  >
  > `It should be placed under the root directory of the branch to be built`
  >
  > `Multiple .travis.yml can exist for multiple working branches`

  Here I will walk you through a working copy of this file

  For detailed reference, read the [Documentation](https://docs.travis-ci.com/)

  ​

```yaml
language: node_js  # 设置主语言/the primary build langauge.

cache: 	# 为重复缓存组件/caching options for repeatedly loaded softwares to save             
        # build time
  - pandoc
  - hexo-renderer-pandoc

node_js: stable  # 设置node_js版本/set node_js version

python: 3.5 # 设置python版本/set python version (this is the second language I use
            # to run some processing scritps)

branches: # 设置目标分支/set target branches. can be used with only options to 
          # specify the working options.
    only:
      - source # 只在SOURCE branch上编译/only build on SOURCE branch

install: # 安装插件/install required software, such as hexo
  - wget ${pandoc}
  - sudo dpkg -i pandoc*.deb	# 安装pandoc/install pandoc package
  - npm install  # 安装hexo及插件/install hexo
  - npm install hexo-renderer-pandoc --save # 安装pandoc插件/install pandoc plugin

before_script: # 编译前步骤/commands before script build
			   # 设置git账户/set up git credentials
			   # 其他代码/some other codes
    - git config --global user.name 'git commit name'
    - git config --global user.email 'git commit email'
    - cd python-codes
    - ./build.sh # 一些自动生成markdown文章的代码/this is a script to generate some
                 # markdown posts
    - cd ..

script: # 编译/build and testing commands
  - hexo cl  # 清除/clean old hexo public folder
  - hexo g  --config source/_data/next.yml #生成/generate new public folder

after_script: # 编译后步骤：推送github/some deployment codes
    - mkdir .deploy               # 创立一个推送临时文件夹/Create a folder to use for the gh-page branch
    - cd .deploy
    # 下载HTML branch到临时文件夹/download latest version of the HTML branch
    # 也可以直接init临时文件夹并设置好remote/or just init the folder and set up remote
    - git clone --depth 1 --branch master --single-branch $DEPLOY_REPO . || (git init && git remote add -t master origin $DEPLOY_REPO)	
    - rm -rf ./*                      # 删除现存文件/Clear old verion
    - cp -r ../public/* .             # 复制新文件到临时文件夹/Copy over files for new version
    - git add -A .
    - git commit -m 'Site updated'    # Make a new commit for new version
    - git branch -m master
    - git push -q -u origin master  # Push silently so we don't leak information

env: # 设置环境变了/set up other environmental variables
  global:
   - GH_REF: github.com/yourname/yourname.github.io.git  # 设置GH_REF，注意更改yourname
   - DEPLOY_REPO: https://${GH_TOKEN}@${GH_REF}
   - pandoc: https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb
```

Now you are all set.

Just push `.travis.yml` to your branch and the automation process should start in seconds.



# Conclusion

Summing it up, to automate your Hexo website build process and **focus only on writing**, here is what you do,

1. Have a Hexo site built on Github, with one branch for source files, one branch for static files
2. Configure travis-ci and add .travis.yml to the source file branch
3. Use prose.io to edit or create posts



#Additional resources

[Official Prose.io Documentation](https://github.com/prose/prose/wiki/Getting-Started)

[Official Travis-ci Documentation](https://docs.travis-ci.com/)

[.travis.yml by HoverBaum](https://gist.github.com/HoverBaum/d11361337d2c59f0de591c9c9390c1a9)

[Continuous Integration Your Hexo Blog With Travis CI](http://lzhr.github.io/2016/06/04/Continuous-Integration-Your-Hexo-Blog-With-TravisCI.html)

[使用 Travis CI 自动部署 Hexo](http://www.jianshu.com/p/5e74046e7a0f)



[^1]: [About at Prose.io](http://prose.io/#about)
[^2]: [BLOGGING LIKE A DEV: JEKYLL + GITHUB + PROSE.IO](http://allandenot.com/development/2015/01/11/blogging-like-a-dev-jekyll-github-prose-io.html)
[^3]: [Wikipedia Travis CI](https://en.wikipedia.org/wiki/Travis_CI)
