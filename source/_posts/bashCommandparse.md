---
title: "A Learning Note on Shell Programming: Commandline Argument Parser"
date: 2017-09-19 21:09:26
categories: ['programming']
tags:
  - bash
---

I have been working with shell script for some time, mostly for completing repeatable tasks can be described by few lines. In case where a file name or some arguments are needed, editing them directly in script would be preferred due to the script's limited length and simple structure. For example, a script I used to copy files in the current directory to upper level directory with certain filename would look like:

<!-- more -->

# Inspiration
I have been working with shell script for some time, mostly for completing repeatable tasks can be described by few lines. In case where a file name or some arguments are needed, editing them directly in script would be preferred due to the script's limited length and simple structure. For example, a script I used to copy files in the current directory to upper level directory with certain filename would look like:

``` bash
#!/bin/bash
newfolder="this is a folder"
for f in Note*.txt; do
    cp $f ../$newfolder/
done
```
Here one just need to change the variabel `newfolder` everytime they move this script to its working directory.

However, for more complicated tasks or pipelines, you will need to work with many more variables. And it is usually much more convenient to allow users to change these variables by entering them as *commandline arguments*.

Recently, I encountered one of these occasions, where I need to generate some text files and deploy them to several local folders, then online repositories hosting my static websites. To complete this task, I need to copy and paste several files from and to multiple folders, generate websites with static website generators locally in each folder, and then deploy the generated folders to several repositories. It is definitely very confusing and cumbersome to do all those steps every time (say, every two days) I upate my text files. Therefore I attempted to write a shell script with some other python codes to build a pipeline to do this.

All the copying/moving/generating are straight forward, but to implement command line arguments interface that takes in my options to allow flexible task call is way more complicated than I expected, partly due to my ignorance in bash programming, and partly due to the strict rules bash progrmaming is implementing.

In this article, I will write down my journey to search for a reasonable implementation of commandline argument parser for my *blog distribution pipeline*. including the mistakes that I made and suggested readings from helpful *Stackoverflow* folks. I do not guarantee the effectiveness or beauty of my code, so take it just as a learning note and a suggested solution to related questions.

Thank you for being patient and there we go.

# Problem Statement
I need to update two posts for my static website, which is generated locally with 2 different generators (Jekyll and Hexo), then deployed onto 3 different onine repositories (2 Githubs and 1 Google Cloud). The generators will have slightly different markdown syntax; the repositories require separte deployment setting. I have set up working python codes to generate posts and different configuration files regarding different repository, now I need a bash script that pipeline all the generating-deploying taks in a single run. The script can take options so that I can perform generating, localy deployment (copying markdown files to website folders) and server deployment independently. A complete work-flow would look like this:

1. Use the python script to generate markdown posts files (/workdir/generation/file1-hexo.md file1-jekyll.md file2-hexo.md, file2-jekyll.md)
2. Deploy markdown files to local website folders (/workdir/hexo-sites/hexo-site1-on-github/google /workdir/jekyll-site-on-github)
3. Deploy updated local website folders to servers (hexo-site1 to github, hexo-site1 to google, jekyll-site to github)

Commandline objectivs
```
-f/--f: optional argument, if present, operand/operands are required. If not present, default file selection will be used
-l/--local: optional argument, if present, selected files will be copied to local website folders
-s/--server: optional argument, with optional operands. If presented, selected files will be first deloyed locally, then the updated folders will be deployed to selected servers. Default server selection will be used if option is not present.
-h/--help: present usage information and quit.
-d/--dryrun: generating markdown files only.

default behavior: dryrun 
default file selection: file1 file2 (all)
default server selection: github1 github2 google (all)
```

# First Attempt: using getop
The first attempt is to use bash's installed function `getopt`
`getopt` allows users to read command line arguments with `-/--` options and operands following them; the options can also be put together such as `-avh` if no operands required. Using `getopt` long options starting with `--` are also allowed.

The implementation with `getopt` is usually done as the [following](http://www.bahmanm.com/blogs/command-line-options-how-to-parse-in-bash-using-getopt) example, where the arguments are parsed into a string/array with `getopt` first, and then passed into a `while; case;` loop for processing. 

```bash
# set an initial value for the flag
ARG_B=0

# read the options
TEMP=`getopt -o a::bc: --long arga::,argb,argc: -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -a|--arga)
            case "$2" in
                "") ARG_A='some default value' ; shift 2 ;;
                *) ARG_A=$2 ; shift 2 ;;
            esac ;;
        -b|--argb) ARG_B=1 ; shift ;;
        -c|--argc)
            case "$2" in
                "") shift 2 ;;
                *) ARG_C=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done
