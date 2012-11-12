Bootstrap Starter Build Script
=======================

## Build out a new Bootstrap Scaffold using a simple shell script.

The script will ask a few questions and then build out a LESS or non-LESS Bootstrap scaffold based on your answers.

**Questions are**:

*    What is the base path for your projects (absolute path, no trailing slashes please)? - You'd answer `/Users/USERNAME/Sites` or what have you
*    What is our new Bootstrap project name? - You'd answer, whatever you want it to be called, no spaces
*    Are we using the Bootstrap LESS files? (y/n)
*    Are we using the Bootstrap JavaScript files? (y/n)
*    Do you have a packages directory already for bootstrap, jQuery and Modernizr? (y/n) ?  - If not we'll build it for you
	 *    Where do you want your packages directory (absolute path, no trailing slashes) ?
*    Where do you keep your packages (absolute path, no trailing slashes)?

**Requirements**:

*    You have to have package management somewhere on your machine, if not, we'll make it for you
*    You must have Git installed
*    You must have wget installed - using homebrew -> `brew install wget`
*    You must have grunt installed - using NPM -> `npm install -g grunt`

**How to Use**:
---
Throw this guy anywhere on your machine ( typically under ~/.sh folder ), cd into that directory and then run:

     ./bootstart.sh

 If that doesn't work, recompile it by running 

     chmod +x bootstart.sh

Then try again.

## Planned Features

*    Package management via Twitter Bower
*    Include .aliases doc for shortcuts

## Changelog

**V1.2.0**

*    Colorized Prompts for easier process
*    Built in dependency check and package builds

**V1.0.0**

*    Initial Push
