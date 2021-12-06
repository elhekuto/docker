FROM centos:8

#main install
RUN yum install java-11-openjdk -y 
RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN echo $'[Elasticsearch-7]\n\
name=Elasticsearch repository for 7.x packages\n\
baseurl=https://artifacts.elastic.co/packages/7.x/yum\n\
gpgcheck=1\n\
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\n\
enabled=1\n\
autorefresh=1\n\
type=rpm-md\n\
' | tee /etc/yum.repos.d/elasticsearch.repo; 
RUN dnf update -y
RUN dnf install elasticsearch -y
#Configuration
RUN echo 'node.name: node-1' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'network.host: 0.0.0.0' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'discovery.seed_hosts: ["127.0.0.1"]' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'cluster.initial_master_nodes: ["node-1"]' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN echo 'http.port: 9200' | tee -a /etc/elasticsearch/elasticsearch.yml
RUN sed -i 's/TimeoutStartSec=*/TimeoutStartSec=300/' /usr/lib/systemd/system/elasticsearch.service

##RUN sed -i 's/#network.host:*/network.host: 127.0.0.1/g' /etc/elasticsearch/elasticsearch.yml 
##sed -i 's/#node.name: node1/node.name: node-1/g' /etc/elasticsearch/elasticsearch.yml \
##sed -i 's/#http.port: 9200/http.port: 9200/g' /etc/elasticsearch/elasticsearch.yml \
##sed -i 's/TimeoutStartSec=*/TimeoutStartSec=300/g' /usr/lib/systemd/system/elasticsearch.service


EXPOSE 9200 9300
