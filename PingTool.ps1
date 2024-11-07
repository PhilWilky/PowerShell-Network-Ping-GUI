# Load required assemblies for GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Website Ping Tool"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Create website input label
$labelWebsite = New-Object System.Windows.Forms.Label
$labelWebsite.Location = New-Object System.Drawing.Point(20, 20)
$labelWebsite.Size = New-Object System.Drawing.Size(150, 20)
$labelWebsite.Text = "Enter website to ping:"
$form.Controls.Add($labelWebsite)

# Create website input textbox
$textboxWebsite = New-Object System.Windows.Forms.TextBox
$textboxWebsite.Location = New-Object System.Drawing.Point(20, 50)
$textboxWebsite.Size = New-Object System.Drawing.Size(250, 20)
$textboxWebsite.Text = "www.google.com"
$form.Controls.Add($textboxWebsite)

# Create the ping button
$buttonPing = New-Object System.Windows.Forms.Button
$buttonPing.Location = New-Object System.Drawing.Point(280, 48)
$buttonPing.Size = New-Object System.Drawing.Size(80, 23)
$buttonPing.Text = "Ping"
$form.Controls.Add($buttonPing)

# Create result label
$labelResult = New-Object System.Windows.Forms.Label
$labelResult.Location = New-Object System.Drawing.Point(20, 90)
$labelResult.Size = New-Object System.Drawing.Size(340, 150)
$labelResult.Text = "Enter a website and click Ping"
$form.Controls.Add($labelResult)

# Add click event to the ping button
$buttonPing.Add_Click({
    $website = $textboxWebsite.Text.Trim()
    if ([string]::IsNullOrEmpty($website)) {
        $labelResult.Text = "Please enter a website"
        $labelResult.ForeColor = "Red"
        return
    }

    try {
        $labelResult.Text = "Pinging $website...`n"
        $labelResult.ForeColor = "Black"
        $ping = Test-Connection -ComputerName $website -Count 1 -ErrorAction Stop
        
        $labelResult.Text += "Ping successful!`n"
        $labelResult.Text += "Response time: $($ping.ResponseTime)ms`n"
        $labelResult.Text += "IP Address: $($ping.Address)`n"
        $labelResult.Text += "Reply from: $($ping.PSComputerName)"
        $labelResult.ForeColor = "Green"
    }
    catch {
        $labelResult.Text = "Ping failed!`nError: Unable to reach $website`nPlease check the website address and your internet connection."
        $labelResult.ForeColor = "Red"
    }
})

# Add key press event for Enter key
$textboxWebsite.Add_KeyPress({
    if ($_.KeyChar -eq [char]13) {
        $buttonPing.PerformClick()
        $_.Handled = $true
    }
})

# Show the form
[void]$form.ShowDialog()
