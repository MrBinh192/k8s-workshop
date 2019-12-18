deploy-aks:
	@cd terraform && terraform init && terraform apply -input=false -auto-approve && sleep 5 && terraform apply -input=false -auto-approve && sleep 5

deploy-kind:
	@cd kind && kind create cluster --config 1m-2w-cluster/cluster.yml --image kindest/node:v1.16.3  

teardown-aks:
	@cd terraform && terraform destroy -input=false -auto-approve

teardown-kind:
	@kind delete cluster