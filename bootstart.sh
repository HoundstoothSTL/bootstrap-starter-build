#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

dependencies=
while [ -z $dependencies ]
do 
	echo -n 'Do you have Node, Grunt, wget and Git installed? (y/n) '
	read dependencies
done

if [[ "$dependencies" =~ ^[Yy]$ ]]
then
	echo "Sweet, let's keep it moving..."
else
	echo "Sorry, gotta have these guys installed first.  Check the Readme"
	exit
fi

projectPath= 
while [ -z $projectPath ]
do 
	echo -n 'What is the base path for your projects (absolute path, no trailing slashes please)? '
	read projectPath
done

projectName=
while [ -z $projectName ]
do 
	echo -n 'What is our new Bootstrap project name? '
	read projectName
done

lessCSS=
while [ -z $lessCSS ]
do 
	echo -n 'Are we using the Bootstrap LESS files? (y/n) '
	read lessCSS
done

bootstrapJS=
while [ -z $bootstrapJS ]
do 
	echo -n 'Are we using the Bootstrap JavaScript files? (y/n) '
	read bootstrapJS
done

packagesYN=
while [ -z $packagesYN ]
do 
	echo -n 'Do you have a packages directory already for bootstrap, jQuery and Modernizr? (y/n) '
	read packagesYN
done

if [[ "$packagesYN" =~ ^[Yy]$ ]]
then
	packageFolder=
	while [ -z $packageFolder ]
	do 
		echo -n 'Where do you keep your packages (absolute path, no trailing slashes)? '
		read packageFolder
	done
else
	packageFolder=
	while [ -z $packageFolder ]
	do
		echo -n 'Where do you want your package folder to be located? (absolute path, no trailing slashes) '
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

cd $projectPath/$projectName

echo "Ok, we scaffolded $projectName and added Bootstrap, jQuery and Modernizr..Rock Out!!"