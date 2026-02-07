# 1. Add the repo
helm repo add argoproj https://argoproj.github.io/argo-helm

# 2. Update the repo index (fetches the latest chart versions)
helm repo update

# 3. Now run your install
helm install argocd argoproj/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f argocd-values.yaml

# To upgrade later (e.g. new chart version or values change):
helm upgrade argocd argoproj/argo-cd \
  --namespace argocd \
  -f argocd-values.yaml
  
pwd=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}")
echo $pwd | base64 -d

#install argo rollout
# brew install argoproj/tap/kubectl-argo-rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

#To view argocd rollout dashboard
kubectl argo rollouts dashboard -n dev

#change image version and commit

#promote from rolloutdashbaord button OR

#kubectl argo rollouts promote dev-py-app -n dev
#kubectl argo rollouts get rollout dev-py-app -n dev