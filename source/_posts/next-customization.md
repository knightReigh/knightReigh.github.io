---
title: Custmoizing Hexo blog theme-Next and Swiper
date: 2017-11-10 00:00
categories: ['programming']
tags:
  - webdev
---

The first thing after moving into a new home is thinking about decoration. We want something more personal, something that represents our taste, style and preference. Or we just want the style that fits the theme, whether it's sci-fi, techie, or kawaii. This is a scratch note on decorating a Hexo-based blog. It is based on some amazing guides from others. My effort is merely an application and translation.

<!-- more -->

# Customization with Style Sheet

```
Theme Version: 5.1.2

Scheme: Gemni

Languges: Less CSS, CSS, YAML, js

! CSS modification will vary depending on the schem![003](next-customization/003.png)e you choose and the theme version
```

> Recommended reading
>
> [打造个性超赞博客Hexo+NexT+GithubPages的超深度优化](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)
>
> [HEXO+NEXT主题个性化配置](http://mashirosorata.vicp.io/HEXO-NEXT%E4%B8%BB%E9%A2%98%E4%B8%AA%E6%80%A7%E5%8C%96%E9%85%8D%E7%BD%AE.html)

{% asset_img 003.png %}

{% asset_img 002.bmp %}

{% asset_img 001.bmp %}


## Change Sidebar Position

It used to be part of customization codes but thanks to recent theme update, it now becomes a default option. For more details, just look inside your `_config.yml`.

## Custom Avatar + Avatar Animation

Wondering about having animation on your profile image? It's in the `site-author-image` section.

```yaml
// _config.yml

avatar: image_url

// components/sidebar/sidebar-author.styl

.site-author-image {
    border: 2px solid rgb(255, 255, 255);
    border-radius: 80px;
    transition: transform 1.0s ease-out;
}

img:hover {
    transform: rotateZ(360deg);
}

.posts-expand .post-body img:hover {
    transform: initial;
}

```

## Sidebar Background and Text Color

```css
// Custom location: themes/next/source/css/_custom/custom.styl
// Original file: themes/next/source/css/_schmes/Pisces/_sidebar.styl:
// 		(for @Gemni, _sidebar.styl is imported from @Pisces)
  
.sidebar-inner{
      background:url(image_path);  
      p,span,a {color: $orange; // text color inside sidebar  
} 
```

## Background and transparency

```css
// _schemes/Gemni/index.styl

body{
        background:url(/images/bwtvyjsuhbe.jpg);
        background-size:cover;
        background-repeat:no-repeat;
        background-attachment:fixed;
        background-position:center;
}

// _common/components/_post/post.styl
.post-block {
  background: rgba(255,255,255,0.8);
  border-radius: 10px;
}

! by default, content-wrap is set to transparent
```

## Sidebar properties

In `Gemni` scheme, sidebar is separated into two parts: `meta + menu` and `avatar + toc`. The `meta + menu` region holds site name and menu; the `avatar + toc` region switch between the site information and a `toc` if available.

###meta + menu

```css
// css/_schemes/Pisces/_brand.styl

// site-meta background
.site-meta {
  background-image: linear-gradient(45deg, #F79533 0%, #F37055 15%, #EF4E7B 30%, #A166AB 44%, #5073B8 58%, #1098AD     72%, #07B39B 86%, #6DBA82 100%);
}

// _schemes/Pisces/_menu.styl

// menu background
.site-nav {
  background: url(image_path) or $color_code;
}

// menu hover
.menu .menu-item {
  &:hover{ // hover transition effects
    background:$color_code;
    color: $orange; // will inherint a {} if not set
    border-bottom-color:$rgba(299,99,0,0.3);
  }
}

// menu dot
.menu-item-active a {
  @extend .menu .menu-item a:hover;
  // optional
  // .menu-item-icon {color:$color_code}
  
  &:after { // the tiny square dot at the right of each menu item
    background-color: $orange;
  }
}

```

###avatar + toc 

####sidebar background + description

```css
// _common/components/sidebar/sidebar-nav.styl
.sidebar-inner {
  background:url(/images/sidebar.jpg);
}

.site-author-name {
  color: rgba($theme-color, $transparency-sidebar);
}

.site-state {
  p,span,a {color: rgba($theme-color, $transparency-sidebar);}
}

.site-state-item {
  p,span,a {color: rgba($theme-color, $transparency-sidebar);}
}

! and more properties: to be added
```

####sidebar toc

```css
// _common/components/sidebar/sidebar-nav.styl

// sidebar-toc title
.sidebar-nav li {
  &:hover { color: rgba($theme-color, $transparency-sidebar); }
}

.sidebar-nav .sidebar-nav-active {
  color: rgba($theme-color, $transparency-sidebar);
  border-bottom-width: 1.5px;
  border-bottom-color: rgba($theme-color, $transparency-sidebar);

  &:hover { color: rgba($theme-color,$transparency-sidebar); }
}

// _common/components/sidebar/sidebar-toc.styl

// sidebar-toc link
.post-toc ol a {
    color: $black-light;
    border-bottom: 1px solid #999;
}

.post-toc ol a:hover {
    color: $theme-color;
    border-bottom-color: $theme-color;
}

// sidebar-toc active link
.post-toc .nav .active > a {
    color: $theme-color;
    border-bottom-color: rgba($theme-color,$transparency-sidebar);
}
.post-toc .nav .active > a:hover {
    color: $theme-color;
    border-bottom-color: rgba($theme-color,$transparency-sidebar);
}
```

###avatar animation

```css
// _common/components/sidebar/sidebar-author.styl

.site-author-image {
    border: 2px solid rgb(255, 255, 255);
    border-radius: 80px;
    transition: transform 1.0s ease-out;
}

img:hover {
    transform: rotateZ(360deg);
}

.posts-expand .post-body img:hover {
    transform: initial;
}
```



## Post-title, Post-nav and Post-tag

Post-title is located at `post/post-title.styl`

Post-nav and post-tag are basically hyper-links, formatted in `post/post-nav.styl & post-tag.styl`

A snippet of related `layout`  file is shown:

```html
// layout/page.swig

<div id="posts" class="posts-expand"> </div>
<div class="tag-cloud-tags"> </div>
```

The customization snippet is as:

```css
// post title & title-link: components/post/post-title.styl
.posts-expand .post-title {
  height: 1px;
  color: $orange;
}

.posts-expand .post-title-link {
  color: $orange;

  &::before {
    background-color: $orange;
  }
}

// components/post/post-nav.styl
// components/post/post-tag.styl
// this is default, can be changed

.post-nav-item a {
    color: $link-color;
  &:hover {
    color: $link-hover-color;
  }
}
```

## Custom variable

>The css variables are loaded before _custom/custm.styl so if you want to style your website based on some variables, you need to do it in /css/_variable/custm.styl

```css
// There are many variable defined across the theme's stylesheets
// They are referred by many style declarations
// Original file: /css/_variables/base.styl
// Custom location: /css/_variable/custom.styl

// Global link color
$link-color                   = $black-light
$link-hover-color             = $orange
$link-decoration-color        = $grey-light
$link-decoration-hover-color  = $red

// Global button variables
$btn-font-weight                = normal

$btn-default-radius             = 0 
$btn-default-bg                 = $orange
$btn-default-color              = white
$btn-default-font-size          = 14px
$btn-default-border-width       = 2px 

$btn-default-border-color       = $orange
$btn-default-hover-bg           = white
$btn-default-hover-color        = $orange
$btn-default-hover-border-color = $orange



```

## Tag-Cloud

```css
// layout/page.swig
// so you can see the color is set inside the layout file

1. Modify the /layout/page.swig to choose your color gradiet
{{ tagcloud({min_font: 12, max_font: 30, amount: 300, color: true, start_color: '#ccc', end_color:'#111'}) }}

2. Add custom css to /_custom/custom.styl
.tag-cloud a {
    color: rgb(5, 147, 211);
    border-bottom: 1px solid rgb(5, 147, 211);                                                                         
    text-decoration: none;

    &:hover {
    color: $theme-color;
    border-bottom: 1px solid rgb(255, 118, 0);
    text-decoration: none;
    }
}
```

For color gradient, you can reference [this](https://uigradients.com/) website.

## Hyper-link

```css
// css/_common/scaffolding/base.styl

a {
  color:$black-light;
  border-bottom: 1px solid $grey-dark;
  word-wrap: break-word;

  &:hover{
    color:$theme-color;
    border-bottom-color:$theme-color;
  }
}
```

## Archive: Timeline Style

```css
// _common/components/post/post-collapse.styl

// timeline
.posts-collapse::after {
    margin-left: -2px;
    background: rgb(255, 118, 0);
    background-image: linear-gradient(180deg,#f79533 0,#f37055 15%,#ef4e7b 30%,#a166ab 44%,#5073b8 58%,#1098ad 72%,    #07b39b 86%,#6dba82 100%);
}
// decoration dot on timeline
.posts-collapse .collection-title::before {
    background: rgb(255, 255, 255);
}
// first decoration dot on timeline
.page-archive .posts-collapse .archive-move-on {
    top: 10px;
    opacity: 1;
    background: rgb(255, 255, 255);
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.5);
}
// active decoration dot
.posts-collapse .post-header::before {
    background: rgb(255, 255, 255);
}
.posts-collapse .post-header:hover::before {
    background: rgba($theme-color, $transparency-sidebar);                                                             
}

// timeline title
.posts-collapse .post-title a {
    color: $black-light;
}
.posts-collapse .post-title a:hover {
    color: rgba($theme-color, $transparency-sidebar);
}

// timeline dotted line underneath title
.posts-collapse .post-header:hover {
    border-bottom-color: rgba($theme-color, $transparency-sidebar);
}

.collection-title h1 {
  background-image: linear-gradient(90deg,#f79533 0,#f37055 15%,#ef4e7b 30%,#a166ab 44%,#5073b8 58%,#1098ad 72%,       #07b39b 86%,#6dba82 100%);
  color: white;
}  
```

## Button style

```css
//_common/components/post/post-button.styl

// post button (readmore)
.post-button {
  .btn {
    color: rgba($theme-color, $transparency-normal);
    background: rgba(255,255,255,0.7);
    border: 1.5px solid rgba($theme-color, $transparency-normal);
    border-radius: 5px
  }
  .btn:hover {
    border: 1.5px solid rgba(255,255,255,0);
      background: rgba($theme-color, $transparency-normal);
  }
}

```

## Back-to-top button

It is set to be somewhat transparent, so whatever you change here will become a little transparent.

```
.back-to-top {
    right: 10px;
    padding-right: 5px;
    padding-left: 5px;
    padding-top: 2.5px;
    padding-bottom: 2.5px;
    background: $theme-color;
    border-radius: 5px;
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.35);
}
.back-to-top.back-to-top-on {
    bottom: 10px;
}

```

## Local Search

{% asset_img 005.bmp %}

Local search needs to be installed first: 

`npm install hexo-generator-search --save`

Then, enable it inside `_config.yml`

```yaml
local_search:
  enable: true
  # if auto, trigger search by changing input
  # if manual, trigger search by pressing enter key or search button
  trigger: auto
  # show top n results per article, show all results by setting to -1
  top_n_per_article: 1
```

Configure the style by

```css
// _common/components/third-party/localsearch.styl

.local-search-popup .search-icon, .local-search-popup .popup-btn-close {
    color: rgb(255, 118, 0);
    margin-top: 7px;
}
.local-search-popup .local-search-input-wrapper input {
    padding: 9px 0;
    height: 21px;
    background: rgb(255, 255, 255);
}
.local-search-popup .popup-btn-close {
    border-left: none;
}
```

## Table Style

Table style depends more on the render you use. For example, you will get different width distribution depending on whether you are using the default `markdown` render or something more advanced such as `pandoc`. However you can always change some more general styles such as background color with `css`.

```css
table {
    //background-color: rgba(255, 255, 255, 0.9);
    background-color: rgba($theme-color, $transparency-normal);
    color: rgba(0, 0, 0, 0.9);
    border: 1px solid rgba(221, 221, 221, 0.9);
}
table>tbody>tr:nth-of-type(odd) {
    background-color: rgba(240, 240, 240, 0.9);
}
table>tbody>tr:hover {
    background-color: rgba(245, 245, 245, 0.9);
}
th, td {
    border-bottom: 3px solid rgba(221, 221, 221, 0.9);
    border-right: 1px solid rgba(238, 238, 238, 0.9);
} 
```



## Complete custom style sheet

Here I attach my custom style sheet for reference. 

```css
// custom variable
$theme-color                  = $orange
$theme-color-light            = rgba($orange, 0.5)
$transparency-normal          = 0.8
$transparency-sidebar					= 0.9


/*** BACKGROUND, HEADBAND ***/

.headband {
    height: 1.5px;
    background: rgba(255, 255, 255, 0);
    background-image: linear-gradient(90deg, #F79533 0%, #F37055 15%, #EF4E7B 30%, #A166AB 44%, #5073B8 58%, #1098AD 72%, #07B39B 86%, #6DBA82 100%);
}


// background + transparency
body{
        background:url(/images/bwtvyjsuhbe.jpg);
        background-size:cover;
        background-repeat:no-repeat;
        background-attachment:fixed;
        background-position:center;
}

.post-block {
	background: rgba(255,255,255,0.9);
	border-radius: 10px;
}


/*** POST ***/

// post title + link title
.posts-expand .post-title {
  color: darken($theme-color,0.5);
}

.posts-expand .post-title-link::before {
    height: 2px;
    background-color: darken($theme-color,0.5);
    background-image: linear-gradient(90deg, #F79533 0%, #F37055 15%, #EF4E7B 30%, #A166AB 44%, #5073B8 58%, #1098AD 72%, #07B39B 86%, #6DBA82 100%);
}

// title gradient
.post-body h1, h2, h3, h4, h5, h6 {
    //border-left: 5px solid rgb(34, 244, 246);
    //margin-left: -15px;
    //padding-left: 10px;
    background-image: linear-gradient(90deg, #3a6186, #89253e);
    background-size: cover;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.post-nav-item a:hover {
	color:$theme-color;
}

// post button (readmore)
.post-button {
	.btn {
		color: rgba($theme-color, $transparency-normal);
		background: rgba(255,255,255,0.7);
		border: 1.5px solid rgba($theme-color, $transparency-normal);
		border-radius: 5px
	}
	.btn:hover {
		border: 1.5px solid rgba(255,255,255,0);
			background: rgba($theme-color, $transparency-normal);
	}
}


/*** HYPERLINKS ***/

// hyper-links
a {
  color:$black-light;
  border-bottom: 1px solid $grey-dark;
  word-wrap: break-word;

  &:hover{
    color:$theme-color;
    border-bottom-color:$theme-color;
  }
}


/*** SIDEBAR ***/

// site-meta background
.site-meta {
	background-image: linear-gradient(45deg, #F79533 0%, #F37055 15%, #EF4E7B 30%, #A166AB 44%, #5073B8 58%, #1098AD 72%, #07B39B 86%, #6DBA82 100%);
}

// menu background
.site-nav {
  background:white;
}

// menu hover
.menu .menu-item {
	font-weight:bold;
  a {
    &:hover{
      background: #f9f9f980;
      color: $theme-color;
      border-bottom-color: rgba($theme-color,0.3);
    }
  }
}

.menu-item-active a {
  @extend .menu .menu-item a:hover;
  // optional
  // .menu-item-icon {color:$color_code}

  &:after { // the tiny square dot at the right of each menu item
    background-color: $theme-color;
  }
}

// sidebar general

.site-author-image {
    border: 2px solid rgb(255, 255, 255);
    border-radius: 80px;
    transition: transform 1.0s ease-out;
}

img:hover {
    transform: rotateZ(360deg);
}

.posts-expand .post-body img:hover {
    transform: initial;
}

// sidebar background + description
.sidebar-inner {
  background:url(/images/sidebar.jpg);
}

.site-author-name {
  color: rgba($theme-color, 1.0);
}

.site-state {
	p,span,a {color: rgba($theme-color, 1.0);}
}

.site-state-item {
	p,span,a {color: rgba($theme-color, 1.0);}
}

// sidebar toc title
.sidebar-nav li {
  &:hover { color: rgba($theme-color, $transparency-sidebar); }
}

.sidebar-nav .sidebar-nav-active {
  color: rgba($theme-color, $transparency-sidebar);
	border-bottom-width: 1.5px;
  border-bottom-color: rgba($theme-color, $transparency-sidebar);

  &:hover { color: rgba($theme-color,$transparency-sidebar); }
}

// sidebar-toc link
.post-toc ol a {
    color: $black-light;
    border-bottom: 1px solid #999;
}

.post-toc ol a:hover {
    color: $theme-color;
    border-bottom-color: $theme-color;
}

// sidebar-toc active link
.post-toc .nav .active > a {
    color: $theme-color;
    border-bottom-color: rgba($theme-color,$transparency-sidebar);
}
.post-toc .nav .active > a:hover {
    color: $theme-color;
    border-bottom-color: rgba($theme-color,$transparency-sidebar);
}

// sidebar toggle button
.sidebar-toggle {
    right: 10px;
    bottom: 43px;
    background: rgba($theme-color, 0.8);
    border-radius: 5px;
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.35);
}

/*** TAG CLOUD ***/
.tag-cloud a {
    color: rgb(5, 147, 211);
    border-bottom: 1px solid rgb(5, 147, 211);
    text-decoration: none;

		&:hover {
    color: $theme-color;
    border-bottom: 1px solid rgb(255, 118, 0);
    text-decoration: none;
		}
}

//categories
.category-all-page .category-list-count {
  color: #3a6186;

  &:before {
    display: inline;
    content: " ("
  }

  &:after {
    display: inline;
    content: ") "
  }
}

/*** COMMENTS ***/

.comments {
    margin-top: 50px;
    margin-right: 20px;
    margin-bottom: 20px;
    margin-left: 20px;
    border-radius: 3px;
    background: rgba(255, 255, 255, 0.35);
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.35);
}

/*** ARCHIVE TIMELINE ***/

.collection-title h1 {
  background-image: linear-gradient(90deg,#f79533 0,#f37055 15%,#ef4e7b 30%,#a166ab 44%,#5073b8 58%,#1098ad 72%,#07b39b 86%,#6dba82 100%);
	color: white;
}

// timeline
.posts-collapse::after {
    margin-left: -2px;
    background: rgb(255, 118, 0);
    background-image: linear-gradient(180deg,#f79533 0,#f37055 15%,#ef4e7b 30%,#a166ab 44%,#5073b8 58%,#1098ad 72%,#07b39b 86%,#6dba82 100%);
}
// decoration dot on timeline
.posts-collapse .collection-title::before {
    background: rgb(255, 255, 255);
}
// first decoration dot on timeline
.page-archive .posts-collapse .archive-move-on {
    top: 10px;
    opacity: 1;
    background: rgb(255, 255, 255);
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.5);
}
// active decoration dot
.posts-collapse .post-header::before {
    background: rgb(255, 255, 255);
}
.posts-collapse .post-header:hover::before {
    background: rgba($theme-color, $transparency-sidebar);
}
// timeline title
.posts-collapse .post-title a {
		color: $black-light;
}
.posts-collapse .post-title a:hover {
    color: rgba($theme-color, $transparency-sidebar);
}

// timeline dotted line underneath title
.posts-collapse .post-header:hover {
    border-bottom-color: rgba($theme-color, $transparency-sidebar);
}


/*** FOOTER ***/

.footer {
    background: rgba(255, 255, 255, 0.75);
    font-size: 15px;
    color: rgb(0, 0, 0);
    border-top-width: 3px;
    border-top-style: solid;
    border-top-color: rgba(255, 118, 0, 0.75);
    padding-top: 0px;
    position: absolute;
    left: 0;
    bottom: 0;
    box-shadow: 0px -10px 10px 0px rgba(0, 0, 0, 0.15);
}


/*** HEXO TAGS: BLOCKQUOTE ***/

blockquote {
   // padding-top: 3px;
    padding-right: 25px;
    //padding-bottom: 3px;
    padding-left: 25px;
    //color: rgba(255, 255, 255, 0.85);
    border-left: 5px solid darken($theme-color,0.5);
}

blockquote.question {
    //color: rgba(0, 0, 0, 0.95);
    //padding-left: 25px;
    border-left: 5px solid rgb(5, 154, 37);
    //background: rgba(255, 255, 255, 0.75);
    //border-top-right-radius: 3px;
    //border-bottom-right-radius: 3px;
}

/*** TABLE ***/

table {
    //background-color: rgba(255, 255, 255, 0.9);
    background-color: rgba($theme-color, $transparency-normal);
    color: rgba(0, 0, 0, 0.9);
    border: 1px solid rgba(221, 221, 221, 0.9);
}
table>tbody>tr:nth-of-type(odd) {
    background-color: rgba(240, 240, 240, 0.9);
}
table>tbody>tr:hover {
    background-color: rgba(245, 245, 245, 0.9);
}
th, td {
    border-bottom: 3px solid rgba(221, 221, 221, 0.9);
    border-right: 1px solid rgba(238, 238, 238, 0.9);
}

/*** CODE BLOCK ***/

code {
    color: rgba(0, 0, 0, 0.95);
    background: rgba(255, 255, 255, 0.75);
    margin: 1px 3px;
    padding: 1px 3px;
}

/*** LOCAL SEARCH ***/

.local-search-popup .search-icon, .local-search-popup .popup-btn-close {
    color: rgb(255, 118, 0);
    margin-top: 7px;
}
.local-search-popup .local-search-input-wrapper input {
    padding: 9px 0;
    height: 21px;
    background: rgb(255, 255, 255);
}
.local-search-popup .popup-btn-close {
    border-left: none;
}

/*** BACK-TO-TOP ***/

.back-to-top {
    right: 10px;
    padding-right: 5px;
    padding-left: 5px;
    padding-top: 2.5px;
    padding-bottom: 2.5px;
    background: $theme-color;
    border-radius: 5px;
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.35);
}
.back-to-top.back-to-top-on {
    bottom: 10px;
}

/*** SCROLLBAR ***/
/* ref: https://segmentfault.com/a/1190000003708894 */
::-webkit-scrollbar {
    width: 10px;
    height: 10px;
}
/* scroll bar track */
::-webkit-scrollbar-track {
    background: #ccc;
}
/* scroll bar thumb */
::-webkit-scrollbar-thumb {
    border-radius: 2px;
    background: darken($theme-color, 0.5);
}
::-webkit-scrollbar-thumb:hover {
    background: lighten($theme-color,0.5);
}

h2.love {
    border-left: none;
    color: rgb(255, 113, 168);
    -webkit-text-fill-color: unset;
}
```



# Custom Index page using [Swiper](http://idangero.us/swiper/)

[Swiper](http://idangero.us/swiper/) is a modern and smooth touch swiper API from [FrameWork7](http://framework7.io/). It can be implemented as part of webpate, or independently as a single website. 

{% asset_img 006.bmp %}

It is highly customizable so I put it here as one customization method to replace one of my other's website's home page. The demo is [here](https://cutelittleturtle.github.io/).

To implement it, the `HTML` code is simple. Just create a new `index.swig` under `themes/next/layout` and write a full page swiper inside. Be careful about the `js` syntax depending on the version. But you will be able to find answers to most of questions under their Github [issue page](https://github.com/nolimits4web/Swiper/issues) or referencing to their [demo](http://idangero.us/swiper/demos/).

The more complicated part is the `css`. There is no short-cut though, so you will have to adjust the css piece by piece. Look at my website's page source if you need some reference.

`! When referring to your css, be careful about the relative path. If css doesn't work, it is most likely because of the css is not properly found`


```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>YBYARCHIVE</title>
</head>
<body>
	{% include '_third-party/analytics/index.swig' %}
	<meta content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" name="viewport"><!-- Link Swiper's CSS -->
	<link href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.1/css/swiper.min.css" rel="stylesheet"><!-- link rel="stylesheet" href="//css/index-separate/index.css" -->
	<link href="/css/index-separate/all.min.css" rel="stylesheet">
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide" style="background-image:url(/img/index/background1/bk1.png)">
				<img alt="" class="bk1_name" src="/img/index/background1/bk1-name.png" style=""> <img alt="" class="bk1_name_pinyin" src="/img/index/background1/bk1-name-pinyin.png" style=""> <img alt="" class="bk_archive" src="/img/index/onlinearchive.png" style=""> <button class="btn ghost-button responsive-width btn-duiwu" type="button">她的队伍</button> <button class="btn ghost-button responsive-width btn-budang" type="button">视频补档</button> <button class="btn ghost-button responsive-width btn-zhibo" type="button">她的直播</button>
			</div>
			<div class="swiper-slide" style="background-image:url(/img/index/background2/bk2.png)">
				<img alt="" class="bk2_intro" src="/img/index/background2/bk2-intro.png" style=""> <img alt="" class="bk2_list" src="/img/index/background2/bk2-list.png" style=""> <img alt="" class="bk_archive" src="/img/index/onlinearchive.png" style=""> <button class="btn ghost-button responsive-width btn-zhibo-bk2" type="button"><a href="/2015/09/20/ybystream/">直播列表</a></button>
			</div>
			<div class="swiper-slide" style="background-image:url(/img/index/background3/bk3.jpg)">
				<img alt="" class="bk3_intro" src="/img/index/background3/bk3-intro.png" style=""> <img alt="" class="bk_archive" src="/img/index/onlinearchive.png" style=""> <button class="btn ghost-button responsive-width btn-budang-bk3" type="button"><a href="/2015/09/07/ybysource/">补档链接</a></button>
			</div>
			<div class="swiper-slide" style="background-image:url(/img/index/background4/bk4.jpg)">
				<img alt="" class="bk4_teamx" src="/img/index/background4/bk4-teamx.png" style=""> <a href="http://www.snh48.com/member_list.html#s_team_x"><img alt="" class="bk4_zhuye" src="/img/index/background4/bk4-zhuye.png" style=""></a> <a href="http://weibo.com/u/5621452734"><img alt="" class="bk4_yingyuanhui" src="/img/index/background4/bk4-yingyuanhui.png" style=""></a> <a href="http://www.snh48.com/html/allnews/"><img alt="" class="bk4_xinwen" src="/img/index/background4/bk4-xinwen.png" style=""></a> <img alt="" class="bk_archive_l" src="/img/index/onlinearchive.png" style=""> <button class="btn ghost-button responsive-width btn-budang-bk4" type="button"><a href="/2014/09/28/ybygongyanquanchang/">公演全集</a></button>
			</div>
		</div>
		<div class="swiper-pagination"></div>
		<div class="swiper-button-next"></div>
		<div class="swiper-button-prev"></div>
	</div><!-- Swiper JS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.0.1/js/swiper.min.js">
	</script> 
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js">
	</script> <!-- Initialize Swiper -->
	 
	<script>
	   var swiper = new Swiper('.swiper-container', {
	       pagination: {
	                 el: '.swiper-pagination',
	          clickable: true,
	       },
	       navigation: {
	         nextEl: '.swiper-button-next',
	         prevEl: '.swiper-button-prev',
	       },
	       loop: true,
	       preload: true,
	       mousewheel: true,
	       slideToClickedSlide: true,
	   });
	</script> 
	<script>
	   $('.btn-zhibo').click(function(){
	            var index=$(this).attr('href');
	                    swiper.slideTo(2);
	   });

	   $('.btn-budang').click(function(){
	            var index=$(this).attr('href');
	                    swiper.slideTo(3);
	   });

	   $('.btn-duiwu').click(function(){
	            var index=$(this).attr('href');
	                    swiper.slideTo(4);
	   });
	</script>
</body>
</html>
```

#Acknowledgement 

This note could not be compiled without reference from many advanced users.

Special thanks to:

[打造个性超赞博客Hexo+NexT+GithubPages的超深度优化](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html)

[HEXO+NEXT主题个性化配置](http://mashirosorata.vicp.io/HEXO-NEXT%E4%B8%BB%E9%A2%98%E4%B8%AA%E6%80%A7%E5%8C%96%E9%85%8D%E7%BD%AE.html)
