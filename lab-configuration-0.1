# Module 2.1: Exam Environment & Life Simulation

This module configures the **DVAD-Damen V1** lab to mirror a professional penetration testing exam environment. It includes simulated user activity, a structured "Flag" system, and an "Exam Scenario."

---

## 🏢 The Exam Scenario (Context)
**Client:** Damen Logistics  
**Objective:** Perform an internal penetration test. Start as an unauthenticated attacker on the network and escalate to **Domain Admin**.

### 🚩 Flag Methodology
To simulate a real exam, three flags have been hidden in the environment:
1.  **User Flag:** Located on `WEB01` (accessible via low-privilege access).
2.  **Service Flag:** Located on `PRINT01` (requires System/Service level privileges).
3.  **Root Flag:** Located on `DC01` (requires Domain Admin privileges).

---

## 👥 Phase 1: Realistic Life Injection
This script creates a "dirty" Active Directory environment. It populates the domain with realistic users, groups, and the "mistakes" often found in enterprise networks.

**File:** `scripts/Inject-Life-Exam.ps1` (Run on **DC01**)
```powershell
# 1. Create Enterprise Structure
$OUs = "Sales", "IT_Ops", "Finance", "Dev"
foreach ($OU in $OUs) { New-ADOrganizationalUnit -Name $OU -Path "DC=Damen,DC=local" }

# 2. Create Users with "Exam-Style" Misconfigurations
$Pass = ConvertTo-SecureString "DamenLogistics2026!" -AsPlainText -Force

# Target 1: The 'Description' Leak (AS-REP Roasting candidate)
New-ADUser -Name "S.Damon" -SamAccountName "SDamon" -Path "OU=Sales,DC=Damen,DC=local" -AccountPassword $Pass -Enabled $true -Description "Account Reset: Welcome2026!"
Set-ADUser -Identity "SDamon" -DoesNotRequirePreAuth $true

# Target 2: The Service Account (Kerberoasting candidate)
New-ADUser -Name "SQL Service" -SamAccountName "sql_svc" -Path "OU=IT_Ops,DC=Damen,DC=local" -AccountPassword $Pass -Enabled $true

# 3. Drop The Flags
# Root Flag on DC01
"DVAD{D4m3n_D0m41n_M4st3r_2026}" | Out-File "C:\Users\Administrator\Desktop\root.txt"

# User Flag on WEB01
Invoke-Command -ComputerName WEB01 -ScriptBlock {
    "DVAD{W3b_3ntry_Succ3ss_99}" | Out-File "C:\Users\Public\user.txt"
}

Write-Host "[+] Exam Environment Ready. Simulation Active." -ForegroundColor Green
```

---

## 🕹️ Phase 2: Difficulty Tier Logic (Exam Tiers)

| Feature | **🟢 Level: Easy (OSCP Style)** | **🟡 Level: Medium (CPTS Style)** | **🔴 Level: Hard (OSEE Style)** |
| :--- | :--- | :--- | :--- |
| **Primary Path** | PrintNightmare (CVE-2021-1675) | Kerberoasting + Evasion | ACL Misconfigs + BloodHound |
| **Firewall** | Off | Strict (Port 80, 445 only) | Advanced Filtering |
| **Defender** | Disabled | Enabled (Real-time) | Enabled + Cloud Protection |
| **Auditing** | None | Basic Logon events | Full Process/CLI Logging |
| **Password Policy** | No Complexity | Standard | Fine-Grained (Long/Complex) |

---

## 🛠️ Exam Configuration Scripts

### To set "Exam Mode: Easy" (Run on Target):
```powershell
# Set-Exam-Easy.ps1
Set-NetFirewallProfile -Enabled False
Set-MpPreference -DisableRealtimeMonitoring $true
# Enable Print Spooler for PrintNightmare
Set-Service -Name Spooler -StartupType Automatic -Status Running
# Registry fix to allow the exploit
$path = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
if (!(Test-Path $path)) { New-Item -Path $path -Force }
Set-ItemProperty -Path $path -Name "NoWarningNoElevationOnInstall" -Value 1
```

### To set "Exam Mode: Hard" (Run on Target):
```powershell
# Set-Exam-Hard.ps1
Set-NetFirewallProfile -Enabled True
Set-MpPreference -DisableRealtimeMonitoring $false
Stop-Service -Name Spooler -Force
# Enable Advanced Logging for Detection
auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
```
