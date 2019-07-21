#!/bin/bash
set -x

rm -rf ./vendor ./lib
yum install -y -q mysql-devel

bundle config build.mysql2 "--with-ldflags=-L/usr/include/openssl --with-cppflags=-I/usr/include/openssl"
gem install mysql2 -v '0.5.2' --source 'https://rubygems.org/' --install-dir ./vendor/bundle/ruby/2.5.0/
bundle install --no-deployment --path vendor/bundle
bundle install --deployment --path vendor/bundle

mkdir ./lib
cp /usr/lib64/mysql/libmysqlclient.so.18 lib/

git clone https://github.com/maehachi08/goosetune.git /tmp/goosetune
cd /tmp/goosetune
git checkout correspond-to-playgoose
gem install rake rspec
rake build
cd -
gem install /tmp/goosetune/pkg/goosetune-0.0.4.gem --install-dir ./vendor/bundle/ruby/2.5.0

