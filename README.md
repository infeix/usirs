# usirs
usirs - Ubuntu Server install Requirments Script

It installs all I need for deploying my rails app. May it works for you too.

It installs:
* yarn
* nginx-extras
* gnupg2
* nodejs
* postgresql-9.5
* postgresql-server-dev-9.5
* rvm
* ruby (2.3.1)
* bundler


It:
* grands deploy passwordless sudo previleges
* removs default nginx config
* creates a Postgres User and its database
* creates database.yml and secrets.yml

result: ready for deploy

## use

```
git clone https://github.com/infeix/usirs.git && bash -l ./usirs/do.sh
```

