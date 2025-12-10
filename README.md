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
---
![3ec2-servers](https://github.com/user-attachments/assets/50971fbf-b283-45a1-bf56-47eebeeb0866)
---
    

## Deployment Flow:

### 1. Select environment (UAT or PROD) in Jenkins.
---
![env-selection](https://github.com/user-attachments/assets/76427092-fa3f-46e9-a04b-6cd8cbf577fe)
---
### 2. Jenkins builds and pushes Docker image from the Dockerfile to DockerHub.
---
![dockerhub-registry](https://github.com/user-attachments/assets/dcd6385e-64b6-452f-ad58-a6345ca45617)
---
### 3. Jenkins executes the CI/CD pipeline and deploys the Docker container.

### The pipeline stages include:
         
- Checkout code from the repository.
         
- Set environment variables.
         
- Build Docker image from the Dockerfile.
         
- Login to Docker Hub and push the image.
         
- Deploy the Docker container on the target EC2 server (either UAT or Production).
         
- Perform health check to ensure the application is running correctly.

<img width="1892" height="907" alt="jenkins-cicd" src="https://github.com/user-attachments/assets/c2ff191f-7f64-4250-9d0d-101c7ea442e4" />


### 4. Application is accessible at:

## UAT Environment:
### http://3.110.45.169:5000/api/hello
---
![Health-check-2](https://github.com/user-attachments/assets/818b954a-9e9e-4850-ba22-8e2cb0e306ae)

## PROD Environment:
### http://13.200.250.92:5000/api/hello
---
![prod-server](https://github.com/user-attachments/assets/bd082b90-8e3d-49ce-a2f5-c4971b60bb07)
---

### 5. Health Check
---
![UAT-server-deploy](https://github.com/user-attachments/assets/dd03d79a-c567-4b47-aeef-4741c65ec903)
---
