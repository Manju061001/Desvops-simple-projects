# Ansible Project: Deploying Tomcat with Java and a Sample Application

This Ansible playbook automates the deployment of Apache Tomcat along with Java and a sample WAR file onto a remote server.

## Prerequisites

1. Ansible installed on the local machine.
2. SSH access to the target server with sudo privileges.
3. Internet connectivity on the target server for downloading packages.

## Instructions

1. Clone this repository to your local machine:
git clone <repository_url>

2. Navigate to the project directory:
cd <project_directory>

3. Edit the `hosts` file to specify the target server's IP address or hostname.

4. Modify the `vars` section in the `tomcat_setup.yml` file if necessary. By default, it sets the Tomcat port to 7700.

5. Ensure that the `sample.war` file is present in the `/home/ec2-user` directory or modify the `src` path in the `deploy to tomcat` task in `tomcat_setup.yml` if it's located elsewhere.

6. Run the Ansible playbook:
ansible-playbook -i hosts tomcat_setup.yml

7. The playbook will execute the following tasks:
   - Update the yum repository.
   - Install Java.
   - Download and install Tomcat.
   - Update Tomcat configuration (server.xml) to use the specified port.
   - Stop Tomcat.
   - Start Tomcat.
   - Deploy the sample application to Tomcat.

8. Once the playbook execution is complete, you can access the deployed application using a web browser at `http://<server_ip>:7700/sample`.
