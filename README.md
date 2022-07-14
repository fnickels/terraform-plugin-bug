# terraform-plugin-bug

This repository is used to reproduce a bug detected in the terraform cli v1.2.5 and earlier

Checked versions: v.1.0.5, v1.2.5

To reproduce, run:

```bash
make
```

The Output will look like:

```
$ make
#
# Build Local Mirror
#
rm -rf ./mirror1 ./app1/terraform.d
terraform -chdir=./providermirror1 \
        providers mirror -platform=linux_amd64 ../mirror1/terraform/plugins
- Mirroring hashicorp/aws...
  - Selected v4.21.0 to meet constraints 4.21.0
  - Downloading package for linux_amd64...
  - Package authenticated: signed by HashiCorp
#
# copy mirror files to local defaulr pluging directories
#
cp -r ./mirror1/terraform ./app1/terraform.d
#
# Test without -chdir  and local plugin directory
#
rm -rf ./app1/.terraform  ./app1/terraform.tfstate ./app1/.terraform.tfstate.lock.info  ./app1/.terraform.lock.hcl
cd ./app1 && terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 1.0.0"...
- Finding hashicorp/external versions matching ">= 1.0.0"...
- Installing hashicorp/aws v4.21.0...
- Installed hashicorp/aws v4.21.0 (unauthenticated)
- Installing hashicorp/external v2.2.2...
- Installed hashicorp/external v2.2.2 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
#
# Test with -chdir and local plugin directory
#
rm -rf ./app1/.terraform ./app1/terraform.tfstate ./app1/.terraform.tfstate.lock.info  ./app1/.terraform.lock.hcl
terraform -chdir=./app1 init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/external versions matching ">= 1.0.0"...
- Finding hashicorp/aws versions matching ">= 1.0.0"...
- Installing hashicorp/external v2.2.2...
- Installed hashicorp/external v2.2.2 (signed by HashiCorp)
- Installing hashicorp/aws v4.22.0...
- Installed hashicorp/aws v4.22.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Note: with the `-chdir` working directory specification with the second `terraform init` results in v4.22.0 of `hashicorp/aws` being pulled in instead of v4.21.0 which was defined in the mirror and pulled in in the first `terraform init` results.

Suspect the search for the `terraform.d/plugins` directory in the current working directory is not checking to see if the current working directory has been reassigned with `-chdir`.
