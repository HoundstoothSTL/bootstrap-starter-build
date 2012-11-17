#!/bin/bash

# install system dependencies

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

dep_install() {

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
    if [[ "$cli" = 0 ]]; then
  		sad_print "Command Line Tools for Xcode" "Failed" && \
  		echo ""
  		echo -e $A"We cannot install XCode. Visit http://stackoverflow.com/a/9329325/89484 for options."
  		echo ""
  		exit
    fi

    if [[ "$brew" = 0 ]]; then
  		echo ""
  		echo -e $M"Installing Homebrew... "
  		echo ""
  		ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
    fi

    if [[ "$git" = 0 ]]; then
		  echo ""
		  echo -e $M"Installing Git... "
		  echo ""
		  brew install git
    fi

    if [[ "$node" = 0 ]]; then
	  	echo ""
	  	echo -e $M"Installing Node... "
	  	echo ""
	  	brew install node
      echo -e $M"Installing Node Package Manager"
	  	sudo curl -O http://npmjs.org/install.sh | sh
      export NODE_PATH="/usr/local/lib/node"
      export PATH="/usr/local/share/npm/bin:$PATH"
    fi

    if [[ "$grunt" = 0 ]]; then
	  	echo ""
	  	echo -e $M"Installing Grunt... "
	  	echo ""
	  	sudo npm install -g grunt
    fi

    if [[ "$bower" = 0 ]]; then
      echo ""
      echo -e $M"Installing Bower... "
      echo ""
      sudo npm install -g bower
    fi

  fi

  echo ""
  echo -e $M"Finished running the installer, let's run a check again... "
  echo ""

}

sysaudit() {
  echo ""
  echo "Re-running the system audit to see how we did... "

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
  [ "$grunt" -eq 1 ] && happy_print "Grunt" "Success"
  [ "$bower" -eq 1 ] && happy_print "Bower" "Success"

  # failures
  if [[ "$mac" = 1 ]]; then
    [ "$cli" -eq 0 ]  && \
      sad_print "Command Line Tools for Xcode" "" && \
      desc_print "Visit http://stackoverflow.com/a/9329325/89484 for installation options."
    [ "$brew" -eq 0 ] && \
      sad_print "Homebrew" "" && \
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
    desc_print "You'll need Grunt for this to work, once you have Node installed, run" "sudo npm install -g grunt"
  [ "$bower" -eq 0 ] && \
    sad_print "Bower" "Failed" && \
    desc_print "You'll need Bower for package management, once you have Node installed, run" "sudo npm install -g bower"


  if [[ "$cli" = 1 && "$brew" = 1 && "$git" = 1 && "$node" = 1 && "$ruby" = 1 && "$gem" = 1 && "$grunt" = 1 && "$bower" = 1 ]]; then
    echo ""
  	echo -e $M"Ok, looks like you're good to go!"
  	echo ""
  else
  	echo -e $A"Hmmm, something didn't work out quite right."
  	echo -e $A"Try again, watch the progress and see where it get's caught up."
  	echo -e $WHITE""
  fi

}

echo -e $M""
echo "Hello, I am the installer"
echo ""

installYN= 
while [ -z $installYN ]
do 
  echo -e -n $QMARK'[?] '$Q'This installer will use Homebrew to install packages, you will need your password for the install, type "y" when you are ready to proceed ' $YN'(y/n) '
  read installYN
done

if [[ "$installYN" =~ ^[Yy]$ ]]
then
  dep_install
  sysaudit
else
  echo -e $M"No problem, feel free to do the install manually if you like"
  exit
fi
