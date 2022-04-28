.PHONY: default \
				tf-apply \
				tf-plan \
				tf-create-workspace \
				gke-creds \
				flux-bootstrap \
				help

ENV?=$(shell if [ -e .terraform/environment ]; then cat .terraform/environment; else echo "europe-west1"; fi)
FLUX_BRANCH?=main

##@ Default
default: tf-plan ## run tf-plan, default ENV is europe-west1

##@ Helpers
install-all: tf-apply flux-bootstrap ## One-stop installation shop

##@ Terraform setup
.terraform/terraform.tfstate: # Download plugins, providers and check the backend
	terraform init

.terraform/environment: .terraform/terraform.tfstate # Select the workspace, '$ENV'
	terraform workspace select $(ENV)

vars/%.tfvars:
	@echo "region = \"$(ENV)\"" >> $@
	@echo "make sure you update locals.tf with your new workspace"

tf-create-workspace: vars/$(ENV).tfvars .terraform/terraform.tfstate ## Create a new workspace, '$ENV'
	terraform workspace new $(ENV)

# If the state or environment files are younger than %.env it means we've moved workspace
# Yes it's the horrible "touch a thing" trick but it works and is the best I can think of
.terraform/%.env: .terraform/terraform.tfstate .terraform/environment
	terraform workspace select $*
	touch $@

##@ Terraform
# Some wrapper targets for terraform.
tf-plan: .terraform/$(ENV).env $(TERRAFORM_FILES) ## Run a plan
	terraform plan -var-file=vars/$(ENV).tfvars

tf-apply: .terraform/$(ENV).env $(TERRAFORM_FILES) ## Terraform apply (you'll be prompted to confirm changes)
	terraform apply -var-file=vars/$(ENV).tfvars

##@ Kubernetes
gke-creds: ## Set kubectl credentials
	gcloud container clusters get-credentials $(ENV)-gke

##@ Flux
flux-bootstrap: gke-creds ## Bootstrap flux in the cluster
	flux bootstrap github --owner=weaveworks \
												--components-extra=image-reflector-controller,image-automation-controller \
											  --repository=weave-gitops-clusters \
											  --path=k8s/clusters/$(ENV)-gke \
											  --branch=$(FLUX_BRANCH) \
											  --read-write-key \
											  --reconcile

sa-keys/enterprise-capi-$(ENV).json: tf-apply

init-capi: flux-bootstrap sa-keys/enterprise-capi-$(ENV).json
	@GCP_B64ENCODED_CREDENTIALS=$(shell cat sa-keys/enterprise-capi-$(ENV).json | tr -d '\n' ) \
	clusterctl init --infrastructure gcp

##@ Utilities
clean: ## Clean up
# The .terraform directory is entirely disposable
	rm -rf .terraform

# Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
help:  ## Display this help.
ifeq ($(OS),Windows_NT)
				@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
				@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif
