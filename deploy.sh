#!/bin/bash

gcp_url="www.mumu.coffee"
resource_dir="/home/dongxu/Github/hexo/resources"

opt=$1

if [ "$opt" == "git" ]; then # fredhdx.github.io deploy-as-is
    if [[ "$PWD" != *"fredhdx-github-dev"* ]]; then
        echo "current directory $PWD does not support deploy on git"
        exit 1
    fi
    cat _config.yml ../resources/metas/meta-git.txt > source/_data/next.yml
    hexo clean
    hexo g --config source/_data/next.yml
    hexo deploy --config source/_data/next.yml
elif [ "$opt" == "gcp" ]; then # deploy to gcp
    if [[ "$PWD" != *"fredhdx-github-dev"* ]]; then
        echo "current directory $PWD does not support deploy on gcp"
        exit 1
    fi
    cp source/_data/next.yml next.bak 
    cat _config.yml ../resources/metas/meta-gcp.txt > source/_data/next.yml

    hexo clean
    hexo g --config source/_data/next.yml
    cd public/
    gsutil -m rsync -d -r . gs://$gcp_url
    cd ..

    mv next.bak source/_data/next.yml
elif [ "$opt" == "yby" ]; then
    if [[ "$PWD" == *"hexo-dev"* ]]; then
        rsync -ah ../hexo-yby/source/_posts/ $resource_dir/posts/yby_posts/ --delete # save yby_posts folder 

        cd ..
        rsync -ah hexo-dev/ hexo-yby/ --delete
        cd hexo-yby

        rm -rf source/_posts/
        cp -r $resource_dir/posts/yby_posts/ source/_posts/ # restore _posts folder
        cat _config.yml ../meta-yby.txt > source/_data/next.yml

        hexo clean
        hexo g --config source/_data/next.yml
        hexo deploy --config source/_data/next.yml

        cd ../hexo-dev
    elif [[ "$PWD" == *"hexo-yby"* ]]; then
        cat _config.yml ../meta-yby.txt > source/_data/next.yml

        hexo clean
        hexo g --config source/_data/next.yml
        hexo deploy --config source/_data/next.yml
    fi
else
    echo "invalid argument. specify: git, gcp, yby"
    exit 1
fi

echo "site information is contained in meta.txt"

