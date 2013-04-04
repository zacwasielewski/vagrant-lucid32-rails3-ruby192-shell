#!/bin/bash
# 
# Installs Ruby 1.9, and Nginx with Passenger. 
#
# <UDF name="db_password" Label="MySQL root Password" />
# <UDF name="rr_env" Label="Rails/Rack environment to run" default="production" />

source ./linode-stackscript-1.sh  # Common bash functions

export DB_PASSWORD='vagrant'

function log {
  echo "$1 `date '+%D %T'`" >> /root/log.txt
}

# Update packages and install essentials
  cd /tmp
  system_update
  log "System updated"
  apt-get -y install build-essential zlib1g-dev libssl-dev libreadline5-dev openssh-server libyaml-dev libcurl4-openssl-dev libxslt-dev libxml2-dev
  goodstuff
  log "Essentials installed"

# Set up MySQL
  mysql_install "$DB_PASSWORD" && mysql_tune 40
  log "MySQL installed"

# Set up Postfix
  postfix_install_loopback_only

# Installing Ruby
  export RUBY_VERSION="ruby-1.9.2-p0"
  log "Installing Ruby $RUBY_VERSION"

  log "Downloading: (from calling wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/$RUBY_VERSION.tar.gz)" 
  log `wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/$RUBY_VERSION.tar.gz`

  log "tar output:"
  log `tar xzf $RUBY_VERSION.tar.gz`
  rm "$RUBY_VERSION.tar.gz"
  cd $RUBY_VERSION

  log "current directory: `pwd`"
  log ""
  log "Ruby Configuration output: (from calling ./configure)" 
  log `./configure` 

  log ""
  log "Ruby make output: (from calling make)"
  log `make`

  log ""
  log "Ruby make install output: (from calling make install)"
  log `make install` 
  cd ..
  rm -rf $RUBY_VERSION
  log "Ruby installed!"

# Set up Nginx and Passenger
  log "Installing Nginx and Passenger" 
  gem install passenger
  passenger-install-nginx-module --auto --auto-download --prefix="/usr/local/nginx"
  log "Passenger and Nginx installed"

# Configure nginx to start automatically
  wget http://library.linode.com/web-servers/nginx/installation/reference/init-deb.sh
  cat init-deb.sh | sed 's:/opt/:/usr/local/:' > /etc/init.d/nginx
  chmod +x /etc/init.d/nginx
  /usr/sbin/update-rc.d -f nginx defaults
  log "Nginx configured to start automatically"

# Install git
  apt-get -y install git-core

# Set up environment
  # Global environment variables
  if [ ! -n "$RR_ENV" ]; then
    RR_ENV="production"
  fi
  cat >> /etc/environment << EOF
RAILS_ENV="$RR_ENV"
RACK_ENV="$RR_ENV"
EOF

# Install Rails 3
  # Update rubygems to (=> 1.3.6 as required by rails3)
  gem update --system

  # Install rails
  gem install rails --no-ri --no-rdoc

  # Install sqlite gem
  apt-get -y install sqlite3 libsqlite3-dev
  gem install sqlite3-ruby --no-ri --no-rdoc

  # Install mysql gem
  apt-get -y install libmysql-ruby libmysqlclient-dev
  gem install mysql2 --no-ri --no-rdoc

# Add deploy user
echo "deploy:deploy:1000:1000::/home/deploy:/bin/bash" | newusers
cp -a /etc/skel/.[a-z]* /home/deploy/
chown -R deploy /home/deploy
# Add to sudoers(?)
echo "deploy    ALL=(ALL) ALL" >> /etc/sudoers

# Spit & polish
  restartServices
  log "StackScript Finished!"