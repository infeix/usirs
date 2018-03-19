#!/bin/bash

echo "Type the app directory, followed by [ENTER]:"

read app_dir

echo "Type the db_user name, followed by [ENTER]:"

read db_user_name

echo "Type the db_user password, followed by [ENTER]:"

read db_user_pass

echo "Type the secret key, followed by [ENTER]:"

read secret_key

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s stable

ecode=$?
if [ ecode != 0 ]; then
  printf "Error when executing command: '$1'"
  exit ecode
fi

rvm install 2.3.1
rvm user 2.3.1
gem install bundler
sudo apt-get install postges-9.5
sudo -u postgres psql -c "CREATE ROLE $db_user_name PASSWORD '$db_user_pass' NOSUPERUSER CREATEDB
NOCREATEROLE INHERIT LOGIN;"

echo 'production:' > "~/$app_dir/shared/config/database.yml"
echo '  adapter: postgresql' >> "~/$app_dir/shared/config/database.yml"
echo "  username: $db_user_name" >> "~/$app_dir/shared/config/database.yml"
echo "  password: $db_user_pass" >> "~/$app_dir/shared/config/database.yml"
echo '  encoding: unicode' >> "~/$app_dir/shared/config/database.yml"
echo '  pool: 5' >> "~/$app_dir/shared/config/database.yml"
echo '  host: localhost' >> "~/$app_dir/shared/config/database.yml"
echo "  database: $db_user_name" >> "~/$app_dir/shared/config/database.yml"


echo "production:" > "~/$app_dir/shared/config/secrets.yml"
echo "  secret_key_base: $secret_key" > "~/$app_dir/shared/config/secrets.yml"

echo " === ready for deploy ==="

