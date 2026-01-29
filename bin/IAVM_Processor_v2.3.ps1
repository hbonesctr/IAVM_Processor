#################################################################################################
# Author: Hector L. Bones
# Date: 2026-01-28
# IAVM Processor v2.3
# PowerShell 5.1 Compatible
# NEW in v2.3: IAVA/IAVB Type extraction, STIG Compliance tab with editable 5-phase schedule
# NEW in v2.2: Intelligent Status field based on publication date (New/Prior/Historical/Aged)
# NEW in v2.1: Fixed CSV serialization, improved readability, added About tab
# NEW in v2.0: User-editable schedule with persistence, fixed character encoding
# Processes IAVM XML files (zipped or unzipped) and generates CSV outputs with metrics

# Requires PowerShell 5.1 or higher
#Requires -Version 5.1

# Fix encoding issues
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Global variables
$Global:ProcessedIAVMs = @()
$Global:PatchSchedule = @()
$Global:STIGSchedule = @()
$Global:OutputPath = ""
$Global:SourcePath = ""
$Global:ConfigPath = Join-Path $PSScriptRoot "IAVM_Config.json"

# Function to load configuration from JSON
function Load-Configuration {
    if (Test-Path $Global:ConfigPath) {
        try {
            $config = Get-Content -Path $Global:ConfigPath -Raw | ConvertFrom-Json
            
            # Convert JSON objects back to PSCustomObjects - Patch Schedule
            $Global:PatchSchedule = @()
            foreach ($month in $config.PatchSchedule) {
                $Global:PatchSchedule += [PSCustomObject]@{
                    Month = $month.Month
                    PatchTuesday = $month.PatchTuesday
                    PriorityIAVM = $month.PriorityIAVM
                    TRB = $month.TRB
                    PatchDay = $month.PatchDay
                    ScanDay = $month.ScanDay
                }
            }
            
            # Convert JSON objects back to PSCustomObjects - STIG Schedule (5-Phase)
            $Global:STIGSchedule = @()
            if ($config.STIGSchedule) {
                foreach ($quarter in $config.STIGSchedule) {
                    $Global:STIGSchedule += [PSCustomObject]@{
                        Quarter = $quarter.Quarter
                        ReleaseDate = $quarter.ReleaseDate
                        TRBDate = $quarter.TRBDate
                        POAMReview = $quarter.POAMReview
                        ImplementationDue = $quarter.ImplementationDue
                        ReviewComplete = $quarter.ReviewComplete
                    }
                }
            } else {
                # If no STIG schedule in config, load defaults
                Load-DefaultSTIGSchedule
            }
            
            Update-StatusLabel "Configuration loaded from: $Global:ConfigPath"
            return $true
        }
        catch {
            Update-StatusLabel "Error loading configuration: $($_.Exception.Message)"
            Load-DefaultPatchSchedule
            Load-DefaultSTIGSchedule
            return $false
        }
    }
    else {
        # First time - load defaults
        Load-DefaultPatchSchedule
        Load-DefaultSTIGSchedule
        Save-Configuration
        return $true
    }
}

