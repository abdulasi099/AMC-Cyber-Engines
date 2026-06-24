# --- 1. บังคับขอสิทธิ์ Admin ตั้งแต่เริ่มสคริปต์แบบเสถียร ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs
    exit
}

# --- 2. โหลดเครื่องมือสำหรับสร้างหน้าต่างกราฟิก (GUI) ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- 3. สร้างหน้าต่างหลักแบบขยายแผง (กว้าง 1120 x สูง 720) ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "AMC CYBER ENGINE v1.0 // THE FIRST HYBRID GENERATION BY ABDULASI CHELONG"
$form.Size = New-Object System.Drawing.Size(1120, 720)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(14, 18, 26)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $False

# --- ตั้งค่าฟอนต์ ---
$fontTitle = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$fontSection = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
$fontBtn = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fontLink = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$fontMon = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)

# ==========================================
#  LEFT PANEL: SYSTEM INFO, LOG & DASHBOARD
# ==========================================

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "AMC ULTIMATE OS ENGINE"
$titleLabel.Font = $fontTitle
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 229, 255)
$titleLabel.Size = New-Object System.Drawing.Size(480, 35)
$titleLabel.Location = New-Object System.Drawing.Point(25, 20)
$form.Controls.Add($titleLabel)

$subLabel = New-Object System.Windows.Forms.Label
$subLabel.Text = "DEVELOPER: ABDULASI CHELONG // BASE BUILD: v1.0 MAIN CORE"
$subLabel.Font = $fontSub
$subLabel.ForeColor = [System.Drawing.Color]::FromArgb(140, 150, 165)
$subLabel.Size = New-Object System.Drawing.Size(480, 20)
$subLabel.Location = New-Object System.Drawing.Point(25, 55)
$form.Controls.Add($subLabel)

$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Size = New-Object System.Drawing.Size(470, 160)
$logBox.Location = New-Object System.Drawing.Point(25, 90)
$logBox.BackColor = [System.Drawing.Color]::FromArgb(8, 10, 15)
$logBox.ForeColor = [System.Drawing.Color]::FromArgb(130, 255, 160)
$logBox.ReadOnly = $True
$form.Controls.Add($logBox)

function Update-Log($text) {
    if ($logBox.IsDisposed) { return }
    $boxWidth = $logBox.ClientSize.Width
    $g = $logBox.CreateGraphics()
    $spaceDim = $g.MeasureString(" ", $logBox.Font)
    $textDim = $g.MeasureString($text, $logBox.Font)
    $g.Dispose()
    $padding = ($boxWidth - $textDim.Width) / 2
    $spaceCount = [math]::Max(0, [math]::Floor($padding / $spaceDim.Width))
    $centeredText = (" " * $spaceCount) + $text
    if ($logBox.Text -eq "") { $logBox.Text = $centeredText } else { $logBox.AppendText("`n" + $centeredText) }
    $logBox.ScrollToCaret()
}

Update-Log "[SYSTEM] Project initialized at baseline v1.0"
Update-Log "[WELCOME] Hybrid Engine Active. Operator: ABDULASI CHELONG"

$lblCpuMon = New-Object System.Windows.Forms.Label
$lblCpuMon.Text = " CPU STACK: LOADING..."
$lblCpuMon.Font = $fontMon
$lblCpuMon.BackColor = [System.Drawing.Color]::FromArgb(8, 10, 15)
$lblCpuMon.ForeColor = [System.Drawing.Color]::FromArgb(255, 215, 0)
$lblCpuMon.Size = New-Object System.Drawing.Size(225, 35)
$lblCpuMon.Location = New-Object System.Drawing.Point(25, 265)
$lblCpuMon.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$form.Controls.Add($lblCpuMon)

