System manager pre-requisites:
AWS Instances(Linux/Windows):
User should have permissions to execute SSM actions, IAM Instance profile should be attached to the target EC2 instances.
SSM Agent should be installed on target EC2 instances.
Verify that you are allowing HTTPS(443) outbound traffic to SSM end points.
On-Prem servers(Linux/Windows):
User should have permissions to execute SSM actions. you can create a new service role or use the existing service role as part of SSM activation creation process.
Create SSM activation in SSM Console which generates activation id & Activation code.
Install SSM agent on on-premises servers.
register the SSM agent using the activation id & activation code in step-1. Now the on-premises server is considered as registered/managed instance in SSM.
