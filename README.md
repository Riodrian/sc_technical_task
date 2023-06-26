# Technical Task

A python microservice returning 100 latest jokes from bash.org.pl in JSON Format

## Description

Flask microservice (the app) is being run inside a docker container deployed to an Amazon EKS Cluster pod. Necessary objects and resources are created using GitHub Actions while utilizing Terraform and Kustomize + Kubectl.

## Getting Started

### Automated Deployment via GitHub Actions

#### Dependencies

- AWS Credentials for IAM User (**AWS_ACCESS_KEY_ID**, **AWS_SECRET_ACCESS_KEY**) provided inside GitHub Actions Secrets for user with sufficient access to deploy S3 Bucket for TFState, DynamoDB Table, Networking, ECR and EKS resources and to read Secrets Manager entries.

- Thumbprint for an OpenID Connect Identity Provider that is able to retrieve KubeConfig from EKS with variables **"username"**, **"password"**, **"email"** stored inside of a Secrets Manager secret **GithubContainerRegistryAccess**.


#### Usage

Locally deploy terraform code in **/bootstrap** directory to create S3 Bucket and DynamoDB Table for TFState storage with state locking.

Run github action **Deploy prepared application to EKS cluster** with desired branch selected. Action will run 2 steps:

1. Terraform plan

2. Apply changes and deploy to EKS cluster


Resulting in verification of planned operations by terraform, and the applying planned resources. It will then Build Docker Container for the App, push it to ECS and apply Cluster configuration from Kustomize manifests in the newly created EKS cluster.

### Executing test run of the script in local environment

#### Dependencies

- Python 3.9

Install required modules via PIP

```bash
pip install -r app/src/requirements.txt
```

Run the local application server

```bash
python app/src/app.py
```

By default the entrypoint for the app is

```uri
http://127.0.0.1:5000
```

### Authors

Contributor names and contact info

##### [Riodrian](https://github.com/Riodrian)
