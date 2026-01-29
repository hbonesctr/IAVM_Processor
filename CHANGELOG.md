# Changelog

All notable changes to the IAVM Processor project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.3.0] - 2026-01-29

### 🎉 Major Features
- **STIG Compliance Integration** - Added dedicated STIG Compliance tab with quarterly lifecycle tracking (5-phase model)
- **STIG Schedule Editor** - Implemented visual DataGridView editor for quarterly STIG dates
- **Type Field Fix** - Corrected Type extraction logic to properly identify IAVA vs IAVB from IAVMNumber pattern

### ✨ Added
- STIG Compliance tab with 5-phase lifecycle visualization
- Edit STIG Schedule button with modal editor window
- STIG schedule persistence in JSON configuration file
- Quarterly calendar view showing Release, TRB, POA&M, Implementation, and Review Complete dates
- Enhanced About tab with STIG workflow documentation
- Comprehensive documentation package (3 Word documents)

### 🔧 Changed
- Updated config file structure to version 2.3 with STIGSchedule array
- Enhanced main form with 4th tab for STIG compliance
- Improved About tab content with integrated workflow explanations
- Revised Type field logic: now uses IAVMNumber prefix (IAVA-/IAVB-) instead of severity
- Updated GUI layout to accommodate STIG functionality

### 🐛 Fixed
- Type field now correctly identifies IAVA vs IAVB bulletin types
- Configuration file versioning properly handles migration from v2.2
- DataGridView column widths optimized for quarterly schedule display

### 📚 Documentation
- Added 2026_Cybersecurity_Calendar.docx (7-page professional document)
- Added 2026_STIG_Compliance_Calendar.docx (landscape poster format)
- Added DISA_STIG_Compliance_Plan.docx (strategic framework)
- Enhanced inline About tab documentation

### 🔬 Technical Details
- Config file now includes STIGSchedule with 4 quarterly entries
- Added STIG editor modal form with 5 columns (Quarter, Release, TRB, POA&M, Implementation, Review Complete)
- Implemented date calculation logic for TRB scheduling
- Added proper date formatting and validation for STIG dates

---

## [2.2.0] - 2026-01-27

### 🎉 Major Features
- **Intelligent Status Classification** - Implemented 4-tier status system (New/Prior/Historical/Aged)
- **Enhanced Processing Logic** - Improved vulnerability classification based on Patch Tuesday timeline

### ✨ Added
- Status field with automatic classification:
  - **New**: Released after most recent Patch Tuesday
  - **Prior**: Released between last 2 Patch Tuesdays
  - **Historical**: Released 2-13 months ago
  - **Aged**: Released more than 13 months ago
- Patch Tuesday calculation logic for intelligent date-based classification
- Enhanced TRB-eligible filtering using status criteria
- Additional CSV output: `IAVM_TRB_Eligible` filtered by actionable status

### 🔧 Changed
- Updated CSV generation to include new Status column
- Modified processing logic to calculate temporal relationships
- Enhanced output file organization with status-based filtering
- Improved visual feedback during processing with status indicators

### 🐛 Fixed
- Date comparison logic handles edge cases around month boundaries
- Status assignment correctly accounts for publication timing
- Processing handles IAVMs without dates gracefully

### 📚 Documentation
- Added STATUS_FIELD_GUIDE.md explaining classification methodology
- Updated RELEASE_NOTES_v2.2.md with detailed feature descriptions
- Enhanced About tab with status field explanation

---

## [2.1.0] - 2026-01-26

### ✨ Added
- Comprehensive About tab with usage instructions
- Version information display
- Contact and feedback information

### 🔧 Changed
- Standardized font sizes to 10pt across all UI elements
- Improved visual consistency throughout interface
- Enhanced tab navigation labels

### 🐛 Fixed
- **Critical**: CSV serialization issue causing output file corruption
- DataGridView column formatting for proper CSV export
- String escaping in CSV files for special characters
- Multi-line field handling in CSV output

### 🔬 Technical Details
- Implemented proper CSV escaping for quotes and commas
- Added CRLF line ending handling
- Fixed encoding issues with special characters in IAVM titles

---

## [2.0.0] - 2026-01-25

### 🎉 Major Release - Complete Rewrite

This version represents a fundamental redesign from Python to native PowerShell with Windows Forms GUI.

### ✨ Added
- **Windows Forms GUI** - Professional desktop application interface
- **3-Tab Layout**:
  - Process IAVMs: Main processing functionality
  - Patch Schedule: Visual calendar with edit capability
  - About: Documentation and help
- **Editable Patch Schedule** - DataGridView editor for all 12 months
- **JSON Configuration** - Persistent storage of user customizations
- **Multiple CSV Outputs** - 6 specialized reports:
  - Complete dataset
  - Summary view
  - Monthly statistics
  - TRB-eligible items
  - Priority items (CAT I/High)
  - Aged items (>90 days)
- **Batch Launcher** - Double-click execution script
- **Enhanced Processing**:
  - Handles both ZIP and XML files
  - Multi-file processing capability
  - Automatic output folder creation
  - Timestamped output files
  - OVAL ID extraction for SCAP integration

