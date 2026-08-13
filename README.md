# Cloud Native DevOps Deployment

A production-style **Cloud Native DevOps CI/CD project** demonstrating automated application testing, Docker image creation, Docker Hub publishing, Helm-based Kubernetes deployment, AWS infrastructure configuration with Terraform, and lightweight Kubernetes monitoring.

The project uses a Flask application deployed to **K3s Kubernetes on AWS EC2** with two replicas and an automated Jenkins CI/CD pipeline.

---

## 🚀 Project Overview

This project demonstrates how a developer's code change can automatically move through the following DevOps workflow:

```text
Developer
    │
    ▼
  GitHub
    │
    ▼
  Jenkins
    │
    ├── Run Tests
    │
    ├── Build Docker Image
    │
    ├── Push Image → Docker Hub
    │
    └── Deploy → AWS Kubernetes
                    │
                    ▼
                  Helm
                    │
                    ▼
                  K3s
                    │
             ┌──────┴──────┐
             ▼             ▼
          Pod 1          Pod 2
             │             │
             └──────┬──────┘
                    ▼
              Flask Application
```

---

## 🎯 Project Objectives

* Build and containerize a Python Flask application
* Implement automated testing with Pytest
* Create a Jenkins CI/CD pipeline
* Build Docker images automatically
* Push versioned images to Docker Hub
* Deploy applications to Kubernetes using Helm
* Run Kubernetes on AWS EC2 using K3s
* Maintain two application replicas for availability
* Configure AWS infrastructure using Terraform
* Implement Kubernetes health checking
* Use Kubernetes Metrics Server for lightweight resource monitoring
* Keep the deployment suitable for an AWS Free Tier-sized environment

---

## 🛠️ Technology Stack

| Category               | Technologies              |
| ---------------------- | ------------------------- |
| Application            | Python, Flask             |
| Testing                | Pytest                    |
| Version Control        | Git, GitHub               |
| CI/CD                  | Jenkins                   |
| Containerization       | Docker                    |
| Container Registry     | Docker Hub                |
| Orchestration          | Kubernetes, K3s           |
| Packaging              | Helm                      |
| Infrastructure as Code | Terraform                 |
| Cloud                  | AWS EC2                   |
| Monitoring             | Kubernetes Metrics Server |
| Web Routing            | Traefik                   |
| Operating System       | Ubuntu Linux              |
| Automation             | Bash, SSH                 |

---

## 📁 Project Structure

```text
cloud-native-devops-deployment/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── templates/
│   │   └── index.html
│   └── tests/
│       └── test_app.py
│
├── helm/
│   └── cloud-native-devops-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           └── ...
│
├── terraform/
│   ├── provider.tf
│   ├── ec2.tf
│   ├── ecr.tf
│   └── outputs.tf
│
├── Dockerfile
├── Jenkinsfile
├── requirements.txt
├── .gitignore
└── README.md
```

---

# 🔄 CI/CD Pipeline

The Jenkins pipeline automatically performs the following stages:

### 1. Test

Jenkins executes the application's automated tests:

```bash
pytest app/tests/test_app.py
```

The pipeline stops if the tests fail.

### 2. Docker Build

A versioned Docker image is created using the Jenkins build number:

```text
phanikumard/cloud-native-devops-app:${BUILD_NUMBER}
```

For example:

```text
phanikumard/cloud-native-devops-app:9
```

### 3. Docker Push

The image is authenticated and pushed to Docker Hub.

This provides a versioned container artifact that can be deployed to Kubernetes.

### 4. Kubernetes Deployment

Jenkins connects securely to the AWS EC2 server through SSH and executes the Helm deployment:

```bash
helm upgrade --install cloud-native-devops-app \
helm/cloud-native-devops-app \
--set image.tag=${BUILD_NUMBER}
```

### 5. Deployment Verification

Jenkins waits for Kubernetes to complete the rollout:

```bash
kubectl rollout status deployment/cloud-native-devops-app
```

A failed rollout causes the CI/CD pipeline to fail.

---

# 🐳 Docker

The Flask application is packaged as a Docker container.

The image is versioned using Jenkins' `BUILD_NUMBER`.

Example:

```text
Build 9
    ↓
Docker Image
    ↓
phanikumard/cloud-native-devops-app:9
```

This provides traceability between a Jenkins build and the deployed application version.

---

# ☸️ Kubernetes

The application runs on **K3s**, a lightweight Kubernetes distribution running on AWS EC2.

The deployment uses:

* Kubernetes Deployment
* 2 application replicas
* Kubernetes Service
* NodePort
* ConfigMap
* Secret
* Health endpoint
* Helm

Current deployment architecture:

```text
                    AWS EC2
                       │
                      K3s
                       │
              ┌────────┴────────┐
              │                 │
           Flask Pod         Flask Pod
           Replica 1         Replica 2
              │                 │
              └────────┬────────┘
                       │
                  Kubernetes
                    Service
                       │
                    NodePort
                       │
                    Port 30080
```

---

# ⛵ Helm

Helm is used to package and deploy the Kubernetes application.

The Helm chart contains Kubernetes configuration templates and allows the Docker image version to be changed without manually editing Kubernetes manifests.

Example:

```bash
helm upgrade --install cloud-native-devops-app \
helm/cloud-native-devops-app \
--set image.tag=9
```

This makes application releases repeatable and version-controlled.

---

# ☁️ AWS Infrastructure

The project uses an AWS EC2 instance as the Kubernetes host.

