# azure_arm_ps_scripts
## `arm_templates` directory details
- This repo contains the Azure ARM template samples.
- The templates can be used to spin up below resources
  - Instance of type `Standard_A0` (cheaper version)
  - Instance placed in VNET and assigned with NIC
  - Instance also has storage disc defined by user
  - Tags also added to instances
- All the samples has the code reference of effective use of ARM template looping
- ARM template `copy` method can be used to iterate number of count
- Count has been passed as input param
- Samples using the below loops
  - nicloop - for creating NICs
  - virtualMachineloop - for creating VMs
  - vmDiskResLoop - for storage Discs

## How the templates can be used
- Templates can be used to create 'n' number instances and discs given in corresponding parameter json file
- Below values needs to be added in parameter json file of coresponding template file,
  - The `offsetIndexValue` param can be used as first reference index value to start the iteration loop
  - `numberOfInstances` param can be used to set the total number of instance count
  - `numberOfDisk` param can be used to set the total number of disc count
  - `adminUsername` and `adminPassword` param values will be used to login the instances 
  
## Invoke templates from the path `ps_scripts` directory
- Run `Login-AzureRmAccount` to login into your Azure account
- Create resource group using `./create_rg.ps1 rg_name`
- Invoke resource creation defined in ARM template using `./create_azure_instances.ps1 rg_name template_json template_parameter_json`