```
The problem I am having with this implementation is that some of my options are skipped and some are reported as bug. While I searched through online resources the most definite answer I get is: **dont't use getopt unless you need to have options combined together; it's bash version is buggy**. Well, so much with a bash built-in parser. I guess I will have to hard-code my own parser then.

It turns out that many people actually prefer to write their own parser anyways, due to the variety of different inputs people face. And writing a parser is not difficult, you only don't get the `getopt` to translate the input arguments into a nice string or array for you. You will have to write your `while;case` to assign actions to input options in either case.

# Revision

And here comes the revision. In short, I loop through all arguments input by shifting the positional argument `$1`. I parse `$1` using a `case;esac` selector to determine if `$1` is an option or an operand, if the option is valid (following `$2` is not an option and `$1` value is defined), if the operand allowed. Then I assign child functions to valid options.

It is noted that in order to have multiple options existing together and to NOT require users follow any input order, I create global variables to store the state of valid options. The child functions are called after the `while` loop and processing input argument, based on the stored option states. 

The result is a script that looks like the following:


```bash
#!/bin/bash 
set -e

HEXOLOCATION="/home/Github/hexo/hexo-gcs"
HEXOWORKLOCATION="/home/Github/hexo/hexo-git"
BACKUPDIR="/home/Github/user/user.github.io"
CURRENTLOCATION=$PWD

ALLOWEDFILES=("file1" "file2") 
ALLOWEDSERVERS=("hexo-gcp" "hexo-git" "google")

main(){	
		# flags, 1 is false, 0 is true. it's the damn bash
		LOCAL_DEPLOY=1
		SERVER_DEPLOY=1
		DRY_RUN=0

    FILES=("${ALLOWEDFILES[@]}"); 
    DEPLOYTARGET=("${ALLOWEDSERVERS[@]}"); 

    if [[ $# -eq 0 ]]
    then
        printf -- "Missing optins, perform DRY RUN\nFor help, run with -h/--help\n"
        for target in "${FILES[@]}"; do generate "$target"; done
        echo "....dry run: markdown files generated in rendered/"
        exit 0
    fi	

		# while-loop only store command line arguments into GLOBAL variables
    while true ; do
        case "$1" in 
            -f |--file) # required operands
                case "$2" in
                    "") die $1 ;;
                    *) 
                        FILES=($2)
                        for i in "${FILES[@]}"; do
                            if  is_option $i; then die $1; fi # check for option 
														if ! check_allowed $i ${ALLOWEDFILES[@]}; then exit 1; fi
                        done; 
                        shift 2;; # input FILES are good
                esac ;;
            -l|--local) # no operands expected
                DRY_RUN=1 # turn off dryrun
                LOCAL_DEPLOY=0 # turn on local deploy
                shift ;;
            -s|--server) # optional operands
                case "$2" in
                    "") shift ;; 
                    *) 
                        DEPLOYTARGET=($2)  # use input
                        for i in "${DEPLOYTARGET[@]}"; do
                            if  is_option $i; then die $1; fi # check for option 
														if ! check_allowed $i ${ALLOWEDSERVERS[@]}; then exit 1; fi
                        done ; shift 2;; # use input value
                esac
                DRY_RUN=1
                SERVER_DEPLOY=0
                ;;
            -n|--dryrun) # dry-run:generate markdown files only
                DRY_RUN=0
                shift ;;
            -h|--help) # docs
                print_help
                exit 0
                ;;
            --) shift; break ;;
            -?*)
                printf 'ERROR: Unkown option: %s\nExisting\n\n' "$1" >&2
                print_help
                exit 1
                shift
                ;; 
            *) 
                break ;; 
        esac 
    done

    echo  "choose files: ${FILES[@]}"
    echo ""

		# operations are run after all arguments being processed, so operations can be done in other order

    # dry-run
    if [[ $DRY_RUN == 0 ]]; then
        echo "..perform dry run.."
        for target in "${FILES[@]}"; do generate "$target"; done
        echo "....dry run: markdown files generated in rendered/"
        exit 0
    fi

    # local-deploy
    if [[ $LOCAL_DEPLOY == 0 ]] && [[ $SERVER_DEPLOY != 0 ]]; then
        echo "..deploy locally"
        for target in "${FILES[@]}"; do 
            generate "$target" > /dev/null
            deploylocal "$target"
        done; 

    fi

    # server-deploy
    if [[ $SERVER_DEPLOY == 0 ]]; then
        echo "..deploy on servers: ${DEPLOYTARGET[@]}"
        echo ""

        for target in "${FILES[@]}"; do # deploy locally 
            generate "$target" > /dev/null
            deploylocal "$target"
        done 

        # deploy to selected server: git or gcp
        for dt in "${DEPLOYTARGET[@]}"; do 
            deployserver $dt 
        done
    fi
}

main "$@"
```
# Pitfalls
There are several programming pitfalls that have been pointed out by others. Most likely my code might be broken if some special character or pattern expansion occured. And if my file name starts with `-/--`. I guess I will have to ask my users to NOT use such filenames and to use double-quotes if they have multiple inputs for one option. 

These pitfalls are solvable if you read through at least the following articles. I will follow up on them if I get the chance.

[bash: using glob](http://mywiki.wooledge.org/glob)
glob: pattern matching, pattern expansion, filename expansion, wildcard
[bash: pitfalls](http://mywiki.wooledge.org/BashPitfalls)

# Conclusion
So I hope you have tolerated my somewhat blurring words and amatuer coding skills. And this piece of note could help you understand a little more on processing commandline input with bash. Please leave any feedbacks you have.
