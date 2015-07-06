Boundary Elastic Search
=======================

Configures an virtual machine with an ElasticSearch instance for testing Boundary Plugin for Elasticsearch

Prerequistes
------------

- Vagrant 1.72. or later, download [here](https://www.vagrantup.com/downloads.html)
- Virtual Box 4.3.26 or later, download [here](https://www.virtualbox.org/wiki/Downloads)
- git 2.3.3 or later

Installation
------------

Prior to installation you need to obtain in your Boundary API Token.


1. Clone the GitHub Repository:
```bash
$ git clone https://github.com/jdgwartney/boundary-vagrant-elasticsearch
```

2. Start the virtual machine using your Boundary API Token:
```bash
$ BOUNDARY_API_TOKEN=<Boundary API Token> vagrant up <virtual machine name>
```
NOTE: Run `vagrant status` to list the name of the virtual machines.

3. Login to the virtual machine
```bash
$ vagrant ssh <virtual machine name>
```


