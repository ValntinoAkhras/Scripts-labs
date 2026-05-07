# Module 2: Lab-Configuration

<img width="1408" height="768" alt="Gemini_Generated_Image_qo0c6xqo0c6xqo0c" src="https://github.com/user-attachments/assets/54c1f6d0-0c34-4665-9a16-310f3376199b" />

This module transforms the raw servers (provisioned in Module 1) into a functional, misconfigured Active Directory domain (Damen.local). The configuration is automated using PowerShell scripts designed for the Server Core (SConfig) interface.
## Step 1: Base Network Configuration

Before running any domain scripts, each server must have its static IP and hostname configured.
On all Machines (from SConfig):

    Open the black console. If SConfig isn't running, type sconfig.

    Choose Option 2 (Computer Name): Rename according to the architecture (e.g., DC01, PRINT01).

    Choose Option 8 (Network Settings): Configure the static IP from the diagram.

        Note: For members (PRINT01, WEB01), set the Preferred DNS to DC01's IP (192.168.122.10).

    Restart the machine.
---
## Step 2: Promote DC01 (The Domain Controller)

We will use a script to automatically install Active Directory and create the forest.
File: scripts/Setup-DC01.ps1

Copy this script to DC01 and run as Administrator.
PowerShell

# DVAD-Damen V1: DC01 Promotion Script

Write-Host "[-] Installing Active Directory Domain Services..." -ForegroundColor Cyan
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Define Domain Parameters
$DomainName = "Damen.local"
$NetbiosName = "DAMEN"

# Promote to Domain Controller
Write-Host "[-] Promoting to Domain Controller (Restart is Automatic)..." -ForegroundColor Cyan
Import-Module ADDSDeployment
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

**DC01 will reboot automatically. After reboot, log in as DAMEN\Administrator.**
---
## Step 3: Join Members (PRINT01, WEB01)

Now we join the members to the new domain.
**File: scripts/Join-Domain.ps1**
---
Run this on PRINT01 and WEB01 as Administrator.
PowerShell

# DVAD-Damen V1: Domain Join Script
$Domain = "Damen.local"
$Password = ConvertTo-SecureString "P@ssword123!" -AsPlainText -Force
$User = "DAMEN\Administrator"
$Credential = New-Object System.Management.Automation.PSCredential($User, $Password)

Write-Host "[-] Joining domain $Domain..." -ForegroundColor Cyan
Add-Computer -DomainName $Domain -Credential $Credential -Restart -Force
---
## Step 4: Vulnerability & Difficulty Levels (The DVAD Magic)

Now we define the scripts that set the levels (Easy, Medium, Hard). The user just needs to run the desired script.
🟢 Level: Easy (The Entry Point)

Primary Target: PRINT01 (Print Spooler Exploit - PrintNightmare)
File: scripts/Set-Level-Easy.ps1

Run this on PRINT01.
PowerShell

# DVAD-Damen V1: Level EASY - Print01 Configuration

Write-Host "[-] Setting Level: EASY..." -ForegroundColor Green

# 1. Open the Firewall wide
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# 2. Kill Windows Defender (Evasion 101: Not needed)
Set-MpPreference -DisableRealtimeMonitoring $true

# 3. ACTIVATE PrintNightmare (CVE-2021-1675)
Write-Host "[!] Activating Print Spooler & Exploit Path..." -ForegroundColor Yellow
Set-Service -Name Spooler -StartupType Automatic
Start-Service -Name Spooler

# Activate PointAndPrint vulnerability registry keys
$path = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
if (!(Test-Path $path)) { New-Item -Path $path -Force }
Set-ItemProperty -Path $path -Name "NoWarningNoElevationOnInstall" -Value 1
Set-ItemProperty -Path $path -Name "UpdatePromptSettings" -Value 2

Write-Host "[+] LEVEL EASY ACTIVE. HAPPY HACKING!" -ForegroundColor Green

🟡 Level: Medium (The Bypass Challenge)

Primary Target: WEB01 (IIS Misconfiguration & Service Account Attacks)
File: scripts/Set-Level-Medium.ps1

Run this on WEB01.
PowerShell

# DVAD-Damen V1: Level MEDIUM - Web01 Configuration

Write-Host "[-] Setting Level: MEDIUM..." -ForegroundColor Blue

# 1. Harden Firewall (Only essential AD/SMB ports)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# 2. Activate Windows Defender (Evasion now REQUIRED)
Set-MpPreference -DisableRealtimeMonitoring $false

# 3. IIS Misconfiguration: Insecure Service Account (For Kerberoasting)
Write-Host "[!] Configuring IIS Service Account for Kerberoasting..." -ForegroundColor Yellow
# (Logic to create a user and assign to an IIS App Pool, then set an SPN - requires AD module)
# This part is complex and often done manually on the DC, but can be automated here.

Write-Host "[+] LEVEL MEDIUM ACTIVE. CHOOSE YOUR BYPASS CAREFULLY!" -ForegroundColor Blue

🔴 Level: Hard (The Defended Network)

Focus: Detection & Hardened Configurations
File: scripts/Set-Level-Hard.ps1

Run this on ALL Machines.
PowerShell

# DVAD-Damen V1: Level HARD - System Hardening

Write-Host "[-] Setting Level: HARD..." -ForegroundColor Red

# 1. Enable Full Local Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# 2. Disable Vulnerable Services (Anti-PrintNightmare)
Write-Host "[#] Disabling Spooler service..." -ForegroundColor Yellow
Stop-Service -Name Spooler
Set-Service -Name Spooler -StartupType Disabled

# 3. Activate Advanced Auditing (Detection focus)
auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable

Write-Host "[+] LEVEL HARD ACTIVE. THEY ARE WATCHING." -ForegroundColor DarkRed