Terraform configuration is included for AWS infrastructure components such as:

* EC2
* ECR
* Provider configuration
* Terraform outputs

Terraform configuration is maintained separately from application deployment.

```text
Terraform
    │
    ├── AWS Provider
    ├── EC2
    └── ECR
```

Terraform state and downloaded providers are excluded from version control where appropriate.

---

# 📊 Monitoring

The AWS K3s cluster includes **Kubernetes Metrics Server** for lightweight resource monitoring.

Example resources can be inspected with:

```bash
kubectl top nodes
```

and:

```bash
kubectl top pods
```

The project was intentionally kept lightweight because the AWS Free Tier-sized EC2 instance has limited memory.

A full Prometheus + Grafana stack was evaluated but not deployed on the final AWS environment because the available resources were insufficient for a stable production-style deployment.

For a larger production environment, Prometheus and Grafana can be added as the next observability layer.

---

# ❤️ Health Checks

![image alt]( https://github.com/phani5790/cloud-native-devops-deployment/blob/59bcc2fc9ce356d7c1f892dd29ec8605cbe4d670/Output/Screenshot%20(17).png)

 ![image alt](https://github.com/phani5790/cloud-native-devops-deployment/blob/59bcc2fc9ce356d7c1f892dd29ec8605cbe4d670/Output/Screenshot%20(15).png)                  

 ![image alt](https://github.com/phani5790/cloud-native-devops-deployment/blob/59bcc2fc9ce356d7c1f892dd29ec8605cbe4d670/Output/Screenshot%20(13).png)  
  

The Flask application provides a dedicated health endpoint:

```text
/health
```

Example response:

```json
{
  "status": "healthy"
}
```

This endpoint can be used by Kubernetes probes, load balancers, monitoring systems, or external health checks.

---

# 🔐 Configuration

Application configuration is separated from the container image using Kubernetes configuration resources.

The deployment uses:

```text
ConfigMap
Secret
```

This demonstrates separation between:

* Application code
* Container image
* Environment configuration
* Sensitive configuration

---

# 🔁 Deployment Flow

When a developer pushes a change:

```text
Developer changes code
        ↓
Git push
        ↓
GitHub
        ↓
Jenkins
        ↓
Pytest
        ↓
Docker Build
        ↓
Docker Hub
        ↓
SSH to AWS EC2
        ↓
Helm Upgrade
        ↓
Kubernetes Deployment
        ↓
2 New/Updated Pods
        ↓
Rollout Verification
        ↓
Application Available
```

This provides an automated path from source-code change to Kubernetes deployment.

---

# 🧪 Application Verification

The final AWS deployment was verified with:

```bash
kubectl get pods -l app=cloud-native-devops-app
```

Result:

```text
cloud-native-devops-app-...   1/1   Running
cloud-native-devops-app-...   1/1   Running
```

Deployment verification:

```bash
kubectl rollout status deployment/cloud-native-devops-app
```

Health verification:

```bash
curl http://127.0.0.1:30080/health
```

Response:

```json
{"status":"healthy"}
```

The deployed image was also verified:

```text
phanikumard/cloud-native-devops-app:9
```

---

# 🔒 Security Considerations

The project uses:

* SSH key authentication
* Jenkins credentials for Docker Hub authentication
* Kubernetes Secrets for sensitive configuration
* GitHub SSH authentication
* No hard-coded Docker Hub passwords in the Jenkinsfile

Private keys and credentials are intentionally excluded from Git.

---

# 💰 AWS Free Tier Considerations

The project was designed to operate within a small AWS environment.

To reduce resource usage:

* A lightweight K3s Kubernetes distribution is used
* A single EC2 instance hosts the Kubernetes cluster
* Two application replicas are used
* Kubernetes Metrics Server provides lightweight monitoring
* Heavy monitoring components were avoided on the final small instance
* Unnecessary AWS resources should be stopped or terminated when not required

This keeps the project practical for learning and portfolio purposes.

---

# 📈 Future Improvements

Possible production-level improvements include:

* Prometheus
* Grafana
* Argo CD
* Kubernetes Ingress
* TLS/HTTPS
* Horizontal Pod Autoscaling
* AWS Load Balancer
* Terraform remote state
* Terraform modules
* EKS instead of K3s
* GitHub webhook-triggered Jenkins builds
* Automated rollback
* Centralized logging
* Alerting

---

# 💼 DevOps Skills Demonstrated

This project demonstrates practical experience with:

```text
Linux
Git & GitHub
Python & Flask
Pytest
Docker
Docker Hub
Jenkins
CI/CD
AWS EC2
Terraform
Kubernetes
K3s
Helm
SSH
Bash
ConfigMaps
Secrets
Services
Deployments
Replica Management
Health Checks
Metrics Server
```

---

# 🏆 Key Achievement

Built an automated **GitHub → Jenkins → Pytest → Docker → Docker Hub → Helm → Kubernetes on AWS** deployment pipeline with a Flask application running as multiple Kubernetes replicas.

The final deployment was successfully verified through Kubernetes rollout status, running replicas, Docker image version, and application health checks.

---

## 👨‍💻 Author

**Phani Kumar Maddala**

DevOps Engineer | Cloud & Automation Enthusiast

* GitHub: https://github.com/phani5790
* LinkedIn: https://www.linkedin.com/in/phani-maddala
* Email: [phanikumarmaddala14@gmail.com](mailto:phanikumarmaddala14@gmail.com)