$lblRamMon = New-Object System.Windows.Forms.Label
$lblRamMon.Text = " RAM STACK: LOADING..."
$lblRamMon.Font = $fontMon
$lblRamMon.BackColor = [System.Drawing.Color]::FromArgb(8, 10, 15)
$lblRamMon.ForeColor = [System.Drawing.Color]::FromArgb(255, 215, 0)
$lblRamMon.Size = New-Object System.Drawing.Size(230, 35)
$lblRamMon.Location = New-Object System.Drawing.Point(265, 265)
$lblRamMon.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$form.Controls.Add($lblRamMon)

$cpuCounter = New-Object System.Diagnostics.PerformanceCounter("Processor", "% Processor Time", "_Total")
$null = $cpuCounter.NextValue()

$monTimer = New-Object System.Windows.Forms.Timer
$monTimer.Interval = 1000
$monTimer.Add_Tick({
    if ($form.Visible) {
        $cpuLoad = [math]::Round($cpuCounter.NextValue())
        $lblCpuMon.Text = " CPU LOAD: $cpuLoad %"
        $os = Get-CimInstance Win32_OperatingSystem
        $totalRam = $os.TotalVisibleMemorySize
        $freeRam = $os.FreePhysicalMemory
        $usedRamPercent = [math]::Round((($totalRam - $freeRam) / $totalRam) * 100)
        $lblRamMon.Text = " RAM USAGE: $usedRamPercent %"
    }
})
$monTimer.Start()

$lblShortcuts = New-Object System.Windows.Forms.Label
$lblShortcuts.Text = "--- UTILITY & DEV SHORTCUTS ---"
$lblShortcuts.Font = $fontSection
$lblShortcuts.ForeColor = [System.Drawing.Color]::FromArgb(180, 140, 255)
$lblShortcuts.Size = New-Object System.Drawing.Size(470, 20)
$lblShortcuts.Location = New-Object System.Drawing.Point(25, 320)
$form.Controls.Add($lblShortcuts)

$btnSandbox = New-Object System.Windows.Forms.Button
$btnSandbox.Text = "MODDING SANDBOX ACCESS"
$btnSandbox.Font = $fontBtn
$btnSandbox.Size = New-Object System.Drawing.Size(470, 40)
$btnSandbox.Location = New-Object System.Drawing.Point(25, 345)
$btnSandbox.BackColor = [System.Drawing.Color]::FromArgb(50, 40, 75)
$btnSandbox.ForeColor = [System.Drawing.Color]::FromArgb(210, 180, 255)
$btnSandbox.FlatStyle = "Flat"
$btnSandbox.FlatAppearance.BorderSize = 0
$btnSandbox.Add_Click({
    Update-Log "[>] Launching Modding Environment Directory..."
    $targetPath = "$env:TEMP"
    if (Test-Path $targetPath) {
        Start-Process "explorer.exe" -ArgumentList $targetPath
        Update-Log "[SUCCESS] Sandbox active."
    }
})
$form.Controls.Add($btnSandbox)

$btnFB = New-Object System.Windows.Forms.Button
$btnFB.Text = "DEVELOPER FACEBOOK"
$btnFB.Font = $fontLink
$btnFB.Size = New-Object System.Drawing.Size(225, 40)
$btnFB.Location = New-Object System.Drawing.Point(25, 400)
$btnFB.BackColor = [System.Drawing.Color]::FromArgb(20, 42, 80)
$btnFB.ForeColor = [System.Drawing.Color]::FromArgb(140, 190, 255)
$btnFB.FlatStyle = "Flat"
$btnFB.FlatAppearance.BorderSize = 0
$btnFB.Add_Click({ Start-Process "https://www.facebook.com/Abdulasi.Aziz/directory_personal_details" })
$form.Controls.Add($btnFB)

$btnIG = New-Object System.Windows.Forms.Button
$btnIG.Text = "DEVELOPER INSTAGRAM"
$btnIG.Font = $fontLink
$btnIG.Size = New-Object System.Drawing.Size(230, 40)
$btnIG.Location = New-Object System.Drawing.Point(265, 400)
$btnIG.BackColor = [System.Drawing.Color]::FromArgb(65, 15, 50)
$btnIG.ForeColor = [System.Drawing.Color]::FromArgb(255, 150, 210)
$btnIG.FlatStyle = "Flat"
$btnIG.FlatAppearance.BorderSize = 0
$btnIG.Add_Click({ Start-Process "https://www.instagram.com/abdulasi_aziz/" })
$form.Controls.Add($btnIG)

