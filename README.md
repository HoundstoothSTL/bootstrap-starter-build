Bootstrap Project Build Script
=======================

### Build out a new Bootstrap Scaffold using a simple shell script.

The script will ask a few questions and then build out a LESS or non-LESS Bootstrap scaffold based on your answers.  This is a complete rewrite from version 1.0.  Version 2.0 utilizes a system audit to check your setup for neccessary packages like Node and Grunt as well as an installer for missing packages.  Some may notice that the audit is similar to the Yeoman audit and that is because it is similar, thanks to Yeoman for the idea for the check script.

Version 2.0 utilizes the Twitter Bower package registry to load javascript packages like jQuery and Modernizr.

**Build Questions**:

*    What is the base path for your projects (absolute path, no trailing slashes please)? - You'd answer `/Users/USERNAME/Sites` or what have you
*    What is our new Bootstrap project name? - You'd answer, whatever you want it to be called, no spaces
*    Are we using the Bootstrap LESS files? (y/n)
*    Are we using the Bootstrap JavaScript files? (y/n)

**Requirements**:

*    This version runs on OSX only
*    XCode - Xcode must be pre-installed to use the build script
*	 Homebrew - built using Ruby -> `ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"`
*    Node - built using Homebrew -> `brew install node`
*    Git - built using homebrew -> `brew install git`
*    Grunt - built using NPM -> `npm install grunt -g`
*    Bower - built using NPM -> `npm install bower -g`

**How to Use**:
---
Clone the repo into any directory (we like ~/.sh for our shell scripts):

     git clone https://github.com/HoundstoothSTL/bootstrap-starter-build.git

Navigate to the directoy through terminal and run:

     ./check.sh

The 'check' script will run an audit against your system to make sure you have the necessary packages and dependencies mentioned above.  

If you are all good, it will move straight to the build script, ask a few simple questions and scaffold out a new Bootstrap project with all dependencies managed nicely through Bower.  

If the system audit finds that you are missing a required package, it will ask if you would like the script to install the missing packages for you, or give you options to do it yourself.

Once you have run the check once and have everything you need, you can simply run the build script itself from there on out:
	
	./build.sh

## Planned Features

*    Include dotfiles for shortcuts and accurate colorizing.

## Changelog

**V2.0.2**

*    Fixed check and install script to require node 0.8.x for Bower support

**V2.0.1**

*    Fixed node $PATH issue
*    Fixed npm $PATH issue (since homebrew doesn't install npm anymore)
*    Added a "proceed" prompt before the installer runs

**V2.0.0**

*    Integrated Twitter Bower for package management
*    Built system audit check (based on the Yeoman audit)
*    Built installer for missing dependencies
*    Re-structure of scaffold to account for Bower's "components" directory
*    Various copy changes and style changes

**V1.1.0**

*    Colorized Prompts for easier process
*    Built in dependency check and package builds

**V1.0.0**

*    Initial Push
