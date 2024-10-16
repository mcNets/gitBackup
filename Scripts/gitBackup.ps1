Clear-Host

Write-Host "gitBackup Ver." -ForegroundColor Green

if (-Not (Test-Path "appsettings.json")) {
    Write-Host "appsettings.json no encontrado" -ForegroundColor Red
    Write-Host "Follow README.md on how to build appsettins.json"
    Write-Host "https://github.com/mcNets/gitBackup"
    return
}

$appsettings = Get-Content -Raw -Path "appsettings.json" | ConvertFrom-Json

$backupFolder = $appsettings.AppSettings.BackupFolder
$repositories = $appsettings.Repositories

Write-Host "BackupFolder: $backupFolder"

Write-Host "Checking backup folder: $backupFolder`n"
if (-Not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
    if (-Not (Test-Path $backupFolder)) {
        Write-Host "Cannot create backup folder: $backupFolder" -ForegroundColor Red
        return
    }
}

# backup actions
foreach ($repository in $repositories) {
    Write-Host "Backup repository: $($repository.Name)"
    
    $backupPath = Join-Path -Path $backupFolder -ChildPath $repository.Path
    if (-Not (Test-Path $backupPath)) {
        $arguments = "clone $($repository.Url) $backupPath"
    } else {
        $arguments = "-C $backupPath pull"
    }

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "git"
    $processInfo.Arguments = $arguments
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo

    $process.Start() | Out-Null
    $process.WaitForExit()

    $output = $process.StandardOutput.ReadToEnd()
    $error = $process.StandardError.ReadToEnd()

    Write-Host $output

    if ($process.ExitCode -eq 0) {
        Write-Host "Backup $($repository.Name) completed`n" -ForegroundColor Green
    } else {
        Write-Host $error -ForegroundColor Red
    }
}
