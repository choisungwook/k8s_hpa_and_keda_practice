HELM_NAMESPACE = default

install: install-kind install-metrics-server install-prometheus-adapter

uninstall:
	@echo "[info] delete kind cluster"
	@kind delete cluster --name hpa-practice

install-kind:
	@echo "[info] install kind cluster"
	@kind create cluster --config kind-config.yaml

install-metrics-server:
	@echo "[info] install latest metrics sevrer"
	@helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
	@helm upgrade --install -n ${HELM_NAMESPACE} -f helm_values/metrics-server.yaml metrics-sevrer metrics-server/metrics-server

install-prometheus-adapter:
	@echo "[info] install latest prometheus-adapter"
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo update
	@helm upgrade --install -n ${HELM_NAMESPACE} prometheus-adapter prometheus-community/prometheus-adapter
