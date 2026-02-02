# Security Policy

**Project Author**: Hector L. Bones

## 🔐 Security Overview

The IAVM Processor is designed for use in government and enterprise sensitive environments. We take security seriously and appreciate the community's help in identifying and addressing security issues.

---

## 🛡️ Security Features

### Built-in Security Characteristics

✅ **Offline-First Design**
- No internet connectivity required
- No telemetry or external communications
- All processing happens locally

✅ **Native Windows Components**
- Uses only PowerShell 5.1 and .NET Framework
- No third-party libraries or dependencies
- Reduced attack surface

✅ **Local Data Storage**
- Configuration stored in user AppData folder
- Outputs saved to local filesystem
- No cloud storage or external databases

✅ **No Sensitive Data Hardcoding**
- No credentials or API keys in code
- No hardcoded file paths to sensitive locations
- User controls all file locations

✅ **Input Validation**
- XML parsing with error handling
- File type verification
- Path traversal protection

✅ **Excel Template Security (New in v2.4)**
- Power Query uses local file references only
- No external data connections
- Macros are not used (macro-free workbook)
- Formulas use IFERROR for safe error handling

---

## 🚨 Supported Versions

Security updates are provided for the following versions:

| Version | Supported          | Notes                          |
| ------- | ------------------ | ------------------------------ |
| 2.4.x   | ✅ Yes             | Current release                |
| 2.3.x   | ✅ Yes             | Security patches only          |
| 2.2.x   | ⚠️ Limited         | Critical security fixes only   |
| 2.1.x   | ⚠️ Limited         | Critical security fixes only   |
| 2.0.x   | ❌ No              | End of life                    |
| 1.x     | ❌ No              | Legacy Python version - EOL    |

**Recommendation**: Always use the latest version (2.4.x) for best security and features.

---

## 📋 Reporting a Vulnerability

### What Qualifies as a Security Vulnerability?

**DO report:**
- Code execution vulnerabilities
- Path traversal or directory traversal issues
- XML parsing vulnerabilities (XXE, XEE, etc.)
- Input validation bypasses
- Privilege escalation issues
- Information disclosure vulnerabilities
- Configuration file manipulation exploits
- CSV injection or formula injection vulnerabilities
- Excel template formula injection or macro exploits
- Power Query data source manipulation

**DON'T report as security issues:**
- Bugs that don't have security implications
- Feature requests
- Performance issues
- Compatibility problems
- Documentation errors

### How to Report

**⚠️ IMPORTANT: Do NOT open public GitHub issues for security vulnerabilities.**

Instead, use one of these private reporting methods:

#### Method 1: GitHub Security Advisory (Recommended)
1. Go to the [Security tab](https://github.com/yourusername/IAVM-Processor/security)
2. Click "Report a vulnerability"
3. Fill out the private advisory form
4. Submit

#### Method 2: Email
Send details to: **[security@example.com]**

**Subject line format:** `[SECURITY] IAVM Processor - Brief Description`

### Information to Include

Please provide:

1. **Vulnerability Description**
   - Clear explanation of the issue
   - Type of vulnerability (e.g., XSS, path traversal, etc.)
   - Component affected (PowerShell script, Excel template, config, etc.)

2. **Affected Versions**
   - Which versions are affected?
   - Have you tested multiple versions?

3. **Steps to Reproduce**
   - Detailed step-by-step instructions
   - Include sample files if needed (sanitized)
   - Environment details (Windows version, PowerShell version, Excel version)

4. **Proof of Concept**
   - Code snippet or exploit demonstration (if appropriate)
   - Screenshots or video (if helpful)

5. **Impact Assessment**
   - What can an attacker achieve?
   - What data or systems are at risk?
   - Severity estimate (Critical/High/Medium/Low)

6. **Suggested Fix** (Optional)
   - If you have ideas for remediation
   - Code patches are welcome

### Example Security Report

```
Subject: [SECURITY] IAVM Processor - XML External Entity (XXE) Vulnerability

Description:
The IAVM XML parser is vulnerable to XXE attacks, allowing an attacker 
to read arbitrary files from the system by crafting malicious IAVM XML files.

Affected Versions:
- Tested on v2.4.0
- Likely affects all 2.x versions

Steps to Reproduce:
1. Create malicious XML file with external entity declaration:
   [sanitized XML example]
2. Load file in IAVM Processor
3. Observer file contents in output

Impact:
An attacker with ability to provide XML files could:
- Read sensitive files from the system
- Potentially execute SSRF attacks
- Severity: HIGH

Proof of Concept:
[Attach sanitized POC file]

Suggested Fix:
Disable external entity resolution in XML parser:
[Code snippet with fix]

Reporter: [Your name/handle]
Date: [Date]
```

---

## ⏱️ Response Timeline

We aim to respond to security reports according to the following timeline:

| Stage | Timeline | Description |
|-------|----------|-------------|
| **Initial Response** | 1-3 business days | Acknowledge receipt of report |
| **Assessment** | 3-7 business days | Evaluate severity and impact |
| **Fix Development** | Varies by severity | Develop and test patch |
| **Public Disclosure** | After fix released | Coordinated disclosure |

### Severity-Based Response Times

- **Critical** (Code execution, data loss): 7-14 days
- **High** (Information disclosure, DoS): 14-30 days
- **Medium** (Limited impact): 30-60 days
- **Low** (Theoretical or minimal impact): 60-90 days

---

## 🔒 Security Best Practices for Users

### For System Administrators

1. **Keep Updated**
   - Use latest version of IAVM Processor (v2.4.x)
   - Subscribe to release notifications
   - Review changelogs for security fixes

2. **File Permissions**
   - Restrict write access to application directory
   - Secure config file location (`%APPDATA%\IAVM_Processor\`)
   - Control access to output directory
   - Protect Excel template from unauthorized modification

3. **Input Validation**
   - Only process IAVM files from trusted sources (DISA)
   - Verify file integrity if possible
   - Don't process IAVM files from untrusted sources
   - Don't open Excel templates from untrusted sources

4. **Execution Policy**
   - Use `RemoteSigned` execution policy (not `Unrestricted`)
   - Verify script signatures if possible
   - Don't run scripts from untrusted locations

5. **Excel Template Security**
   - Keep template with CSV files in controlled location
   - Don't modify Power Query connections to point to untrusted data sources
   - Review formulas before enabling if template is modified
   - Excel template is macro-free - don't enable macros if prompted

6. **Monitoring**
   - Review generated CSV files for anomalies
   - Monitor output directory for unexpected files
   - Check PowerShell logs if available
   - Review Excel template data sources periodically

### For Government/Enterprise Users

1. **Follow Organizational Policies**
   - Ensure tool is approved for use in your environment
   - Follow data handling procedures for IAVM content
   - Use appropriate network segment
   - Comply with data protection requirements for vulnerability data

2. **Secure Configuration**
   - Store config files according to data sensitivity
   - Protect CSV outputs (may contain vulnerability data)
   - Follow proper disposal procedures for old outputs
   - Secure Excel templates with organizational data

3. **Audit Trail**
   - Maintain records of IAVM processing activities
   - Track configuration changes
   - Document any customizations
   - Log Excel template data refresh activities

4. **Data Classification**
   - Treat IAVM data according to organizational classification
   - CSV outputs may contain CUI (Controlled Unclassified Information)
   - Excel dashboards with populated data should be protected accordingly
   - Follow proper sharing and transmission protocols

---

## 🔍 Known Security Considerations

### Current Limitations

1. **CSV Formula Injection**
   - CSVs may be opened in Excel
   - Formulas in CSV data could execute in spreadsheet applications
   - **Mitigation**: Review CSVs before opening, use safe viewing tools, import as text
   - **Status**: Input sanitization in consideration for future version

2. **Excel Template Formula Injection**
   - Template contains formulas for calculations
   - All formulas use IFERROR for safe error handling
   - No external data sources or macros
   - **Mitigation**: Don't modify template formulas unless you understand Excel security
   - **Status**: Template uses safe formula patterns only

3. **XML Parsing**
   - PowerShell XML parsing with standard .NET libraries
   - External entities disabled by default in PowerShell
   - Regular monitoring for XML-related vulnerabilities
   - **Status**: Following PowerShell security best practices

4. **Configuration File**
   - Stored as JSON in user AppData
   - Readable by user and system administrators
   - No encryption (contains schedule data only, no credentials)
   - **Status**: No sensitive data stored in configuration

5. **Power Query Data Sources**
   - Excel template uses Power Query to load CSV files
   - Data sources are file paths (local filesystem only)
   - No external connections, web queries, or database connections
   - **Mitigation**: Don't modify Power Query connections to point to untrusted locations
   - **Status**: Template configured for local files only

### What We Don't Store

The IAVM Processor does NOT store, transmit, or handle:
- ❌ Credentials or passwords
- ❌ Classified information (beyond IAVM content itself)
- ❌ Network traffic or telemetry
- ❌ User personal information
- ❌ System information beyond PowerShell version
- ❌ Excel macros or VBA code
- ❌ External data connections

### IAVM File Security

⚠️ **IMPORTANT**: IAVM XML files are NOT included with this tool.

Users must obtain IAVM files from:
- DISA IAVM Website: https://public.cyber.mil/announcement/disa-iavm/
- Authorized government portals
- Your organization's security distribution channels

This tool processes IAVM files but does not distribute vulnerability data. Users are responsible for protecting IAVM content according to organizational policies.

**Data Classification:**
- IAVM notices themselves are typically unclassified but may contain CUI
- Aggregated vulnerability data in CSVs and Excel dashboard may require protection
- Follow your organization's data handling procedures

---

## 🆕 Security Enhancements in v2.4.0

### Excel Template Security Features

1. **Macro-Free Design**
   - No VBA code or macros
   - No ActiveX controls
   - Reduced attack surface

2. **Formula Safety**
   - All formulas wrapped in IFERROR
   - No volatile functions that could cause performance issues
   - No external references or links

3. **Power Query Security**
   - Local file references only
   - No web queries or external connections
   - No database connections
   - User controls all data sources

4. **Data Validation**
   - Conditional formatting based on data content only
   - No user input fields that could be exploited
   - Read-only data sources (CSV files)

5. **Print Safety**
   - Headers and footers contain metadata only
   - No personally identifiable information
   - Professional formatting without security implications

### Best Practices for Excel Template

1. **Source Control**
   - Keep template in version control
   - Track any modifications
   - Verify template integrity before distribution

2. **Data Source Validation**
   - Ensure CSV files are from IAVM Processor only
   - Don't modify Power Query to load untrusted data
   - Verify data sources before refreshing

3. **Distribution**
   - Distribute clean template without populated data
   - Don't share templates with organizational vulnerability data
   - Use proper channels for template distribution

4. **Modification Safety**
   - Document any template customizations
   - Test modifications in isolated environment
   - Review formulas for security implications

---

## 📚 Security Resources

### For Users
- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/security/overview)
- [Excel Security Best Practices](https://support.microsoft.com/en-us/office/excel-security)
- [DISA STIGs for Windows](https://public.cyber.mil/stigs/)
- [CISA Cybersecurity](https://www.cisa.gov/cybersecurity)

### For Developers
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [PowerShell Security](https://docs.microsoft.com/en-us/powershell/scripting/security/)
- [Office Security](https://docs.microsoft.com/en-us/deployoffice/security/)

---

## 🏆 Security Hall of Fame

We recognize security researchers who help improve IAVM Processor security:

<!-- Will be populated as security issues are reported and fixed -->

**Contributors:**
- [Name] - [Brief description of finding] - [Date]

*Thank you to all security researchers who help keep this project secure!*

---

## 📝 Disclosure Policy

### Our Commitment

We are committed to:
1. **Timely Response** - Acknowledge reports within 3 business days
2. **Transparency** - Communicate status and timeline
3. **Credit** - Recognize researchers (with permission)
4. **Coordination** - Work with reporter on disclosure timing

### Coordinated Disclosure

We follow responsible disclosure practices:

1. **Private Reporting** - Report sent privately (not public issue)
2. **Fix Development** - We develop and test patch
3. **Coordinated Release** - Patch released with advisory
4. **Public Disclosure** - After patch is available
5. **Credit Given** - Researcher credited (with permission)

**Disclosure Timeline:**
- Security advisory published with patch release
- 90-day maximum timeline for disclosure after report
- Earlier disclosure if fix is simple and low-risk
- Delayed disclosure if critical and requires coordination

---

## ⚖️ Legal

### Safe Harbor

We support security research conducted in good faith. Researchers who:
- Follow this policy
- Report vulnerabilities responsibly
- Don't exploit vulnerabilities beyond demonstration
- Don't access or modify data without authorization

Will not face legal action from the project maintainers.

**However:** We cannot provide legal protection from:
- Other organizations' systems you may test against
- Third-party IAVM files or systems
- Your employer's policies
- Law enforcement if illegal activities are involved

### Scope

This policy covers:
✅ IAVM Processor application code (PowerShell script)
✅ Excel Analysis Template (formulas, Power Query)
✅ Documentation and examples provided
✅ Configuration files and output formats
✅ Batch launcher scripts

This policy does NOT cover:
❌ Third-party systems (DISA, Microsoft, etc.)
❌ User's own systems or networks
❌ Organizational infrastructures where tool is deployed
❌ Microsoft Excel application itself
❌ PowerShell runtime environment

---

## 📞 Contact

**Security Issues:** [security@example.com] or GitHub Security Advisory

**General Questions:** Open a [GitHub Discussion](https://github.com/yourusername/IAVM-Processor/discussions)

**Other Issues:** Open a [GitHub Issue](https://github.com/yourusername/IAVM-Processor/issues)

---

**Thank you for helping keep IAVM Processor and its users secure!** 🔒🛡️

---

## 🔄 Version History

**v2.4.0 Security Updates (January 30, 2026):**
- Added Excel template security considerations
- Documented Power Query data source safety
- Added macro-free template security features
- Enhanced data classification guidance

**v2.3.0 and earlier:** See previous versions of this file in git history

---

**Project Author**: Hector L. Bones  
**Current Version**: 2.4.0  
**Last Updated**: January 30, 2026
