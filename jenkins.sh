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


Issue Reason – Docker private registry hosts are not accessible from nodes in http call.
Solution – Need to add –insecure-registry property in daemon.json file for each node and master. Restart docker and kubelt and login to docker account.

	Add –insecure-registry flag in /etc/docker/deamon.json file
{
  "insecure-registries" : ["55.666.77.888:5000"]
}
	Restart docker –> sudo service docker restart
	Restart kubelet –> cd /etc/init.d and kubelet restart
	Docker login 55.666.77.888:5000 –u user –pw password
