# Module 2.2: Exam Mode - Medium (CPTS Style)

This module provides the technical configuration to activate **"Exam Mode: Medium"** on the **DVAD-Damen V1** lab. This level simulates advanced Kerberoasting and Evasion logic.
<img width="1408" height="768" alt="Gemini_Generated_Image_9k9ouy9k9ouy9k9o" src="https://github.com/user-attachments/assets/de013417-4152-4e31-9dd1-8062e8a36ae2" />

---

## Step 1: Exam Scenario
**Objective:** Perform an attack chain from a low-privilege position. You must bypass Windows Defender and exploit a weak Service Account (Kerberoasting).

### Flag Location
* **Target:** `IIS_SVC` account.
* **Flag:** `C:\Inetpub\Public\medium.txt` on **WEB01**.

---

## Step 2: Activate Medium Level Logic
Run this script on all machines (**DC01**, **WEB01**, **PRINT01**) to harden the environment and force advanced attack techniques.

**File:** `scripts/Activate-Exam-Medium.ps1`

```powershell
# DVAD-Damen V1: EXAM MODE - MEDIUM (CPTS Simulation)
Write-Host "[-] Activating CPTS Level Simulation..." -ForegroundColor Yellow

# 1. Enable Firewalls (Strict Rules)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# 2. Activate Windows Defender (Evasion Required)
Write-Host "[!] Windows Defender ACTIVE. OBFUSCATION REQUIRED." -ForegroundColor Red
Set-MpPreference -DisableRealtimeMonitoring $false

# 3. Patch Easy Vulnerabilities
# Stop and Disable Print Spooler (Anti-PrintNightmare)
Stop-Service -Name Spooler -Force
Set-Service -Name Spooler -StartupType Disabled

Write-Host "[+] Exam Mode: MEDIUM ACTIVE. HAPPY BYPASSING!" -ForegroundColor Blue
```

---

## Step 3: Configure Service Account (On DC01)
Run this on **DC01** to make the `IIS_SVC` account vulnerable to Kerberoasting.

```powershell
# Set SPN for IIS_SVC to allow Kerberoasting
setspn -s http/web01.damen.local IIS_SVC
Write-Host "[+] SPN Set: IIS_SVC is now Kerberoastable." -ForegroundColor Green
```

---
