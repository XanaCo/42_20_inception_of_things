## IoT

### Documentation
#### GLOBAL : Kubectl commands cheat sheet
- [Kubectl](https://spacelift.io/blog/kubernetes-cheat-sheet)
- [Deployments vs Services](https://zeet.co/blog/kubernetes-service-vs-deployment)

#### P1 : K3s and Vagrant
- [K3s](https://docs.k3s.io/)
- [Vagrant - Doc](https://developer.hashicorp.com/vagrant/tutorials/getting-started?product_intent=vagrant)
- [TechWhale](https://www.youtube.com/watch?v=5-PGV-r_684&pp=ygUYdmFncmFudCBjb21tZW50IHV0aWxpc2Vy)

#### P2 : K3s and three simple applications
- [K3s - First Deploy](https://k33g.gitlab.io/articles/2020-02-21-K3S-02-FIRST-DEPLOY.html)
- [K3s - Medium](https://medium.com/@samanazizi/how-to-deploy-a-simple-static-html-project-on-k3s-322667967ed4)
- [K3s - Blog](https://www.jeffgeerling.com/blog/2022/quick-hello-world-http-deployment-testing-k3s-and-traefik)

#### P3 : K3d and Argo CD
- [K3d](https://k3d.io/stable/)
- [Argo CD - Doc](https://argo-cd.readthedocs.io/en/stable/)
- [Argo CD - Blog](https://une-tasse-de.cafe/blog/argocd/)
- [Argo CD - Sokube](https://www.sokube.io/en/blog/gitops-on-a-laptop-with-k3d-and-argocd-en)


sudo kubectl get nodes -o wide
sudo cat /var/lib/rancher/k3s/server/token
sudo journalctl -u k3s
sudo journalctl -u k3s-agent
ip a show eth1