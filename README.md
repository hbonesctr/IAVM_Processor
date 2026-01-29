# IAVM Processor v2.3

> **Integrated Vulnerability Management & STIG Compliance Tracking System**

A PowerShell-based tool designed for Information Assurance professionals to streamline DISA IAVM processing and STIG compliance lifecycle management.

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)

---

## 🎯 Overview

The **IAVM Processor v2.3** is a comprehensive Windows Forms application that combines two critical cybersecurity workflows:

- **IAVM Processing**: Automated parsing and classification of DISA Information Assurance Vulnerability Management bulletins
- **STIG Compliance**: Quarterly tracking of Security Technical Implementation Guide 5-phase lifecycle

This tool eliminates manual spreadsheet management, provides intelligent vulnerability classification, and integrates seamlessly with existing cybersecurity operations.

---

## ✨ Key Features

### IAVM Processing Engine
- ✅ **Automatic XML Parsing** - Handles both zipped and unzipped DISA IAVM files
- ✅ **Intelligent Status Classification** - 4-tier system (New/Prior/Historical/Aged)
- ✅ **Type Detection** - Automatic IAVA/IAVB identification from bulletin numbers
- ✅ **Multiple CSV Outputs** - 6 specialized reports for different stakeholders
- ✅ **SCAP-Ready** - OVAL ID extraction for automated scanning workflows

### Patch Schedule Management
- 📅 **Visual Calendar** - View entire year's patch cycle at a glance
- 🔧 **Editable Schedule** - Customize dates via integrated DataGridView editor
- 💾 **Persistent Configuration** - JSON-based storage with automatic backup
- 📊 **TRB Integration** - Tracks Patch Tuesday, Priority IAVMs, TRB meetings, and scan dates

### STIG Compliance Tracking
- 📋 **Quarterly Lifecycle** - Manages 5-phase, 75-day STIG implementation
- 🗓️ **5-Phase Framework** - Release, TRB, POA&M, Implementation, Continuous Compliance
- ⚙️ **Customizable Timelines** - Edit STIG schedule with visual editor
- 🔄 **Continuous Compliance** - Phase 5 ongoing review tracking

### User Experience
- 🖥️ **Native Windows GUI** - No Python, no third-party dependencies
- 🎨 **Professional Interface** - Color-coded tabs with clear visual hierarchy
- 📖 **Built-in Documentation** - About tab with comprehensive usage guide
- 🚀 **Quick Launch** - Double-click batch file or PowerShell script

---

## 📋 Requirements

### System Requirements
- **Operating System**: Windows 10/11 or Windows Server 2016+
- **PowerShell**: Version 5.1 (included with Windows)
- **Excel**: Microsoft Excel LTSC 2021 or equivalent (for viewing CSV outputs)
- **.NET Framework**: 4.5+ (included with Windows)

### Input Files

⚠️ **IMPORTANT: IAVM XML files are NOT included with this tool.**

Users must obtain IAVM files directly from DISA's official sources:
- DISA IAVM Website: https://public.cyber.mil/announcement/disa-iavm/
- Authorized government portals
- Your organization's security distribution channels

This tool processes IAVM XML files but does not distribute vulnerability data.

**Supported File Types:**
- DISA IAVM XML files (`.xml`)
- Zipped IAVM files (`.zip`)

### No Additional Software Required
- ✅ No Python installation needed
- ✅ No third-party libraries required
- ✅ Works in restricted environments
- ✅ No admin rights needed for execution

---

## 🚀 Quick Start

### Installation

1. **Download the latest release**
   ```
   Download IAVM-Processor-v2.3.zip from GitHub Releases
   ```

2. **Extract to your preferred location**
   ```
   C:\Tools\IAVM-Processor\
   ```

3. **Launch the application**
   - **Option A**: Double-click `Launch_IAVM_Processor_v2.3.bat`
   - **Option B**: Right-click `IAVM_Processor_v2.3.ps1` → Run with PowerShell

### First-Time Setup

1. **Configure Patch Schedule** (if needed)
   - Navigate to "Patch Schedule" tab
   - Click "Edit Patch Schedule" button
   - Modify dates to match your organization's calendar
   - Click "Save Changes"

2. **Configure STIG Schedule** (if needed)
   - Navigate to "STIG Compliance" tab
   - Click "Edit STIG Schedule" button
   - Adjust quarterly dates as required
   - Click "Save Changes"