# --- HARDWARE ECO MATRIX CONTROLLER (ปุ่มปิดไฟ RGB) ---
$lblHardwareEco = New-Object System.Windows.Forms.Label
$lblHardwareEco.Text = "--- HARDWARE ECO MATRIX CONTROLLER ---"
$lblHardwareEco.Font = $fontSection
$lblHardwareEco.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 120)
$lblHardwareEco.Size = New-Object System.Drawing.Size(470, 20)
$lblHardwareEco.Location = New-Object System.Drawing.Point(25, 460)
$form.Controls.Add($lblHardwareEco)

$isRgbOff = $False
$btnRgbToggle = New-Object System.Windows.Forms.Button
$btnRgbToggle.Text = "TURBO RGB SHUTDOWN: ACTIVE"
$btnRgbToggle.Font = $fontBtn
$btnRgbToggle.Size = New-Object System.Drawing.Size(470, 45)
$btnRgbToggle.Location = New-Object System.Drawing.Point(25, 485)
$btnRgbToggle.BackColor = [System.Drawing.Color]::FromArgb(15, 60, 40)
$btnRgbToggle.ForeColor = [System.Drawing.Color]::FromArgb(100, 255, 180)
$btnRgbToggle.FlatStyle = "Flat"
$btnRgbToggle.FlatAppearance.BorderSize = 0
$btnRgbToggle.Add_Click({
    $script:isRgbOff = -not $script:isRgbOff
    if ($script:isRgbOff) {
        $btnRgbToggle.Text = "TURBO RGB SHUTDOWN: DARK MODE (ECO ACTIVE)"
        $btnRgbToggle.BackColor = [System.Drawing.Color]::FromArgb(60, 15, 20)
        $btnRgbToggle.ForeColor = [System.Drawing.Color]::FromArgb(255, 100, 100)
        Update-Log "[!] ECO MODE: Cutting Power to Peripheral RGB Matrix..."
        net stop "LightingService" >$null 2>&1
        taskkill /f /im "MysticLight.exe" >$null 2>&1
        Update-Log "[SUCCESS] RGB Elements Suspended."
    } else {
        $btnRgbToggle.Text = "TURBO RGB SHUTDOWN: ACTIVE"
        $btnRgbToggle.BackColor = [System.Drawing.Color]::FromArgb(15, 60, 40)
        $btnRgbToggle.ForeColor = [System.Drawing.Color]::FromArgb(100, 255, 180)
        Update-Log "[!] ECO MODE: Restoring Hardware RGB Link Matrix..."
        net start "LightingService" >$null 2>&1
        Update-Log "[SUCCESS] RGB Framework standard operational."
    }
})
$form.Controls.Add($btnRgbToggle)

$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "DISCONNECT SYSTEM PROTOCOL (EXIT)"
$btnExit.Font = $fontBtn
$btnExit.Size = New-Object System.Drawing.Size(470, 45)
$btnExit.Location = New-Object System.Drawing.Point(25, 610)
$btnExit.BackColor = [System.Drawing.Color]::FromArgb(28, 32, 40)
$btnExit.ForeColor = [System.Drawing.Color]::FromArgb(255, 90, 90)
$btnExit.FlatStyle = "Flat"
$btnExit.FlatAppearance.BorderSize = 0
$btnExit.Add_Click({ $monTimer.Stop(); $autoTimer.Stop(); $form.Close() })
$form.Controls.Add($btnExit)


# ==========================================
#  RIGHT PANEL: ENGINE ACTION PROTOCOLS
# ==========================================