### 🔧 Changed
- **Complete platform migration**: Python → PowerShell 5.1
- **No external dependencies**: Eliminated Python library requirements
- **Native Windows integration**: Uses .NET Framework Forms
- **Simplified deployment**: Single PS1 file + optional BAT launcher

### ⚠️ Breaking Changes
- Not compatible with v1.x Python-based tool
- Different configuration file format (JSON vs INI)
- New output file naming convention
- Changed output directory structure

### 🗑️ Removed
- Python dependencies (lxml, pandas, zipfile)
- Requirements.txt file
- Python virtual environment setup
- Command-line only interface

### 📚 Documentation
- Created comprehensive README.md
- Added installation guide
- Included usage examples
- Documented configuration options

### 🔬 Technical Details
- PowerShell 5.1 compatible
- .NET Framework 4.5+ required
- Windows 10/11 and Server 2016+ support
- Config location: `%APPDATA%\IAVM_Processor\IAVM_Config.json`
- Output location: `C:\Temp\IAVM_Output\`

---

## [1.x] - Legacy Python Version

### Historical Note
Version 1.x was a Python-based command-line tool. Due to environment constraints with Python approvals and dependency management, the tool was completely rewritten in native PowerShell starting with v2.0.0.

**Key limitations of v1.x:**
- Required Python 3.7+ installation
- Needed pip package management
- Multiple library dependencies (lxml, pandas, openpyxl)
- Command-line interface only
- Manual configuration via INI file
- Limited to single IAVM processing

**Why the rewrite:**
- Eliminated approval friction for Python in restricted environments
- Removed dependency on external package managers
- Native Windows integration for better user experience
- Enhanced functionality with GUI
- Simplified deployment and maintenance

---

## Release Nomenclature

### Version Number Format: `MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible changes, platform migrations, architectural rewrites
- **MINOR**: New features, significant enhancements, maintains backward compatibility
- **PATCH**: Bug fixes, documentation updates, minor improvements

### Release Types

- **🎉 Major Features**: Significant new capabilities
- **✨ Added**: New functionality or components
- **🔧 Changed**: Modifications to existing features
- **🐛 Fixed**: Bug fixes and corrections
- **🗑️ Removed**: Deprecated or removed features
- **⚠️ Breaking Changes**: Changes requiring user action
- **📚 Documentation**: Documentation improvements
- **🔬 Technical Details**: Implementation specifics

---

## Upgrade Path

### From v2.2 to v2.3
- **Automatic**: Config file migrates automatically
- **Action Required**: None - fully backward compatible
- **New Features**: STIG Compliance tab (5-phase lifecycle), Type field fix
- **Config Changes**: Adds STIGSchedule array to JSON

### From v2.1 to v2.2
- **Automatic**: No config changes required
- **Action Required**: None
- **New Features**: Status field classification
- **Output Changes**: Additional Status column in CSV files

### From v2.0 to v2.1
- **Automatic**: Config compatible
- **Action Required**: None
- **New Features**: About tab, CSV fixes
- **Bug Fixes**: Critical CSV serialization fix

### From v1.x to v2.0
- **Manual Migration Required**
- **Action Required**: 
  1. Uninstall Python version
  2. Install PowerShell version
  3. Manually transfer patch schedule preferences
- **Breaking Changes**: Complete platform change
- **Recommendation**: Start fresh with default config, customize as needed

---

## Roadmap

### Planned Features (Future Versions)

#### v2.4 (Proposed)
- [ ] POA&M generation from aged items
- [ ] Email notification integration for priority IAVMs
- [ ] Custom status thresholds configuration
- [ ] Enhanced TRB report generation
- [ ] Dashboard summary metrics

#### v2.5 (Proposed)
- [ ] SCAP scan result import and correlation
- [ ] Automated OVAL ID matching with scan results
- [ ] Compliance posture visualization
- [ ] Historical trend analysis
- [ ] Export to EMASS-compatible format

#### v3.0 (Concept)
- [ ] Multi-organization support
- [ ] Database backend option (SQL Server)
- [ ] Web-based dashboard (optional)
- [ ] Role-based access control
- [ ] API endpoints for integration

### Community Feedback
Feature requests and suggestions are welcome via GitHub Issues. Priority is given to features that:
- Benefit the broader IA community
- Maintain tool simplicity and ease of use
- Don't require additional software approvals
- Align with DISA and government cybersecurity frameworks

---

## Support

For version-specific questions or issues:
- **Current Release (v2.3)**: Open a GitHub issue with `[v2.3]` tag
- **Previous Versions**: Recommend upgrading to current release
- **Legacy v1.x**: No longer supported - migrate to v2.x

---

## Contributors

**Author**: Hector L. Bones

Thank you to the IA community for feedback, testing, and feature suggestions that have shaped this tool's development.

---

**[Unreleased]** - Features in development
- See GitHub project board for work in progress
- Beta features available in development branch

[2.3.0]: https://github.com/yourusername/IAVM-Processor/releases/tag/v2.3.0
[2.2.0]: https://github.com/yourusername/IAVM-Processor/releases/tag/v2.2.0
[2.1.0]: https://github.com/yourusername/IAVM-Processor/releases/tag/v2.1.0
[2.0.0]: https://github.com/yourusername/IAVM-Processor/releases/tag/v2.0.0
