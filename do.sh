#!/bin/bash

echo "Type the app directory, followed by [ENTER]:"
read app_dir

echo "Type the db_user name, followed by [ENTER]:"
read db_user_name

echo "Type the db_user password, followed by [ENTER]:"
read db_user_pass

echo "Type the secret (bundle exec rake secret) key, followed by [ENTER]:"
read secret_key


echo "Add GPG key for downloading rvm [ENTER]:"
read notused
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

echo "Download and install rvm [ENTER]:"
read notused
\curl -sSL https://get.rvm.io | bash -s stable

echo "Install ruby (2.3.1) with rvm [ENTER]:"
read notused
rvm install 2.3.1
rvm --default use 2.3.1
rvm use 2.3.1

echo "Install bundler [ENTER]:"
read notused
gem install bundler

echo "Install Postgres (sudo needed) [ENTER]:"
read notused
sudo apt-get install postgesql-9.5

echo "Create Postgres User [ENTER]:"
read notused
sudo -u postgres psql -c "CREATE ROLE $db_user_name PASSWORD '$db_user_pass' NOSUPERUSER CREATEDB
NOCREATEROLE INHERIT LOGIN;"

echo "Create database.yml [ENTER]:"
read notused
mkdir ~/$app_dir
mkdir ~/$app_dir/shared
mkdir ~/$app_dir/shared/config

echo 'production:' > "~/$app_dir/shared/config/database.yml"
echo '  adapter: postgresql' >> "~/$app_dir/shared/config/database.yml"
echo "  username: $db_user_name" >> "~/$app_dir/shared/config/database.yml"
echo "  password: $db_user_pass" >> "~/$app_dir/shared/config/database.yml"
echo '  encoding: unicode' >> "~/$app_dir/shared/config/database.yml"
echo '  pool: 5' >> "~/$app_dir/shared/config/database.yml"
echo '  host: localhost' >> "~/$app_dir/shared/config/database.yml"
echo "  database: $db_user_name" >> "~/$app_dir/shared/config/database.yml"

echo "Create secrets.yml [ENTER]:"
read notused
echo "production:" > "~/$app_dir/shared/config/secrets.yml"
echo "  secret_key_base: $secret_key" > "~/$app_dir/shared/config/secrets.yml"

echo " === ready for deploy ==="