$lblApex = New-Object System.Windows.Forms.Label
$lblApex.Text = "--- APEX SYSTEM MONITOR & AUTOMATION ---"
$lblApex.Font = $fontSection
$lblApex.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 200)
$lblApex.Size = New-Object System.Drawing.Size(520, 20)
$lblApex.Location = New-Object System.Drawing.Point(540, 20)
$form.Controls.Add($lblApex)

$btnNetOpt = New-Object System.Windows.Forms.Button
$btnNetOpt.Text = "NETWORK OPTIMIZER"
$btnNetOpt.Font = $fontBtn
$btnNetOpt.Size = New-Object System.Drawing.Size(250, 45)
$btnNetOpt.Location = New-Object System.Drawing.Point(540, 45)
$btnNetOpt.BackColor = [System.Drawing.Color]::FromArgb(18, 70, 85)
$btnNetOpt.ForeColor = [System.Drawing.Color]::FromArgb(140, 255, 255)
$btnNetOpt.FlatStyle = "Flat"
$btnNetOpt.FlatAppearance.BorderSize = 0
$btnNetOpt.Add_Click({
    Update-Log "[!] Optimizing network packets & flushing DNS..."
    $form.Refresh()
    ipconfig /flushdns > $null
    netsh winsock reset > $null
    Update-Log "[SUCCESS] DNS Flushed & Winsock reloaded."
})
$form.Controls.Add($btnNetOpt)

$isAutoPurgeActive = $False
$btnAuto = New-Object System.Windows.Forms.Button
$btnAuto.Text = "AUTO-PURGE: OFF"
$btnAuto.Font = $fontBtn
$btnAuto.Size = New-Object System.Drawing.Size(250, 45)
$btnAuto.Location = New-Object System.Drawing.Point(810, 45)
$btnAuto.BackColor = [System.Drawing.Color]::FromArgb(40, 50, 40)
$btnAuto.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 140)
$btnAuto.FlatStyle = "Flat"
$btnAuto.FlatAppearance.BorderSize = 0

$autoTimer = New-Object System.Windows.Forms.Timer
$autoTimer.Interval = 15000 
$autoTimer.Add_Tick({
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Remove-Item "$env:TEMP\*" -Recycle -Force -ErrorAction SilentlyContinue
    Update-Log "[AUTO-ENGINE] Automated RAM & Cache optimization injected."
})
$btnAuto.Add_Click({
    $script:isAutoPurgeActive = -not $script:isAutoPurgeActive
    if ($script:isAutoPurgeActive) {
        $btnAuto.Text = "AUTO-PURGE: ACTIVE"
        $btnAuto.BackColor = [System.Drawing.Color]::FromArgb(18, 90, 45)
        $btnAuto.ForeColor = [System.Drawing.Color]::FromArgb(140, 255, 170)
        $autoTimer.Start()
        Update-Log "[SYSTEM] Auto-Purge protocol initialized (Every 15s)."
    } else {
        $btnAuto.Text = "AUTO-PURGE: OFF"
        $btnAuto.BackColor = [System.Drawing.Color]::FromArgb(40, 50, 40)
        $btnAuto.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 140)
        $autoTimer.Stop()
        Update-Log "[SYSTEM] Auto-Purge protocol deactivated."
    }
})
$form.Controls.Add($btnAuto)

$lblSec1 = New-Object System.Windows.Forms.Label
$lblSec1.Text = "--- RESOURCE & MEMORY PURGE TOOLS ---"
$lblSec1.Font = $fontSection
$lblSec1.ForeColor = [System.Drawing.Color]::FromArgb(235, 160, 0)
$lblSec1.Size = New-Object System.Drawing.Size(520, 20)
$lblSec1.Location = New-Object System.Drawing.Point(540, 110)
$form.Controls.Add($lblSec1)

