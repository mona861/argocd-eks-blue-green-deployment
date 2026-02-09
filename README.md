# ArgoCD Blue Green Rollout Deployment Guide

## About

This repository contains instructions and configuration for installing ArgoCD, a declarative GitOps continuous delivery tool for EKS.

## Table of Contents

- [📋Prerequisites](#prerequisites)
- [🎯Installation](#installation)
- [💻 Accessing ArgoCD UI](#accessing-argocd-ui)
- [➕Create An ArgoCD Application](#create-an-argocd-application)
- [🔵Check Active Revision](#-check-active-revision-blue-deployment)
- [🟢Create Preview Revision](#-how-to-create-a-preview-revision-green-deployment)
- [✅Promote Preview Revision](#-how-to-promote-the-preview-revision-make-green-deployment-active)

## 📋Prerequisites

Before installing ArgoCD, ensure you have:

- A running Kubernetes cluster (v1.21 or later)
- `kubectl` installed and configured to communicate with your cluster
- Sufficient permissions to create namespaces and deploy resources

## 🎯Installation
### 1. Install Argo Rollout cli
[Argo Rollout cli](https://argo-rollouts.readthedocs.io/en/stable/installation/)
### 2. Install ArgoCD and Argo Rollout With Helm Chart
The script will install argo cd helm chart on your EKS cluster
```bash

sh argocd-argocd-bluegreen-deployments-bootstrap.sh
```
Note the password shown as output after running the script
<br/>
Open the argo rollout dashboard link given at the end of the script

## 💻Accessing ArgoCD UI

- As specified in argocd-values.yaml that's passed while installing argocd through helm
  a loadBalancer is created for the ArgoCD dashboard.
- Open AWS dashboard and get
  the public DNS of the load balancer.
- Login using the username: admin and password in the step above
- Edit the password

![Application](https://github.com/mona861/argocd-eks-deployment/blob/main/doc/screenshots/argo-login.png)


## ➕Create An ArgoCD Application
The ArgoCD application will link your repo to ArgoCD gitops.
The application can be created directly through the dashboard or
using a yaml file. To create through the yaml run
```bash
kubectl apply -f  argocd-application.yaml
```

After creating the application it will be visible on the ArgoCD dashboard.
Click on the application and your setup will be visible

![revision1 infra](https://github.com/mona861/argocd-eks-blue-green-deployment/blob/main/doc/screenshots/argo-dashboard.png)

## 🔵 Check Active Revision (Blue Deployment)
Open Argo CD dashboard
You will see active deployment's replica set
![revision1](https://github.com/mona861/argocd-eks-blue-green-deployment/blob/main/docs/screenshots/blue-infra.png)

Open Argo Rollout dashboard.
You will see one revision which is the active revision <br/>
![revision1](https://github.com/mona861/argocd-eks-blue-green-deployment/blob/main/docs/screenshots/blue-deployment.png)

## 🟢 How To Create a Preview Revision (Green Deployment)
- Edit the image in the manifests in k8s-manifests/base/deployment.yaml 
- Commit and Push to Git
- Check the ArgoCD dashboard. Gitops will identify changes and sync them
- A new replica set appear which is attached to the preview service
![revision1 and revision2 infra](https://github.com/mona861/argocd-eks-blue-green-deployment/blob/main/docs/screenshots/preview-infra.png)

- Open the Argo Rollout dashboard. You will now see 2 revisions.
![revision1 and revision2](https://github.com/mona861/argocd-eks-blue-green-deployment/blob/main/docs/screenshots/green-deployment.png)

## ✅ How To Promote the Preview Revision (Make Green Deployment Active)
- Open the Argo Rollout dashboard.
- Click on the promote button
- The green/preview replica set will become active
- The old replica set will be deleted