# Function to save configuration to JSON
function Save-Configuration {
    try {
        $config = @{
            Version = "2.3"
            LastUpdated = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            PatchSchedule = $Global:PatchSchedule
            STIGSchedule = $Global:STIGSchedule
        }
        
        $json = $config | ConvertTo-Json -Depth 10
        $json | Out-File -FilePath $Global:ConfigPath -Encoding UTF8 -Force
        
        Update-StatusLabel "Configuration saved to: $Global:ConfigPath"
        return $true
    }
    catch {
        Update-StatusLabel "Error saving configuration: $($_.Exception.Message)"
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to save configuration:`n$($_.Exception.Message)", 
            "Save Error", 
            [System.Windows.Forms.MessageBoxButtons]::OK, 
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        return $false
    }
}

# Function to load default patch schedule (2026)
function Load-DefaultPatchSchedule {
    $Global:PatchSchedule = @(
        [PSCustomObject]@{Month="January"; PatchTuesday="January 13, 2026"; PriorityIAVM="January 15, 2026"; TRB="January 20, 2026"; PatchDay="January 22, 2026"; ScanDay="January 25, 2026"},
        [PSCustomObject]@{Month="February"; PatchTuesday="February 10, 2026"; PriorityIAVM="February 12, 2026"; TRB="February 17, 2026"; PatchDay="February 19, 2026"; ScanDay="February 25, 2026"},
        [PSCustomObject]@{Month="March"; PatchTuesday="March 10, 2026"; PriorityIAVM="March 12, 2026"; TRB="March 17, 2026"; PatchDay="March 19, 2026"; ScanDay="March 25, 2026"},
        [PSCustomObject]@{Month="April"; PatchTuesday="April 14, 2026"; PriorityIAVM="April 16, 2026"; TRB="April 21, 2026"; PatchDay="April 23, 2026"; ScanDay="April 25, 2026"},
        [PSCustomObject]@{Month="May"; PatchTuesday="May 12, 2026"; PriorityIAVM="May 14, 2026"; TRB="May 19, 2026"; PatchDay="May 21, 2026"; ScanDay="May 25, 2026"},
        [PSCustomObject]@{Month="June"; PatchTuesday="June 9, 2026"; PriorityIAVM="June 11, 2026"; TRB="June 16, 2026"; PatchDay="June 18, 2026"; ScanDay="June 25, 2026"},
        [PSCustomObject]@{Month="July"; PatchTuesday="July 14, 2026"; PriorityIAVM="July 16, 2026"; TRB="July 21, 2026"; PatchDay="July 23, 2026"; ScanDay="July 25, 2026"},
        [PSCustomObject]@{Month="August"; PatchTuesday="August 11, 2026"; PriorityIAVM="August 13, 2026"; TRB="August 18, 2026"; PatchDay="August 20, 2026"; ScanDay="August 25, 2026"},
        [PSCustomObject]@{Month="September"; PatchTuesday="September 8, 2026"; PriorityIAVM="September 10, 2026"; TRB="September 15, 2026"; PatchDay="September 17, 2026"; ScanDay="September 25, 2026"},
        [PSCustomObject]@{Month="October"; PatchTuesday="October 13, 2026"; PriorityIAVM="October 15, 2026"; TRB="October 20, 2026"; PatchDay="October 22, 2026"; ScanDay="October 25, 2026"},
        [PSCustomObject]@{Month="November"; PatchTuesday="November 10, 2026"; PriorityIAVM="November 12, 2026"; TRB="November 17, 2026"; PatchDay="November 19, 2026"; ScanDay="November 25, 2026"},
        [PSCustomObject]@{Month="December"; PatchTuesday="December 8, 2026"; PriorityIAVM="December 10, 2026"; TRB="December 15, 2026"; PatchDay="December 17, 2026"; ScanDay="December 25, 2026"}
    )
}

# Function to load default STIG schedule (5-Phase Lifecycle)
function Load-DefaultSTIGSchedule {
    $Global:STIGSchedule = @(
        [PSCustomObject]@{Quarter="Q1"; ReleaseDate="January 31, 2026"; TRBDate="February 15, 2026"; POAMReview="February 28, 2026"; ImplementationDue="March 17, 2026"; ReviewComplete="April 15, 2026"},
        [PSCustomObject]@{Quarter="Q2"; ReleaseDate="April 30, 2026"; TRBDate="May 15, 2026"; POAMReview="May 30, 2026"; ImplementationDue="June 16, 2026"; ReviewComplete="July 15, 2026"},
        [PSCustomObject]@{Quarter="Q3"; ReleaseDate="July 31, 2026"; TRBDate="August 15, 2026"; POAMReview="August 30, 2026"; ImplementationDue="September 16, 2026"; ReviewComplete="October 15, 2026"},
        [PSCustomObject]@{Quarter="Q4"; ReleaseDate="October 31, 2026"; TRBDate="November 15, 2026"; POAMReview="November 30, 2026"; ImplementationDue="December 17, 2026"; ReviewComplete="January 15, 2027"}
    )
}

# Function to open schedule editor dialog
function Open-ScheduleEditor {
    # Create editor form
    $editorForm = New-Object System.Windows.Forms.Form
    $editorForm.Text = "Edit Patch Schedule"
    $editorForm.Size = New-Object System.Drawing.Size(900, 600)
    $editorForm.StartPosition = "CenterParent"
    $editorForm.FormBorderStyle = "FixedDialog"
    $editorForm.MaximizeBox = $false
    $editorForm.MinimizeBox = $false
    
    # Instructions label
    $lblInstructions = New-Object System.Windows.Forms.Label
    $lblInstructions.Location = New-Object System.Drawing.Point(20, 15)
    $lblInstructions.Size = New-Object System.Drawing.Size(850, 40)
    $lblInstructions.Text = "Edit the patch schedule dates below. Format: 'Month DD, YYYY' (e.g., January 13, 2026)`nChanges are saved automatically when you click OK."
    $editorForm.Controls.Add($lblInstructions)
    
    # Create DataGridView for schedule editing
    $dgv = New-Object System.Windows.Forms.DataGridView
    $dgv.Location = New-Object System.Drawing.Point(20, 60)
    $dgv.Size = New-Object System.Drawing.Size(850, 420)
    $dgv.AllowUserToAddRows = $false
    $dgv.AllowUserToDeleteRows = $false
    $dgv.SelectionMode = "FullRowSelect"
    $dgv.MultiSelect = $false
    $dgv.AutoSizeColumnsMode = "Fill"
    
    # Add columns
    $colMonth = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colMonth.HeaderText = "Month"
    $colMonth.ReadOnly = $true
    $colMonth.Width = 100
    $dgv.Columns.Add($colMonth)
    
    $colPatchTuesday = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colPatchTuesday.HeaderText = "Patch Tuesday"
    $colPatchTuesday.Width = 150
    $dgv.Columns.Add($colPatchTuesday)
    
    $colPriorityIAVM = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colPriorityIAVM.HeaderText = "Priority IAVM"
    $colPriorityIAVM.Width = 150
    $dgv.Columns.Add($colPriorityIAVM)
    
    $colTRB = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colTRB.HeaderText = "TRB Meeting"
    $colTRB.Width = 150
    $dgv.Columns.Add($colTRB)
    
    $colPatchDay = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colPatchDay.HeaderText = "Patch Day"
    $colPatchDay.Width = 150
    $dgv.Columns.Add($colPatchDay)
    
    $colScanDay = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colScanDay.HeaderText = "Scan Day"
    $colScanDay.Width = 150
    $dgv.Columns.Add($colScanDay)
    
    # Populate with current schedule
    foreach ($month in $Global:PatchSchedule) {
        $row = @($month.Month, $month.PatchTuesday, $month.PriorityIAVM, $month.TRB, $month.PatchDay, $month.ScanDay)
        $dgv.Rows.Add($row)
    }
    
    $editorForm.Controls.Add($dgv)
    
    # Buttons
    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Location = New-Object System.Drawing.Point(570, 500)
    $btnOK.Size = New-Object System.Drawing.Size(100, 35)
    $btnOK.Text = "OK"
    $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $editorForm.Controls.Add($btnOK)
    
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(680, 500)
    $btnCancel.Size = New-Object System.Drawing.Size(100, 35)
    $btnCancel.Text = "Cancel"
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $editorForm.Controls.Add($btnCancel)
    
    $btnResetDefaults = New-Object System.Windows.Forms.Button
    $btnResetDefaults.Location = New-Object System.Drawing.Point(20, 500)
    $btnResetDefaults.Size = New-Object System.Drawing.Size(150, 35)
    $btnResetDefaults.Text = "Reset to Defaults"
    $btnResetDefaults.Add_Click({
        $result = [System.Windows.Forms.MessageBox]::Show(
            "Are you sure you want to reset to default 2026 schedule?`nAll custom dates will be lost.", 
            "Confirm Reset", 
            [System.Windows.Forms.MessageBoxButtons]::YesNo, 
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Load-DefaultPatchSchedule
            
            # Clear and repopulate grid
            $dgv.Rows.Clear()
            foreach ($month in $Global:PatchSchedule) {
                $row = @($month.Month, $month.PatchTuesday, $month.PriorityIAVM, $month.TRB, $month.PatchDay, $month.ScanDay)
                $dgv.Rows.Add($row)
            }
        }
    })
    $editorForm.Controls.Add($btnResetDefaults)
    
    $editorForm.AcceptButton = $btnOK
    $editorForm.CancelButton = $btnCancel
    
    # Show dialog
    $result = $editorForm.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        # Validate and save changes
        $newSchedule = @()
        $hasErrors = $false
        $errorMessages = @()
        
        for ($i = 0; $i -lt $dgv.Rows.Count; $i++) {
            $row = $dgv.Rows[$i]
            $month = $row.Cells[0].Value
            
            # Validate each date
            $dates = @{
                "PatchTuesday" = $row.Cells[1].Value
                "PriorityIAVM" = $row.Cells[2].Value
                "TRB" = $row.Cells[3].Value
                "PatchDay" = $row.Cells[4].Value
                "ScanDay" = $row.Cells[5].Value
            }
            
            $validDates = @{}
            foreach ($key in $dates.Keys) {
                try {
                    $dateValue = $dates[$key]
                    if ([string]::IsNullOrWhiteSpace($dateValue)) {
                        throw "Date is empty"
                    }
                    $parsedDate = [datetime]::Parse($dateValue)
                    $validDates[$key] = $dateValue
                }
                catch {
                    $hasErrors = $true
                    $errorMessages += "$month - $key : Invalid date format"
                }
            }
            
            if (-not $hasErrors) {
                $newSchedule += [PSCustomObject]@{
                    Month = $month
                    PatchTuesday = $validDates["PatchTuesday"]
                    PriorityIAVM = $validDates["PriorityIAVM"]
                    TRB = $validDates["TRB"]
                    PatchDay = $validDates["PatchDay"]
                    ScanDay = $validDates["ScanDay"]
                }
            }
        }
        
        if ($hasErrors) {
            $errorText = "The following errors were found:`n`n" + ($errorMessages -join "`n")
            [System.Windows.Forms.MessageBox]::Show($errorText, "Validation Errors", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return $false
        }
        else {
            # Update global schedule
            $Global:PatchSchedule = $newSchedule
            
            # Save to config file
            if (Save-Configuration) {
                [System.Windows.Forms.MessageBox]::Show("Patch schedule updated successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
                
                # Refresh display
                Display-PatchSchedule
                return $true
            }
            else {
                return $false
            }
        }
    }
    
    return $false
}

# Function to open STIG schedule editor dialog
function Open-STIGScheduleEditor {
    # Create editor form
    $editorForm = New-Object System.Windows.Forms.Form
    $editorForm.Text = "Edit STIG Compliance Schedule (5-Phase Lifecycle)"
    $editorForm.Size = New-Object System.Drawing.Size(1100, 450)
    $editorForm.StartPosition = "CenterParent"
    $editorForm.FormBorderStyle = "FixedDialog"
    $editorForm.MaximizeBox = $false
    $editorForm.MinimizeBox = $false
    
    # Instructions label
    $lblInstructions = New-Object System.Windows.Forms.Label
    $lblInstructions.Location = New-Object System.Drawing.Point(20, 15)
    $lblInstructions.Size = New-Object System.Drawing.Size(1050, 40)
    $lblInstructions.Text = "Edit the 5-phase STIG compliance schedule dates below. Format: 'Month DD, YYYY' (e.g., January 31, 2026)`nChanges are saved automatically when you click OK."
    $editorForm.Controls.Add($lblInstructions)
    
    # Create DataGridView for schedule editing
    $dgv = New-Object System.Windows.Forms.DataGridView
    $dgv.Location = New-Object System.Drawing.Point(20, 60)
    $dgv.Size = New-Object System.Drawing.Size(1050, 250)
    $dgv.AllowUserToAddRows = $false
    $dgv.AllowUserToDeleteRows = $false
    $dgv.SelectionMode = "FullRowSelect"
    $dgv.MultiSelect = $false
    $dgv.AutoSizeColumnsMode = "Fill"
    
    # Add columns for 5-phase lifecycle
    $colQuarter = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colQuarter.HeaderText = "Quarter"
    $colQuarter.ReadOnly = $true
    $colQuarter.Width = 70
    $dgv.Columns.Add($colQuarter)
    
    $colRelease = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colRelease.HeaderText = "Release (T+0)"
    $colRelease.Width = 150
    $dgv.Columns.Add($colRelease)
    
    $colTRB = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colTRB.HeaderText = "TRB (T+15)"
    $colTRB.Width = 150
    $dgv.Columns.Add($colTRB)
    
    $colPOAM = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colPOAM.HeaderText = "POA&M (T+30)"
    $colPOAM.Width = 150
    $dgv.Columns.Add($colPOAM)
    
    $colImplementation = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colImplementation.HeaderText = "Impl Due (T+45)"
    $colImplementation.Width = 150
    $dgv.Columns.Add($colImplementation)
    
    $colReview = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $colReview.HeaderText = "Review (T+75)"
    $colReview.Width = 150
    $dgv.Columns.Add($colReview)
    
    # Populate with current schedule
    foreach ($quarter in $Global:STIGSchedule) {
        $row = @($quarter.Quarter, $quarter.ReleaseDate, $quarter.TRBDate, $quarter.POAMReview, $quarter.ImplementationDue, $quarter.ReviewComplete)
        $dgv.Rows.Add($row)
    }
    
    $editorForm.Controls.Add($dgv)
    
    # Buttons
    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Location = New-Object System.Drawing.Point(750, 330)
    $btnOK.Size = New-Object System.Drawing.Size(90, 30)
    $btnOK.Text = "OK"
    $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $editorForm.Controls.Add($btnOK)
    
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(850, 330)
    $btnCancel.Size = New-Object System.Drawing.Size(90, 30)
    $btnCancel.Text = "Cancel"
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $editorForm.Controls.Add($btnCancel)
    
    $btnReset = New-Object System.Windows.Forms.Button
    $btnReset.Location = New-Object System.Drawing.Point(950, 330)
    $btnReset.Size = New-Object System.Drawing.Size(120, 30)
    $btnReset.Text = "Reset to Defaults"
    $btnReset.Add_Click({
        $result = [System.Windows.Forms.MessageBox]::Show(
            "This will reset the STIG schedule to 2026 default dates. Continue?",
            "Reset to Defaults",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )
        
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Load-DefaultSTIGSchedule
            Save-Configuration
            Display-STIGSchedule
            $editorForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $editorForm.Close()
        }
    })
    $editorForm.Controls.Add($btnReset)
    
    $editorForm.AcceptButton = $btnOK
    $editorForm.CancelButton = $btnCancel
    
    $result = $editorForm.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        # Validate and save changes
        $newSchedule = @()
        $hasErrors = $false
        $errorMessages = @()
        
        for ($i = 0; $i -lt $dgv.Rows.Count; $i++) {
            $row = $dgv.Rows[$i]
            $quarter = $row.Cells[0].Value
            
            $dates = @{
                "Release Date" = $row.Cells[1].Value
                "TRB Date" = $row.Cells[2].Value
                "POA&M Review" = $row.Cells[3].Value
                "Implementation Due" = $row.Cells[4].Value
                "Review Complete" = $row.Cells[5].Value
            }
            
            $validDates = @{}
            foreach ($key in $dates.Keys) {
                $dateValue = $dates[$key]
                try {
                    $parsedDate = [datetime]::Parse($dateValue)
                    $validDates[$key] = $dateValue
                }
                catch {
                    $hasErrors = $true
                    $errorMessages += "$quarter - $key : Invalid date format"
                }
            }
            
            if ($validDates.Count -eq 5) {
                $newSchedule += [PSCustomObject]@{
                    Quarter = $quarter
                    ReleaseDate = $validDates["Release Date"]
                    TRBDate = $validDates["TRB Date"]
                    POAMReview = $validDates["POA&M Review"]
                    ImplementationDue = $validDates["Implementation Due"]
                    ReviewComplete = $validDates["Review Complete"]
                }
            }
        }
        
        if ($hasErrors) {
            $errorMessage = "The following errors were found:`n`n" + ($errorMessages -join "`n")
            [System.Windows.Forms.MessageBox]::Show($errorMessage, "Validation Errors", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return $false
        }
        else {
            # Update global schedule
            $Global:STIGSchedule = $newSchedule
            
            # Save to config file
            if (Save-Configuration) {
                [System.Windows.Forms.MessageBox]::Show("STIG schedule updated successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
                
                # Refresh display
                Display-STIGSchedule
                return $true
            }
            else {
                return $false
            }
        }
    }
    
    return $false
}

# Function to calculate last Thursday
function Get-LastThursday {
    param([datetime]$FromDate = (Get-Date))
    
    # Calculate days to subtract to get to last Thursday
    $daysToSubtract = switch ($FromDate.DayOfWeek) {
        'Thursday'  { 0 }  # Today is Thursday
        'Friday'    { 1 }  # Yesterday was Thursday
        'Saturday'  { 2 }
        'Sunday'    { 3 }
        'Monday'    { 4 }
        'Tuesday'   { 5 }
        'Wednesday' { 6 }
    }
    
    return $FromDate.AddDays(-$daysToSubtract).Date
}

# Function to determine IAVM status based on release date
function Get-IAVMStatus {
    param([datetime]$ReleaseDate)
    
    $today = (Get-Date).Date
    $lastThursday = Get-LastThursday
    $twoWeeksAgo = $today.AddDays(-14)
    $fourWeeksAgo = $today.AddDays(-28)
    
    # Multi-tier status logic
    # New/Received: Since last Thursday
    # Prior Publication: 1-2 weeks old
    # Historical: 2-4 weeks old
    # Aged: 30+ days old
    if ($ReleaseDate.Date -ge $lastThursday) {
        return "New/Received"
    }
    elseif ($ReleaseDate.Date -ge $twoWeeksAgo) {
        return "Prior Publication"
    }
    elseif ($ReleaseDate.Date -ge $fourWeeksAgo) {
        return "Historical"
    }
    else {
        return "Aged"
    }
}

# Function to unzip files
function Unzip-Files {
    param (
        [string]$SourceDir,
        [string]$TempDir
    )
    
    $zipFiles = Get-ChildItem -Path $SourceDir -Filter "*.zip" -File
    $unzipCount = 0
    
    foreach ($zipFile in $zipFiles) {
        try {
            $destFolder = Join-Path $TempDir $zipFile.BaseName
            if (-not (Test-Path $destFolder)) {
                New-Item -Path $destFolder -ItemType Directory -Force | Out-Null
            }
            
            Expand-Archive -Path $zipFile.FullName -DestinationPath $destFolder -Force
            $unzipCount++
            Update-StatusLabel "Unzipped: $($zipFile.Name)"
        }
        catch {
            Update-StatusLabel "Error unzipping $($zipFile.Name): $($_.Exception.Message)"
        }
    }
    
    return $unzipCount
}

# Function to parse IAVM XML
function Parse-IAVMXML {
    param (
        [string]$XmlPath
    )
    
    try {
        [xml]$xml = Get-Content -Path $XmlPath -Encoding UTF8
        $ns = @{iavm = "http://iavm.csd.disa.mil/schemas/IavmNoticeSchema/1.2"}
        
        # Helper function to safely get XML value
        function Get-XmlValue {
            param($XPath, $Default = "")
            $node = Select-Xml -Xml $xml -XPath $XPath -Namespace $ns
            if ($node) { return $node.Node.InnerText } else { return $Default }
        }
        
        # Extract CVEs from techOverview
        $cveList = @()
        $techOverview = Select-Xml -Xml $xml -XPath "//iavm:techOverview/iavm:entry/iavm:title" -Namespace $ns
        if ($techOverview) {
            $cveList = $techOverview | ForEach-Object { $_.Node.InnerText }
        }
        
        # Extract supersedes list
        $supersedes = @()
        $supersedesNodes = Select-Xml -Xml $xml -XPath "//iavm:supersedes" -Namespace $ns
        if ($supersedesNodes) {
            $supersedes = $supersedesNodes | ForEach-Object { $_.Node.InnerText }
        }
        
        # Parse dates
        $releaseDate = Get-XmlValue "//iavm:releaseDate"
        $releaseDateObj = if ($releaseDate) { [datetime]::Parse($releaseDate) } else { Get-Date }
        
        # Calculate metrics
        $ageInDays = [math]::Round(((Get-Date) - $releaseDateObj).TotalDays)
        $knownExploits = (Get-XmlValue "//iavm:knownExploits" "false").ToUpper()
        
        # Calculate priority
        $priority = if ($knownExploits -eq "TRUE") { "CRITICAL" }
                    elseif ($ageInDays -gt 30) { "HIGH" }
                    elseif ($ageInDays -gt 14) { "MEDIUM" }
                    else { "LOW" }
        
        # Get month name
        $monthName = $releaseDateObj.ToString("MMMM")
        
        # Get week number
        $weekNum = (Get-Culture).Calendar.GetWeekOfYear($releaseDateObj, [System.Globalization.CalendarWeekRule]::FirstDay, [DayOfWeek]::Sunday)
        
        # Determine if priority IAVM (released after Patch Tuesday)
        $monthSchedule = $Global:PatchSchedule | Where-Object { $_.Month -eq $monthName }
        $isPriority = $false
        if ($monthSchedule) {
            $patchTuesday = [datetime]::Parse($monthSchedule.PatchTuesday)
            $isPriority = $releaseDateObj -gt $patchTuesday
        }
        
        # Determine TRB eligibility
        $currentMonth = (Get-Date).ToString("MMMM")
        $trbEligible = if ($monthName -ne $currentMonth) {
            "OLD - TRB Eligible"
        }
        elseif ($isPriority -eq $false) {
            "Current Month - TRB Eligible"
        }
        else {
            "Post-Priority - Next TRB"
        }
        
        # Extract IAVM Number first to determine Type
        $iavmNumber = [string](Get-XmlValue "//iavm:iavmNoticeNumber")
        
        # Determine Type from IAVM Number pattern (YYYY-A- or YYYY-B-)
        $iavmType = if ($iavmNumber -match '-A-') { 
            "IAVA" 
        } elseif ($iavmNumber -match '-B-') { 
            "IAVB" 
        } else { 
            "Unknown" 
        }
        
        # Create IAVM object
        $iavm = [PSCustomObject]@{
            IAVMNumber = $iavmNumber
            Title = [string](Get-XmlValue "//iavm:title")
            Type = $iavmType
            State = [string](Get-XmlValue "//iavm:state")
            ReleaseDate = $releaseDate
            Month = $monthName
            Year = $releaseDateObj.Year
            ReleaseWeek = $weekNum
            Severity = "CAT " + [string](Get-XmlValue "//iavm:stigFindingSeverity" "3")
            KnownExploits = $knownExploits
            KnownDodIncidents = (Get-XmlValue "//iavm:knownDodIncidents" "false").ToUpper()
            AffectedSystems = [string]((Get-XmlValue "//iavm:vulnAppsSysAndCntrmsrs").Replace("<br>", "; ").Replace("&lt;br&gt;", "; ").Trim())
            Status = Get-IAVMStatus -ReleaseDate $releaseDateObj
            PriorityLevel = $priority
            AgeDays = $ageInDays
            IsPriorityIAVM = $isPriority
            TRBEligible = $trbEligible
            PrecoordDue = [string](Get-XmlValue "//iavm:precoordDueDate")
            AcknowledgeDue = [string](Get-XmlValue "//iavm:acknowledgeDate")
            FirstReportDue = [string](Get-XmlValue "//iavm:firstReportDate")
            POAMMitigationDue = [string](Get-XmlValue "//iavm:poamMitigationDate")
            SupersededBy = [string](Get-XmlValue "//iavm:supersededBy")
            SupersedesList = ($supersedes -join ", ")
            FixAction = [string](Get-XmlValue "//iavm:fixAction")
            CVEs = ($cveList -join ", ")
            CVECount = $cveList.Count
            ImplementationDate = ""
            ComplianceStatus = "Pending"
            Notes = ""
            XmlUrl = [string](Get-XmlValue "//iavm:xmlUrl")
            HtmlUrl = [string](Get-XmlValue "//iavm:htmlUrl")
            SourceFile = Split-Path $XmlPath -Leaf
        }
        
        return $iavm
    }
    catch {
        Update-StatusLabel "Error parsing $XmlPath : $($_.Exception.Message)"
        return $null
    }
}

# Function to process all XML files
function Process-IAVMFiles {
    param (
        [string]$SourceDir,
        [System.Windows.Forms.ProgressBar]$ProgressBar,
        [System.Windows.Forms.Label]$StatusLabel
    )
    
    $Global:ProcessedIAVMs = @()
    
    # Create temp directory for unzipped files
    $tempDir = Join-Path $env:TEMP "IAVM_Temp_$(Get-Date -Format 'yyyyMMddHHmmss')"
    New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
    
    Update-StatusLabel "Checking for ZIP files..."
    $unzipCount = Unzip-Files -SourceDir $SourceDir -TempDir $tempDir
    
    if ($unzipCount -gt 0) {
        Update-StatusLabel "Unzipped $unzipCount ZIP file(s)"
    }
    
    # Get all XML files (including from unzipped folders)
    $xmlFiles = Get-ChildItem -Path $SourceDir, $tempDir -Filter "*.xml" -File -Recurse -ErrorAction SilentlyContinue
    
    if ($xmlFiles.Count -eq 0) {
        Update-StatusLabel "No XML files found in source directory or ZIP files"
        [System.Windows.Forms.MessageBox]::Show("No IAVM XML files found.`nPlease check the source directory.", "No Files", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    Update-StatusLabel "Found $($xmlFiles.Count) XML file(s)"
    
    $ProgressBar.Maximum = $xmlFiles.Count
    $ProgressBar.Value = 0
    
    $processedCount = 0
    foreach ($xmlFile in $xmlFiles) {
        $iavm = Parse-IAVMXML -XmlPath $xmlFile.FullName
        
        if ($iavm) {
            $Global:ProcessedIAVMs += $iavm
            $processedCount++
        }
        
        $ProgressBar.Value++
        Update-StatusLabel "Processing: $($xmlFile.Name) ($processedCount/$($xmlFiles.Count))"
        [System.Windows.Forms.Application]::DoEvents()
    }
    
    # Cleanup temp directory
    try {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    catch {
        # Ignore cleanup errors
    }
    
    Update-StatusLabel "Processing complete: $processedCount IAVMs processed"
}

# Function to update status label
function Update-StatusLabel {
    param([string]$Message)
    
    if ($script:StatusLabel) {
        $script:StatusLabel.Text = $Message
        [System.Windows.Forms.Application]::DoEvents()
    }
}

# Function to generate CSV outputs
function Generate-CSVOutputs {
    param (
        [string]$OutputDir
    )
    
    if ($Global:ProcessedIAVMs.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No IAVM data to export.`nPlease process files first.", "No Data", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return $false
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    try {
        # 1. Main IAVM Data CSV
        $mainCsvPath = Join-Path $OutputDir "IAVM_Data_$timestamp.csv"
        $Global:ProcessedIAVMs | Export-Csv -Path $mainCsvPath -NoTypeInformation -Encoding UTF8
        Update-StatusLabel "Exported: IAVM_Data_$timestamp.csv"
        
        # 2. Summary Metrics CSV
        $summaryCsvPath = Join-Path $OutputDir "IAVM_Summary_Metrics_$timestamp.csv"
        $summary = [PSCustomObject]@{
            TotalIAVMs = $Global:ProcessedIAVMs.Count
            TypeA = ($Global:ProcessedIAVMs | Where-Object { $_.Type -eq "A" }).Count
            TypeB = ($Global:ProcessedIAVMs | Where-Object { $_.Type -eq "B" }).Count
            Critical = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "CRITICAL" }).Count
            High = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "HIGH" }).Count
            Medium = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "MEDIUM" }).Count
            Low = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "LOW" }).Count
            CAT1 = ($Global:ProcessedIAVMs | Where-Object { $_.Severity -eq "CAT 1" }).Count
            CAT2 = ($Global:ProcessedIAVMs | Where-Object { $_.Severity -eq "CAT 2" }).Count
            CAT3 = ($Global:ProcessedIAVMs | Where-Object { $_.Severity -eq "CAT 3" }).Count
            KnownExploits = ($Global:ProcessedIAVMs | Where-Object { $_.KnownExploits -eq "TRUE" }).Count
            TRBEligible = ($Global:ProcessedIAVMs | Where-Object { $_.TRBEligible -like "*TRB Eligible" }).Count
            AvgAgeDays = [math]::Round(($Global:ProcessedIAVMs | Measure-Object -Property AgeDays -Average).Average, 1)
            MaxAgeDays = ($Global:ProcessedIAVMs | Measure-Object -Property AgeDays -Maximum).Maximum
            GeneratedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        $summary | Export-Csv -Path $summaryCsvPath -NoTypeInformation -Encoding UTF8
        Update-StatusLabel "Exported: IAVM_Summary_Metrics_$timestamp.csv"
        
        # 3. Monthly Distribution CSV
        $monthCsvPath = Join-Path $OutputDir "IAVM_By_Month_$timestamp.csv"
        $monthlyData = $Global:ProcessedIAVMs | Group-Object -Property Month | ForEach-Object {
            [PSCustomObject]@{
                Month = $_.Name
                Count = $_.Count
            }
        }
        $monthlyData | Export-Csv -Path $monthCsvPath -NoTypeInformation -Encoding UTF8
        Update-StatusLabel "Exported: IAVM_By_Month_$timestamp.csv"
        
        # 4. TRB Eligible CSV
        $trbCsvPath = Join-Path $OutputDir "IAVM_TRB_Eligible_$timestamp.csv"
        $trbData = $Global:ProcessedIAVMs | Where-Object { $_.TRBEligible -like "*TRB Eligible" } | 
            Select-Object IAVMNumber, Title, Severity, ReleaseDate, AgeDays, PriorityLevel, TRBEligible, Status, KnownExploits, CVEs
        $trbData | Export-Csv -Path $trbCsvPath -NoTypeInformation -Encoding UTF8
        Update-StatusLabel "Exported: IAVM_TRB_Eligible_$timestamp.csv"
        
        # 5. Priority Items CSV
        $priorityCsvPath = Join-Path $OutputDir "IAVM_Priority_Items_$timestamp.csv"
        $priorityData = $Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -in @("CRITICAL", "HIGH") } | 
            Sort-Object @{Expression = {$_.PriorityLevel -eq "CRITICAL"}; Descending = $true}, AgeDays -Descending
        $priorityData | Export-Csv -Path $priorityCsvPath -NoTypeInformation -Encoding UTF8
        Update-StatusLabel "Exported: IAVM_Priority_Items_$timestamp.csv"
        
        # 6. Patch Schedule CSV
        $scheduleCsvPath = Join-Path $OutputDir "Patch_Schedule_$(($Global:PatchSchedule[0].PatchTuesday -split ' ')[-1]).csv"
        $Global:PatchSchedule | Export-Csv -Path $scheduleCsvPath -NoTypeInformation -Encoding UTF8
        Update-StatusLabel "Exported: Patch_Schedule CSV"
        
        Update-StatusLabel "All CSV files exported successfully"
        return $true
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error generating CSV files:`n$($_.Exception.Message)", "Export Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return $false
    }
}

# Function to display results in text box
function Display-Results {
    if ($Global:ProcessedIAVMs.Count -eq 0) {
        $script:ResultsTextBox.Text = "No IAVMs processed yet."
        return
    }
    
    # Calculate statistics
    $total = $Global:ProcessedIAVMs.Count
    $typeA = ($Global:ProcessedIAVMs | Where-Object { $_.Type -eq "A" }).Count
    $typeB = ($Global:ProcessedIAVMs | Where-Object { $_.Type -eq "B" }).Count
    $critical = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "CRITICAL" }).Count
    $high = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "HIGH" }).Count
    $medium = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "MEDIUM" }).Count
    $low = ($Global:ProcessedIAVMs | Where-Object { $_.PriorityLevel -eq "LOW" }).Count
    $cat1 = ($Global:ProcessedIAVMs | Where-Object { $_.Severity -eq "CAT 1" }).Count
    $cat2 = ($Global:ProcessedIAVMs | Where-Object { $_.Severity -eq "CAT 2" }).Count
    $cat3 = ($Global:ProcessedIAVMs | Where-Object { $_.Severity -eq "CAT 3" }).Count
    $exploits = ($Global:ProcessedIAVMs | Where-Object { $_.KnownExploits -eq "TRUE" }).Count
    $avgAge = [math]::Round(($Global:ProcessedIAVMs | Measure-Object -Property AgeDays -Average).Average, 1)
    $maxAge = ($Global:ProcessedIAVMs | Measure-Object -Property AgeDays -Maximum).Maximum
    $trbEligible = ($Global:ProcessedIAVMs | Where-Object { $_.TRBEligible -like "*TRB Eligible" }).Count
    
    # Monthly breakdown
    $monthlyBreakdown = $Global:ProcessedIAVMs | Group-Object -Property Month | Sort-Object Name | ForEach-Object {
        "    $($_.Name.PadRight(12)) $($_.Count)"
    }
    
    $resultsText = @"
