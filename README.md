# Jenkins Pipeline for Dockerized .NET Core Application Deployment


---

## Prerequisites
- You will need 3 EC2 instances for this CI/CD pipeline:
1. EC2 instance for Jenkins & Docker (CI/CD Server)
   - Runs Jenkins for building and deploying the app.
   - Docker installed to build and run containers.
   - Security Group:
       - Allow SSH (port 22)
       - Allow inbound port 8080 for Jenkins
    
    - Jenkins accessible at:
      http://13.201.55.209:8080/
      
2. EC2 instance for UAT (User Acceptance Testing)
   - Runs the .NET application in Docker container.

   - Security Group:
      - Allow SSH from Jenkins EC2 (for deployment).
      - Allow inbound port 5000 for testing.
    
3. EC2 for PROD (Production)

   - Runs the .NET application in Docker container.

   - Security Group:
      - Allow SSH from Jenkins EC2 (for deployment).
      - Allow inbound port 5000 for users.
    

## Deployment Flow:

1. Select environment (UAT or PROD) in Jenkins.

2. Jenkins builds Docker image from the Dockerfile.

3. Jenkins connects to target EC2 (UAT or PROD).

4. Stops and removes old container if running.

5. Runs new Docker container with port 5000 forwarded.

6. Application is accessible at:

http://<EC2_PUBLIC_IP>:5000
