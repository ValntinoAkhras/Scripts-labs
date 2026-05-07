#  Module 1: Infrastructure Installation Guide
---
This module explains how to build a 3-node Active Directory lab using minimal resources (**25GB Storage / 6GB RAM**) by utilizing Windows Server Core and QEMU/KVM Linked Clones.

##  Prerequisites & Resources
* **Hypervisor:** `virt-manager` (QEMU/KVM) installed on Linux.
* **Base OS ISO:** [Windows Server 2022 Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022) (Download the ISO).
* **Documentation:** [Microsoft: What is Server Core?](https://learn.microsoft.com/en-us/windows-server/administration/server-core/what-is-server-core)

---

##  Phase 1: Creating the "Mother Image" (Template)
The Mother Image is the foundation. We install it once and use it as a "Read-Only" base for all other servers.

1. **New VM:** Open `virt-manager` and create a new Virtual Machine named `WS2022-Mother`.
2. **Installation Media:** Select the downloaded Windows Server ISO.
3. **OS Selection (CRITICAL):** During setup, you must select:
   > **Windows Server 2022 Standard (Server Core)**
   *Do NOT select "Desktop Experience" as it requires 4x more RAM and storage.*
4. **Resources:** Assign 2 vCPUs and 2GB RAM for the installation process.
5. **Initial Preparation:**
   Once the black console appears, set the Administrator password and run:
   ```powershell
   # Set Windows Updates to Manual to prevent background resource usage
   sconfig  # Choose option 5, then 'm' for Manual
   
   # Enable Remote Management (needed for later automation)
   Enable-PSRemoting -Force
   
   # Shut down the Template
   Stop-Computer
---
  ## Phase 2: QEMU Linked Clones (The Storage Saver)

Instead of 3 separate 20GB installations (60GB total), we create 3 "Delta" disks that point back to the Mother Image.

    Locate your Mother Image disk (usually /var/lib/libvirt/images/WS2022-Mother.qcow2).

    Open your Linux terminal and run the following commands:
    Bash

    ***sudo qemu-img create -f qcow2 -b WS2022-Mother.qcow2 DC01.qcow2***
    ***sudo qemu-img create -f qcow2 -b WS2022-Mother.qcow2 PRINT01.qcow2***
    ***sudo qemu-img create -f qcow2 -b WS2022-Mother.qcow2 WEB01.qcow2***

    Note: These new disks start at only a few Kilobytes in size.
---
## Phase 3: Hardware Provisioning

In virt-manager, create 3 new VMs using the "Import existing disk image" option. 
Select the .qcow2 files created in Phase 2.

**DC01 2.0RAM**
**PRINT01 1.5**
**WEB01 1.5**
TOTAL IS 5.0GPPP



   
