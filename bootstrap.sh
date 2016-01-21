#!/bin/bash
# USE vagrant_1.8.1_x86_64   with   virtualbox-5.0_5.0.10-104061-Ubuntu-trusty_amd64
# vagrant plugin install vagrant-vbguest

#Mysql password
PASSWORD='root'

# update / upgrade
#sudo apt-get update
#sudo apt-get -y upgrade

#Install java8
su -
sudo echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
sudo echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer
sudo apt-get install oracle-java8-set-default

#Cassandra repo
echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -

#CASSANDRA 2.2.4 installation
sudo apt-get update
sudo apt-get install -y dsc22=2.2.4-1 cassandra=2.2.4
sudo sed -i 's/rpc_address: localhost/rpc_address: 0.0.0.0/g' /etc/cassandra/cassandra.yaml
sudo sed -i 's/^# broadcast_rpc_address\:\ 1.2.3.4/broadcast_rpc_address\:\ 1.2.3.4/g' /etc/cassandra/cassandra.yaml  
sudo service cassandra stop
sudo service cassandra start

#Elasticsearch 1.73 installation
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.deb
sudo dpkg -i elasticsearch-1.7.3.deb
sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
sudo service elasticsearch start

# install apache 2.4 and php 5.5
sudo apt-get update
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
sudo service mysql restart

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# restart apache
sudo service apache2 restart

#Cleanup
sudo apt-get autoremove -y
