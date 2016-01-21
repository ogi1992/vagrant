#Installing Vagrant Box
The Vagrant box definition here provides a server with MySQL, Cassandra and ElasticSearch pre-installed.
The DB Servers are available at their standard ports and with MySQL user paswword as "root".
Once the box is running you can then connect the application.properties to the standard ports for each service.

The following are the steps to get started.
 1. Install virtualbox-5.0_5.0.10-104061-Ubuntu-trusty_amd64 (https://www.virtualbox.org/wiki/Download_Old_Builds_5_0)
 2. Install vagrant_1.8.1_x86_64 (https://releases.hashicorp.com/vagrant/1.8.1/) and then run: vagrant plugin install vagrant-vbguest
 3. Create a directory from which you will run the box 
 4. Place the "Vagrantfile" and the "bootstrap.sh" file in the directory
 5. From that directory, run:
    1. wget http://downloads.datastax.com/community/dsc-cassandra-2.2.4-bin.tar.gz
    2. tar -zxvf dsc-cassandra-2.2.4-bin.tar.gz
 6. Run "vagrant up"

The first time you run it will take a bit longer as it sets up the box
Run "vagrant ssh" to ssh into the box.

For accessing Elasticsearch:

http://192.168.23.23:9200/_plugin/head/

For Cassandra:

cd dsc-cassandra-2.2.4/bin
./cqlsh 192.168.23.23 9042

For Mysql:

apt-get install mysql-client on host machine if you don't already have it installed.
mysql -h 192.168.23.23 -uroot -proot

For PhpMyAdmin:

http://192.168.23.23/phpmyadmin/

user/pass = root/root