================================================================
                   IAVM PROCESSING RESULTS
================================================================

SUMMARY METRICS
----------------------------------------------------------------
Total IAVMs Processed:              $total
    - Type A (IAVMs):               $typeA
    - Type B (IAVMs):               $typeB

PRIORITY BREAKDOWN
----------------------------------------------------------------
    CRITICAL (exploits exist):      $critical
    HIGH (>30 days):                $high
    MEDIUM (>14 days):              $medium
    LOW (<=14 days):                $low

SEVERITY BREAKDOWN
----------------------------------------------------------------
    CAT 1 (High):                   $cat1
    CAT 2 (Medium):                 $cat2
    CAT 3 (Low):                    $cat3

AGE METRICS
----------------------------------------------------------------
    Average Age:                    $avgAge days
    Maximum Age:                    $maxAge days

OTHER METRICS
----------------------------------------------------------------
    Known Exploits:                 $exploits
    TRB Eligible IAVMs:             $trbEligible

MONTHLY DISTRIBUTION
----------------------------------------------------------------
$($monthlyBreakdown -join "`n")

================================================================
CSV FILES GENERATED
================================================================
The following files have been created in your output directory:

  1. IAVM_Data_[timestamp].csv
     Complete IAVM dataset with all 33 fields

  2. IAVM_Summary_Metrics_[timestamp].csv
     Aggregated statistics and summary metrics

  3. IAVM_By_Month_[timestamp].csv
     Monthly distribution breakdown

  4. IAVM_TRB_Eligible_[timestamp].csv
     Pre-filtered items ready for TRB review

  5. IAVM_Priority_Items_[timestamp].csv
     Critical and High priority items only

  6. Patch_Schedule_[year].csv
     Full year organizational patch calendar

