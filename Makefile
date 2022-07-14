
.PHONY: test

test:
	#
	# Build Local Mirror
	#
	-rm -rf ./mirror1 ./app1/terraform.d
	terraform -chdir=./providermirror1 \
		providers mirror -platform=linux_amd64 ../mirror1/terraform/plugins
	#
	# copy mirror files to local default plugin directorty
	#
	cp -r ./mirror1/terraform ./app1/terraform.d
	#
	# Test without -chdir  and local plugin directory
	#
	-rm -rf ./app1/.terraform  ./app1/terraform.tfstate ./app1/.terraform.tfstate.lock.info  ./app1/.terraform.lock.hcl
	cd ./app1 && TF_LOG=trace terraform init
	#
	# Test with -chdir and local plugin directory
	#
	-rm -rf ./app1/.terraform ./app1/terraform.tfstate ./app1/.terraform.tfstate.lock.info  ./app1/.terraform.lock.hcl
	TF_LOG=trace terraform -chdir=./app1 init

dev:
	#
	# Build Local Mirror
	#
	-rm -rf ./mirror1 ./app1/terraform.d
	terraform-dev -chdir=./providermirror1 \
		providers mirror -platform=linux_amd64 ../mirror1/terraform/plugins
	#
	# copy mirror files to local default plugin directorty
	#
	cp -r ./mirror1/terraform ./app1/terraform.d
	#
	# Test without -chdir  and local plugin directory
	#
	-rm -rf ./app1/.terraform  ./app1/terraform.tfstate ./app1/.terraform.tfstate.lock.info  ./app1/.terraform.lock.hcl
	# cd ./app1 && TF_LOG=trace terraform-dev init
	cd ./app1 && terraform-dev init
	#
	# Test with -chdir and local plugin directory
	#
	-rm -rf ./app1/.terraform ./app1/terraform.tfstate ./app1/.terraform.tfstate.lock.info  ./app1/.terraform.lock.hcl
	# TF_LOG=trace terraform-dev -chdir=./app1 init
	terraform-dev -chdir=./app1 init