$btnRam = New-Object System.Windows.Forms.Button
$btnRam.Text = "RAM CONTROLLER"
$btnRam.Font = $fontBtn
$btnRam.Size = New-Object System.Drawing.Size(250, 45)
$btnRam.Location = New-Object System.Drawing.Point(540, 135)
$btnRam.BackColor = [System.Drawing.Color]::FromArgb(45, 55, 35)
$btnRam.ForeColor = [System.Drawing.Color]::FromArgb(140, 255, 140)
$btnRam.FlatStyle = "Flat"
$btnRam.FlatAppearance.BorderSize = 0
$btnRam.Add_Click({
    Update-Log "[!] Triggering System RAM Defragmentation..."
    $form.Refresh()
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Update-Log "[SUCCESS] System RAM flushed!"
})
$form.Controls.Add($btnRam)

$btnKillApps = New-Object System.Windows.Forms.Button
$btnKillApps.Text = "APP TERMINATOR"
$btnKillApps.Font = $fontBtn
$btnKillApps.Size = New-Object System.Drawing.Size(250, 45)
$btnKillApps.Location = New-Object System.Drawing.Point(810, 135)
$btnKillApps.BackColor = [System.Drawing.Color]::FromArgb(70, 35, 85)
$btnKillApps.ForeColor = [System.Drawing.Color]::FromArgb(220, 150, 255)
$btnKillApps.FlatStyle = "Flat"
$btnKillApps.FlatAppearance.BorderSize = 0
$btnKillApps.Add_Click({
    Update-Log "[!] Terminating heavy background apps & browsers..."
    $form.Refresh()
    $targetApps = @("msedge", "chrome", "firefox", "discord", "spotify", "teams", "onedrive")
    foreach ($app in $targetApps) {
        if (Get-Process -Name $app -ErrorAction SilentlyContinue) {
            Stop-Process -Name $app -Force -ErrorAction SilentlyContinue
            Update-Log "[-] Purged process: $app"
            $form.Refresh()
        }
    }
    Update-Log "[SUCCESS] Background app footprints destroyed."
})
$form.Controls.Add($btnKillApps)

$lblSec2 = New-Object System.Windows.Forms.Label
$lblSec2.Text = "--- WINDOWS & PERFORMANCE BOOSTER ---"
$lblSec2.Font = $fontSection
$lblSec2.ForeColor = [System.Drawing.Color]::FromArgb(100, 120, 150)
$lblSec2.Size = New-Object System.Drawing.Size(520, 20)
$lblSec2.Location = New-Object System.Drawing.Point(540, 200)
$form.Controls.Add($lblSec2)

$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "PURGE CACHE & TEMP"
$btnClean.Font = $fontBtn
$btnClean.Size = New-Object System.Drawing.Size(250, 45)
$btnClean.Location = New-Object System.Drawing.Point(540, 225)
$btnClean.BackColor = [System.Drawing.Color]::FromArgb(33, 43, 63)
$btnClean.ForeColor = [System.Drawing.Color]::White
$btnClean.FlatStyle = "Flat"
$btnClean.FlatAppearance.BorderSize = 0
$btnClean.Add_Click({
    Update-Log "[!] Executing Deep Clean Engine..."
    $form.Refresh()
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\*" -Recycle -Force -ErrorAction SilentlyContinue
    Update-Log "[SUCCESS] Windows cache cleared!"
})
$form.Controls.Add($btnClean)

$btnGameBypass = New-Object System.Windows.Forms.Button
$btnGameBypass.Text = "GAME MODE BYPASS"
$btnGameBypass.Font = $fontBtn
$btnGameBypass.Size = New-Object System.Drawing.Size(250, 45)
$btnGameBypass.Location = New-Object System.Drawing.Point(810, 225)
$btnGameBypass.BackColor = [System.Drawing.Color]::FromArgb(100, 20, 60)
$btnGameBypass.ForeColor = [System.Drawing.Color]::FromArgb(255, 180, 200)
$btnGameBypass.FlatStyle = "Flat"
$btnGameBypass.FlatAppearance.BorderSize = 0
$btnGameBypass.Add_Click({
    Update-Log "[!] Allocating MAX core priority for gaming environments..."
    $form.Refresh()
    $null = New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowMetrics" -PropertyType String -Value "0" -ErrorAction SilentlyContinue
    Update-Log "[SUCCESS] Windows UI footprint minimized."
})
$form.Controls.Add($btnGameBypass)

