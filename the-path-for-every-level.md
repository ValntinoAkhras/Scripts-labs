**Module 3** formatted for your GitHub.

---

# Module 3: Operational Missions (Tasks)

This module defines the mission objectives for each difficulty tier in **DVAD-Damen V1**. Use these tasks as your guide during the assessment.

---

## 🟢 Level: EASY (The Entry Point)
**Mindset:** "Low Hanging Fruit." In this level, the administrator has been lazy and left the front door unlocked.

### 📋 Your Tasks:
1.  **Network Recon:** Perform an `Nmap` scan to identify all 3 live hosts and their running services.
2.  **OSINT/Internal Enumeration:** Search Active Directory object properties (like User Descriptions) for leaked credentials.
3.  **Initial Access:** Use discovered credentials to gain a foothold via WinRM or SMB.
4.  **Local Privilege Escalation:** Identify and exploit the **PrintNightmare (CVE-2021-1675)** vulnerability on `PRINT01` to gain `SYSTEM` privileges.
5.  **Exfiltration:** Locate the `user.txt` flag on the Desktop.

---

## 🟡 Level: MEDIUM (The Bypass Challenge)
**Mindset:** "Living off the Land." The basics are patched. You must now use legitimate Windows features against the domain while staying invisible to Defender.

### 📋 Your Tasks:
1.  **Stealth Recon:** Perform a service discovery scan while attempting to minimize your network footprint.
2.  **Payload Crafting:** Generate an obfuscated C2 agent (e.g., Sliver or Metasploit) that can execute on `WEB01` without being killed by **Windows Defender**.
3.  **Service Account Attack:** Perform **Kerberoasting** to request a TGS ticket for the `IIS_SVC` account and crack it offline.
4.  **Lateral Movement:** Use your cracked service credentials to access restricted file shares (`C:\Shares`) on `WEB01`.
5.  **Exfiltration:** Recover the `medium.txt` flag from the hidden IIS directory.

---

## 🔴 Level: HARD (The Hardened Enterprise)
**Mindset:** "Zero Trust." Everything is logged. The firewall is strict, and there are no public exploits. You must exploit logical misconfigurations.

### 📋 Your Tasks:
1.  **Advanced AD Enumeration:** Use `BloodHound` or `PowerView` to map out complex Group Policy (GPO) or ACL misconfigurations.
2.  **Evasion:** Execute your tools purely in-memory (Fileless) to avoid detection by advanced auditing.
3.  **Persistence:** Establish a persistent foothold that survives a system reboot without alerting the administrator.
4.  **Domain Dominance:** Exploit a "Constrained Delegation" or "Shadow Admin" flaw to escalate to **Domain Admin** on `DC01`.
5.  **Final Objective:** Capture the `root.txt` flag from the Administrator's desktop on the Domain Controller.

---
To "complete" the lab, you should be able to reset the environment and clear all three levels in a single session without referring to outside notes.

**How does this mission structure look to you, Valentino? It gives the student a clear path without spoiling the "Aha!" moment of the hack.**
