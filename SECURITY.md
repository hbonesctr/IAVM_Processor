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

---

## 🚨 Supported Versions

Security updates are provided for the following versions:

| Version | Supported          | Notes                          |
| ------- | ------------------ | ------------------------------ |
| 2.3.x   | ✅ Yes             | Current release                |
| 2.2.x   | ✅ Yes             | Security patches only          |
| 2.1.x   | ⚠️ Limited         | Critical security fixes only   |
| 2.0.x   | ⚠️ Limited         | Critical security fixes only   |
| 1.x     | ❌ No              | Legacy Python version - EOL    |

**Recommendation**: Always use the latest version (2.3.x) for best security and features.

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

2. **Affected Versions**
   - Which versions are affected?
   - Have you tested multiple versions?

3. **Steps to Reproduce**
   - Detailed step-by-step instructions
   - Include sample files if needed (sanitized)
   - Environment details (Windows version, PowerShell version)

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
- Tested on v2.3.0
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
   - Use latest version of IAVM Processor
   - Subscribe to release notifications
   - Review changelogs for security fixes

2. **File Permissions**
   - Restrict write access to application directory
   - Secure config file location (`%APPDATA%\IAVM_Processor\`)
   - Control access to output directory

3. **Input Validation**
   - Only process IAVM files from trusted sources (DISA)
   - Verify file integrity if possible
   - Don't process IAVM files from untrusted sources

4. **Execution Policy**
   - Use `RemoteSigned` execution policy (not `Unrestricted`)
   - Verify script signatures if possible
   - Don't run scripts from untrusted locations

5. **Monitoring**
   - Review generated CSV files for anomalies
   - Monitor output directory for unexpected files
   - Check PowerShell logs if available

### For Government/Enterprise Users

1. **Follow Organizational Policies**
   - Ensure tool is approved for use in your environment
   - Follow data handling procedures for IAVM content
   - Use appropriate network segment

2. **Secure Configuration**
   - Store config files according to data sensitivity
   - Protect CSV outputs (may contain vulnerability data)
   - Follow proper disposal procedures for old outputs

3. **Audit Trail**
   - Maintain records of IAVM processing activities
   - Track configuration changes
   - Document any customizations

---

## 🔍 Known Security Considerations

### Current Limitations

1. **CSV Formula Injection**
   - CSVs may be opened in Excel
   - Mitigation: Review CSVs before opening, use safe viewing tools
   - Status: Being addressed in future version

2. **XML Parsing**
   - PowerShell XML parsing with standard .NET libraries
   - External entities disabled by default in PowerShell
   - Regular monitoring for XML-related vulnerabilities

3. **Configuration File**
   - Stored as JSON in user AppData
   - Readable by user and system administrators
   - No encryption (contains schedule data only)

### What We Don't Store

The IAVM Processor does NOT store, transmit, or handle:
- ❌ Credentials or passwords
- ❌ Classified information (beyond IAVM content itself)
- ❌ Network traffic or telemetry
- ❌ User personal information
- ❌ System information beyond PowerShell version

### IAVM File Security

⚠️ **IMPORTANT**: IAVM XML files are NOT included with this tool.

Users must obtain IAVM files from:
- DISA IAVM Website: https://public.cyber.mil/announcement/disa-iavm/
- Authorized government portals
- Your organization's security distribution channels

This tool processes IAVM files but does not distribute vulnerability data. Users are responsible for protecting IAVM content according to organizational policies.

---

## 📚 Security Resources

### For Users
- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/security/overview)
- [DISA STIGs for Windows](https://public.cyber.mil/stigs/)
- [CISA Cybersecurity](https://www.cisa.gov/cybersecurity)

### For Developers
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [PowerShell Security](https://docs.microsoft.com/en-us/powershell/scripting/security/)

---

## 🏆 Security Hall of Fame

We recognize security researchers who help improve IAVM Processor security:

<!-- Will be populated as security issues are reported and fixed -->

**Contributors:**
- [Name] - [Brief description of finding] - [Date]

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
✅ IAVM Processor application code
✅ Documentation and examples provided
✅ Configuration files and output formats

This policy does NOT cover:
❌ Third-party systems (DISA, Microsoft, etc.)
❌ User's own systems or networks
❌ Organizational infrastructures where tool is deployed

---

## 📞 Contact

**Security Issues:** [security@example.com] or GitHub Security Advisory

**General Questions:** Open a [GitHub Discussion](https://github.com/yourusername/IAVM-Processor/discussions)

**Other Issues:** Open a [GitHub Issue](https://github.com/yourusername/IAVM-Processor/issues)

---

**Thank you for helping keep IAVM Processor and its users secure!** 🔒🛡️

---

**Project Author**: Hector L. Bones  
**Version**: 2.3.0  
**Last Updated**: January 29, 2026
