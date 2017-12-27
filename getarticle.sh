#!/bin/bash

DIR="/home/dongxu/Github/repo/cutelittleturtle/cutelittleturtle.github.io"
cp -r $DIR/source/_posts/* source/_posts/

# exclude
rm source/_posts/example-mc.html
