---
title: Blogging on Google Cloud Platform
date: 2017-09-19 21:09:26
categories: ['programming']
tags:
  - webdev
---
Github is more than enough to host your static website. It provides free storage, bandwidth and a in-house static website generator that builds your website online. However, there are occasions when you want to use other hosting services, for reasons such as not exposing your files directly, scaling-up freely based usage, and using plugins that are not supported by Github's strict codecs. While there are many such services, I would like to introduce Google Cloud Platoform, which is nearly-free, code-friendly and built on the top cloud infrastructure.
<!-- more -->

{% asset_img gcp-main.bmp gcp-main  %}

# What is  Google Cloud platform
Google cloud platform is a collection of cloud computing services provided by Google.com that allows users to use the same infrastructures and engines which Google uses for its own services such as Google Search. It provides a wide range of scalable, managable services and products, such as cloud storage, cloud computing, virtual machines, machine learning, data analytics and so on. [More info](https://cloud.google.com/).

## Ways to host website on Google Cloud Platform (gcp)
GCP provides many ways to host website thanks to its huge selection of cloud computing and storage serivcs.

For static websites where you essentially only serve HTML files with simple plugins such as Javascript, GCP recommends its cloud storage services to host the static files (Firebase or storage bucket).

For dynamic websites where a more complicated and functional websites are created, GCP provides various choices such  VM, Container Engines, or App Engines.

For a detailed comparision, visit [link](https://cloud.google.com/solutions/web-serving-overview)

#### Price
Hosting static website on Google Cloud Storage is essentially free.

You can sign up for its *[Free Tier Trial](https://cloud.google.com/free/)*, which includes a 12 months + $300 credit to use on any GCP products, and a non-expiring *Always Free* usage limit on some of its products. For cloud storage, you get free 5 GB storage and 1G egress in/to North America, which is more than enough for blogs.

Beyond the free limit, you are charged at a reasonable rate for the setup you choose. Google provides a very detailed price chart and a [price calculator](https://cloud.google.com/products/calculator/) for estimation. For example, a simple blog set on cloud storage bucket which on multi-regional access will roughly cost: 

{% asset_img estimate.bmp estimate  %}

<div align="center">
Now without future ado, let's build our static website on Google Cloud Storage.
</div>

&nbsp;

# Prerequisite
## Choose a static website generator
Previously I have introduced [Jekyll](https://jekyllrb.com/), which is the #1 used package based on serveral online surveys. However, this time we are going to use a different one, [Hexo](hexo.io), which is similar to Jekyll in many aspects, but beats Jekyll for faster generating speed with large volume of pages and a more well defined plugin environment. Personally, I switched to Hexo because of its absence of [kramdown](https://kramdown.gettalong.org/) as default markdown language. The simpler default package makes Hexo closer to universal standards and easier to transfer to other platforms. Of course, based on Javascript, Hexo is also obviously much more friendly to users on Windows.

Hexo installation is very simple. Follow this [guide](https://hexo.io/docs/) and finish within 5 minutes.

The website building process is the same as with any other generators. Initialize in a folder, install a theme and start writing. Follow this [page](https://hexo.io/docs/setup.html).

{% asset_img hexo-main.bmp hexo-main  %}

## Get a domain name
The next thing is to get a domain name. Unlike Github page, Google Cloud does not provide free sub-domains. So you will purchase your own. Many people would do it anyways. 

There are many services selling domains; I will recommend [NameCheap](https://www.namecheap.com/), which I use personally. NameCheap provides domains at reasonable price, free 1st-year privacy protection ($2.88/year afterwards), free DNS, and a user-friendly interface. Another service I came across is [NameSilo](https://www.namesilo.com/), from what I read, is also a good choice. 

Don't stress too much about domain name. They are cheap and easy to transfer.

### Verify domain
One thing you will have to do with Google Cloud is to verify that you are the owner of the domain with it. Google provides several ways to do it, I will just introduce the simplest one. For a complete discussion, visit [link](https://cloud.google.com/storage/docs/domain-name-verification).

1. Log into [Google Webmaster](https://www.google.com/webmasters) and click `search console`
2. Click `Add A Property` on the right corner and enter your domain name
3. Click next and choose `Alternative methods -> Domain name provider`. Add a `TXT record` under your domain provider's DNS management interface. Consult your domain provider for how-tos. Wait for a while.
4. Click `verify`. If the record is processed successfully, your verification concludes. 

### Add a CNAME alias
For your domain url to access files stored on Google Cloud, you will also need to add a `CNAME alias` to your domain's DNS management.
Create a `CNAME` alias pointing to `c.storage.googleapis.com`.
*A CNAME alias is a DNS record that lets you use a url from your own domain to access resourcs stored on Google Cloud.*
The record type should be `www`; the record value should be `c.storage.googleapis.com`. Consult your domain provider to verify that.

For **NameCheap**, the final DNS setting looks like this:

{% asset_img dns.bmp dns %}

More reference: [Google](https://cloud.google.com/storage/docs/hosting-static-website)

*Note: you should not have multiple DNS records with the same type.*


# Deploy your website online
Now you are ready to deploy your website onto GCP.
First, you need to create a **cloud bucket** to store your website's files.

## Create a cloud bucket
1. Log into your [Google Cloud Console](https://console.cloud.google.com) and then `storage->Browse`.
2. Click `Create a bucket`.
3. Enter your domain name as the bucket name. You will encounter problems if you haven't verify that.
4. Choose `Multi-Regional` as your data class.
5. Click `Create`

Then, to allow the public see your website, you need to serve your files publicly.

## Set bucket permission
1. Go to storage's `Browse` page
2. Click the setting icon at the right side of your bucket and `edit bucket permissions`.
3. You don't have to set the entire bucket public, in case you want to hide some of data or pages. So only set the permission for **object**.
4. For example, create a new permission rule that sets `Members: allUsers  Role: Object Viewer` to automatically set all objects uploaded as viewable to public. 

{% asset_img bucket-permission.bmp bucket %}

*Note: You can always come back to change permissions for each object.*

# Upload files
The last step is to upload your website's static files.
Hexo generates the website in `public/` folder.
Upload the content of `public/` folder into your configured bucket's root directory.
You can use GCP's web interface, or you can use google's `gsutil` tool for upload.

*In case you are curious about deploy to Github, you still upload only the content from `public/` folders to the root. There is a Hexo plugin allows you to do it with `hexo deploy` command.*

# BONUS: an upload script
In case you are a heavy terminal user and hates web interfaces, I provide a shell script help you deploy your website. You need to install Google's [`gsutil` tool](https://cloud.google.com/storage/docs/gsutil). 
```
hexo generate
gsutil -m rsync -d -r . gs://$websiteurl
```