================================================================
NEXT STEPS
================================================================
1. Review priority items (Critical and High)
2. Import IAVM_Data CSV into your Excel tracker
3. Update status as items are addressed
4. Prepare TRB_Eligible CSV for upcoming meeting

================================================================
"@
    
	## Replaced    $script:ResultsTextBox.Text = $resultsText
	# FIX: Force Windows-style line endings for the TextBox
    $script:ResultsTextBox.Text = $resultsText -replace "`n", "`r`n"
	}

# Function to display patch schedule
function Display-PatchSchedule {
    $scheduleText = @"
===============================================================
            2026 ORGANIZATIONAL PATCH SCHEDULE
===============================================================

"@
    
    foreach ($month in $Global:PatchSchedule) {
        $scheduleText += @"
MONTH: $($month.Month.ToUpper())
---------------------------------------------------------------
  Patch Tuesday:     $($month.PatchTuesday)
  Priority IAVM:     $($month.PriorityIAVM)
  TRB Meeting:       $($month.TRB)
  Patch Day:         $($month.PatchDay)
  Scan Day:          $($month.ScanDay)

"@
    }
    
    $scheduleText += @"
===============================================================
KEY DEFINITIONS
===============================================================
Patch Tuesday:    Microsoft's monthly patch release
                  (2nd Tuesday of each month)

Priority IAVM:    IAVMs released AFTER Patch Tuesday
                  (Thursday following Patch Tuesday)

TRB Meeting:      Technical Review Board meeting
                  (3rd Tuesday of each month)

Patch Day:        Organizational patch implementation day
                  (3rd Thursday of each month)

Scan Day:         Monthly compliance scan execution
                  (25th of each month)

TRB ELIGIBILITY CRITERIA:
  1. Old IAVMs from previous months (not yet patched)
  2. IAVMs released in first 2 weeks of current month
===============================================================
"@
    
## Replaced    $script:ScheduleTextBox.Text = $scheduleText

# FIX: Force Windows-style line endings for the TextBox
    $script:ScheduleTextBox.Text = $scheduleText -replace "`n", "`r`n"

}

