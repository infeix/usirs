#!/bin/bash

# user input
# ---
echo "Enter [APP_NAME]:"
read app_name
db_user_name="${app_name}_user"
echo "Enter [PASSWORD] for db user:"
read db_user_pass
deploy_user=`whoami`
echo "Enter SECRET_KEY (bundle exec rake secret):"
read secret_key
app_dir=$app_name

user_action='ENTER'

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

echo "Grand deploy passwordless sudo previleges (sudo needed) [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

sudo bash -c "echo '$deploy_user ALL=NOPASSWD: ALL' >> /etc/sudoers"

fi
# ---

echo "Install apt-get packages (sudo needed) [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

echo "add yarn APT repository"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# ---

echo "installation apt packages"
sudo apt-get update
sudo apt-get install -y nginx-extras gnupg2 nodejs yarn postgresql-9.5 postgresql-server-dev-9.5

fi
# ---

echo "Removing default nginx config [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

sudo rm /etc/nginx/sites-enabled/default

fi
# ---

echo "Start creating Postgres User [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

sudo -u postgres psql -c "CREATE ROLE $db_user_name PASSWORD '$db_user_pass' NOSUPERUSER CREATEDB NOCREATEROLE INHERIT LOGIN;"
sudo -u postgres psql -c "CREATE DATABASE $db_user_name OWNER $db_user_name"

fi
# ---

echo "Start download and install rvm [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

# Add GPG key for downloading rvm
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
gpg2 --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# installation rvm
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

fi
# ---

echo "Start install ruby (2.3.1) with rvm [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

rvm install 2.3.1
rvm --default use 2.3.1
rvm use 2.3.1

fi
# ---

echo "Start install bundler [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

gem install bundler

fi
# ---

echo "Start creating database.yml [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

mkdir ~/$app_dir
mkdir ~/$app_dir/shared
mkdir ~/$app_dir/shared/config
touch ~/$app_dir/shared/config/database.yml
touch ~/$app_dir/shared/config/secrets.yml

echo 'production:' >> ~/$app_dir/shared/config/database.yml
echo '  adapter: postgresql' >> ~/$app_dir/shared/config/database.yml
echo "  username: $db_user_name" >> ~/$app_dir/shared/config/database.yml
echo "  password: $db_user_pass" >> ~/$app_dir/shared/config/database.yml
echo '  encoding: unicode' >> ~/$app_dir/shared/config/database.yml
echo '  pool: 5' >> ~/$app_dir/shared/config/database.yml
echo '  host: localhost' >> ~/$app_dir/shared/config/database.yml
echo "  database: $db_user_name" >> ~/$app_dir/shared/config/database.yml

fi
# ---

echo "Start creating secrets.yml [${user_action}]:"
reaction=`user_interact`
if [ "$reaction" != 'skip' ]; then

echo "production:" >> ~/$app_dir/shared/config/secrets.yml
echo "  secret_key_base: $secret_key" >> ~/$app_dir/shared/config/secrets.yml

fi
echo " === ready for deploy ==="

