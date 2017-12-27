#!/bin/bash

resource_dir="/home/dongxu/Github/hexo/resources"

# separate config file into _config.yml and meta.txt
if [ -e _config.yml ]; then cp _config.yml _config.bak.clean; fi
sed '/user-site-configurations/q' source/_data/next.yml > _config.yml
sed '1,/user-site-configurations/d' source/_data/next.yml > meta.txt

echo "separating next.yml into _config.yml and meta.txt"
