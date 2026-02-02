# Installation Guide

Complete installation instructions for the IAVM Processor v2.4

**Author**: Hector L. Bones

---

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Quick Installation](#quick-installation)
- [Detailed Installation](#detailed-installation)
- [First Launch Configuration](#first-launch-configuration)
- [Excel Template Setup](#excel-template-setup)
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
- **Excel**: Microsoft Excel 2013 or newer (for Excel Analysis Template)
  - Excel 2016, Excel 2019, or Microsoft 365 recommended
  - Power Query built into Excel 2013+
- **PDF Reader**: For viewing documentation (Edge browser works)
- **Word**: For viewing .docx documentation files (optional)

### Excel Analysis Template Requirements (New in v2.4)
- **Excel 2013** or newer (minimum - Power Query included)
- **Excel 2016** or newer (recommended for best compatibility)
- **Office 365** (best experience with latest features)
- **NOT supported**: Excel 2010 or older, Excel Online (limited features)

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
   - Download: `IAVM-Processor-v2.4.0.zip`

2. **Extract the ZIP file**
   ```
   Right-click → Extract All → Choose location (e.g., C:\Tools\IAVM-Processor\)
   ```

3. **Launch the application**
   ```
   Double-click: Launch_IAVM_Processor_v2_4.bat
   ```

4. **Done!** The application should open and be ready to use.

5. **Optional: Set up Excel Template**
   - See [Excel Template Setup](#excel-template-setup) section below

---

## 📦 Detailed Installation

### Step 1: Download Files

#### Option A: GitHub Release (Recommended)
1. Navigate to the [Releases page](https://github.com/yourusername/IAVM-Processor/releases)
2. Find the latest version (v2.4.0 or newer)
3. Download **IAVM-Processor-v2.4.0.zip** (main application)
4. Optionally download **Documentation-Package-v2.4.zip** (Word documents)

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
1. Right-click on `IAVM-Processor-v2.4.0.zip`
2. Select "Extract All..."
3. Choose destination (recommended: `C:\Tools\IAVM-Processor\`)
4. Click "Extract"

**PowerShell Method:**
```powershell
# Extract to current directory
Expand-Archive -Path "IAVM-Processor-v2.4.0.zip" -DestinationPath "C:\Tools\IAVM-Processor"

# Verify extraction
Get-ChildItem "C:\Tools\IAVM-Processor"
```

### Step 3: Verify File Structure

Your installation directory should contain:
```
C:\Tools\IAVM-Processor\
├── IAVM_Processor_v2_4.ps1          (Main application)
├── Launch_IAVM_Processor_v2_4.bat   (Quick launcher)
├── IAVM_Analysis_Template.xlsx      (NEW - Excel dashboard)
├── IAVM_Config.json                 (Sample configuration)
├── README.md                         (User guide)
├── CHANGELOG.md                      (Version history)
├── LICENSE                           (MIT License)
├── CONTRIBUTING.md                   (For contributors)
├── SECURITY.md                       (Security policy)
└── docs/
    ├── EXCEL_TEMPLATE_GUIDE.md       (NEW - Excel guide)
    ├── EXCEL_TEMPLATE_GUIDE.docx     (NEW - Excel guide Word)
    ├── STATUS_FIELD_GUIDE.md         (Status reference)
    ├── 2026_Cybersecurity_Calendar.docx
    ├── 2026_STIG_Compliance_Calendar.docx
    └── DISA_STIG_Compliance_Plan.docx
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
powershell.exe -ExecutionPolicy Bypass -File "C:\Tools\IAVM-Processor\IAVM_Processor_v2_4.ps1"
```

#### Option C: Use Batch Launcher (Easiest)
- The included `.bat` file automatically uses bypass
- No policy change needed
- Just double-click `Launch_IAVM_Processor_v2_4.bat`

### Step 5: Create Output Directory

The application auto-creates this, but you can prepare it:
```powershell
# Create output folder
New-Item -Path "C:\IAVM_Output" -ItemType Directory -Force

# Verify write permissions
Test-Path "C:\IAVM_Output" -PathType Container
```

---

## ⚙️ First Launch Configuration

### Initial Launch

1. **Start the application** using one of these methods:
   - Double-click `Launch_IAVM_Processor_v2_4.bat`
   - Right-click `IAVM_Processor_v2_4.ps1` → Run with PowerShell
   - From PowerShell: `.\IAVM_Processor_v2_4.ps1`

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
3. Click **"Browse Source Directory"**
4. Choose folder with IAVM XML/ZIP files
5. Click **"Browse Output Directory"**
6. Choose where CSVs should be saved
7. Click **"Process Files"**
8. Click **"Export CSVs"**
9. Review generated CSV files in output directory

---

## 📊 Excel Template Setup

### What is the Excel Analysis Template?

**New in v2.4.0**: Professional Excel dashboard that automatically loads and visualizes IAVM data from CSV files.

**Features:**
- 5 priority metric tiles (TRB Eligible, CAT I, Aged, Total, New)
- Status distribution pie chart
- Severity breakdown bar chart
- 6 specialized data sheets
- Automated Power Query data loading
- Print-ready formatting

### Quick Setup (5 Minutes)

1. **Process IAVMs first:**
   - Run IAVM Processor as described above
   - Export CSVs to a specific folder (e.g., `C:\IAVM_Output\`)

2. **Copy Excel template:**
   - Copy `IAVM_Analysis_Template.xlsx` to the **SAME folder** as your CSV files
   ```
   Example - CORRECT:
   C:\IAVM_Output\Complete_IAVM_Results.csv
   C:\IAVM_Output\Summary_IAVM_Results.csv
   C:\IAVM_Output\IAVM_Analysis_Template.xlsx  ← Same folder!
   ```

3. **Open template in Excel:**
   - Double-click `IAVM_Analysis_Template.xlsx`
   - Click **Data** tab → **Refresh All** button
   - Wait 30-60 seconds for data to load

4. **Review Dashboard:**
   - Metrics should show actual counts
   - Charts should display data
   - Conditional formatting highlights key items

### Power Query Setup (First Time Only)

**If template doesn't refresh automatically:**

See detailed instructions in:
- `docs/EXCEL_TEMPLATE_GUIDE.md` (comprehensive)
- `docs/EXCEL_TEMPLATE_GUIDE.docx` (print-ready)
- Instructions sheet in Excel template

**Quick version:**
1. Data → Get Data → From Text/CSV
2. Select CSV file (e.g., Complete_IAVM_Results.csv)
3. Load To → Table → Existing worksheet → Cell A4
4. Repeat for all 6 CSV files
5. Save template

### Excel Template Troubleshooting

**Problem: Template shows "-" or blank metrics**
- Click Data → Refresh All
- Ensure template is in SAME folder as CSVs
- Check that CSVs have data (not just headers)

**Problem: "DataSource.Error"**
- CSV files not found
- Verify template and CSVs in same folder
- Check CSV file names match exactly

**For complete troubleshooting**, see `docs/EXCEL_TEMPLATE_GUIDE.md`

---

## 🔒 Restricted Environment Installation

### For Government/Enterprise Networks

#### Download Outside Restricted Network
1. Download `IAVM-Processor-v2.4.0.zip` on internet-connected system
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
3. Verify Excel 2013+ if using template:
   ```powershell
   # Check if Excel is installed
   Test-Path "C:\Program Files\Microsoft Office\root\Office*\EXCEL.EXE"
   ```
4. Launch application (no internet needed)
5. Process local IAVM XML files
6. Use Excel template with local CSV files

#### Considerations for Restricted Environments
- ✅ No internet connectivity required after installation
- ✅ All processing happens locally
- ✅ No telemetry or external communications
- ✅ Configuration stored in user profile
- ✅ Outputs saved to local filesystem only
- ✅ Excel template uses local file references only (no external connections)

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
├── IAVM-Processor-v2.4.0.zip
├── PowerShell-5.1-Installer.msi (if needed)
├── docs/
│   ├── INSTALLATION.md (this file)
│   ├── EXCEL_TEMPLATE_GUIDE.md
│   └── README.md
└── Excel-Installer.exe (if Excel not installed)
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

2. **Install/Verify Excel** (if using template)
   - Excel 2013 or newer required
   - Verify Power Query is available (built into 2013+)

3. **Extract IAVM Processor**
   - Extract ZIP to approved location
   - Verify file integrity

4. **Configure for offline use**
   - No configuration needed - tool is offline-first
   - All features work without network
   - Excel template uses local files only

5. **Test functionality**
   - Launch application
   - Process sample IAVM file
   - Verify CSV outputs
   - Test Excel template refresh

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
powershell.exe -ExecutionPolicy Bypass -File "IAVM_Processor_v2_4.ps1"
```

**Solution 3** (Use Batch File):
- Double-click `Launch_IAVM_Processor_v2_4.bat` instead

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
1. Right-click `IAVM_Processor_v2_4.ps1`
2. Choose "Edit" to open in PowerShell ISE or editor
3. Press F5 to run with visible errors
4. Or run from PowerShell console:
   ```powershell
   cd "C:\Tools\IAVM-Processor"
   .\IAVM_Processor_v2_4.ps1
   ```

### Issue: "Cannot find path" or config errors

**Cause**: Insufficient permissions or missing folders

**Solution**:
```powershell
# Create necessary directories
New-Item -Path "$env:APPDATA\IAVM_Processor" -ItemType Directory -Force
New-Item -Path "C:\IAVM_Output" -ItemType Directory -Force

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
   .\IAVM_Processor_v2_4.ps1 -Verbose
   ```

### Issue: Excel template doesn't work

**Cause**: Excel version too old or Power Query not available

**Solution**:
1. Verify Excel version:
   - File → Account → About Excel
   - Must be 2013 or newer
2. Check for Power Query:
   - Data tab → should see "Get Data" or "Get External Data"
3. If Excel 2010 or older:
   - Upgrade to Excel 2013+ for template support
   - Or use CSV files directly in Excel

### Issue: Excel template shows errors

**Cause**: CSV files not in correct location

**Solution**:
1. Verify template is in SAME folder as CSV files
2. Check CSV file names match exactly:
   - Complete_IAVM_Results.csv
   - Summary_IAVM_Results.csv
   - Monthly_Statistics.csv
   - TRB_Eligible_Items.csv
   - Priority_Items_CAT_I.csv
   - Aged_Items.csv
3. See `docs/EXCEL_TEMPLATE_GUIDE.md` for detailed troubleshooting

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
   Remove-Item "C:\IAVM_Output" -Recurse -Force
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
- Keep Excel templates with organizational data

---

## ⬆️ Upgrading from Previous Versions

### From v2.3 to v2.4

**Automatic Upgrade** (Recommended):
1. Download v2.4.0 files
2. Extract to same location (overwrite when prompted)
3. Launch application
4. Config file automatically compatible (no changes needed)
5. **NEW**: Excel Analysis Template included
6. **NEW**: Enhanced About tab with tools documentation

**What's New:**
- Excel Analysis Template (IAVM_Analysis_Template.xlsx)
- Excel template guides (MD + DOCX)
- Tools & Resources documentation in About tab
- Batch launcher updated to v2_4.bat
- Enhanced documentation

**Manual Upgrade** (If you want to keep old version):
1. Rename old folder: `IAVM-Processor-v2.3` → `IAVM-Processor-v2.3-backup`
2. Extract v2.4 to new folder
3. Copy config if you want to preserve customizations:
   ```powershell
   Copy-Item "$env:APPDATA\IAVM_Processor\IAVM_Config.json" "$env:APPDATA\IAVM_Processor\IAVM_Config_v2.3_backup.json"
   ```
4. Launch v2.4
5. Try Excel template with existing CSV files

### From v2.2 or v2.1 to v2.4

**Automatic upgrade** - config file fully compatible

**New features to explore:**
- STIG Compliance tab (added in v2.3)
- Excel Analysis Template (added in v2.4)
- Tools documentation (added in v2.4)

### From v2.0 to v2.4

Same as above - config file compatible

### From v1.x (Python version) to v2.4

**Complete Migration Required:**

1. **Backup old configuration:**
   - Save any custom settings from v1.x INI file
   - Export any important IAVM data

2. **Uninstall Python version:**
   - Remove Python application files
   - Optionally remove Python environment

3. **Install v2.4:**
   - Follow standard installation process above
   - Manually configure schedules (no automatic migration from v1.x)
   - Set up Excel template for new workflow

4. **No data migration:**
   - v1.x and v2.x use different formats
   - Re-process IAVMs with new version
   - Build new baseline datasets
   - Use Excel template for visualization

---

## 📞 Installation Support

If you encounter issues not covered here:

1. **Check existing issues**: [GitHub Issues](https://github.com/yourusername/IAVM-Processor/issues)
2. **Review documentation**: 
   - See README.md for usage
   - See EXCEL_TEMPLATE_GUIDE.md for template help
   - See SECURITY.md for security questions
3. **Open new issue**: Provide details from "Troubleshooting" section above
4. **Community help**: [GitHub Discussions](https://github.com/yourusername/IAVM-Processor/discussions)

---

## ✅ Verification Checklist

After installation, verify everything works:

### PowerShell Application
- [ ] Application launches without errors
- [ ] All 4 tabs are visible and functional
- [ ] Patch Schedule displays 12 months
- [ ] STIG Compliance shows 4 quarters (5-phase model)
- [ ] About tab displays version 2.4
- [ ] Tools & Resources section appears in About tab
- [ ] Excel Analysis Template section appears in About tab
- [ ] Can select and process IAVM XML file
- [ ] CSV files generate in output directory
- [ ] Can edit and save Patch Schedule
- [ ] Can edit and save STIG Schedule (all 5 phases)
- [ ] Config file persists at `%APPDATA%\IAVM_Processor\IAVM_Config.json`

### Excel Analysis Template (New in v2.4)
- [ ] Template file exists (IAVM_Analysis_Template.xlsx)
- [ ] Template opens in Excel without errors
- [ ] Can place template in same folder as CSVs
- [ ] Data → Refresh All loads data successfully
- [ ] Dashboard shows 5 metric tiles with numbers
- [ ] Status distribution chart displays
- [ ] Severity breakdown chart displays
- [ ] All 6 data sheets have data
- [ ] Conditional formatting works (red/orange/yellow)
- [ ] Instructions sheet is readable and helpful
- [ ] Can print dashboard page

### Documentation
- [ ] README.md opens and is readable
- [ ] EXCEL_TEMPLATE_GUIDE.md exists in docs/
- [ ] EXCEL_TEMPLATE_GUIDE.docx exists in docs/
- [ ] STATUS_FIELD_GUIDE.md exists
- [ ] All 3 Word calendars exist in docs/

---

**Installation complete! Ready to process IAVMs and track STIG compliance.** 🚀

See [README.md](README.md) for usage instructions and [EXCEL_TEMPLATE_GUIDE.md](docs/EXCEL_TEMPLATE_GUIDE.md) for Excel template guidance.

---

**Author**: Hector L. Bones  
**Version**: 2.4.0  
**Last Updated**: January 30, 2026
