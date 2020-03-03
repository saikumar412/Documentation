# System manager pre-requisites:

#### AWS Instances(Linux/Windows):
  1. User should have permissions to execute SSM actions, [IAM Instance profile](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-profile.html) should be attached to the target EC2 instances.
  2. SSM Agent should be installed on target EC2 instances.
  3. Verify that you are allowing HTTPS(443) outbound traffic to SSM end points.
  
#### On-Prem servers(Linux/Windows):
  1. User should have permissions to execute SSM actions. [you can create a new service role or use the existing service role as](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-service-role.html) part of SSM activation creation process.
  2. Create SSM activation in SSM Console which generates activation id & Activation code.
  3. Install SSM agent on on-premises servers.
  4. Register the SSM agent using the activation id & activation code in step-1. Now the on-premises server is considered as registered/managed instance in SSM.
  
### Registering new EC2 Instance(Linux/Windows) to SSM:
  1. While creating a new EC2 instance attach the Instance profile created(pre-requisite) under configure instance section.
  2. We need to install the SSM Agent which can be done using user data.
  3. No need to generate key pair i.e you can proceed with instance creation with out generating any key pair.
  4. No need to create the security group with 22 port open.
  
**Note:**  SSM agent is installled by default on following AMIs. Hence you skip SSM agent installation under userdata section for the below AMIs.                      
  Windows Server 2003-2012 R2 AMIs published in November 2016 or later, Windows Server 2016 and 2019, Amazon Linux, Amazon Linux 2, Ubuntu Server 16.04, Ubuntu Server 18.04.
  
### Registering Existing EC2 Instance(Linux/Windows) to SSM:
  #### Linux:
  1. SSH into the existing Linux Instance.
  2. [Install SSM agent.](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-manual-agent-install.html)
  3. Attach the IAM instance profile to EC2 instance. If already role is attached to the instance then attach the SSM policy as inline policy to the existing role.
  4. Now the Existing EC2 linux instance is managed instance and will appear under Manager instances section under SSM console.
  #### Windows:
  1. Login into Windows instance using RDP or windows powershell. 
  2. [Install the SSM agent](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-win.html) using either powershell or direct download link.
  3. start or restart SSM agent service using windows power shell.

### Registering Hybrid Environment servers(Linux/windows) to SSM:
   1. [Create IAM service role](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-service-role.html) for virtual machines or servers in hybrid environment to communicate with System manager service. The role grants AssumeRole trust to the system manager service. You only need to create the service role for a hybrid environment once for each AWS account.
   2. [TLS(Transport Layer Security) certificate must be installed](https://docs.aws.amazon.com/systems-manager/latest/userguide/hybrid-tls-certificate.html) on each managed instance you use with system manager.
   3. create instance activation. creating instance activation includes the details such as activation description, instance limit, IAM Role(Step-1), activation expiry date, default instance name. This will return activation id & activation code.
**Activation Description** - Description for the activation. This field is optional.               
**Instance limit** - Total no of on premises servers or vms that you want to register with AWS as part of the activation.               
**IAM Role** - service role that enable on premises servers or vms to communicate with System manager. You can create new one or select the existing one(created as part of Step-1).                  
**Activation Expiry Date** - Expiration date for the activation.               
4. Install SSM agent.            
   **Windows:**          
   1. Login into Hybrid environment windows server.          
   2. open the windows powershell in administrative mode.          
   3. copy and replace region, activation-id, activation code( refer to step-3) in powershell code and press Enter.          
   4. This code installs SSM agent & registers the server or VM to SSM.             
   5. Now the server or VM is managed instance. 
   
   **Linux:**          
   1. Login into VM or Server in Hybrid environment.
   2. [Copy and paste one of the following command blocks into SSH.](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-managed-linux.html) Replace the placeholder values with the Activation Code and Activation ID generated when you create a managed-instance activation, and with the identifier of the AWS Region you want to download SSM Agent from.
   3. Press Enter. Command downloads and install SSM agent, stop the SSM agent, registers the SSM agent with SSM using activation id & activation code( refer to step-3).
   4. Now the server is managed instance and appears under Managed instances section under SSM.        
   
**Note:**  
1. on-premises instances are distinguished from Amazon EC2 instances with the prefix "mi-".   
2. There is a limit of 1,000 instances per activation and activation expires after a maximum of 30 days. After activation expiry, new instances can’t be registered to it, but registered instances can continue to be managed.           
3. AWS Systems Manager offers a standard-instances tier and an advanced-instances tier for servers and VMs in your hybrid environment. The standard-instances tier enables you to register a maximum of 1,000 on-premises servers or VMs per AWS account per AWS Region. If you need to register more than 1,000 on-premises servers or VMs in a single account and Region, then use the advanced-instances tier.

### Setting up SSM in multi account configuration:

AWS Systems Manager Automations can be run across multiple AWS Regions and AWS accounts or AWS Organizational Units (OUs) from an Automation management account. Running Automations in multiple Regions and accounts or OUs reduces the time required to administer your AWS resources while enhancing the security of your computing environment.
