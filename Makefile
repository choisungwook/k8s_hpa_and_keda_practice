install:
	@echo "[info] install kind cluster"
	@kind create cluster --config kind-config.yaml

uninstall:
	@echo "[info] delete kind cluster"
	@kind delete cluster --name hpa-practice
