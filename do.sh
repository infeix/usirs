#!/bin/bash

echo "Install apt-get packages (sudo needed) [ENTER]:"
read notused

echo "add the Passenger APT repository"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main >
/etc/apt/sources.list.d/passenger.list'

echo "add yarn APT repository"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

sudo apt-get update
sudo apt-get install -y nginx-extras passenger gnupg2 nodejs yarn postgresql-9.5 postgresql-server-dev-9.5

echo "Type the db_user name, followed by [ENTER]:"
read db_user_name

echo "Type the db_user password, followed by [ENTER]:"
read db_user_pass

echo "Create Postgres User [ENTER]:"
read notused
sudo -u postgres psql -c "CREATE ROLE $db_user_name PASSWORD '$db_user_pass' NOSUPERUSER CREATEDB NOCREATEROLE INHERIT LOGIN;"
sudo -u postgres psql -c "CREATE DATABASE $db_user_name OWNER $db_user_name"
echo "Add GPG key for downloading rvm [ENTER]:"
read notused
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
gpg2 --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

echo "Type the app directory, followed by [ENTER]:"
read app_dir

echo "Download and install rvm [ENTER]:"
read notused
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

echo "Install ruby (2.3.1) with rvm [ENTER]:"
read notused
rvm install 2.3.1
rvm --default use 2.3.1
rvm use 2.3.1

echo "Install bundler [ENTER]:"
read notused
gem install bundler

echo "Type the app directory, followed by [ENTER]:"
read app_dir

echo "Type the secret (bundle exec rake secret) key, followed by [ENTER]:"
read secret_key

echo "Create database.yml [ENTER]:"
read notused
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

echo "Create secrets.yml [ENTER]:"
read notused
echo "production:" >> ~/$app_dir/shared/config/secrets.yml
echo "  secret_key_base: $secret_key" >> ~/$app_dir/shared/config/secrets.yml

echo " === ready for deploy ==="

