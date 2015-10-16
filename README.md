# vagrant-jon-demo
This vagrant project will create an environment to help with JON demonstrations

## What is in the image ?
* Fedora 22 Desktop
* Postgres 9.3
* EAP and JON plugins
* JON

## How to set it up
* Install Vagrant
* Install VirtualBox
* clone this github project and download the required artifacts as per installs/ReadMe.md file
* run command "vagrant up" under the root folder of this project (run command "vagrant destroy" before re-installing the image)
* Log into the jon-demo vagrant VM in VirtualBox as demo/demo (leave the defaults and click through the start up Fedora screens)
* Start EAP (${HOME}/tools/jboss-eap-6.4/bin/standalone.sh) and then JON server (${HOME}/tools/jon-server-3.3.0.GA/bin/rhqctl start)
* Navigate to JON admin console (http://localhost:7080) with rhqadmin/rhqadmin credentials
