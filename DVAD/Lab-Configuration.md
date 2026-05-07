
# Module 2: Server & Service Configuration

This module provides the technical steps to promote **DC01** to a Domain Controller and configure **WEB01** and **PRINT01** as domain members with their respective services.

---

## 1️⃣ DC01: Domain Controller Setup
**Role:** Primary Domain Controller, DNS Server, and Global Catalog.

**Script:** `scripts/Setup-DC01.ps1`
```powershell
# 1. Install AD-DS Role
Write-Host "[-] Installing Active Directory Domain Services..." -ForegroundColor Cyan
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 2. Promote to Forest Root
Import-Module ADDSDeployment
Install-ADDSForest `
    -DomainName "Damen.local" `
    -DomainNetbiosName "DAMEN" `
    -InstallDns:$true `
    -NoRebootOnCompletion:$false `
    -Force:$true
```
*Wait for automatic reboot. Log in as `DAMEN\Administrator`.*

---

## 2️⃣ Member Server: Domain Join
**Target:** Run on both **PRINT01** and **WEB01**.

**Script:** `scripts/Join-Domain.ps1`
```powershell
# Define Credentials
$AdminPass = ConvertTo-SecureString "P@ssword123!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential("DAMEN\Administrator", $AdminPass)

# Join Domain
Write-Host "[-] Joining Damen.local domain..." -ForegroundColor Cyan
Add-Computer -DomainName "Damen.local" -Credential $Credential -Restart -Force
```

---

## 3️⃣ PRINT01: Print Services Setup
**Role:** Central Print Management.

**Script:** `scripts/Setup-PrintServer.ps1`
```powershell
# 1. Install Print Server Role
Write-Host "[-] Installing Print-Server Role..." -ForegroundColor Cyan
Install-WindowsFeature -Name Print-Server

# 2. Ensure Spooler Service is configured
Set-Service -Name Spooler -StartupType Automatic
Start-Service -Name Spooler

Write-Host "[+] Print Server Role Active." -ForegroundColor Green
```

---

## 4️⃣ WEB01: IIS & File Services Setup
**Role:** Web Server (IIS) and Shared File Storage.

**Script:** `scripts/Setup-WebServer.ps1`
```powershell
# 1. Install IIS Web Server & File Server Roles
Write-Host "[-] Installing IIS and File Server Roles..." -ForegroundColor Cyan
Install-WindowsFeature -Name Web-Server, FS-FileServer -IncludeManagementTools

# 2. Create Shared Directory
$SharePath = "C:\Shares"
New-Item -Path $SharePath -ItemType Directory -Force
New-SmbShare -Name "CompanyData" -Path $SharePath -FullAccess "Everyone"

Write-Host "[+] IIS and File Share Configured." -ForegroundColor Green
```

---

## 📋 Post-Configuration Status
Once these scripts are executed, your environment will consist of:
* **DC01:** Managing identity (`Damen.local`).
* **PRINT01:** Running the Print Spooler service for future exploitation testing.
* **WEB01:** Hosting a default web page and an open SMB share for enumeration testing.



---

**What is the next step for your DVAD-Damen V1 project?**
