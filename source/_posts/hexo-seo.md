---
title: Search Engine Optimization for Hexo-next site
date: 2017-11-12 01:49:18
categories: ['programming']
tags:
  - webdev
  - seo
  - google-webmaster
  - hexo
---
This is an article publised by [RuJia](http://www.ehcoo.com/seo.html) to set up simple SEO improvement on Hexo supported website. It targeted both on Google Search Engine and Baidu Search (an equivalent in China). It's simple and elegant; therefore I translated into English for my own reference and hoping to help new bloggeres.
<!-- more -->

{% asset_img 001.bmp %}

# Optimizing title

All SEO about is to make it easy for search engine to find your website by keywords of different priorities. 
For website titles, the optimization keys are **important tags first, using pipes to separate and being short, precise and descriptive**. 
The goal is to have a human readable title that is also easily understood by computers.

> For more detailed explanation, visit [this](https://searchenginewatch.com/sew/how-to/2154469/write-title-tags-search-engine-optimization) site.

To optimize, edit this file:  `website/themes/next/layout/index.swig`

Change line:
```html
{% block title %}{{ config.title }}{% if theme.index_with_subtitle and config.subtitle %} - {{config.subtitle }}{% endif %}{% endblock %}
```

To:
```html
{% block title %}{{ theme.keywords }} - {{ config.title }}{% if theme.index_with_subtitle and config.subtitle %} - {{config.subtitle }}{% endif %}{{ theme.description }}{% endblock %}
```
*There is now an option to turn on title seo in [Next](https://github.com/iissnan/hexo-theme-next/releases)'s configuration file. However, the title disappears on the index page. It's probably going to be fixed som time in the future, but for now, I would just hand-edit the file.*

# Permalinks

The default permalink format is `::year::month::day::postname`, which is very annoying and seo-unfriendly. It is recommended to change it to `permalink: :title/` in the `_config.yml` file.

Notice the extra space in-between and the **two** colons.

# Use sitemap

> Sitemaps are used by search engines such as Google to quickly find all your web **pages** not just your website. It is like a quick guide to all your rooms in your house. Because Google ranks webpages instead of website, it is extremely helpful to have such as guide on your site for Google to crawl.

Plus, if you site is newly online and have dynamically generated pages, a sitemap helps both Google and site visitors understand better your website structure.

Sitemaps are usually placed directly under your website directory. the `/` and under the name `sitemap.xml`.

For Hexo generated site, there are two plugins to help generate sitemaps:

`npm install hexo-generator-sitemap --save`

`npm install hexo-generator-baidu-sitemap --save`

The latter is for Baidu.com, a Google equivalent search engine in China.

After you install the two plug-ins, add the following lines to your `_config.yml` file:

```yaml
sitemap:
  path: sitemap.xml
baidusitemap:
  path: baidusitemap.xml
```

Also edit `url` in the configuration file. Note that if your website is hosted on Github page (free version), prefix `https://` in front of your domain name, otherwise Google will not recognize urls generated.

`url: url: https://yoursite.github.io`

Now, run `hexo g`. You should be able to see `sitemap.xml` and `baidusitemap.xml` under your `\public` folder.

# Set up robots.txt

> Unlike sitemaps, `robots.txt` is used to defend your content against web crawls, or robots.
> 
> By default, search engines and web crawls will crawl **all** your content on your website. However, you could deny this behavior by add a `robots.txt` under your website's root directory and using codes like `Allow` and `Disallow` to control the access.

Here is the default example and should be placed under your `source` directory.

```
# hexo robots.txt
User-agent: *

Allow: /
Allow: /archives/
Allow: /categories/
Allow: /tags/
Allow: /about-me/

Disallow: /vendors/
Disallow: /js/
Disallow: /css/
Disallow: /fonts/
Disallow: /vendors/
Disallow: /fancybox/

Sitemap: https://yoursite/sitemap.xml
Sitemap: https://yoursite/baidusitemap.xml
```
The last two lines are to add the sitemaps for search engines. You can directly upload it to `Google Search Console` instead of adding them here.

# Google search optimization

1. Register for Google Search Console
  {% asset_img gseo1.bmp %}
2. Add your website
  {% asset_img gseo2.bmp %}
3. Follow steps to *verify* your website. I used the `HTML tag`. 
   To do so, copy the provided string to your `themes/next/layout/_partials/head.swig`.
  {% asset_img gseo3.bmp %}
4. Upload your udpated website. Wait for a while.
5. Test your `robots.txt`
  {% asset_img gseo4.bmp %}
6. Submit your sitemaps
  {% asset_img gseo5.bmp %}

If everything goes without errors, your Google SEO is done. Allow google few days to start indexing webpages. You can also manually submit indexing requests by using the `crawl -> Fetch as Google` function on the left panel.
  {% asset_img gseo6.bmp %}

# Baidu search optimization

It is the same procedure to optimize for Baidu.com search engine. You will need to register for a Baidu account with real name and a Chinese cell phone number.

# Keywords

Keywords is another important seo part in your website's `meta-tag` region. The `meta-tag` contains descriptive information about your websites that feeds search engine and web crawlers. The website title is part of this meta data.

1. Add keywords to your `_config.yml` by editing `keywords: key1, key2, key3`. Notice the **space** and **,** separator.
2. Add keywords to your posts' meta data by adding `keywords: ` and `description: `. Notice the **space**.

# Add "nofollow" tag to exturl

> "Nofollow" provides a way for webmasters to tell search engines "Don't follow links on this page" or "Don't follow this specific link." by [Google](https://support.google.com/webmasters/answer/96569?hl=en).

It basically ask search engines not to include any outgoing links on your website tagged with "nofollow" in order to **1) avoid untrusted content**, **2) Paid/advertised links**, **3) Unimportant links**. It all contributes to up-ranking your useful links and leveling your website's search priorities. 

Basically, you can add this `rel="external nofollow"` tag to any links of your discretion. In the default *Next* theme files, there are few outgoing advertising links.

In the `themes/next/layout/_partials/footer.swig`, change the two lines

```
{{ __('footer.powered', '<a class="theme-link" href="http://hexo.io">Hexo</a>') }}

<a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">


```

to

```
{{ __('footer.powered', '<a class="theme-link" href="http://hexo.io" rel="external nofollow">Hexo</a>') }}

<a class="theme-link" href="https://github.com/iissnan/hexo-theme-next" rel="external nofollow">

```

And in `themes/next/layout/_macro/sidebar.swig`, change the two lines

```
<a href="{{ link }}" target="_blank">{{ name }}</a>
```
to
```
<a href="{{ link }}" target="_blank" rel="external nofollow">{{ name }}</a>

<a href="http://creativecommons.org/licenses/{{ theme.creative_commons }}/4.0" class="cc-opacity" target="_blank" rel="external nofollow">
```

# Acknowledgement

This article is based on [this](http://www.ehcoo.com/seo.html) Chinese article. It is merely a reproduction and translation. All effort goes to the original author.

For more readings on SEO, refer to [Google Search Console](https://support.google.com/webmasters/answer/40349?hl=en) documentation and its [Starter Guide](https://static.googleusercontent.com/media/www.google.com/en//webmasters/docs/search-engine-optimization-starter-guide.pdf)

Thanks for reading.
