#!/bin/bash

# user input
# ---
if [ "$1" != '-f' ]; then

user_action='ENTER'

else

user_action='CTRL + C'

fi

# ---

function user_interact {
  notused=''
  if [ "$user_action" == 'ENTER' ]; then
    read notused
  else
    sleep 1
  fi
  if [ "$notused" == '!' ]; then
    user_action='CTRL + C'
  fi
  echo $notused
  return 0
}


echo "Install apt-get packages [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

  echo "add yarn APT repository"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
  curl -sL https://deb.nodesource.com/setup_8.x | bash -

# ---

  echo "installation apt packages"
  apt-get update
  apt -y install postgresql-10 postgresql-server-dev-10
  apt-get install -y nginx-extras gnupg2 nodejs yarn

else
  echo "skipped"
fi
# ---

echo "Removing default nginx config [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

  rm /etc/nginx/sites-enabled/default

else
  echo "skipped"
fi
# ---

echo "Start download and install rvm [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

  echo 'Add GPG key for downloading rvm'
  gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  gpg2 --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

  echo 'installing rvm'
  \curl -sSL https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm

else
  echo "skipped"
fi
# ---

echo "Start install ruby (2.5.1) with rvm [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

  rvm install 2.5.1
  rvm --default use 2.5.1
  rvm use 2.5.1

else
  echo "skipped"
fi
# ---

echo "Start install bundler [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

  gem install bundler

else
  echo "skipped"
fi
# ---

