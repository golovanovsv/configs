# install
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.7/manifests/install.yaml

# adding repos to argo
argocd repo add https://gitlab.com/project.git --name infra --username <login> --password <token>

# users
edit cm argocd-cm:
```bash
data:
  accounts.<login>: "apiKey, login"
```

# roles
edit cm argocd-rbac-cm:
policy.csv: |
    p, role:org-admin, applications, *, */*, allow
    p, role:org-admin, clusters, get, *, allow
    p, role:org-admin, repositories, get, *, allow
    p, role:org-admin, repositories, create, *, allow
    p, role:org-admin, repositories, update, *, allow
    p, role:org-admin, repositories, delete, *, allow
    g, <login>, role:org-admin
  policy.default: role:''
