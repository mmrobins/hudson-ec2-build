#!/usr/bin/env bash

# Fix path for solaris
export PATH=/usr/gnu/bin/:$PATH

# Install Ruby
if [ -f /usr/bin/yum ]
then
    yum install -y ruby rdoc
elif [ -f /usr/bin/apt-get ]
then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y ruby libopenssl-ruby rdoc git-core
elif [ -f /usr/bin/emerge ]
then
    emerge dev-lang/ruby
elif [ -f /usr/bin/pkg ]
then
  pkg install -q SUNWruby18
fi

# Download the latest stable puppet
git clone git://github.com/puppetlabs/puppet.git

# Download the latest stable facter
git clone git://github.com/puppetlabs/facter.git

# Download the latest rubygems
rm -rf rubygems*
wget -O rubygems.tgz http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
tar zxf rubygems.tgz
cd rubygems*
ruby setup.rb
ln -s /usr/bin/gem1.8 /usr/bin/gem || true
cd

# Get ready to run puppet
export PATH=$HOME/puppet/bin:$HOME/puppet/sbin:$HOME/facter/bin:$PATH
export RUBYLIB=$HOME/facter/lib:$HOME/puppet/lib:$RUBYLIB

puppet --color false --modulepath=$HOME/hudson-ec2-build $HOME/hudson-ec2-build/manifest.pp

