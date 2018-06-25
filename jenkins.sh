 sudo apt-get update
 wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
 vi /etc/apt/sources.list
 sudo vi /etc/apt/sources.list
 java
 sudo apt-get install default-jre
 sudo apt-get update
 sudo apt-get install jenkins
 sudo service jenkins start
 sudo service jenkins status
 sudo cat /var/lib/jenkins/secrets/initialAdminPassword