3. **Process Your First IAVM**
   - Navigate to "Process IAVMs" tab
   - Click "Select IAVM File(s)"
   - Choose one or more IAVM XML/ZIP files
   - Click "Process IAVMs"
   - Review results and generated CSV files

---

## 📊 Output Files

The tool generates **6 specialized CSV files** for different use cases:

| File | Description | Use Case |
|------|-------------|----------|
| `IAVM_Complete_YYYYMMDD_HHMMSS.csv` | Full dataset with all fields | Master reference, audit trail |
| `IAVM_Summary_YYYYMMDD_HHMMSS.csv` | Key fields only (Title, Status, Type, Dates) | Quick review, leadership briefs |
| `IAVM_Monthly_Stats_YYYYMMDD_HHMMSS.csv` | Count by month and status | Trend analysis, metrics |
| `IAVM_TRB_Eligible_YYYYMMDD_HHMMSS.csv` | Items requiring TRB review | Preparing TRB agenda |
| `IAVM_Priority_Items_YYYYMMDD_HHMMSS.csv` | CAT I/High priority items | Immediate action items |
| `IAVM_Aged_Items_YYYYMMDD_HHMMSS.csv` | Items >90 days old | POA&M tracking, compliance |

### Output Locations
- All CSV files are saved to: `C:\Temp\IAVM_Output\`
- Config file location: `%APPDATA%\IAVM_Processor\IAVM_Config.json`

---

## 🔧 Configuration

### Configuration File Structure

The tool uses `IAVM_Config.json` to persist settings:

```json
{
  "Version": "2.3",
  "PatchSchedule": [
    {
      "Month": "January",
      "PatchTuesday": "2026-01-13",
      "PriorityIAVM": "2026-01-15",
      "TRBDate": "2026-01-20",
      "PatchDay": "2026-01-22",
      "ScanDay": "2026-01-25"
    }
    // ... 11 more months
  ],
  "STIGSchedule": [
    {
      "Quarter": "Q1",
      "ReleaseDate": "2026-01-31",
      "TRBDate": "2026-02-15",
      "POAMReview": "2026-02-28",
      "ImplementationDue": "2026-03-17",
      "ReviewComplete": "2026-04-15"
    }
    // ... Q2, Q3, Q4
  ]
}
```

### Manual Configuration
You can edit `IAVM_Config.json` directly with any text editor, or use the built-in GUI editors in the application.

---

## 📖 Understanding Status Field Classification

The IAVM Processor uses intelligent logic to classify bulletins into 4 categories:

| Status | Definition | Logic |
|--------|------------|-------|
| **New** | Recently published | Released after most recent Patch Tuesday |
| **Prior** | Previous cycle | Released between last 2 Patch Tuesdays |
| **Historical** | Older items | Released 2-13 months ago |
| **Aged** | Long-standing | Released >13 months ago |

**Why This Matters**: This classification helps prioritize TRB discussions by focusing on items that are actionable within your current patch cycle.

### Example Timeline
```
Patch Tuesday: Jan 14, 2025
Processing Date: Jan 29, 2025

