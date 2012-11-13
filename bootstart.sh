#!/bin/bash

# Version 1.1.0

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
    __  ___            __                                                
   /  |/  /____ _ ____/ /___                                             
  / /|_/ // __ `// __  // _ \                                            
 / /  / // /_/ // /_/ //  __/                                            
/_/  /_/ \__,_/ \__,_/ \___/                                             
    __                                                                   
   / /_   __  __                                                         
  / __ \ / / / /                                                         
 / /_/ // /_/ /                                                          
/_.___/ \__, /                                                           
       /____/                                                            
    __  __                          __       __                 __   __  
   / / / /____   __  __ ____   ____/ /_____ / /_ ____   ____   / /_ / /_ 
  / /_/ // __ \ / / / // __ \ / __  // ___// __// __ \ / __ \ / __// __ \
 / __  // /_/ // /_/ // / / // /_/ /(__  )/ /_ / /_/ // /_/ // /_ / / / /
/_/ /_/ \____/ \__,_//_/ /_/ \__,_//____/ \__/ \____/ \____/ \__//_/ /_/ 
                                                                         
'

dependencies=
while [ -z $dependencies ]
do 
	echo -e -n $QMARK'[?] '$Q'Do you have Xcode, Node, Grunt, wget and Git installed?' $YN'(y/n) '
	read dependencies
done

if [[ "$dependencies" =~ ^[Yy]$ ]]
then
	echo -e $M"Sweet, let's keep it moving..."