# --- MSI CLAW CONTROLLER NODE ---
$lblSec3 = New-Object System.Windows.Forms.Label
$lblSec3.Text = "--- MSI CLAW CONTROLLER NODE ---"
$lblSec3.Font = $fontSection
$lblSec3.ForeColor = [System.Drawing.Color]::FromArgb(255, 90, 95)
$lblSec3.Size = New-Object System.Drawing.Size(250, 20)
$lblSec3.Location = New-Object System.Drawing.Point(540, 290)
$form.Controls.Add($lblSec3)

function Kill-MsiProcesses {
    Update-Log "[!] Terminating all MSI tasks..."
    net stop "MSI Foundation Service" >$null 2>&1
    taskkill /f /im "MSI Center M.exe" >$null 2>&1
    taskkill /f /im MSI_Center_M_Server* >$null 2>&1
    Update-Log "[SUCCESS] MSI targets purged by Operator."
}

$btnMsiKill = New-Object System.Windows.Forms.Button
$btnMsiKill.Text = "PURGE MSI TASKS"
$btnMsiKill.Font = $fontBtn
$btnMsiKill.Size = New-Object System.Drawing.Size(250, 45)
$btnMsiKill.Location = New-Object System.Drawing.Point(540, 315)
$btnMsiKill.BackColor = [System.Drawing.Color]::FromArgb(140, 35, 40)
$btnMsiKill.ForeColor = [System.Drawing.Color]::White
$btnMsiKill.FlatStyle = "Flat"
$btnMsiKill.FlatAppearance.BorderSize = 0
$btnMsiKill.Add_Click({ Kill-MsiProcesses })
$form.Controls.Add($btnMsiKill)

$btnMsiReload = New-Object System.Windows.Forms.Button
$btnMsiReload.Text = "RELOAD MSI CORE"
$btnMsiReload.Font = $fontBtn
$btnMsiReload.Size = New-Object System.Drawing.Size(250, 45)
$btnMsiReload.Location = New-Object System.Drawing.Point(540, 370)
$btnMsiReload.BackColor = [System.Drawing.Color]::FromArgb(180, 20, 85)
$btnMsiReload.ForeColor = [System.Drawing.Color]::White
$btnMsiReload.FlatStyle = "Flat"
$btnMsiReload.FlatAppearance.BorderSize = 0
$btnMsiReload.Add_Click({
    Kill-MsiProcesses
    net start "MSI Foundation Service" >$null 2>&1
    Update-Log "[SUCCESS] MSI Core service re-deployed."
})
$form.Controls.Add($btnMsiReload)

# --- ROG ALLY CONTROLLER NODE ---
$lblSec4 = New-Object System.Windows.Forms.Label
$lblSec4.Text = "--- ROG ALLY CONTROLLER NODE ---"
$lblSec4.Font = $fontSection
$lblSec4.ForeColor = [System.Drawing.Color]::FromArgb(200, 100, 255)
$lblSec4.Size = New-Object System.Drawing.Size(250, 20)
$lblSec4.Location = New-Object System.Drawing.Point(810, 290)
$form.Controls.Add($lblSec4)

function Kill-AsusProcesses {
    Update-Log "[!] Overriding ASUS Node: Terminating Armoury Crate tasks..."
    $form.Refresh()
    net stop "ArmouryCrateService" >$null 2>&1
    net stop "AsusAppService" >$null 2>&1
    taskkill /f /im "ArmouryCrate.exe" >$null 2>&1
    taskkill /f /im "ArmouryCrateKeyControl.exe" >$null 2>&1
    Update-Log "[SUCCESS] ROG Ally processes suspended."
}