Status Assignment:
- IAVA after Jan 14 → "New"
- IAVA Dec 10-Jan 13 → "Prior" 
- IAVA Jan-Nov 2024 → "Historical"
- IAVA before Jan 2024 → "Aged"
```

See `docs/STATUS_FIELD_GUIDE.md` for detailed information.

---

## 📅 Workflow Integration

### Monthly Patch Cycle
```
Week 1: [Patch Tuesday] → [Priority IAVM Release]
Week 2: Monitor for additional IAVMs
Week 3: [TRB Meeting] → [Patch Implementation]
Week 4: [Compliance Scan] → Monthly reporting
```

### Quarterly STIG Cycle (5-Phase, 75-Day Lifecycle)

**Phase 1 (T+0 to T+15): Release & Initial Assessment**
- Phase 1a: Create or Update Current Benchmarks to New Checklist
- Phase 1b: Review Open findings and update Finding Notes

**Phase 2 (T+15 to T+30): TRB Approval for Changes**
- Present changes to Technical Review Board
- Obtain approvals for implementation plan

**Phase 3 (T+30 to T+45): Plan of Actions & Milestones Review**
- New Benchmark Creation
- Create New POA&Ms
- Update existing POA&Ms

**Phase 4 (T+45 to T+75): SME Deep Dive & Implementation**
- Full configuration review against new benchmark
- System hardening implementation
- Compliance validation

**Phase 5 (Ongoing): 90-Day Continuous Compliance**
- Regular configuration reviews
- Deviation tracking
- Remediation of findings
- Continuous monitoring

### TRB Meeting Strategy
- **3rd Tuesday**: Patch & IAVM TRB (Tactical - vulnerability response)
- **Mid-Month (varies)**: STIG TRB for approvals (Strategic - configuration management)

---

## 🎓 Documentation

Comprehensive documentation is included in the `docs/` directory:

- **2026_Cybersecurity_Calendar.docx** - 7-page professional calendar with integrated patch and STIG schedules
- **2026_STIG_Compliance_Calendar.docx** - Landscape poster-format STIG lifecycle calendar
- **DISA_STIG_Compliance_Plan.docx** - Strategic implementation framework
- **STATUS_FIELD_GUIDE.md** - Detailed explanation of classification logic
- **RELEASE_NOTES_v2.3.md** - Version 2.3 feature details and changes

---

## 🆘 Troubleshooting

### Common Issues

**Q: Script won't run - "Execution policy" error**
```powershell
# Run PowerShell as Administrator and execute:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Q: No CSV files generated after processing**
- Check `C:\Temp\IAVM_Output\` directory exists
- Verify you have write permissions to C:\Temp
- Review PowerShell console for error messages

**Q: Config file changes not saving**
- Ensure `%APPDATA%\IAVM_Processor\` folder exists
- Check folder permissions (should allow write access)
- Verify no other application has config file open

**Q: IAVM XML file won't process**
- Confirm file is valid DISA IAVM XML format
- Try extracting ZIP files before processing
- Ensure file isn't corrupted (download again if needed)

**Q: Dates appear incorrect in schedules**
- Check system date/time settings
- Verify time zone is correctly configured
- Re-edit schedule using GUI editor to refresh

---

## 🔄 Version History

### v2.3.0 (Current)
- ✅ Fixed Type field extraction (IAVA/IAVB from IAVMNumber pattern)
- ✅ Added STIG Compliance tab with quarterly calendar
- ✅ Implemented Edit STIG Schedule functionality
- ✅ Added STIG schedule persistence to config file
- ✅ Enhanced About tab with expanded documentation

### v2.2.0
- ✅ Implemented intelligent 4-tier Status classification
- ✅ Enhanced GUI with professional formatting
- ✅ Improved CSV generation logic

### v2.1.0
- ✅ Fixed CSV serialization issues
- ✅ Standardized 10pt fonts across interface
- ✅ Added comprehensive About tab

### v2.0.0
- ✅ Complete rewrite with Windows Forms GUI
- ✅ User-editable patch schedule
- ✅ JSON configuration persistence
- ✅ Multiple CSV output formats

See `CHANGELOG.md` for complete version history.

---

## 🤝 Contributing

Contributions are welcome! This tool is designed for the IA community. If you have suggestions, bug reports, or feature requests:

1. **Open an Issue** describing your suggestion or problem
2. **Fork the repository** if you want to contribute code
3. **Submit a Pull Request** with clear description of changes
4. **Follow PowerShell best practices** for code contributions

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Hector L. Bones**

Created for Information Assurance professionals managing DISA IAVM processing and STIG compliance workflows.

---

## 🙏 Acknowledgments

- **DISA** for providing IAVM XML schema and STIG publications
- **IA Community** for workflow feedback and requirements
- **PowerShell Community** for Windows Forms examples and best practices

---

## 📞 Support

For questions, issues, or feature requests:
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/IAVM-Processor/issues)
- **Documentation**: Check the `docs/` folder for detailed guides
- **About Tab**: Built-in documentation in the application

---

## ⚠️ Disclaimer

This tool is provided as-is for use by cybersecurity professionals. While designed to assist with IAVM processing and STIG compliance tracking, users are responsible for verifying all outputs and ensuring compliance with their organization's policies and procedures.

This tool does not replace official DISA guidance or organizational security requirements.

**IAVM files are not included.** Users must obtain IAVM XML files from DISA or authorized channels.

---

**Ready to streamline your vulnerability management workflow?**

[Download Latest Release](https://github.com/yourusername/IAVM-Processor/releases/latest) | [View Documentation](docs/) | [Report Issue](https://github.com/yourusername/IAVM-Processor/issues)
