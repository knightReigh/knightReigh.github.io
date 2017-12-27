---
title: 初尝B站爬虫：总结和感悟
date: 2017-12-23
categories: ['data']
tags:
    - web-crawl
    - data
    - python
    - BeautifulSoup
    - bilibili
    - lxml
---

{% asset_img head.jpg %}

<!-- more -->
# 前言
+ 提取单个视频信息(GetList)
+ 提取搜索遍历(GetCover)
+ 首页图片存储(GetCover)
+ csv列表、markdown表格导出(GetList)
+ 参考1：airingursb/bilibili-video
+ 参考2：http://www.cnblogs.com/liuliliuli2017/p/6746433.html
+ 参考3：airingursb/bilibili-danmu
+ 参考4：airingursb/bilibili-user
+ 持续整理中...

# 开发平台
Linux

# 软件要求
+ Python version: 3.6.3

```python 
    import requests
    import os,sys,re
    import json
    from bs4 import BeautifulSoup
    import csv
```
# 完整代码
[fredhdx/CrawlBilyInfo](https://github.com/fredhdx/CrawlBilyInfo)

# 中心代码

## requests, BeautifulSoup命令
```
# 解析网页
r = requests.get(url, headers=header, <options>)
# 翻译requests object
soup = BeautifulSoup(r, 'html5lib')
# 搜索数据
object = soup.find(element_keyword, {attribute:keyword})
    # element_keyword = ['div','body','head','script', etc]
    # attribute_keyword = ['class:classname','type:text/javascript','custom:custom-key']
    # example: soud.find('div',{'class':'gallery'})
# 提取数据信息
text = object.text # or object.string or object.content
attribute_value = object['attribute'] # object['class'] -> 'div'
# 得到多个搜索结果
object_list = soup.findAll(element_keyword,{attribute:keyword})
for object in object_list: do something

```

## 1. 关键字搜索
```python

# 搜索API 
page = "https://search.bilibili.com/all?keyword=" + keyword + "&page="

# 搜索模式
#  order = ("1: 综合排序 2:最多点击 3:最新发布 4:最多弹幕 5:最多收藏")
#  order = ('&order=totalrank', '&order=click', '&order=pubdate', '&order=dm', '&order=stow')

# 抓取搜索页
q = requests.get(page + str(1) + order, headers = UA)
Soup_q = BeautifulSoup(q.text, 'html5lib')

page_upper = Soup_q.find('body', class_="report-wrap-module old-ver")
page_upper_int = int(page_upper['data-num_pages']) + 1

for i in range(1, page_upper_int):
    # 抓取单个页面
    r = requests.get(page + str(i) + order,headers = UA)
    Soup = BeautifulSoup(r.text,'html5lib')

    # 得到视频列表
    all_li = Soup.find_all('li', class_ = "video matrix " )
    for li in all_li:

        # 抓取单个视频
        print(li.a['title'])
        video_html = requests.get("https:" + li.a['href'], headers = UA)
        video_soup = BeautifulSoup(video_html.text,'html5lib')

        # do something

        # input("任意键继续下一项...")
    print("第" + str(i) + "页爬取完毕")
```

## 2. 提取封面图片
```Python

# PATH = 目标文件夹
# URL = 目标视频链接

# 检查文件夹
if not os.path.exists(path + "/" + order):
    os.makedirs(path + "/" + order)
try:
    video_html = requests.get(url, headers = UA)
    video_soup = BeautifulSoup(video_html.text,'html5lib')

    # 生成图片绝对地址 path-to-image/imagename.extension
    img_src = video_soup.find('img')
    r = requests.get("http:" + img_src, headers = UA)
    path = path + "/" + order +"/" + str(page_num) + "/"+ title + "." +page_url.split('.')[-1]

    if not os.path.exists(path):
        # 储存图片
        f = open(path, "wb")
        f.write(r.content)
        f.close()
```

## 3. 信息爬虫

```python
# 自定义储存类型
class bilibili_video:

    def __init__(self, args={}):
        self.meta = {'url':'','title':'','aid':-1,'cid':-1,'uploadtime':'','duration':'','category':''}
        self.play = {'view':0,'click':0,'favorite':0,'coin':0,'danmaku':0,'reply':0,'share':0}
        self.up = {'up':'','mid':-1, 'upspace':''}
        self.text = {'intro':''}

        if bool(args):
            self.update(args)

    # 写入信息
    def update(self, args):

    # 打印信息
    def write(self,kargs=[]):
    def writevalue(self):
    def writekey(self):

# 爬虫代码
def spider(url):

    # 翻译网页
    try:
        html = requests.get(url, headers=UA)
        soup = BeautifulSoup(html.text,'html5lib')
    except requests.exceptions.RequestException as e:
        print(e)
        sys.exit(1)

    # 标题
    title = soup.find('div', class_="v-title").h1['title'] # 标题

    # 视频aid
    aidlocator = soup.findAll('script', {'language':"javascript"})[-1]
    aid = re.search(r'aid=\'(.*)\', typeid', aidlocator.text).group(1)

    # 上传时间
    uploadtime = soup.find('meta',attrs={'itemprop':"uploadDate"})['content']

    # 分类信息
    timeinfo = soup.find('div', class_="tminfo")
    time_log = []
    for logx in timeinfo.find_all('span'):
        time_log.append(logx.a.text)

    # UP主信息
    up = soup.find('div', class_="usname").a.text
    mid = soup.find('div', class_="usname").a['mid']
    upspace = "https:" + soup.find('div', class_="usname").a['href']

    # 标签: b站更新后暂时没找到相关api

    # 视频简介
    intro_text = soup.find('div', class_="v_desc report-scroll-module report-wrap-module").text

    # 视频cids &分P
    cids = []
    cid_urls = []
    videos = soup.find_all('option')

    if videos:
        for video in videos:
            cids.append(video['cid'])
            cid_urls.append( PROTOCAL + Bilibili + video['value'])
    else:
        cidlocator = soup.find('script',{"type":"text/javascript"},text=re.compile('EmbedPlayer')).text
        cids.append(re.search('cid=(.*)&aid',cidlocator).group(1))
        cid_urls.append(PROTOCAL + Bilibili + '/video/' + str(aid))

    # 视频播放数据：已被移植json
    # 播放数据API1
    info_url = PROTOCAL + "interface.bilibili.com/player?id=cid:" + str(cids[0]) + "&aid=" + aid
    try:
        video_info = requests.get(info_url)
    except requests.exceptions.RequestException as e:
        print(e)
        sys.exit(1)

    # 播放数据API2
    try:
        json_url = PROTOCAL + "api.bilibili.com/archive_stat/stat?aid=" + aid
        json = requests.get(json_url, headers=UA).json()['data']
    except requests.exceptions.RequestException as e:
        print(e)
        sys.exit(1)
    
    # 收藏、弹幕、硬币、分析、回复、点击、时长
    favorite = json['favorite']
    danmaku = json['danmaku']
    coin = json['coin']
    view = json['view']
    share = json['share']
    reply = json['reply']
    click = re.search('<click>(.*)</click>',video_info.text).group(1)
    duration = re.search('<duration>(.*)</duration>',video_info.text).group(1)

    # 另外一个API暂时没什么用
    json_url2 = PROTOCAL + "api.bilibili.com/x/reply?jsonp=jsonp&type=1&sort=0&pn=1&nohot=1&oid=" + aid

    # 储存结果
    meta_info = {'url':url,'title':title,'aid':int(aid),'cid':int(cids[0]),'uploadtime':uploadtime,'duration':duration, 'category':time_log}
    play_info ={'view':view,'click':click,'favorite':favorite,'coin':coin,'danmaku':danmaku,'reply':reply,'share':share}
    up_info = {'up':up,'mid':mid, 'upspace':upspace}
    text_info = {'intro':intro_text}

    # 注意:语法要求python3.5以上 
    result = bilibili_video({**meta_info, **play_info, **up_info, **text_info})

    return result
```
结果展示
{% asset_img crawl_info.jpg %}

## 分析多P视频
```python

try:
    page = requests.get(url)
    soup = BeautifulSoup(page.text, 'html.parser')
except:
    print('pyton.requests: %s cannot be opened' % url)
    sys.exit(1)

# 获取多P视频列表:关键字:option
videos = soup.find_all('option')

if videos: # 多P视频
    for video in videos:
        
        # 抓取每P信息
        video_title = video.contents[0][2:]
        
        # API: video_url = url + '/index_' + str(page) + '.html'
        video_url = 'https://www.bilibili.com' + video.get('value')

        # do something

else:# 单P视频
    # do something else
```

## 写入CSV
```python
import csv

# 打开csv文件
f = open(filename,'w')
csv_port = csv.writer(f)

# 按行写入: 输入为list
csv_port.writerow(['item1','item2','item3','etc'])

f.close()

# 读取csv

with open(inputfile,newline='') as csvfile:
    out = open('output.txt','w')

    # 打开csv reader
    videoreader = csv.reader(csvfile,delimiter=',')
    # 跳过表头
    next(videoreader, None)

    # 按行读取
    for row in videoreader:
        out.write(row[0] + row[1] + row[3] + 'etc')

```

## 文件夹操作
```python
import os

# 当前工作目录
DIRECTORY = os.getcwd()

# 代码运行目录
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

# 创立文件夹
os.makedirs(path)
```

## regex搜索
```python
import re

# 搜索text1和text2之间的段落
re.search(r'text1(.*)?text2',string).group(1)

```
# 创作一个好看的表格

网上有很多模板。把csv结果按行写成HTML表格,加上css就好了。

[样品](https://cutelittleturtle.github.io/example-mc/)
{% asset_img table.jpg %}

[更多模板](http://freefrontend.com/css-tables/)

# 鸣谢

这篇文章采用了很多牛人的爬虫代码,特此感谢:

+ airingursb/bilibili-video
+ http://www.cnblogs.com/liuliliuli2017/p/6746433.html
+ airingursb/bilibili-danmu
+ airingursb/bilibili-user

其中[airingursb/bilibili-video](https://github.com/airingursb/bilibili-video/)采用了`lxml etree`分析网页,是一个很好的代替思路.我没有采用'lxml'的主要原因是`lxml`的分析结果都以`list`方式输出,提取代码每一行都会多一个`[0]`的后缀,看着很烦2333. 其次就是`BeautifulSoup`的结构遍历方式比较直观,采用`object.element_type['attribute'].another_find.another_find`的语法,对于我这种新手来说容易理解和查错.相反,`lxml`的结构遍历采取路径式:`etree.xpath(object/div[@attribute]/another_div/@another_attr)`. 个人感觉更容易出错.不过`lxml`的结构树非常的清晰,用路径式搜索也很直观,而且代码来说比较简洁,各有优劣吧.

这篇代码[airingursb/bilibili-video](https://github.com/airingursb/bilibili-video/)还采用了MySQLdb数据库来整理信息.我因为,懒,所以就没去弄,毕竟我现在需要的数据量很小,网也不快2333.但做大量数据分析还是用数据库更加稳定和高效.我会补上这一部分.

从这两天分析b站网页得出,爬虫最关键的还是找到合适的API.短短几年,b站的代码格式和数据结构已经变了很多,参考代码我也不得不大幅度改动.所以爬虫没有一劳永逸这回事.

不过另一方面来讲,规范化的API和网页结构,和开发成熟的工具,类似`BeautifulSoup`和`lxml`,使得爬虫的门槛变得很低.以后真正的竞争是获得数据和大数据的梳理建模.如何快速准确的获得数据和如何生动形象的呈现数据,才是数据工作者真正的价值所在.

路还有很长.
