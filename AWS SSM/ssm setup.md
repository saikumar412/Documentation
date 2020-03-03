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

 ![alt text](https://github.com/saikumar412/Documentation/blob/master/AWS%20SSM/automation-multi-region-and-multi-account.png)
 
#### Centralized Account(Prod Account):
IAM role on controlling account(Prod account) : 
1. Create a role named  AWS-SystemsManager-AutomationAdministrationRole. This role gives the user permission to run Automation workflows in multiple AWS accounts and OUs.
2. Download and unzip the [AWS-SystemManager-AutomationAdministrationRole.zip folder](https://docs.aws.amazon.com/systems-manager/latest/userguide/samples/AWS-SystemManager-AutomationAdministrationRole.zip). This folder includes AWS-SystemManager-AutomationAdministrationRole.json AWS CloudFormation template file.
3. Open the AWS CloudFormation console at [https://console.aws.amazon.com/cloudformation.](https://console.aws.amazon.com/cloudformation)
4. Choose Create Stack.
5. In the Choose a template section, choose Upload a template to Amazon S3.
6. Choose Browse, and then choose the AWS-SystemManager-AutomationAdministrationRole.json AWS CloudFormation template file.
7. Choose Next.
8. On the Specify Details page, in the Stack Name field, enter a name.
9. Choose Next.
10. On the Options page, enter values for any options you want to use. Choose Next.
11. On the Review page, scroll down and choose the I acknowledge that AWS CloudFormation might create IAM resources option.
12. Choose Create.

#### Target accounts:

IAM role to be used by ec2 instances(target instances):

1. Create the role named AWS-SystemsManager-AutomationExecutionRole. This role gives the user permission to run Automation workflows.
2. Download and unzip the [AWS-SystemsManager-AutomationExecutionRole.zip folder.](https://docs.aws.amazon.com/systems-manager/latest/userguide/samples/AWS-SystemsManager-AutomationExecutionRole.zip) This folder includes the AWS-SystemsManager-AutomationExecutionRole.json AWS CloudFormation template file.
3. Open the AWS CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation)
4. Choose Create Stack.
5. In the Choose a template section, choose Upload a template to Amazon S3.
6. Choose Browse, and then choose the AWS-SystemsManager-AutomationExecutionRole.json AWS CloudFormation template file.
7. Choose Next.
8. On the Specify Details page, in the Stack Name field, enter a name.
9. In the Parameters section, in the MasterAccountID(Shared services Account) field, enter the ID for the account that you want to use to run multi-Region and multi-account Automations.
10. Choose Next.
11. On the Options page, enter values for any options you want to use. Choose Next.
12. On the Review page, scroll down and choose the I acknowledge that AWS CloudFormation might create IAM resources option.
13. Choose Create.

### Run an automation workflow in multiple regions & accounts:

1. Open the AWS Systems Manager console at [https://console.aws.amazon.com/systems-manager/](https://console.aws.amazon.com/systems-manager/)

2. In the navigation pane, choose Automation, and then choose Execute automation.

3. In the Automation document list, choose a document. Choose one or more options in the Document categories pane to filter SSM documents according to their purpose. To view a document that you own, choose the Owned by me tab. To view a document that is shared with your account, choose the Shared with me tab. To view all documents, choose the All documents tab.                
**Note:** You can view information about a document by choosing the document name.          
4. In the Document details section, verify that Document version is set to the version that you want to run. The system includes the following version options:            
   1. Default version at runtime: Choose this option if the Automation document is updated periodically and a new default version is assigned.
   2. Latest version at runtime: Choose this option if the Automation document is updated periodically, and you want to run the version that was most recently updated.
   3. 1 (Default): Choose this option to run the first version of the document, which is the default.
5. Choose Next.
6. On the Execute automation document page, choose Multi-account and Region.
7. In the Target accounts and Regions section, use the Accounts and organizational (OUs) field to specify the different AWS accounts or AWS Organizational Units (OUs) where you want to run the Automation. Separate multiple accounts or OUs with a comma.
8. Use the AWS Regions list to choose one or more Regions where you want to run the Automation.
9. Use the Multi-Region and account rate control options to restrict the Automation execution to a limited number of accounts running in a limited number of Regions. These options don't restrict the number of AWS resources that can run the Automations.      
  ...a. In the Location (account-Region pair) concurrency section, choose an option to restrict the number of Automation workflows that can run in multiple accounts and Regions at the same time. For example, if you choose to run an Automation in five (5) AWS accounts, which are located in four (4) AWS Regions, then Systems Manager runs Automations in a total of 20 account-Region pairs. You can use this option to specify an absolute number, such as 2, so that the Automation only runs in two account-Region pairs at the same time. Or you can specify a percentage of the account-Region pairs that can run at the same time. For example, with 20 account-Region pairs, if you specify 20%, then the Automation simultaneously runs in a maximum of five (5) account-Region pairs.          
         ..i. Choose targets to enter an absolute number of account-Region pairs that can run the Automation workflow simultaneously.       
         ..ii. Choose percent to enter a percentage of the total number of account-Region pairs that can run the Automation workflow simultaneously.                   
  ..b. In the Error threshold section, choose an option:               
     ..i. Choose errors to enter an absolute number of errors allowed before Automation stops sending the workflow to other resources.         
     ..ii. Choose percent to enter a percentage of errors allowed before Automation stops sending the workflow to other resources.      
     
10. In the Targets section, choose how you want to target the AWS Resources where you want to run the Automation. These options are required.  
   a. Use the Parameter list to choose a parameter. The items in the Parameter list are determined by the parameters in the Automation document that you selected at the start of this procedure. By choosing a parameter you define the type of resource on which the Automation workflow runs.   
   b. Use the Targets list to choose how you want to target resources.  
     - If you chose to target resources by using parameter values, then enter the parameter value for the parameter you chose in the Input parameters section.   
     - If you chose to target resources by using AWS Resource Groups, then choose the name of the group from the Resource Group list.
     - If you chose to target resources by using tags, then enter the tag key and (optionally) the tag value in the fields provided. Choose Add.
     - If you want to run an Automation playbook on all instances in the current AWS account and Region, then choose All instances.

11. In the Input parameters section, specify the required inputs. Optionally, you can choose an IAM service role from the AutomationAssumeRole list.

**Note:** You may not need to choose some of the options in the Input parameters section. This is because you targeted resources in multiple Regions and accounts by using tags or a resource group. For example, if you chose the AWS-RestartEC2Instance document, then you don't need to specify or choose instance IDs in the Input parameters section. The Automation execution locates the instances to restart by using the tags you specified.

12. Use the options in the Rate control section to restrict the number of AWS resources that can run the Automation within each account-Region pair.

In the Concurrency section, choose an option:

  - Choose targets to enter an absolute number of targets that can run the Automation workflow simultaneously.

  - Choose percentage to enter a percentage of the target set that can run the Automation workflow simultaneously.

13. In the Error threshold section, choose an option:

  - Choose errors to enter an absolute number of errors allowed before Automation stops sending the workflow to other resources.

  - Choose percentage to enter a percentage of errors allowed before Automation stops sending the workflow to other resources.

14. Choose Execute.
