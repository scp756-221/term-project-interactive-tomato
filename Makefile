KUBERNETES_NAMESPACE_APP=c756ns
KUBERNETES_NAMESPACE_ISTIO=istio-system
KUBERNETES_NAMESPACE_KIALI=kiali-operator
HELM_REPOSITORY_PROMETHEUS=prometheus-community
HELM_REPOSITORY_KIALI=kiali
HELM_RELEASE=c756
HELM_RELEASE_KIALI=kiali-operator

# Install Istio to the current Kubernetes cluster
# See https://istio.io/latest/docs/setup/getting-started/
install-istio:
	istioctl install --set profile=demo -y | tee -a log/install-istio.log

# Install the Prometheus stack with Helm, which also includes Grafana
# See https://helm.sh/docs/helm/helm_install/
install-prometheus: init-helm
	helm install --namespace $(KUBERNETES_NAMESPACE_ISTIO) -f helm/kube-prom-stack-values.yaml $(HELM_RELEASE) $(HELM_REPOSITORY_PROMETHEUS)/kube-prometheus-stack | tee -a log/install-prometheus.log
	kubectl apply -n $(KUBERNETES_NAMESPACE_ISTIO) -f k8s/monitoring-lb-services.yaml | tee -a log/install-prometheus.log
	kubectl apply -n $(KUBERNETES_NAMESPACE_ISTIO) -f k8s/grafana-flask-configmap.yaml | tee -a log/install-prometheus.log

# Install Kiali Server and Operator with Helm
# See https://kiali.io/docs/installation/installation-guide/install-with-helm/
install-kiali:
	helm install --set cr.create=true --set cr.namespace=$(KUBERNETES_NAMESPACE_ISTIO) --namespace $(KUBERNETES_NAMESPACE_KIALI) --create-namespace $(HELM_RELEASE_KIALI) $(HELM_REPOSITORY_KIALI)/kiali-operator | tee -a log/install-kiali.log
	kubectl apply -n $(KUBERNETES_NAMESPACE_ISTIO) -f k8s/kiali-cr.yaml | tee -a log/obs-kiali.log
	# Kiali operator can take a while to start Kiali
	tools/waiteq.sh 'app=kiali' '{.items[*]}'              ''        'Kiali' 'Created'
	tools/waitne.sh 'app=kiali' '{.items[0].status.phase}' 'Running' 'Kiali' 'Running'

# Add the repo of Prometheus and Kiali to Helm, and then update repos
# See https://github.com/prometheus-community/helm-charts, https://kiali.io/docs/installation/installation-guide/install-with-helm/
init-helm:
	helm repo add $(HELM_REPOSITORY_PROMETHEUS) https://prometheus-community.github.io/helm-charts
	helm repo add $(HELM_REPOSITORY_KIALI) https://kiali.org/helm-charts
	helm repo update

deploy: init-k8s-ns deploy-gateway deploy-user deploy-music deploy-artist deploy-db deploy-monitoring

init-k8s-ns:
	# Appended "|| true" so that make continues even when command fails
	# because namespace already exists
	kubectl create ns $(KUBERNETES_NAMESPACE_APP) || true
	kubectl label namespace $(KUBERNETES_NAMESPACE_APP) --overwrite=true istio-injection=enabled

deploy-gateway:
	kubectl -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/gateway.yaml log/gw.log

# Update S1 and associated monitoring, rebuilding if necessary
deploy-user:
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/s1.yaml | tee log/s1.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/s1-sm.yaml | tee -a log/s1.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/s1-vs.yaml | tee -a log/s1.log

# Update S2 and associated monitoring, rebuilding if necessary
deploy-music: rollout-s2
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/s2-svc.yaml | tee log/s2.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/s2-sm.yaml | tee -a log/s2.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/s2-vs.yaml | tee -a log/s2.log

# TODO
deploy-artist:

# Update DB and associated monitoring, rebuilding if necessary
deploy-db:
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/awscred.yaml | tee log/db.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/dynamodb-service-entry.yaml | tee -a log/db.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/db.yaml | tee -a log/db.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/db-sm.yaml | tee -a log/db.log
	$(KC) -n $(KUBERNETES_NAMESPACE_APP) apply -f k8s/db-vs.yaml | tee -a log/db.log

# TODO
deploy-monitoring: