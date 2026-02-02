# IAVM Processor v2.4

[![Version](https://img.shields.io/badge/version-2.4.0-blue.svg)](https://github.com/yourusername/iavm-processor/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Excel](https://img.shields.io/badge/Excel-2013+-green.svg)](https://www.microsoft.com/excel)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Professional PowerShell tool for processing DISA Information Assurance Vulnerability Management (IAVM) notices with integrated Excel dashboard for analysis and reporting.

![IAVM Processor Dashboard](docs/images/dashboard-preview.png)

---

## 🎉 What's New in v2.4.0

- **📊 Excel Analysis Template** - Professional dashboard with Power Query integration
- **📚 Enhanced Documentation** - Comprehensive user guides in Markdown and Word formats
- **🔧 Tools Integration** - Documentation for Evaluate-STIG, SCC Tool, and STIG Viewer
- **🚀 Batch Launcher** - User-friendly .bat file for easy execution

See [CHANGELOG.md](CHANGELOG.md) for complete version history.

---

## ✨ Features

### Core Functionality

- **Multi-Format Input Support**
  - IAVM XML files (single or batch)
  - ZIP archives (automatic extraction)
  - Drag-and-drop interface
  - Folder-based batch processing

- **Comprehensive Data Processing**
  - IAVM metadata extraction
  - Status classification (New, Prior, Historical, Aged)
  - TRB eligibility tracking
  - Severity analysis
  - Days-since-release calculations

- **Multiple Export Formats**
  - 6 CSV files for different use cases
  - Professional Word document calendars
  - Excel dashboard with automated refresh

### Excel Analysis Template (NEW in v2.4)

<img src="docs/images/excel-dashboard.png" width="600" alt="Excel Dashboard">

**Dashboard Features:**
- 5 priority metric tiles
- Status distribution chart
- Severity breakdown chart
- Automated data loading via Power Query
- Conditional formatting for visual analysis
- Print-ready professional layout

**6 Specialized Data Sheets:**
- Complete Data (all IAVM details)
- Trends (monthly statistics)
- TRB Focus (current cycle items)
- Priority Items (CAT I/Critical)
- Aged Items (POA&M tracking)
- Summary (quick reference)

### Professional Reporting

- **2026 Cybersecurity Calendar** - Patch Tuesday and TRB schedules
- **2026 STIG Compliance Calendar** - 5-phase lifecycle tracking
- **DISA STIG Compliance Plan** - Template for compliance documentation

---

## 🚀 Quick Start

### Prerequisites

- Windows 10 or newer
- PowerShell 5.1 or later
- Microsoft Excel 2013+ (for Excel template)
- No admin rights required

### Installation

1. **Download the latest release** from [Releases](https://github.com/yourusername/iavm-processor/releases)

2. **Extract to your preferred location:**
   ```
   C:\Tools\IAVM-Processor\
   ```

3. **Launch the application:**
   ```batch
   # Option 1: Use batch launcher (recommended)
   Launch_IAVM_Processor_v2_4.bat
   
   # Option 2: Run PowerShell script directly
   powershell.exe -ExecutionPolicy Bypass -File IAVM_Processor_v2_4.ps1
   ```

### Basic Usage

1. **Process IAVMs:**
   - Launch the tool
   - Select source directory (IAVM XML/ZIP files)
   - Select output directory
   - Click "Process Files"
   - Click "Export CSVs"

2. **Use Excel Template:**
   - Copy `IAVM_Analysis_Template.xlsx` to same folder as CSV files
   - Open template in Excel
   - Click Data → Refresh All
   - View dashboard and analyze data

📖 **For detailed instructions, see [EXCEL_TEMPLATE_GUIDE.md](docs/EXCEL_TEMPLATE_GUIDE.md)**

---

## 📦 Package Contents

```
IAVM-Processor/
├── IAVM_Processor_v2_4.ps1           # Main PowerShell script
├── Launch_IAVM_Processor_v2_4.bat   # Batch launcher
├── IAVM_Analysis_Template.xlsx      # Excel dashboard template
├── IAVM_Config.json                 # Configuration file
├── README.md                         # This file
├── CHANGELOG.md                      # Version history
├── LICENSE                           # MIT License
├── CONTRIBUTING.md                   # Contribution guidelines
├── docs/
│   ├── EXCEL_TEMPLATE_GUIDE.md      # Excel template user guide
│   ├── EXCEL_TEMPLATE_GUIDE.docx    # Excel template guide (Word)
│   ├── STATUS_FIELD_GUIDE.md        # Status classification reference
│   ├── 2026_Cybersecurity_Calendar.docx
│   ├── 2026_STIG_Compliance_Calendar.docx
│   └── DISA_STIG_Compliance_Plan.docx
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── bug_report.md
    │   └── feature_request.md
    └── workflows/
        └── release.yml
```

---

## 📊 CSV Outputs

The tool generates 6 CSV files for different analysis needs:

| File | Description | Use Case |
|------|-------------|----------|
| **Complete_IAVM_Results.csv** | All IAVMs with all fields (12 columns) | Full analysis, dashboard data source |
| **Summary_IAVM_Results.csv** | Essential fields only (5 columns) | Quick reference, email sharing |
| **Monthly_Statistics.csv** | Aggregated monthly data (7 columns) | Trend analysis, historical comparison |
| **TRB_Eligible_Items.csv** | New + Prior status items | TRB meeting preparation |
| **Priority_Items_CAT_I.csv** | CAT I and Critical severity | Risk management, urgent action |
| **Aged_Items.csv** | Items over 13 months old | POA&M tracking, compliance reporting |

---

## 🔧 Configuration

Edit `IAVM_Config.json` to customize default settings:

```json
{
  "DefaultSourceDirectory": "C:\\IAVM_Source",
  "DefaultOutputDirectory": "C:\\IAVM_Output",
  "AutoExportCSV": false,
  "EnableLogging": true,
  "DateFormat": "MM/dd/yyyy"
}
```

---

## 🛠️ Tools Integration

IAVM Processor integrates with DISA tools for complete vulnerability management:

### Automated Scanning

- **Evaluate-STIG** ⭐ (Preferred) - PowerShell-based automation, CAC required
- **SCC Tool v5.3** - Publicly available SCAP scanner

### Review & Tracking

- **STIG Viewer v2.4.0** - Manual review and validation
- **Manual POA&M Tracking** - Spreadsheets or external systems

See the About tab in the GUI for complete tool documentation and workflow diagrams.

---

## 📖 Documentation

- **[README.md](README.md)** - This file (overview and quick start)
- **[EXCEL_TEMPLATE_GUIDE.md](docs/EXCEL_TEMPLATE_GUIDE.md)** - Comprehensive Excel template documentation
- **[EXCEL_TEMPLATE_GUIDE.docx](docs/EXCEL_TEMPLATE_GUIDE.docx)** - Print-ready Word version
- **[STATUS_FIELD_GUIDE.md](docs/STATUS_FIELD_GUIDE.md)** - Status classification reference
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Areas for contribution:**
- Additional export formats
- Enhanced visualizations
- Integration with other tools
- Documentation improvements
- Bug fixes and optimizations

---

## 🐛 Issues and Feature Requests

Found a bug or have a feature request?

- **Bug Reports:** Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md)
- **Feature Requests:** Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- DISA for IAVM and STIG standards
- PowerShell community for frameworks and examples
- Organizations using this tool for feedback and requirements

---

## 📞 Support

### Documentation
- Review comprehensive guides in [docs/](docs/) folder
- Check [FAQ section](docs/EXCEL_TEMPLATE_GUIDE.md#frequently-asked-questions) in Excel guide
- Consult built-in Instructions sheet in Excel template

### Troubleshooting
- See [Troubleshooting section](docs/EXCEL_TEMPLATE_GUIDE.md#troubleshooting) in Excel guide
- Review [CHANGELOG.md](CHANGELOG.md) for known issues
- Check [closed issues](https://github.com/yourusername/iavm-processor/issues?q=is%3Aissue+is%3Aclosed) for solutions

### Community
- Open an [issue](https://github.com/yourusername/iavm-processor/issues) for questions
- Contribute via [pull request](https://github.com/yourusername/iavm-processor/pulls)

---

## 🗺️ Roadmap

### Planned Features

- [ ] Additional chart types in Excel template (line chart for trends)
- [ ] Automated Power Query connection setup
- [ ] API integration for IAVM downloads
- [ ] Database export options (SQL Server, SQLite)
- [ ] Custom report templates
- [ ] Email notification system

See [Projects](https://github.com/yourusername/iavm-processor/projects) for detailed roadmap.

---

## 📊 Statistics

![GitHub release](https://img.shields.io/github/v/release/yourusername/iavm-processor)
![GitHub downloads](https://img.shields.io/github/downloads/yourusername/iavm-processor/total)
![GitHub stars](https://img.shields.io/github/stars/yourusername/iavm-processor)
![GitHub forks](https://img.shields.io/github/forks/yourusername/iavm-processor)

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/iavm-processor&type=Date)](https://star-history.com/#yourusername/iavm-processor&Date)

---

## 👤 Author

**Hector L. Bones**

Professional PowerShell tool for DISA IAVM processing, vulnerability management, and STIG compliance tracking.

---

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

---

**IAVM Processor v2.4.0** - Professional vulnerability management for Information Assurance teams

*Last Updated: January 30, 2026*
