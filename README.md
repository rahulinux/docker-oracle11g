docker-oracle11g
================

Docker + Oralce Linux 6.5 + Oracle Database 11gR2 (Enteprise Edition) setup.
Does not include the DB11g binary.
You need to download that from the official site beforehand.

## Download

Download the database binary (11.2.0) from below.  Unzip to the subdirectory name "database".

http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

* linux.x64_11gR2_database_1of2.zip
* linux.x64_11gR2_database_2of2.zip

Clone this repository to the local directory.  Move the "database" directory to the same folder.
```
$ git clone https://github.com/rahulinux/docker-oracle11g/
$ cd docker-oracle11g
 ```

## Image build and container install

Pull the Oracle Linux 6.5 Docker image from the Docker Hub repository.

Image was created in the following way:
* use official centos:centos6 image
* convert into Oracle Linux 6.5 https://linux.oracle.com/switch/centos/
* fix locale warning
* install oracle-rdbms-server-11gR2-preinstall
* create install directories
* add ORACLE_XX environment variables
* install ssh server


```
$ sudo docker build -t oracle11g .
   
$ sudo docker run -d -p 0.0.0.0:2222:22 -v $PWD/docker-oracle11g:/shared -e ROOT_PASS="mySshPassword" -t oracle11g

```

## DB Install


Install Database.
```
$ ssh -p 2222 root@localhost

bash-4.1# su - oracle

[oracle@localhost ~]$ /shared/database/runInstaller -silent -ignorePrereq -responseFile /shared/db_install.rsp

Show the log file... 

[oracle@localhost ~]$ exit

bash-4.1# /opt/oraInventory/orainstRoot.sh
bash-4.1# /opt/oracle/product/11.2.0/dbhome_1/root.sh

bash-4.1# exit

$ sudo docker restart <CONTAINER_ID>

```

## Check docker logs, it will take 5-10 minutes to starting oracle and creating db

```
$ sudo docker logs <CONTAINER_ID>
```

Test connection.
```
[oracle@localhost ~]$ sqlplus system/oracle@localhost:1521/orcl

```
