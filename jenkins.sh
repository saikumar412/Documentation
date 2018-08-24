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
 
 
 
 Solution – Need to execute the below steps as root, after every Jenkins backup restore.

	sudo mkdir /var/lib/jenkins/.kube/
	chmod 777 /var/lib/jenkins/.kube/
	sudo cp /root/.kube/config /var/lib/jenkins/.kube/
	sudo chmod 444 /var/lib/jenkins/.kube/config

and verify what is the access given to Jenkins in visudo. (right now it is in Root access)

	visudo
jenkins    ALL=(ALL)    NOPASSWD: ALL

going on we will create a separate group, in which we will add Jenkins and that group will have permissions to execute Kubectl, Docker and helm.
