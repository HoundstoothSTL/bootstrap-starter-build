#!/bin/bash

# audit system and check dependencies

# logic
# 0 = not installed
# 1 = installed, correct version
# 2 = installed, wrong version

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

# Requirements
reqnode=0.8.0
reqruby=1.8.7

# Check os
os=$(uname -s)

if [[ "$os" == "Darwin" ]]; then
  mac=1
elif [[ "$os" == "Linux" ]]; then
  echo "Linux has not been tested, support will be ready soon."
  exit 1 
else
  echo "Windows is not supported."
  exit 1
fi

# Dependency checks
    clangfile=$(command -v clang)
     brewfile=$(command -v brew)
      gitfile=$(command -v git)
     nodefile=$(command -v node)
     rubyfile=$(command -v ruby)
      gemfile=$(command -v gem)
    gruntfile=$(command -v grunt)
    bowerfile=$(command -v bower)

# Check if installed.
check_set(){
  [[ -x "$1" ]]  && echo 1 || echo 0
}

# This prints the ✘ in red,
# rest in bold.
sad_print(){
  printf '\e[31m%s\e[0m \e[1m%s\e[0m %s\n' "✘" "$1" "$2"
}

# This prints ✓ in green,
# rest in bold.
happy_print(){
  printf '\e[32m%s\e[0m \e[1m%s\e[0m %s\n' "✓" "$1" "$2"
}

# print extra descriptions for failure states
desc_print(){
  printf "\t%s \e[47m\e[0;35m%s\e[0m %s\n" "$1" "$2" "$3"
}

# system audit

sysaudit() {
  echo ""
  echo "We are running a system audit to check for necessary packages and dependencies... "
  echo "We are not installing anything at this time, here are your results: "

  if [[ $mac = 1 ]]; then
    # xcode cli test.
    cli=$(check_set $clangfile)

    # brew test.
    brew=$(check_set $brewfile)
  fi

  # node test
  node=$(check_set $nodefile)
  if [[ $node == 1 ]]; then
    nodever=$(node -e 'console.log(process.versions.node);')
    # node version check
    if [[ "$nodever" < "$reqnode" ]]; then
      node=2
    fi
  fi

  # ruby test
  ruby=$(check_set $rubyfile)
  if [[ $ruby == 1 ]]; then
    rubyver=$(ruby -e 'print RUBY_VERSION')
    # ruby version check
    if [[ "$rubyver" < "$reqruby" ]]; then
      ruby=2
    fi
  fi


  git=$(check_set $gitfile)
  gem=$(check_set $gemfile)
  grunt=$(check_set $gruntfile)
  bower=$(check_set $bowerfile)

  # display results
  #
  # results logic
  # passes first
  # fails second

  echo ""

  # passes
  if [[ "$mac" = 1 ]]; then
    [ "$cli" -eq 1 ] &&  happy_print "Command Line Tools for Xcode" "Success, killer..."
    [ "$brew" -eq 1 ] && happy_print "Homebrew" "Success, killer..."
  fi

  [ "$git" -eq 1 ] && happy_print "Git" "Success"
  [ "$node" -eq 1 ] && happy_print "NodeJS" "Success"
  [ "$ruby" -eq 1 ] && happy_print "Ruby" "Success"
  [ "$gem" -eq 1 ] && happy_print "RubyGems" "Success"
  [ "$grunt" -eq 1 ] && happy_print "Grunt" "Success - you hipster!"
  [ "$bower" -eq 1 ] && happy_print "Bower" "Success - you hipster!"

  # failures
  if [[ "$mac" = 1 ]]; then
    [ "$cli" -eq 0 ]  && \
      sad_print "Command Line Tools for Xcode" "Failed" && \
      desc_print "Visit http://stackoverflow.com/a/9329325/89484 for installation options."
    [ "$brew" -eq 0 ] && \
      sad_print "Homebrew" "Failed" && \
      desc_print "Install Homebrew from the instructions at https://github.com/mxcl/homebrew/wiki/Installation " && \
      desc_print "For best results, after install, be sure to run" "brew doctor" "and follow the recommendations."
  fi


  [ "$git" -eq 0 ] && \
    sad_print "Git" "Failed" && \
    desc_print "Install through your package manager. " && \
    desc_print "For example, with homebrew:" "brew install git"
  [ "$node" -eq 0 ] && \
    sad_print "NodeJS" "Failed" && \
    desc_print "I recommend you grab a fresh NodeJS install (>= 0.8.x) from http://nodejs.org/download/ "
  [ "$ruby" -eq 0 ] && \
    sad_print "Ruby"  "Failed" && \
    desc_print "Check your ruby version is adequate with" "ruby -v" "(>= 1.8.7 required) and install http://www.ruby-lang.org/en/downloads/"
  [ "$gem" -eq 0 ] && \
    sad_print "RubyGems" "Failed" && \
    desc_print "You'll acquire this with your ruby installation. "
  [ "$grunt" -eq 0 ] && \
    sad_print "Grunt" "Failed" && \
    desc_print "You'll need Grunt for this to work, once you have Node installed, do" "npm install -g grunt"
  [ "$bower" -eq 0 ] && \
    sad_print "Bower" "Failed" && \
    desc_print "You'll need Grunt for this to work, once you have Node installed, do" "npm install -g grunt"


  if [[ "$cli" = 0 || "$brew" = 0 || "$git" = 0 || "$node" = 0 || "$node" = 2 || "$ruby" = 0  || "$ruby" = 2 || "$gem" = 0 || "$grunt" = 0 || "$bower" = 0 ]]; then
    
    echo ""
    echo -e $A"Looks like you're missing some needed packages."
    echo ""

    installYN=
    while [ -z $installYN ]
    do
      echo -e -n $QMARK'[?] '$Q'Do you want me to install the missing packages?' $YN'(y/n) '
      read installYN
      
      if [[ "$installYN" =~ ^[Yy]$ ]]
      then
        if [[ "$cli" = 0 ]]; then
          sad_print "Command Line Tools for Xcode" "Failed" && \
          echo ""
          echo -e $A"We cannot install XCode Command Line Tools"
          echo "Visit http://stackoverflow.com/a/9329325/89484 for options."
          echo ""
          exit
        fi
        echo -e $M"Ok, let's go..."
        ./install.sh
      else
        echo -e $A"\n================================================\n"
        echo -e $A"No worries, install these guys and come on back... "
        echo -e $A"\n================================================\n"
        exit
      fi
    done

  else
    echo ""
    echo -e $M"Rock on, you are set to start building apps with package management! "
    echo ""
    ./build.sh

  fi

}

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

# function calls.
sysaudit
