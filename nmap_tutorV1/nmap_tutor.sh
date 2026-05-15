#!/bin/bash

echo "========================================================="
echo "         Advanced Modular Nmap Scanner for noobs         "
echo "========================================================="

# Initialize empty variables to hold our flags
TARGET=""
PORTS=""
SCAN_TYPE=""
VERSION_OS=""
TIMING=""
EVASION=""
OUTPUT=""

# =========================================================
# 1. TARGET SPECIFICATION
# =========================================================
echo -e "\n[+] Enter your Target IP, Range, or CIDR (e.g., 192.168.1.1, 10.0.0.0/24, 172.16.1.1-50):"
read -p "> " TARGET

if [ -z "$TARGET" ]; then
    echo "Error: Target cannot be empty."
    exit 1
fi

# =========================================================
# 2. PORT SPECIFICATION
# =========================================================
echo -e "\n[+] Select Port Range:"
echo "1) Default (Top 1000 ports)"
echo "2) Fast Scan (Top 100 ports) [-F]"
echo "3) All 65535 Ports [-p-]"
echo "4) Custom Ports (e.g., 22,80,443 or 1-1000)"
read -p "> " port_choice

case $port_choice in
    2) PORTS="-F" ;;
    3) PORTS="-p-" ;;
    4) read -p "Enter custom ports: " custom_ports; PORTS="-p $custom_ports" ;;
    *) PORTS="" ;; # Default
esac

# =========================================================
# 3. SCAN TYPE
# =========================================================
echo -e "\n[+] Select Scan Type:"
echo "1) TCP SYN Stealth Scan [-sS]"
echo "2) TCP Connect Scan [-sT]"
echo "3) UDP Scan [-sU]"
echo "4) Ping Sweep Only (No port scan) [-sn]"
echo "5) Comprehensive (TCP SYN + UDP) [-sS -sU]"
read -p "> " scan_choice

case $scan_choice in
    1) SCAN_TYPE="-sS" ;;
    2) SCAN_TYPE="-sT" ;;
    3) SCAN_TYPE="-sU" ;;
    4) SCAN_TYPE="-sn" ;;
    5) SCAN_TYPE="-sS -sU" ;;
    *) SCAN_TYPE="-sS" ;; # Default to stealth
esac

# =========================================================
# 4. VERSION, OS, AND SCRIPTS
# =========================================================
echo -e "\n[+] Select Version & OS Detection:"
echo "1) None (Faster)"
echo "2) Service Version Detection [-sV]"
echo "3) Version Light Mode [-sV --version-light]"
echo "4) OS Detection [-O]"
echo "5) Safe Default Scripts [-sC]"
echo "6) Aggressive (OS, Version, Scripts, Traceroute) [-A]"
echo "7) Custom Combo (Version + OS + Scripts) [-sV -O -sC]"
read -p "> " vo_choice

case $vo_choice in
    2) VERSION_OS="-sV" ;;
    3) VERSION_OS="-sV --version-light" ;;
    4) VERSION_OS="-O" ;;
    5) VERSION_OS="-sC" ;;
    6) VERSION_OS="-A" ;;
    7) VERSION_OS="-sV -O -sC" ;;
    *) VERSION_OS="" ;;
esac

# ---------------------------------------------------------
# 5. TIMING & PERFORMANCE
# ---------------------------------------------------------
echo -e "\n[+] Select Timing Template:"
echo "1) Normal [-T3] (Default)"
echo "2) Sneaky / Timely [-T2]"
echo "3) Aggressive [-T4]"
echo "4) Very Aggressive (Fast networks only) [-T5]"
read -p "> " time_choice

case $time_choice in
    2) TIMING="-T2" ;;
    3) TIMING="-T4" ;;
    4) TIMING="-T5" ;;
    *) TIMING="-T3" ;;
esac

# =========================================================
# 6. FIREWALL EVASION
# =========================================================
echo -e "\n[+] Select Evasion Techniques:"
echo "1) None"
echo "2) Treat hosts as online (Skip Ping) [-Pn]"
echo "3) Fragment Packets [-f]"
echo "4) Skip Ping & Fragment Packets [-Pn -f]"
read -p "> " evade_choice

case $evade_choice in
    2) EVASION="-Pn" ;;
    3) EVASION="-f" ;;
    4) EVASION="-Pn -f" ;;
    *) EVASION="" ;;
esac

# =========================================================
# 7. OUTPUT
# =========================================================
echo -e "\n[+] Enter directory/filename to save results (e.g., /home/user/scan_results):"
echo "(Leave blank to skip saving to a file)"
read -p "> " filepath

if [ -n "$filepath" ]; then
    echo -e "\n[+] Select Output Format:"
    echo "1) Normal [-oN]"
    echo "2) Grepable [-oG]"
    echo "3) XML [-oX]"
    echo "4) All Formats [-oA]"
    read -p "> " out_choice

    case $out_choice in
        1) OUTPUT="-oN $filepath" ;;
        2) OUTPUT="-oG $filepath.gnmap" ;;
        3) OUTPUT="-oX $filepath.xml" ;;
        4) OUTPUT="-oA $filepath" ;;
        *) OUTPUT="-oN $filepath" ;;
    esac
fi

# =========================================================
# EXECUTION
# =========================================================
# Build the final command string
FINAL_CMD="nmap $SCAN_TYPE $PORTS $VERSION_OS $TIMING $EVASION $OUTPUT $TARGET"

# Cleanup any double spaces created by empty variables
FINAL_CMD=$(echo "$FINAL_CMD" | tr -s ' ')

echo -e "\n========================================================="
echo -e "\033[1;32mExecuting Command:\033[0m"
echo -e "\033[1;36m$FINAL_CMD\033[0m"
echo "========================================================="

# Run the command (requires sudo for raw packet scans like -sS, -O)
if [ "$EUID" -ne 0 ]; then
    echo "[!] Some scans (like -sS, -O) require root privileges. Escalating..."
    sudo $FINAL_CMD
else
    eval $FINAL_CMD
fi