# Function to display STIG compliance schedule
function Display-STIGSchedule {
    $stigText = @"
================================================================
            DISA STIG COMPLIANCE CALENDAR - 2026
        Security Configuration 5-Phase Review Lifecycle
================================================================

QUARTERLY STIG LIFECYCLE OVERVIEW (5-Phase, 75-Day Model)
----------------------------------------------------------------
Each STIG release follows a structured 5-phase, 75-day lifecycle:

  Phase 1 (T+0 to T+15):  Release & Initial Assessment
     Phase 1a: Create or Update Benchmarks to New Checklist
     Phase 1b: Review Open Findings and Update Finding Notes

  Phase 2 (T+15 to T+30): TRB Approval for Changes
     Present Changes to Technical Review Board
     Obtain Approvals for Implementation Plan

  Phase 3 (T+30 to T+45): Plan of Actions & Milestones Review
     New Benchmark Creation
     Create New POA&Ms
     Update Existing POA&Ms

  Phase 4 (T+45 to T+75): SME Deep Dive & Implementation
     Full Configuration Review Against New Benchmark
     System Hardening Implementation
     Compliance Validation

  Phase 5 (Ongoing):      90-Day Continuous Compliance
     Regular Configuration Reviews
     Deviation Tracking
     Remediation of Findings
     Continuous Monitoring


"@
    
    foreach ($quarter in $Global:STIGSchedule) {
        $stigText += @"
$($quarter.Quarter) LIFECYCLE (5-Phase Implementation)
----------------------------------------------------------------
  $($quarter.ReleaseDate)
    DISA releases $($quarter.Quarter) STIG package (Phase 1 Start)
    SMEs begin initial assessment
    Benchmarks created/updated

  $($quarter.TRBDate) (Phase 2)
    STIG TRB Meeting - Approval for Changes
    Board approves implementation plan
    Resource allocation confirmed

  $($quarter.POAMReview) (Phase 3)
    POA&M Review Complete
    New benchmarks finalized
    POA&Ms created/updated

  $($quarter.ImplementationDue) (Phase 4)
    SME Deep Dive & Implementation Due
    System hardening completed
    Compliance validation performed

  $($quarter.ReviewComplete) (Phase 5 Start)
    $($quarter.Quarter) STIG Review Complete
    All systems aligned with new benchmark
    90-day continuous compliance begins


"@
    }
    
    $stigText += @"
INTEGRATION WITH PATCH CYCLE
----------------------------------------------------------------
  Monthly Patch & IAVM TRB:  3rd Tuesday (Tactical)
  Quarterly STIG TRB:        Mid-month following release (Strategic)

  Note: STIG TRBs are scheduled to allow 15 days for initial
        assessment (Phase 1) before presenting to the board.


KEY DATES SUMMARY - 2026 (5-Phase Model)
----------------------------------------------------------------
  STIG Release Dates (Phase 1 - T+0):
"@
    
    foreach ($quarter in $Global:STIGSchedule) {
        $stigText += "    $($quarter.ReleaseDate.PadRight(20)) ($($quarter.Quarter) Release)`n"
    }
    
    $stigText += @"

  TRB Approval Dates (Phase 2 - T+15):
"@
    
    foreach ($quarter in $Global:STIGSchedule) {
        $stigText += "    $($quarter.TRBDate.PadRight(20)) ($($quarter.Quarter) TRB)`n"
    }
    
    $stigText += @"

  POA&M Review Dates (Phase 3 - T+30):
"@
    
    foreach ($quarter in $Global:STIGSchedule) {
        $stigText += "    $($quarter.POAMReview.PadRight(20)) ($($quarter.Quarter) POA&M)`n"
    }
    
    $stigText += @"

  Implementation Due Dates (Phase 4 - T+45):
"@
    
    foreach ($quarter in $Global:STIGSchedule) {
        $stigText += "    $($quarter.ImplementationDue.PadRight(20)) ($($quarter.Quarter) Implementation)`n"
    }
    
    $stigText += @"

  Review Completion Dates (Phase 5 - T+75):
"@
    
    foreach ($quarter in $Global:STIGSchedule) {
        $stigText += "    $($quarter.ReviewComplete.PadRight(20)) ($($quarter.Quarter) Complete)`n"
    }
    
    $stigText += @"


================================================================
   For questions about STIG compliance, consult with your
   Information Assurance team or Security Configuration SMEs.
   
   Author: Hector L. Bones | Version: 2.3.0
================================================================
"@
    
    # FIX: Force Windows-style line endings for the TextBox
    $script:STIGTextBox.Text = $stigText -replace "`n", "`r`n"
}

