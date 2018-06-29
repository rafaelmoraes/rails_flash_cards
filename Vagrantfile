# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  GUEST_MOUNT_POINT = '/vagrant'.freeze
  DATABASE_SERVER_IP = '192.168.1.10'.freeze

  config.vm.box_check_update = false # I like to update when I want! =P
  config.vm.box = 'centos/7'
  config.vm.synced_folder '.', GUEST_MOUNT_POINT, type: 'virtualbox'

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.memory = '1024'
    vb.cpus = 2
  end

  config.vm.provision 'shell',
                      name: '[optional] System upgrade and customize ~/.bashrc',
                      privileged: false,
                      inline: <<-SHELL
      sudo yum upgrade -y
      sudo yum install -y vim
      sed "/cd \#{GUEST_MOUNT_POINT}/d" -i ~/.bashrc
      echo "cd #{GUEST_MOUNT_POINT}" >> ~/.bashrc
  SHELL

  config.vm.provision 'shell',
                      name: 'Add PostgresSQL repository',
                      inline: <<-SHELL
    sed -e '/exclude=postgresql\*/d' -e '/^\\[base\\]$\\|^\\[updates\\]$/a exclude=postgresql*' -i /etc/yum.repos.d/CentOS-Base.repo
    yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
  SHELL

  config.vm.define 'rails' do |rails|
    rails.vm.network 'forwarded_port', guest: 3000, host: 3000

    rails.vm.provision 'shell',
                       name: 'Install Ruby and Ruby on Rails',
                       privileged: false,
                       inline: <<-SHELL
      ## Install requirements
      sudo yum install -y epel-release
      sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel nodejs
      ## Install rbenv
      git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
      cd ~/.rbenv && src/configure && make -C src
      git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
      echo 'eval "$(rbenv init -)"' >> ~/.bashrc
      source ~/.bashrc
      ## Install Ruby
      rbenv install 2.5.1
      rbenv global 2.5.1
      ## Install Ruby on Rails
      echo "gem: --no-ri --no-doc" > ~/.gemrc
      gem install rails

      ## Necessary to install gem pg
      sudo yum install -y postgresql-devel
      bundle config build.pg --with-pg-config=/usr/pgsql-10/bin/pg_config
    SHELL

    rails.vm.provision 'shell',
                       name: 'Customize ./bashrc',
                       privileged: false,
                       inline: <<-SHELL
      sed '/export PS1=*./d' -i ~/.bashrc
      echo 'export PS1="rails:[\\w]\\n>> "' >> ~/.bashrc
    SHELL
  end

  config.vm.define 'postgres' do |db|
    db.vm.network 'private_network', ip: DATABASE_SERVER_IP

    db.vm.provision 'shell',
                    name: 'Install PostgreSQL',
                    privileged: false,
                    inline: <<-SHELL
      # Install
      sudo yum install -y postgresql10 postgresql10-server
      sudo /usr/pgsql-10/bin/postgresql-10-setup initdb

      # Access
      sudo sed -e "/^listen_addresses = '\*'/d" -e "/#listen_addresses = 'localhost'/a listen_addresses = '\*'" -i /var/lib/pgsql/10/data/postgresql.conf
      sudo sed 's/host.*all.*all.*127.0.0.1.*ident/host    all     all     all     md5/' -i /var/lib/pgsql/10/data/pg_hba.conf

      # Daemon
      sudo systemctl enable postgresql-10.service
      sudo systemctl restart postgresql-10.service

      # Create database and user
      sudo -u postgres createdb $USER
      sudo -u postgres psql -U postgres -d $USER -c "CREATE ROLE $USER WITH SUPERUSER LOGIN PASSWORD '$USER';"
    SHELL

    db.vm.provision 'shell',
                    name: '[optional] Customize ./bashrc',
                    privileged: false,
                    inline: <<-SHELL
      sed '/export PS1=*./d' -i ~/.bashrc
      echo 'export PS1="postgres:[\\w]\\n>> "' >> ~/.bashrc
    SHELL
  end
end
