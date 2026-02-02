# Release Notes - IAVM Processor v2.4.0

**Release Date:** January 30, 2026  
**Author:** Hector L. Bones  
**License:** MIT

---

## 🎉 What's New

### Major Features

#### Excel Analysis Template
Professional Excel dashboard with comprehensive IAVM analysis capabilities.

**Dashboard Features:**
- 5 priority metric tiles (TRB Eligible, CAT I, Aged, Total, New)
- Status distribution pie chart
- Severity breakdown bar chart  
- Automated Power Query data loading
- Conditional formatting for visual analysis
- Print-ready professional layout

**Data Sheets:**
- Complete Data (all 12 IAVM fields)
- Trends (monthly statistics over 12 months)
- TRB Focus (current cycle items)
- Priority Items (CAT I/Critical only)
- Aged Items (POA&M tracking)
- Summary (quick reference)
- Instructions (comprehensive built-in guide)

#### Enhanced Documentation
- **EXCEL_TEMPLATE_GUIDE.md** (522 lines) - Comprehensive technical reference
- **EXCEL_TEMPLATE_GUIDE.docx** (40 KB) - Print-ready Word version
- **Tools & Resources** section in About tab
- **Excel Template Usage** guide in About tab

#### Tools Integration Documentation
- Evaluate-STIG (preferred automation tool)
- SCC Tool v5.3 (public alternative)
- Tool selection guidance (decision matrix)
- STIG Viewer v2.4.0
- Integrated workflow diagram

### Improvements

- **Batch Launcher** - User-friendly `.bat` file for easy execution
- **Technical Accuracy** - Updated tool descriptions and workflows
- **Manual POA&M Tracking** - Realistically documented (no automated tool exists)
- **Realistic Workflow** - Hybrid automation + manual process clearly shown

---

## 📦 Downloads

### Complete Package

**IAVM-Processor-v2.4.0.zip** (recommended)
- All files in one package
- Ready to extract and use
- ~350 KB total size

### Individual Files

- IAVM_Processor_v2_4.ps1 (72 KB)
- Launch_IAVM_Processor_v2_4.bat (2 KB)
- IAVM_Analysis_Template.xlsx (20 KB)
- EXCEL_TEMPLATE_GUIDE.md
- EXCEL_TEMPLATE_GUIDE.docx (40 KB)
- Word documents (calendars, plans)

---

## ⬆️ Upgrade Guide

### From v2.3 to v2.4

**Compatibility:** Full backward compatibility with v2.3

**New Files:**
- IAVM_Analysis_Template.xlsx
- EXCEL_TEMPLATE_GUIDE.md
- EXCEL_TEMPLATE_GUIDE.docx
- Launch_IAVM_Processor_v2_4.bat

**Updated Files:**
- IAVM_Processor_v2_4.ps1 (replaces v2_3.ps1)
- README.md
- CHANGELOG.md

**Configuration:**
- IAVM_Config.json compatible (no changes needed)

**Migration Steps:**
1. Download v2.4.0 package
2. Extract to new folder (or replace existing files)
3. Copy your IAVM_Config.json if customized
4. Use new batch launcher or run .ps1 directly
5. Try Excel template with existing CSV files

---

## 🐛 Known Issues

- Excel template Power Query connections must be configured manually (file paths are user-specific)
- First data refresh may take 1-2 minutes for datasets with 500+ IAVMs (normal behavior)
- Monthly trend chart requires 12 months of data to populate fully

---

## 💡 Tips for New Users

### Quick Start

1. Extract all files to one folder
2. Double-click `Launch_IAVM_Processor_v2_4.bat`
3. Select source folder (IAVM XML/ZIP files)
4. Select output folder  
5. Process files and export CSVs
6. Copy Excel template to CSV folder
7. Open template and click Data → Refresh All

### Excel Template

- **CRITICAL:** Template must be in **same folder** as CSV files
- Power Query setup: One-time configuration per template
- See EXCEL_TEMPLATE_GUIDE.md for step-by-step instructions
- Built-in Instructions sheet provides quick reference

### Documentation

- **Quick Start:** README.md
- **Excel Guide:** EXCEL_TEMPLATE_GUIDE.md (comprehensive)
- **Print Version:** EXCEL_TEMPLATE_GUIDE.docx
- **Status Reference:** STATUS_FIELD_GUIDE.md
- **Version History:** CHANGELOG.md

---

## 🎯 What's Next

### Planned for v2.5

- Monthly trend line chart in Excel dashboard
- Additional severity filters
- Performance optimizations
- Enhanced error handling

### Future Roadmap

- Automated Power Query setup (if technically feasible)
- Database export options
- API integration for IAVM downloads
- Custom report templates

See [GitHub Issues](https://github.com/yourusername/iavm-processor/issues) for feature requests.

---

## 📊 Statistics

**Package Contents:**
- 1 PowerShell script (72 KB)
- 1 Batch launcher (2 KB)
- 1 Excel template (20 KB)
- 5 documentation files (MD + DOCX)
- 3 Word templates (calendars, plans)
- 1 configuration file (JSON)

**Total Size:** ~350 KB

**Documentation:**
- README: 200+ lines
- CHANGELOG: 113 lines
- Excel Guide (MD): 522 lines
- Excel Guide (DOCX): ~12 pages
- Contributing: 250+ lines

---

## 🙏 Acknowledgments

Thank you to:
- DISA for IAVM and STIG standards
- PowerShell community for frameworks
- Information Assurance professionals providing feedback
- All contributors and testers

---

## 📞 Support

**Documentation:**
- Comprehensive guides in `docs/` folder
- Built-in Instructions sheet in Excel template
- FAQ section in Excel guide

**Issues:**
- Bug reports: Use bug report template
- Feature requests: Use feature request template
- Questions: Open a discussion

**Community:**
- GitHub Issues for bugs and features
- GitHub Discussions for questions
- Pull requests welcome!

---

## ✅ Checksums

**SHA-256 Hashes:**

```
IAVM_Processor_v2_4.ps1         [hash]
Launch_IAVM_Processor_v2_4.bat  [hash]
IAVM_Analysis_Template.xlsx     [hash]
```

*(Hashes will be generated upon release)*

---

## 📜 License

This project is licensed under the MIT License.

**TL;DR:** Free to use, modify, and distribute with attribution.

See [LICENSE](LICENSE) for full details.

---

## 👤 Author

**Hector L. Bones**

Professional PowerShell tool for DISA IAVM processing, vulnerability management, and STIG compliance tracking.

---

**IAVM Processor v2.4.0** - Professional vulnerability management for IA teams

*Released: January 30, 2026*