# Alias for consistency with button call
function Update-STIGDisplay {
    Display-STIGSchedule
}

# Create main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "IAVM Processor v2.3"
$form.Size = New-Object System.Drawing.Size(1000, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Create TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(10, 10)
$tabControl.Size = New-Object System.Drawing.Size(965, 640)
$form.Controls.Add($tabControl)

# ===== TAB 1: Process IAVMs =====
$tabProcess = New-Object System.Windows.Forms.TabPage
$tabProcess.Text = "Process IAVMs"
$tabControl.Controls.Add($tabProcess)

# Source Directory
$lblSource = New-Object System.Windows.Forms.Label
$lblSource.Location = New-Object System.Drawing.Point(20, 20)
$lblSource.Size = New-Object System.Drawing.Size(120, 20)
$lblSource.Text = "Source Directory:"
$tabProcess.Controls.Add($lblSource)

$txtSource = New-Object System.Windows.Forms.TextBox
$txtSource.Location = New-Object System.Drawing.Point(20, 45)
$txtSource.Size = New-Object System.Drawing.Size(680, 25)
$txtSource.ReadOnly = $true
$tabProcess.Controls.Add($txtSource)

$btnBrowseSource = New-Object System.Windows.Forms.Button
$btnBrowseSource.Location = New-Object System.Drawing.Point(710, 43)
$btnBrowseSource.Size = New-Object System.Drawing.Size(100, 25)
$btnBrowseSource.Text = "Browse..."
$tabProcess.Controls.Add($btnBrowseSource)

# Output Directory
$lblOutput = New-Object System.Windows.Forms.Label
$lblOutput.Location = New-Object System.Drawing.Point(20, 80)
$lblOutput.Size = New-Object System.Drawing.Size(120, 20)
$lblOutput.Text = "Output Directory:"
$tabProcess.Controls.Add($lblOutput)

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Location = New-Object System.Drawing.Point(20, 105)
$txtOutput.Size = New-Object System.Drawing.Size(680, 25)
$txtOutput.ReadOnly = $true
$tabProcess.Controls.Add($txtOutput)

$btnBrowseOutput = New-Object System.Windows.Forms.Button
$btnBrowseOutput.Location = New-Object System.Drawing.Point(710, 103)
$btnBrowseOutput.Size = New-Object System.Drawing.Size(100, 25)
$btnBrowseOutput.Text = "Browse..."
$tabProcess.Controls.Add($btnBrowseOutput)

# Process Button
$btnProcess = New-Object System.Windows.Forms.Button
$btnProcess.Location = New-Object System.Drawing.Point(820, 43)
$btnProcess.Size = New-Object System.Drawing.Size(120, 30)
$btnProcess.Text = "Process Files"
$btnProcess.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$btnProcess.BackColor = [System.Drawing.Color]::LightGreen
$tabProcess.Controls.Add($btnProcess)

# Export Button
$btnExport = New-Object System.Windows.Forms.Button
$btnExport.Location = New-Object System.Drawing.Point(820, 83)
$btnExport.Size = New-Object System.Drawing.Size(120, 30)
$btnExport.Text = "Export CSVs"
$btnExport.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$btnExport.BackColor = [System.Drawing.Color]::LightBlue
$tabProcess.Controls.Add($btnExport)

# Progress Bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 145)
$progressBar.Size = New-Object System.Drawing.Size(920, 25)
$tabProcess.Controls.Add($progressBar)

# Status Label
$script:StatusLabel = New-Object System.Windows.Forms.Label
$script:StatusLabel.Location = New-Object System.Drawing.Point(20, 180)
$script:StatusLabel.Size = New-Object System.Drawing.Size(920, 20)
$script:StatusLabel.Text = "Ready. Select source directory and click 'Process Files'."
$tabProcess.Controls.Add($script:StatusLabel)

# Results TextBox
$script:ResultsTextBox = New-Object System.Windows.Forms.TextBox
$script:ResultsTextBox.Location = New-Object System.Drawing.Point(20, 210)
$script:ResultsTextBox.Size = New-Object System.Drawing.Size(920, 380)
$script:ResultsTextBox.Multiline = $true
$script:ResultsTextBox.ScrollBars = "Vertical"
$script:ResultsTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$script:ResultsTextBox.ReadOnly = $true
$script:ResultsTextBox.Text = "No results yet. Process files to see summary statistics."
$tabProcess.Controls.Add($script:ResultsTextBox)

# ===== TAB 2: Patch Schedule =====
$tabSchedule = New-Object System.Windows.Forms.TabPage
$tabSchedule.Text = "Patch Schedule"
$tabControl.Controls.Add($tabSchedule)

# Edit Schedule Button
$btnEditSchedule = New-Object System.Windows.Forms.Button
$btnEditSchedule.Location = New-Object System.Drawing.Point(20, 20)
$btnEditSchedule.Size = New-Object System.Drawing.Size(150, 35)
$btnEditSchedule.Text = "Edit Schedule..."
$btnEditSchedule.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$btnEditSchedule.BackColor = [System.Drawing.Color]::LightYellow
$tabSchedule.Controls.Add($btnEditSchedule)

# Config File Label
$lblConfigFile = New-Object System.Windows.Forms.Label
$lblConfigFile.Location = New-Object System.Drawing.Point(180, 28)
$lblConfigFile.Size = New-Object System.Drawing.Size(750, 20)
$lblConfigFile.Text = "Config file: $Global:ConfigPath"
$lblConfigFile.ForeColor = [System.Drawing.Color]::Gray
$tabSchedule.Controls.Add($lblConfigFile)

$script:ScheduleTextBox = New-Object System.Windows.Forms.TextBox
$script:ScheduleTextBox.Location = New-Object System.Drawing.Point(20, 65)
$script:ScheduleTextBox.Size = New-Object System.Drawing.Size(920, 525)
$script:ScheduleTextBox.Multiline = $true
$script:ScheduleTextBox.ScrollBars = "Vertical"
$script:ScheduleTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$script:ScheduleTextBox.ReadOnly = $true
$tabSchedule.Controls.Add($script:ScheduleTextBox)

# ===== TAB 3: STIG Compliance =====
$tabSTIG = New-Object System.Windows.Forms.TabPage
$tabSTIG.Text = "STIG Compliance"
$tabControl.Controls.Add($tabSTIG)

# STIG Edit Button
$btnEditSTIG = New-Object System.Windows.Forms.Button
$btnEditSTIG.Location = New-Object System.Drawing.Point(20, 20)
$btnEditSTIG.Size = New-Object System.Drawing.Size(180, 30)
$btnEditSTIG.Text = "Edit STIG Schedule..."
$btnEditSTIG.Add_Click({
    Open-STIGScheduleEditor
    Update-STIGDisplay
})
$tabSTIG.Controls.Add($btnEditSTIG)

# STIG Config Path Label
$lblSTIGConfig = New-Object System.Windows.Forms.Label
$lblSTIGConfig.Location = New-Object System.Drawing.Point(220, 25)
$lblSTIGConfig.Size = New-Object System.Drawing.Size(700, 20)
$lblSTIGConfig.Text = "Config file: $Global:ConfigPath"
$tabSTIG.Controls.Add($lblSTIGConfig)

# STIG Schedule TextBox
$script:STIGTextBox = New-Object System.Windows.Forms.TextBox
$script:STIGTextBox.Location = New-Object System.Drawing.Point(20, 65)
$script:STIGTextBox.Size = New-Object System.Drawing.Size(920, 525)
$script:STIGTextBox.Multiline = $true
$script:STIGTextBox.ScrollBars = "Vertical"
$script:STIGTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$script:STIGTextBox.ReadOnly = $true
$tabSTIG.Controls.Add($script:STIGTextBox)

# ===== TAB 4: About =====
$tabAbout = New-Object System.Windows.Forms.TabPage
$tabAbout.Text = "About"
$tabControl.Controls.Add($tabAbout)

$script:AboutTextBox = New-Object System.Windows.Forms.TextBox
$script:AboutTextBox.Location = New-Object System.Drawing.Point(20, 20)
$script:AboutTextBox.Size = New-Object System.Drawing.Size(920, 570)
$script:AboutTextBox.Multiline = $true
$script:AboutTextBox.ScrollBars = "Vertical"
$script:AboutTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$script:AboutTextBox.ReadOnly = $true
$tabAbout.Controls.Add($script:AboutTextBox)

# Populate About content
$aboutText = @"
================================================================
               IAVM PROCESSOR v2.3
        Vulnerability Management and Planning Tool
================================================================

DEVELOPED BY
----------------------------------------------------------------
Hector L. Bones
----------------------------------------------------------------

VERSION INFORMATION
----------------------------------------------------------------
Version:        2.3
Release Date:   January 28, 2026

PowerShell:     5.1+
Platform:       Windows 7/8/10/11, Server 2012 R2+


RECENT UPDATES (v2.3)
----------------------------------------------------------------
  - IAVA/IAVB Type extraction
    (Accurate type from IAVM number pattern)
  
  - STIG Compliance tab added
    (Dedicated quarterly STIG lifecycle calendar)
  
  - Edit STIG Schedule button
    (Editable STIG dates with persistence)


PREVIOUS UPDATES (v2.2)
----------------------------------------------------------------
  - Intelligent Status field logic
    (New/Prior/Historical/Aged based on publication date)
  
  - Automatic status assignment
    (Based on last Thursday IAVM publication)


PREVIOUS UPDATES (v2.1)
----------------------------------------------------------------
  - Fixed CSV serialization issue
    (Title/Type "System.Object[]" problem)
  
  - Improved screen readability
    (larger fonts, better spacing)


PREVIOUS UPDATES (v2.0)
----------------------------------------------------------------
  - User-editable patch schedule
    (GUI editor)
  
  - Persistent configuration
    (JSON config file)


STIG COMPLIANCE LIFECYCLE (Reference)
----------------------------------------------------------------
  DISA publishes Security Technical Implementation Guides
  (STIGs) quarterly for system hardening and compliance.

  Release Schedule:
    Q1: End of January
    Q2: End of April
    Q3: End of July
    Q4: End of October

  Implementation Timeline (4 Phases):
    Phase 1 (T+0 to T+30):
      Release & Initial Assessment by SMEs
    
    Phase 2 (T+30 to T+45):
      STIG Deep Dive TRB (4th Tuesday)
      New Benchmark Creation
    
    Phase 3 (T+45 to T+75):
      SME Deep Dive & Implementation
      Full Configuration Review
    
    Phase 4 (Ongoing):
      90-Day Continuous Compliance Reviews

  See "STIG Compliance" tab for detailed 2026 calendar.


STATUS FIELD LOGIC (v2.2)
----------------------------------------------------------------
  Status is automatically assigned based on release date:
  
  New/Received:
    IAVMs published since last Thursday
    (Current week's work)
  
  Prior Publication:
    IAVMs from 1-2 weeks ago
    (Previous week's backlog)
  
  Historical:
    IAVMs from 2-4 weeks ago
    (Older backlog items)
  
  Aged:
    IAVMs older than 30 days
    (Long-standing items)


CORE FEATURES
----------------------------------------------------------------
  File Processing:
    - Automatic ZIP file extraction
    - XML parsing with full IAVM schema support
  
  Calculations:
    - Automated metric calculations
    - Age, priority, and TRB eligibility
    - Intelligent status assignment
  
  Outputs:
    - 6 different CSV output files
    - Various use cases supported
  
  Schedule Management:
    - Integrated organizational patch schedule
    - User-editable dates
  
  User Interface:
    - Real-time progress tracking
    - User-friendly Windows Forms GUI


PRIORITY LEVELS
----------------------------------------------------------------
  CRITICAL - Known exploits exist
  
  HIGH     - Age greater than 30 days
  
  MEDIUM   - Age greater than 14 days
  
  LOW      - Age 14 days or less


TRB ELIGIBILITY
----------------------------------------------------------------
  Eligible IAVMs include:
  
    - IAVMs from previous months
      (not yet patched)
  
    - Current month IAVMs released
      before 3rd Tuesday


CSV OUTPUT FILES
----------------------------------------------------------------
  1. IAVM_Data
     Complete dataset with all fields
  
  2. IAVM_Summary_Metrics
     Aggregated statistics
  
  3. IAVM_By_Month
     Monthly distribution
  
  4. IAVM_TRB_Eligible
     Pre-filtered for TRB meetings
  
  5. IAVM_Priority_Items
     Critical and High priority only
  
  6. Patch_Schedule
     Organizational calendar


QUICK START GUIDE
----------------------------------------------------------------
  Step 1 - SELECT SOURCE DIRECTORY
    - Click "Browse..." next to Source Directory
    - Choose folder with IAVM XML/ZIP files
  
  Step 2 - SELECT OUTPUT DIRECTORY
    - Click "Browse..." next to Output Directory
    - Choose where to save CSV files
  
  Step 3 - PROCESS FILES
    - Click "Process Files" button
    - Watch progress bar
    - Review results summary
  
  Step 4 - EXPORT CSVs
    - Click "Export CSVs" button
    - 6 CSV files are generated
    - Import into Excel tracker
  
  Step 5 - MANAGE SCHEDULE (Optional)
    - Go to "Patch Schedule" tab
    - Click "Edit Schedule..." button
    - Modify dates as needed
    - Click OK to save


CONFIGURATION FILE
----------------------------------------------------------------
  Location:  Same folder as script
  Filename:  IAVM_Config.json
  
  Contents:  Patch schedule dates for all 12 months
  
  Backup:    Copy JSON file to safe location


ORGANIZATIONAL WORKFLOW
----------------------------------------------------------------
  Every Thursday:
    New IAVMs published
    Status = "New/Received"
  
  2nd Tuesday:
    Microsoft Patch Tuesday
  
  3rd Tuesday:
    TRB (Technical Review Board) meeting
  
  3rd Thursday:
    Patch implementation day
  
  25th of month:
    Compliance scan execution


SYSTEM REQUIREMENTS
----------------------------------------------------------------
  Operating System:
    - Windows 7 or later
  
  Software:
    - PowerShell 5.1 or higher
    - .NET Framework 4.5 or higher
  
  Permissions:
    - Standard user (no admin required)
  
  Disk Space:
    - Approximately 150 KB


SUPPORT DOCUMENTATION
----------------------------------------------------------------
  README_v2.md
    Complete user guide
  
  MIGRATION_GUIDE.md
    Upgrade instructions
  
  CHANGELOG.md
    Detailed version history
  
  VISUAL_QUICK_START.md
    Visual UI guide


SECURITY NOTES
----------------------------------------------------------------
  Data Classification:
    - IAVM files contain CUI
      (Controlled Unclassified Information)
    - Store in approved locations per org policy
  
  Configuration:
    - Config file contains dates only
    - Non-sensitive information
    - No credentials or classified data stored
  
  Execution:
    - Execution policy bypass handled by launcher
    - No manual policy changes required


TROUBLESHOOTING
----------------------------------------------------------------
  Execution Policy Error:
    - Use Launch_IAVM_Processor_v2.bat launcher
    - OR run: Set-ExecutionPolicy -Scope CurrentUser
              RemoteSigned
  
  CSV "System.Object[]" Issue:
    - FIXED in v2.1!
    - Update to latest version
  
  Status Field Shows All "New/Received":
    - FIXED in v2.2!
    - Now intelligently assigned based on date
  
  Type Field Shows Wrong Values:
    - FIXED in v2.3!
    - Now extracted from IAVM Number (IAVA/IAVB)
  
  Schedule Not Saving:
    - Check write permissions in script folder
    - Try "Run as Administrator" if needed
  
  Garbled Characters:
    - FIXED in v2.0!
    - Update to latest version


CREDITS & ACKNOWLEDGMENTS
----------------------------------------------------------------
  Developed by:
    Hector L. Bones
  
  Purpose:
    DoD Vulnerability Management
  
  Organization:
    Information Assurance / Cybersecurity
  
LICENSE
----------------------------------------------------------------
This tool is provided as-is for use within authorized
organizations. Modify as needed for specific requirements.


================================================================
         IAVM PROCESSOR v2.1 - Bones Version!
================================================================
"@

	# FIX: Force Windows-style line endings for the TextBox
    ## Replaced $script:AboutTextBox.Text = $aboutText
	
	$script:AboutTextBox.Text = $aboutText -replace "`n", "`r`n"

# ===== EVENT HANDLERS =====

$btnBrowseSource.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select folder containing IAVM XML/ZIP files"
    $folderBrowser.ShowNewFolderButton = $false
    
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtSource.Text = $folderBrowser.SelectedPath
        $Global:SourcePath = $folderBrowser.SelectedPath
    }
})

