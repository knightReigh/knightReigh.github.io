---
title: Simple Guide to Set up Github Website
date: 2017-11-08 00:00
categories: ['programming']
tags:
  - webdev
  - Jekyll
---


Github Page provides a fast and easy way to set up a static website/blog. It uses Github as a free hosting platform, which comes with free domain, and Jekyll as a very simple site generator. Although there have been a million tutorial and documentation on how to use it, I found them usually over complicated and not easy to get started. Therefor I want to share my own experience setting up one blog from scratch with a chosen TEMPLATE; and you can just follow these steps to start your own site as well. 

<!-- more -->

# Basic concepts
Here we introduce few basic concepts that help you understand the services that we are going to set up our website.

## Github
Github is a online code [plaintext] hosting service. It is free for a public project. You need to pay to make a private project. You can use the service through its web interface, or with its local managing tool git.

For a complete tutorial on github, visit [Github 101](https://guides.github.com/) and [Github Simple Guide](http://rogerdudler.github.io/git-guide/)

**Terms you need to know now**

---------------------------------------
Term            					   Definition
--------------------------   ----------------------------------------------------------------------------
**Repository**  					   A Github project

**Branch**      					   A isolated copy of project for testing new features
 
**Clone**									   Action to copy the online repository to your local machine

**Add, commit, and push**    Actions to submit a change from local copy to online repository 

**Pull**        						 Action to update your local copy from onlien repository newest changes

**Merge**      							 Action to combine tested features from branches back into the master branch

**Fork**        						 Make a copy of someone else's project and put it under your account (You can build your own project from it if the license permits)
------------------------------------------

## Github page
Github page is a feature provide by Gitub to host user, organization, and project pages directly based on Github repository. It starts with the idea to quickly generate product documents for Github projects, but then expands to *anything* you want to publish to the web, officially. There is a [full documentation](https://pages.github.com/) for Github page and examples, I will just put down some pros-cons.

***Github page is good for***:

`Small, fast and static</b> websites or blogs that provides <b>public and non-sensitive information.`

***Github page is not designed for/does not support***:
```
Server-side code such as PHP, Ruby, or Python
Sensitive transactions such as passwords, credit card information etc
Sites larger than 1GB, or monthly bandwidth over 100GB or hourly build over 10 builds.
```
## Jekyll
Jekyll is a static site generator that renders user post files and template files into complete HTML website files.You will provide the template files that tells Jekyll how your website should look like and the post files containing the contents. Jekyll will do all the dirty work.
For a complete guide on Jekyll, visit its [official website](https://jekyllrb.com/)

&nbsp;
<center><font size="3">Now that we have some understandings on the tools and platforms,</font></center>

<center><font size="3">We will begin to build the site.</font></center>
&nbsp;

# Set up a Github page repository
Github page allows you to create websites based on your existing repository or with a new repository. You can set up a user/organization github page or a project page. 

## Set up a user/organization github page
1. Go to [Github](https://github.com) and create a new repository named **username.github.io**. Username has to match your user name/organization name on Github. If not, it will not work. 
2. Create index.html that contains any strings. The index.html will serve as your homepage content.If index.html does not exist, README.md will be used. 
3. Commit and push (if created using terminal)

*To make sure that your site works, log into your Github repository and check under `Settings`. You should see Github page service activated.*

## Set up a project github page
1. Create or log into an existing Github project
2. Create a **gh-pages** branch
3. Go to **Settings** and choose gh-pages branch under **Source** and save.  
4. You will see your Github page link right above the line.

*If no website file is added, README.md will be used as `index.html`.*

# Choose a template
Now that we have a working website literally. All you need to do is to set up how it should look like (template or theme) and add real contents.

Like any other staitc website framework, Jekyll depends on different modules to build a good-looking website. In a snapshot, you will need those files.

 -----------------------------------------------------------------------
 File/Folders   Description 
 -------------  -------------------------------------------------------------------------
 index.html     Homepage template to display the front page  

  \_config.yml  Jekyll configuration file that sets up site description, meta description, baseurl, markdown type, default post setting etc. The content of this file depends on functions the theme provided  

  \_layouts/    template files defining how posts are wrapped on a post-by-post base  

  \_includes/   partials that can be reused in layouts and posts. Using liquid tag {% raw %}{% include "file.ext" %}{% endraw %} to access partial in \_includes/file.ext  

  \_sass/       sass partials to be used to generated your main.css stylesheet  

  \_assets/     store custom files such as images  

  css/   				main css or sass files  

  \_posts/   		individual post files (YEAR-MONTH-DAY-title.markdown or .md  

  \_drafts/   	individual draft files (title.markdown), will not be published. Preview with Jekyll serve --draft   
 -----------------------------

For a full list of modules and explanation, visit [Jekyll Doc](https://jekyllrb.com/docs/structure/)

**And don't worry!** If you uses Github Theme Chooser, you only need index.html to start with. If you are using an existing theme, most of them will provide all these files.

**Now let's see how to apply a theme.**

## Use Github's Jekyll theme chooser
The easiest way to apply a theme is to use the build-in [Jekyll theme chooser](https://help.github.com/articles/creating-a-github-pages-site-with-the-jekyll-theme-chooser/). 

If you start with a new repository, just go to **Settings** and click on **Choose a theme**. Pick up a theme and click **Select**. Bingo!

If you start with an existing repository, do the same but make sure to correct all your markdown files. For more information, visit [Troubleshooting](https://help.github.com/articles/troubleshooting-github-pages-builds/).

## Use general Jekyll theme
Another option is to use a general theme that is developed for Jekyll framework, which might not be officially supported by Github. But you will have way more options.

The process is also very easy.

1. Clone the theme repository to your local disk

2. Modify necessary files such as *index.html*, *_config.yml*, or *_posts* to reflect your own contents 

3. Test the theme with *Jekyll serve* on local machine

4. Make a backup of your existing repository (post files, old themes, configurations etc)

5. Copy the new theme to your repository, add, commit and push

6. Check the published site for any error and correction 

If you have problem seeing the site, you might want to try set the baseurl in /_config.html to your Github page url.

&nbsp;
<br><center><font size="3">Now it's time to write your first post</font></center></br> 
&nbsp;

# Write your first post

The primary reason that I prefer Github page over other more sophisticated Web publishing platform is that Github page allows people to concentrate on the contents with a overly simplified editing interface such as *Vim* and provides an almost instant preview of work on local Jekyll server, without using a mouse or messing with server/database/PHP installations.

**Writing a post with Github page is as easy as adding a file to a folder. Yes, just create one markdown file and push it to the \_posts directory. That is all you need to do.**

There are few rules you need to follow though:

+ The file must follow the format: **YEAR-MONTH-DAY-title.MARKUP**. Example: 2017-01-01-Hello.markdown
+ The content must begin with [YAML Front Matter](https://jekyllrb.com/docs/frontmatter/)
    <pre>
      ---
      layout: post
      title: Blogging Like a Hacker
      ---
    </pre>
  The YAML Front Matter tells Jekyll how to process the file with predefined variables 
+ Write your post with the markdown language of your choice

For more information on writing a post with enriched content such as inserting images, creating an index and so on, visit the [official Jekyll tutorial](https://jekyllrb.com/docs/posts/)

# Develop on local machine

The last part I want to show you is how to set up a local installation of Jekyll environment on your own machine, from which you can test your website before publishing it online, experimenting with different template, writing posts while you have no internet, and many other things offline.

**Requirement**
```
1. GNU/Linux, Unix or macOS

2. [Ruby](https://www.ruby-lang.org/en/downloads/) version 2.1, with development branch (-dev)

3. [RubyGems](https://rubygems.org/pages/download)

4. GCC and Make (You should have it with Linux installation. If something is wrong, try upgrade them to newest version with apt-get first)

For Jekyll 2 or earlier version, install Python2.7 and NodeJS
```

**Installation**

Use *gem* to install: `gem install jekyll bundler`

To update existing installaiton: `gem update jekyll`

**Usage**

Go to your local github page directory, run:
````
Jekyll serve
Browse to [http://localhost:4000](http://localhost:4000)
````
For a full guide, visit [Quick-start](https://jekyllrb.com/docs/quickstart/)

