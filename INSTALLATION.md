# Installation Guide

Complete installation instructions for the IAVM Processor v2.3

**Author**: Hector L. Bones

---

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Quick Installation](#quick-installation)
- [Detailed Installation](#detailed-installation)
- [First Launch Configuration](#first-launch-configuration)
- [Restricted Environment Installation](#restricted-environment-installation)
- [Air-Gapped Installation](#air-gapped-installation)
- [Troubleshooting Installation Issues](#troubleshooting-installation-issues)
- [Uninstallation](#uninstallation)
- [Upgrading from Previous Versions](#upgrading-from-previous-versions)

---

## 🖥️ System Requirements

### Minimum Requirements
- **Operating System**: Windows 10 (version 1809+) or Windows 11
- **OR**: Windows Server 2016, 2019, 2022
- **PowerShell**: 5.1 or higher (included with Windows)
- **.NET Framework**: 4.5 or higher (included with Windows 10/11)
- **Disk Space**: 10 MB for application, 100 MB recommended for outputs
- **RAM**: 2 GB minimum (4 GB recommended for large IAVM files)
- **Display**: 1280x720 minimum resolution (1920x1080 recommended)

### Recommended Requirements
- **Excel**: Microsoft Excel LTSC 2021 or Microsoft 365 (for viewing CSV outputs)
- **PDF Reader**: For viewing documentation (Edge browser works)
- **Word**: For viewing .docx documentation files (optional)

### Not Required
- ❌ Python installation
- ❌ Pip or package managers
- ❌ Internet connectivity (after download)
- ❌ Administrator privileges (for running the application)
- ❌ Third-party libraries or dependencies

### ⚠️ IAVM Files Not Included

**IMPORTANT**: IAVM XML files are NOT included with this tool.

Users must obtain IAVM files from:
- DISA IAVM Website: https://public.cyber.mil/announcement/disa-iavm/
- Authorized government portals
- Your organization's security distribution channels

This tool processes IAVM files but does not distribute vulnerability data.

---

## 🚀 Quick Installation

### For Most Users (5 Minutes)

1. **Download the latest release**
   - Go to: https://github.com/yourusername/IAVM-Processor/releases/latest
   - Download: `IAVM-Processor-v2.3.zip`

2. **Extract the ZIP file**
   ```
   Right-click → Extract All → Choose location (e.g., C:\Tools\IAVM-Processor\)
   ```

3. **Launch the application**
   ```
   Double-click: Launch_IAVM_Processor_v2.3.bat
   ```

4. **Done!** The application should open and be ready to use.

---

## 📦 Detailed Installation

### Step 1: Download Files

#### Option A: GitHub Release (Recommended)
1. Navigate to the [Releases page](https://github.com/yourusername/IAVM-Processor/releases)
2. Find the latest version (v2.3.0 or newer)
3. Download **IAVM-Processor-v2.3.zip** (main application)
4. Optionally download **Documentation-Package-v2.3.zip** (Word documents)

#### Option B: Clone Repository
```powershell
# Using Git
git clone https://github.com/yourusername/IAVM-Processor.git
cd IAVM-Processor

# Or download as ZIP
# Click "Code" → "Download ZIP" on GitHub
```

### Step 2: Extract Files

**Windows Explorer Method:**
1. Right-click on `IAVM-Processor-v2.3.zip`
2. Select "Extract All..."
3. Choose destination (recommended: `C:\Tools\IAVM-Processor\`)
4. Click "Extract"

**PowerShell Method:**
```powershell
# Extract to current directory
Expand-Archive -Path "IAVM-Processor-v2.3.zip" -DestinationPath "C:\Tools\IAVM-Processor"

# Verify extraction
Get-ChildItem "C:\Tools\IAVM-Processor"
```

### Step 3: Verify File Structure

Your installation directory should contain:
```
C:\Tools\IAVM-Processor\
├── IAVM_Processor_v2.3.ps1          (Main application)
├── Launch_IAVM_Processor_v2.3.bat   (Quick launcher)
├── README.md                         (User guide)
├── CHANGELOG.md                      (Version history)
├── LICENSE                           (MIT License)
├── CONTRIBUTING.md                   (For contributors)
├── INSTALLATION.md                   (This file)
├── config/
│   └── IAVM_Config.json              (Sample configuration)
└── docs/
    ├── 2026_Cybersecurity_Calendar.docx
    ├── 2026_STIG_Compliance_Calendar.docx
    ├── DISA_STIG_Compliance_Plan.docx
    ├── STATUS_FIELD_GUIDE.md
    └── RELEASE_NOTES_v2.3.md
```

### Step 4: Set PowerShell Execution Policy (If Needed)

**Check current policy:**
```powershell
Get-ExecutionPolicy -Scope CurrentUser
```

**If it shows "Restricted" or "AllSigned", you need to change it:**

#### Option A: Change Policy (Recommended)
```powershell
# Run PowerShell as regular user (NOT Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Confirm when prompted
```

#### Option B: Use Bypass (No Permanent Change)
```powershell
# Launch with bypass (each time you run)
powershell.exe -ExecutionPolicy Bypass -File "C:\Tools\IAVM-Processor\IAVM_Processor_v2.3.ps1"
```

#### Option C: Use Batch Launcher (Easiest)
- The included `.bat` file automatically uses bypass
- No policy change needed
- Just double-click `Launch_IAVM_Processor_v2.3.bat`

### Step 5: Create Output Directory

The application auto-creates this, but you can prepare it:
```powershell
# Create output folder
New-Item -Path "C:\Temp\IAVM_Output" -ItemType Directory -Force

# Verify write permissions
Test-Path "C:\Temp\IAVM_Output" -PathType Container
```

---

## ⚙️ First Launch Configuration

### Initial Launch

1. **Start the application** using one of these methods:
   - Double-click `Launch_IAVM_Processor_v2.3.bat`
   - Right-click `IAVM_Processor_v2.3.ps1` → Run with PowerShell
   - From PowerShell: `.\IAVM_Processor_v2.3.ps1`

2. **First-time setup occurs automatically:**
   - Config file created at: `%APPDATA%\IAVM_Processor\IAVM_Config.json`
   - Default 2026 schedules loaded
   - Output directory verified

3. **You should see:**
   - Main window with 4 tabs
   - Status bar showing "Ready"
   - Pre-populated schedules

### Customize Patch Schedule

1. Click **"Patch Schedule"** tab
2. Review the default 2026 dates
3. Click **"Edit Patch Schedule"** button
4. Modify dates as needed:
   - Patch Tuesday (typically 2nd Tuesday)
   - Priority IAVM (Thursday after Patch Tuesday)
   - TRB Date (typically 3rd Tuesday)
   - Patch Day (typically 3rd Thursday)
   - Scan Day (typically 25th)
5. Click **"Save Changes"**
6. Verify changes appear in the main display

### Customize STIG Schedule (5-Phase Model)

1. Click **"STIG Compliance"** tab
2. Review the default quarterly dates
3. Click **"Edit STIG Schedule"** button
4. Modify dates for 5-phase lifecycle:
   - **Release Date**: DISA STIG publication (T+0)
   - **TRB Date**: Technical Review Board approval (T+15)
   - **POA&M Review**: Plan of Actions review (T+30)
   - **Implementation Due**: SME implementation complete (T+45)
   - **Review Complete**: Final review and validation (T+75)
5. Click **"Save Changes"**
6. Verify changes appear in the calendar view

### Test with Sample IAVM

1. Download a sample IAVM XML file from DISA
2. Click **"Process IAVMs"** tab
3. Click **"Select IAVM File(s)"**
4. Choose your IAVM file (XML or ZIP)
5. Click **"Process IAVMs"**
6. Review generated CSV files in `C:\Temp\IAVM_Output\`

---

## 🔒 Restricted Environment Installation

### For Government/Enterprise Networks

#### Download Outside Restricted Network
1. Download `IAVM-Processor-v2.3.zip` on internet-connected system
2. Scan for viruses/malware
3. Copy to USB drive or approved transfer media

#### Transfer to Restricted Network
1. Follow your organization's media transfer procedures
2. Scan USB drive at entry point
3. Copy files to approved location on restricted network

#### Installation on Restricted System
1. Extract ZIP file as described above
2. Verify PowerShell 5.1 is available:
   ```powershell
   $PSVersionTable.PSVersion
   ```
3. Launch application (no internet needed)
4. Process local IAVM XML files

#### Considerations for Restricted Environments
- ✅ No internet connectivity required after installation
- ✅ All processing happens locally
- ✅ No telemetry or external communications
- ✅ Configuration stored in user profile
- ✅ Outputs saved to local filesystem only

---

## 🌐 Air-Gapped Installation

### Completely Offline Systems

#### Preparation (On Connected System)
1. Download complete package from GitHub
2. Download PowerShell 5.1 installer (if target system needs it)
3. Gather documentation files
4. Create installation bundle

#### Installation Bundle Contents
```
IAVM-Processor-Offline-Bundle\
├── IAVM-Processor-v2.3.zip
├── PowerShell-5.1-Installer.msi (if needed)
├── INSTALLATION.md (this file)
└── README.md
```

#### Transfer to Air-Gapped System
1. Use approved media transfer process
2. Follow organizational security procedures
3. Virus scan at entry point

#### Installation Steps
1. **Install/Verify PowerShell 5.1** (if needed)
   ```powershell
   # Check current version
   $PSVersionTable.PSVersion
   
   # If <5.1, install from MSI
   ```

2. **Extract IAVM Processor**
   - Extract ZIP to approved location
   - Verify file integrity

3. **Configure for offline use**
   - No configuration needed - tool is offline-first
   - All features work without network

4. **Test functionality**
   - Launch application
   - Process sample IAVM file
   - Verify CSV outputs

---

## 🔧 Troubleshooting Installation Issues

### Issue: "Cannot be loaded because running scripts is disabled"

**Cause**: PowerShell execution policy is too restrictive

**Solution 1** (Recommended):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Solution 2** (Temporary):
```powershell
powershell.exe -ExecutionPolicy Bypass -File "IAVM_Processor_v2.3.ps1"
```

**Solution 3** (Use Batch File):
- Double-click `Launch_IAVM_Processor_v2.3.bat` instead

### Issue: "File path too long" during extraction

**Cause**: Windows 260-character path limit

**Solution**:
1. Extract to shorter path: `C:\Tools\IAVM\` instead of `C:\Users\...\Downloads\...`
2. Or enable long path support:
   ```powershell
   # Run as Administrator
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
   ```

### Issue: PowerShell window closes immediately

**Cause**: Script error or execution policy

**Solution**:
1. Right-click `IAVM_Processor_v2.3.ps1`
2. Choose "Edit" to open in PowerShell ISE or editor
3. Press F5 to run with visible errors
4. Or run from PowerShell console:
   ```powershell
   cd "C:\Tools\IAVM-Processor"
   .\IAVM_Processor_v2.3.ps1
   ```

### Issue: "Cannot find path" or config errors

**Cause**: Insufficient permissions or missing folders

**Solution**:
```powershell
# Create necessary directories
New-Item -Path "$env:APPDATA\IAVM_Processor" -ItemType Directory -Force
New-Item -Path "C:\Temp\IAVM_Output" -ItemType Directory -Force

# Check permissions
Test-Path "$env:APPDATA\IAVM_Processor" -PathType Container
```

### Issue: .NET Framework version errors

**Cause**: Older Windows version missing required .NET

**Solution**:
1. Check Windows version:
   ```powershell
   [System.Environment]::OSVersion.Version
   ```
2. Install .NET Framework 4.5+:
   - Windows 10/11: Already included
   - Windows Server: Install via Server Manager
   - Older systems: Download from Microsoft

### Issue: Application starts but UI doesn't display

**Cause**: Graphics driver or display issue

**Solution**:
1. Update graphics drivers
2. Check display scaling settings (100-150% recommended)
3. Try different launch method:
   ```powershell
   # Launch with verbose output
   .\IAVM_Processor_v2.3.ps1 -Verbose
   ```

---

## 🗑️ Uninstallation

### Complete Removal

1. **Delete application files:**
   ```powershell
   Remove-Item "C:\Tools\IAVM-Processor" -Recurse -Force
   ```

2. **Delete configuration (optional):**
   ```powershell
   Remove-Item "$env:APPDATA\IAVM_Processor" -Recurse -Force
   ```

3. **Delete output files (optional):**
   ```powershell
   Remove-Item "C:\Temp\IAVM_Output" -Recurse -Force
   ```

4. **Revert execution policy (optional):**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
   ```

### Partial Removal (Keep Configuration)

If you want to reinstall later with same settings:
- Delete application files only (Step 1)
- Keep `%APPDATA%\IAVM_Processor\IAVM_Config.json`
- Keep output files if needed for records

---

## ⬆️ Upgrading from Previous Versions

### From v2.2 to v2.3

**Automatic Upgrade** (Recommended):
1. Download v2.3 files
2. Extract to same location (overwrite when prompted)
3. Launch application
4. Config file automatically migrates to 5-phase STIG model
5. STIG schedule added with defaults
6. Patch schedule preserved

**Manual Upgrade** (If you want to keep old version):
1. Rename old folder: `IAVM-Processor-v2.2` → `IAVM-Processor-v2.2-backup`
2. Extract v2.3 to new folder
3. Copy config if you want to preserve customizations:
   ```powershell
   Copy-Item "$env:APPDATA\IAVM_Processor\IAVM_Config.json" "$env:APPDATA\IAVM_Processor\IAVM_Config_v2.2_backup.json"
   ```
4. Launch v2.3 (creates new config with 5-phase STIG)
5. Manually transfer patch schedule if desired

### From v2.0 or v2.1 to v2.3

Same as v2.2 upgrade - fully automatic

### From v1.x (Python version) to v2.3

**Complete Migration Required:**

1. **Backup old configuration:**
   - Save any custom settings from v1.x INI file
   - Export any important IAVM data

2. **Uninstall Python version:**
   - Remove Python application files
   - Optionally remove Python environment

3. **Install v2.3:**
   - Follow standard installation process above
   - Manually configure schedules (no automatic migration from v1.x)

4. **No data migration:**
   - v1.x and v2.x use different formats
   - Re-process IAVMs with new version
   - Build new baseline datasets

---

## 📞 Installation Support

If you encounter issues not covered here:

1. **Check existing issues**: [GitHub Issues](https://github.com/yourusername/IAVM-Processor/issues)
2. **Review documentation**: See README.md and other docs
3. **Open new issue**: Provide details from "Troubleshooting" section above
4. **Community help**: [GitHub Discussions](https://github.com/yourusername/IAVM-Processor/discussions)

---

## ✅ Verification Checklist

After installation, verify everything works:

- [ ] Application launches without errors
- [ ] All 4 tabs are visible and functional
- [ ] Patch Schedule displays 12 months
- [ ] STIG Compliance shows 4 quarters (5-phase model)
- [ ] About tab displays version 2.3
- [ ] Can select and process IAVM XML file
- [ ] CSV files generate in C:\Temp\IAVM_Output\
- [ ] Can edit and save Patch Schedule
- [ ] Can edit and save STIG Schedule (all 5 phases)
- [ ] Config file persists at `%APPDATA%\IAVM_Processor\IAVM_Config.json`

---

**Installation complete! Ready to process IAVMs and track STIG compliance.** 🚀

See [README.md](README.md) for usage instructions and examples.

---

**Author**: Hector L. Bones  
**Version**: 2.3.0  
**Last Updated**: January 29, 2026
