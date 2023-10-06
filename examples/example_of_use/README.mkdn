# Example title

Brief description of an example.

## Required tools

### AZ CLI

Before you start, you need to install Azure CLI according to the official [documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

Use the `az login` command to login to your Azure subscription.

### asdf and direnv

Additinaly `asdf` and `direnv` must be installed and configured according to their official documentation.

- [asdf](https://asdf-vm.com/) -  manages multiple runtime versions;
- [direnv](https://direnv.net/) - augments existing shells with a new feature that can load and unload environment variables.

### Terraform

The suggested Terraform version is defined in the [.tool-versions](.tool-versions) file.
To install it, simply execute

```bash
asdf install terraform
```

## Terraforming infrastructure

To start working with the module, you need to initialize terraform.

```shell
terraform init
```

Execute plan command.

```shell
terraform plan
```

and verify what will be created.

The last step is to create the repo

```shell
terrafrorm apply
```

**IMPORTANT**: Please double-check the command output. The vital section can be seen in the example `Plan: 6 to add, 0 to change, 0 to destroy`. Ensure that you understand the changes you are making.

Next, you will be asked

```shell
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Type `yes` to approve and let the magic happen.