else
	xcodeYN=
	while [ -z $xcodeYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you have Xcode installed?' $YN'(y/n) '
		read xcodeYN
		
		if [[ "$xcodeYN" =~ ^[Yy]$ ]]
		then
			echo -e $M"Ok cool..."
		else
			echo -e $A"\n================================================\n"
			echo -e $A"You must have XCode installed then come on back... "
			echo -e $A"\n================================================\n"
			open https://itunes.apple.com/us/app/xcode/id497799835?ls=1
			exit
		fi
	done

	buildYN=
	while [ -z $buildYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you want me to build the package dependencies out for you?' $YN'(y/n) '
		read buildYN
		
		if [[ "$buildYN" =~ ^[Yy]$ ]]
		then
			echo -e $M"Ok cool, let's get started..."
		else
			echo -e $M"Cool, you can do it youself using these links:"
			echo "Homebrew - http://mxcl.github.com/homebrew"
			echo "Git - http://git-scm.com/downloads"
			echo "Node - http://nodejs.org"
			echo "NPM - https://npmjs.org/doc/install.html"
			echo "Grunt - http://gruntjs.com/"
			echo "Wget - http://mxcl.github.com/homebrew"
			exit
		fi
	done

	homebrewYN=
	while [ -z $homebrewYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you have homebrew installed?' $YN'(y/n) '
		read homebrewYN
		
		if [[ "$homebrewYN" =~ ^[Yy]$ ]]
		then
			echo -e $M"Ok cool, let's update homebrew and install some hipster packages..."
			brew update
		else
			ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
		fi

	done

	gitYN=
	while [ -z $gitYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you have Git installed?' $YN'(y/n) '
		read gitYN
			if [[ "$gitYN" =~ ^[Yy]$ ]]
			then
				echo -e $M"Killer"
			else
				brew install git
			fi	
	done

	nodeYN=
	while [ -z $nodeYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you have Node installed?' $YN'(y/n) '
		read nodeYN
			if [[ "$nodeYN" =~ ^[Yy]$ ]]
			then
				echo -e $M"Killer"
			else
				brew install node
				sudo curl http://npmjs.org/install.sh | sh
				echo -e $M"Installing Node Package Manager"
			fi	
	done

	gruntYN=
	while [ -z $gruntYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you have Grunt installed?' $YN'(y/n) '
		read gruntYN
			if [[ "$gruntYN" =~ ^[Yy]$ ]]
			then
				echo -e $M"Killer"
			else
				sudo npm install grunt -g
			fi	
	done

	wgetYN=
	while [ -z $wgetYN ]
	do
		echo -e -n $QMARK'[?] '$Q'Do you have Wget installed?' $YN'(y/n) '
		read wgetYN
			if [[ "$wgetYN" =~ ^[Yy]$ ]]
			then
				echo -e $M"Killer"
			else
				brew install wget
			fi	
	done

	echo -e $M"Ok, we're all setup to use the Bootstrap Build Script"
fi

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

packagesYN=
while [ -z $packagesYN ]
do 
	echo -e -n $QMARK'[?] '$Q'Do you have a packages directory already for bootstrap, jQuery and Modernizr?' $YN'(y/n) '
	read packagesYN
done

if [[ "$packagesYN" =~ ^[Yy]$ ]]
then
	packageFolder=
	while [ -z $packageFolder ]
	do 
		echo -e -n $QMARK'[?] '$Q'Where do you keep your packages (absolute path, no trailing slashes)? ' $WHITE
		read packageFolder
	done
else
	packageFolder=
	while [ -z $packageFolder ]
	do
		echo -e -n $QMARK'[?] '$Q'Where do you want your package folder to be located? (absolute path, no trailing slashes) ' $WHITE
		read packageFolder
		mkdir $packageFolder && cd $packageFolder
		git clone https://github.com/twitter/bootstrap.git
		git clone https://github.com/Modernizr/Modernizr.git
		git clone https://github.com/jquery/jquery.git && cd jquery && npm install
	done
fi
cd $projectPath && mkdir $projectName && cd $projectName

mkdir styles scripts images ico && cd scripts && mkdir vendor

cd $packageFolder/bootstrap && git pull origin master

cd $packageFolder/jquery && git pull origin master
grunt
cp dist/jquery.min.js $projectPath/$projectName/scripts/vendor/jquery.min.js

cd $packageFolder/Modernizr && git pull origin master
grunt
cp modernizr.min.js $projectPath/$projectName/scripts/vendor/modernizr.min.js

if [[ "$lessCSS" =~ ^[Yy]$ ]]
then
	mkdir $projectPath/$projectName/styles/less
	mkdir $projectPath/$projectName/styles/less/bootstrap && mkdir $projectPath/$projectName/styles/less/project
    cd $packageFolder/bootstrap
    cp -r less/*.less $projectPath/$projectName/styles/less/bootstrap/
    cp -r img/* $projectPath/$projectName/images/
    cp $projectPath/$projectName/styles/less/bootstrap/variables.less $projectPath/$projectName/styles/less/project/variables.less
    cd $projectPath/$projectName/styles/less/project && touch theme.less responsive.less variables.less    
else 
	cd $packageFolder/bootstrap-stripped && wget http://twitter.github.com/bootstrap/assets/bootstrap.zip && unzip bootstrap.zip
	cp -r bootstrap/css/*.css $projectPath/$projectName/styles/
	cp -r bootstrap/img/* $projectPath/$projectName/images/
	mkdir $projectPath/$projectName/styles/less && cd $projectPath/$projectName/styles/less && mkdir project
	cd $projectPath/$projectName/styles/less/project && touch theme.less responsive.less variables.less 
fi

if [[ "$bootstrapJS" =~ ^[Yy]$ ]]
then
	mkdir $projectPath/$projectName/scripts/vendor/bootstrap
	cd $packageFolder/bootstrap
	cp -r js/*.js $projectPath/$projectName/scripts/vendor/bootstrap/
	cd $projectPath/$projectName/scripts/vendor/bootstrap/
	cat *.js | grep -Ev "#include" > ../bootstrap.js
fi

cd $projectPath/$projectName/scripts && touch app.js
cp $DIR/index.html $projectPath/$projectName/index.html

echo -e $WHITE"\n==============================================================================\n"
echo -e $M"Ok, we scaffolded $projectName and added Bootstrap, jQuery and Modernizr..Rock Out!!"
echo -e $WHITE"\n==============================================================================\n"

cd $projectPath/$projectName