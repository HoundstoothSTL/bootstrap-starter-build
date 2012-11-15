#!/bin/bash

# Build version 1.2.0

DIR="$( cd "$( dirname "$0" )" && pwd )"
CYAN="\033[1;36m"
LIGHTRED="\033[1;31m"
LIGHTGRAY="\033[1;30m"
LIGHTCYAN="\033[1;36m"
WHITE="\033[1;37m"
LIGHTGREEN="\033[1;32m"

TITLE=$LIGHTCYAN
Q=$LIGHTGRAY
M=$CYAN
A=$LIGHTRED
YN=$WHITE
QMARK=$LIGHTGREEN

echo -e $TITLE'
   ___       _ __   __                 
  / _ )__ __(_/ ___/ /                 
 / _  / // / / / _  /                  
/____/\_,_/_/_/\_,_/                   
   ___          __     __              
  / _ )___ ___ / /____/ /________ ____ 
 / _  / _ / _ / __(_-/ __/ __/ _ `/ _ \
/____/\___\___\__/___\__/_/  \_,_/ .__/
                                /_/    
'   


projectPath= 
while [ -z $projectPath ]
do 
	echo -e -n $QMARK'[?] '$Q'What is the base path for your projects (absolute path, no trailing slashes please)? ' $WHITE
	read projectPath
done

projectName=
while [ -z $projectName ]
do 
	echo -e -n $QMARK'[?] '$Q'What is our new Bootstrap project name? ' $WHITE
	read projectName
done

lessCSS=
while [ -z $lessCSS ]
do 
	echo -e -n $QMARK'[?] '$Q'Are we using the Bootstrap LESS files?' $YN'(y/n) '
	read lessCSS
done

bootstrapJS=
while [ -z $bootstrapJS ]
do 
	echo -e -n $QMARK'[?] '$Q'Are we using the Bootstrap JavaScript files?' $YN'(y/n) '
	read bootstrapJS
done

cd $projectPath && mkdir $projectName

cd $projectPath/$projectName && bower install bootstrap && bower install modernizr

cd $projectPath/$projectName && mkdir app

cd $projectPath/$projectName/app && mkdir styles scripts images ico && cd scripts && mkdir vendor

cp $projectPath/$projectName/components/jquery/jquery.min.js $projectPath/$projectName/app/scripts/vendor/jquery.min.js

cd $projectPath/$projectName/components/modernizr && grunt

cp $projectPath/$projectName/components/modernizr/modernizr.min.js $projectPath/$projectName/app/scripts/vendor/modernizr.min.js

if [[ "$lessCSS" =~ ^[Yy]$ ]]
then
	mkdir $projectPath/$projectName/app/styles/less
	mkdir $projectPath/$projectName/app/styles/less/bootstrap && mkdir $projectPath/$projectName/app/styles/less/project
    cp -r $projectPath/$projectName/components/bootstrap/less/*.less $projectPath/$projectName/app/styles/less/bootstrap/
    cp -r $projectPath/$projectName/components/bootstrap/img/* $projectPath/$projectName/app/images/
    cp $projectPath/$projectName/app/styles/less/bootstrap/variables.less $projectPath/$projectName/app/styles/less/project/variables.less
    cd $projectPath/$projectName/app/styles/less/project && touch theme.less responsive.less variables.less    
else 
	mkdir $projectPath/$projectName/components/bootstrap-css && cd $projectPath/$projectName/components/bootstrap-css
	curl -O http://twitter.github.com/bootstrap/assets/bootstrap.zip && unzip bootstrap.zip
	rm bootstrap.zip && mv bootstrap/* . && mv css/*.css . && rm -rf bootstrap css js 
	cp -r *.css $projectPath/$projectName/app/styles/
	cp -r img/* $projectPath/$projectName/app/images/ && rm -rf img
	mkdir $projectPath/$projectName/app/styles/less && cd $projectPath/$projectName/app/styles/less && mkdir project
	cd $projectPath/$projectName/app/styles/less/project && touch theme.less responsive.less variables.less 
fi

if [[ "$bootstrapJS" =~ ^[Yy]$ ]]
then
	mkdir $projectPath/$projectName/app/scripts/vendor/bootstrap
	cp -r $projectPath/$projectName/components/bootstrap/js/*.js $projectPath/$projectName/app/scripts/vendor/bootstrap/
	cd $projectPath/$projectName/app/scripts/vendor/bootstrap/
	cat *.js | grep -Ev "#include" > $projectPath/$projectName/app/scripts/vendor/bootstrap.js
fi

cd $projectPath/$projectName/app/scripts && touch app.js
cp $DIR/_templates/index.html $projectPath/$projectName/app/index.html

echo -e $WHITE"\n==============================================================================\n"
echo -e $M"Ok, we scaffolded $projectName and added Bootstrap, jQuery and Modernizr..Rock Out!!"
echo -e $WHITE"\n==============================================================================\n"

cd $projectPath/$projectName/