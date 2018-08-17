# azure_arm_ps_scripts
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
  