$btnBrowseOutput.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select output folder for CSV files"
    $folderBrowser.ShowNewFolderButton = $true
    
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtOutput.Text = $folderBrowser.SelectedPath
        $Global:OutputPath = $folderBrowser.SelectedPath
    }
})

$btnProcess.Add_Click({
    if ([string]::IsNullOrEmpty($txtSource.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a source directory first.", "Source Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    $btnProcess.Enabled = $false
    $progressBar.Value = 0
    $script:ResultsTextBox.Text = "Processing..."
    
    Process-IAVMFiles -SourceDir $txtSource.Text -ProgressBar $progressBar -StatusLabel $script:StatusLabel
    Display-Results
    
    $btnProcess.Enabled = $true
})

$btnExport.Add_Click({
    if ([string]::IsNullOrEmpty($txtOutput.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please select an output directory first.", "Output Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    $success = Generate-CSVOutputs -OutputDir $txtOutput.Text
    
    if ($success) {
        $result = [System.Windows.Forms.MessageBox]::Show("CSV files generated successfully!`n`nWould you like to open the output folder?", "Export Complete", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Information)
        
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Start-Process $txtOutput.Text
        }
        
        Display-Results
    }
})

$btnEditSchedule.Add_Click({
    Open-ScheduleEditor
})

# Initialize
Load-Configuration
Display-PatchSchedule
Display-STIGSchedule

# Show form
[void]$form.ShowDialog()