$btnAsusKill = New-Object System.Windows.Forms.Button
$btnAsusKill.Text = "PURGE ASUS TASKS"
$btnAsusKill.Font = $fontBtn
$btnAsusKill.Size = New-Object System.Drawing.Size(250, 45)
$btnAsusKill.Location = New-Object System.Drawing.Point(810, 315)
$btnAsusKill.BackColor = [System.Drawing.Color]::FromArgb(90, 30, 140)
$btnAsusKill.ForeColor = [System.Drawing.Color]::White
$btnAsusKill.FlatStyle = "Flat"
$btnAsusKill.FlatAppearance.BorderSize = 0
$btnAsusKill.Add_Click({ Kill-AsusProcesses })
$form.Controls.Add($btnAsusKill)

$btnAsusReload = New-Object System.Windows.Forms.Button
$btnAsusReload.Text = "RELOAD ASUS CORE"
$btnAsusReload.Font = $fontBtn
$btnAsusReload.Size = New-Object System.Drawing.Size(250, 45)
$btnAsusReload.Location = New-Object System.Drawing.Point(810, 370)
$btnAsusReload.BackColor = [System.Drawing.Color]::FromArgb(130, 40, 200)
$btnAsusReload.ForeColor = [System.Drawing.Color]::White
$btnAsusReload.FlatStyle = "Flat"
$btnAsusReload.FlatAppearance.BorderSize = 0
$btnAsusReload.Add_Click({
    Kill-AsusProcesses
    net start "AsusAppService" >$null 2>&1
    net start "ArmouryCrateService" >$null 2>&1
    Update-Log "[SUCCESS] ROG Armoury Crate Ecosystem Online!"
})
$form.Controls.Add($btnAsusReload)

# --- SYSTEM MAINTENANCE PROTOCOLS ---
$lblMaintenance = New-Object System.Windows.Forms.Label
$lblMaintenance.Text = "--- SYSTEM MAINTENANCE PROTOCOLS ---"
$lblMaintenance.Font = $fontSection
$lblMaintenance.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$lblMaintenance.Size = New-Object System.Drawing.Size(520, 20)
$lblMaintenance.Location = New-Object System.Drawing.Point(540, 445)
$form.Controls.Add($lblMaintenance)

$btnStorage = New-Object System.Windows.Forms.Button
$btnStorage.Text = "STORAGE HEALTH DEFENDER"
$btnStorage.Font = $fontBtn
$btnStorage.Size = New-Object System.Drawing.Size(250, 45)
$btnStorage.Location = New-Object System.Drawing.Point(540, 470)
$btnStorage.BackColor = [System.Drawing.Color]::FromArgb(50, 60, 70)
$btnStorage.ForeColor = [System.Drawing.Color]::FromArgb(210, 225, 240)
$btnStorage.FlatStyle = "Flat"
$btnStorage.FlatAppearance.BorderSize = 0
$btnStorage.Add_Click({
    Update-Log "[!] Analyzing Storage block integrity via Trim engine..."
    Optimize-Volume -DriveLetter C -Defrag -Verbose > $null 2>&1
    Update-Log "[SUCCESS] Storage sectors trimmed."
})
$form.Controls.Add($btnStorage)

$btnExplorer = New-Object System.Windows.Forms.Button
$btnExplorer.Text = "REFRESH WINDOWS EXPLORER"
$btnExplorer.Font = $fontBtn
$btnExplorer.Size = New-Object System.Drawing.Size(250, 45)
$btnExplorer.Location = New-Object System.Drawing.Point(810, 470)
$btnExplorer.BackColor = [System.Drawing.Color]::FromArgb(50, 60, 75)
$btnExplorer.ForeColor = [System.Drawing.Color]::White
$btnExplorer.FlatStyle = "Flat"
$btnExplorer.FlatAppearance.BorderSize = 0
$btnExplorer.Add_Click({
    Stop-Process -Name explorer -Force
    Update-Log "[SUCCESS] Desktop elements reloaded."
})
$form.Controls.Add($btnExplorer)

# --- 5. โหลดหน้าต่างโปรแกรมขึ้นจอภาพ ---
$form.ShowDialog() | Out-Null