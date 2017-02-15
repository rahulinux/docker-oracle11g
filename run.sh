#!/bin/bash

if [[ -f /mnt/start.sh ]]
then
      /mnt/start.sh 
else

    ## if oracle is installed then do create databases
    export DISPLAY=hostname:0.0
    export ORACLE_HOME=/opt/oracle/product/11.2.0/dbhome_1

    if [[ -x $ORACLE_HOME/bin/lsnrctl ]] 
    then
       if [[ ! -f /.create_dbs ]];
       then
           su - oracle -c "export DISPLAY=hostname:0.0
           netca -silent -responseFile /opt/oracle/netca.rsp
           echo "netca is completed""
           sleep 2
           su - oracle -c "dbca -silent -createDatabase -responseFile /opt/oracle/dbca.rsp -syspassword oracle -systempassword oracle  -dbsnmppassword oracle -gdbname orcl -sid orcl"
           touch /.create_dbs 
           #sleep 2
           #echo "Preparing SQL data"
           #su - oracle -c "sqlplus system/oracle@localhost:1521/orcl @/mnt/sqldatadump.sql"
       else
          echo "Make sure clean shutdown"
          su - oracle -c "lsnrctl stop"
          su - oracle -c "echo -e 'connect / as sysdba\nshutdown\nquit'| sqlplus /nolog"
          sleep 2
          echo "Starting Oracle"
          su - oracle -c "lsnrctl start"
          su - oracle -c "echo -e 'connect / as sysdba\nstartup\nquit'| sqlplus /nolog"
          sleep 1
          su - oracle -c "lsnrctl status"
       fi
    else
         echo "Install Database, check README.md"
    fi

fi

if [ ! -f /.root_pw_set ]; then
        /set_root_pw.sh
fi

exec /usr/sbin/sshd -D
