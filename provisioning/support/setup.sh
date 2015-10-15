#!/bin/bash
DEMO_HOME=/home/demo
VAGRANT="/vagrant"
#POSTGRES_HOME="/var/lib/pgsql"
POSTGRES_HOME="/var/lib/pgsql/9.3"
TOOLS=tools
EAP=jboss-eap-6.4.0
JON=jon-server-3.3.0.GA
EAP_JON_PLUGINS=jon-plugin-pack-eap-3.3.0.GA


echo "=== creating demo user with demo password and sudo access ... "
useradd -p 90IsrKmbBbFnE -d ${DEMO_HOME} -G users,wheel -c "Demo" demo

echo "=== copying install artifacts..."
cd ${DEMO_HOME}
mkdir ${TOOLS}
cp ${VAGRANT}/provisioning/installs/* ${DEMO_HOME}/${TOOLS}
cp ${VAGRANT}/provisioning/support/start_all.sh ${DEMO_HOME}/
chmod +x ${DEMO_HOME}/*.sh
sudo chown -R demo:users ${DEMO_HOME}/${TOOLS}*
sudo chown -R demo:users ${DEMO_HOME}/${TOOLS}/*

echo "=== installing postgresql..."
###postgres download mirror seems to be down
#sudo dnf -y install postgresql-server postgresql-contrib
#sudo systemctl enable postgresql

### using rpm method to install postgres
cd ${TOOLS}
sudo rpm -iUvh pgdg*.rpm
sudo yum -y install postgresql93 postgresql93-server postgresql93-contrib postgresql93-libs --enablerepo=pgdg93

echo "=== initializing postgres..."
#sudo postgresql-setup initdb
sudo /usr/pgsql-9.3/bin/postgresql93-setup initdb

/bin/cp --force ${VAGRANT}/provisioning/support/pg_hba.conf ${POSTGRES_HOME}/data/pg_hba.conf

echo "=== starting postgres database..."
#sudo systemctl start postgresql
systemctl start postgresql-9.3

echo "=== creating rhqadmin user, rhq database with rhqadmin as owner for JON..."
sudo -u postgres psql --command "create user rhqadmin password 'rhqadmin';"
sudo -u postgres psql --command "CREATE DATABASE rhq OWNER rhqadmin;"

echo "=== unpackaging EAP and JON install artifacts..."
cd ${DEMO_HOME}/${TOOLS}
unzip -q ${EAP}.zip
unzip -q ${JON}.zip
unzip -q ${EAP_JON_PLUGINS}.zip

echo "=== configuring JON and copying EAP JON plugins..."
/bin/cp --force ${VAGRANT}/provisioning/support/rhq-server.properties ${JON}/bin/rhq-server.properties
/bin/cp --force ${EAP_JON_PLUGINS}/* ${JON}/plugins/

sudo chown -R demo:users ${DEMO_HOME}/${TOOLS}/*

echo "=== installing JON server, agent and storage node..."
${DEMO_HOME}/${TOOLS}/${JON}/bin/rhqctl install
/bin/cp --force ${EAP_JON_PLUGINS}/* ${JON}/plugins/
sudo chown -R demo:users ${DEMO_HOME}/${TOOLS}/*

echo "Successful! Your environment for JON demo is ready. start EAP and JON to show these awesome products !!!"
