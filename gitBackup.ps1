# Limpiar la consola
Clear-Host

# Obtener la versión actual del ensamblado
Write-Host "gitBackup Ver." -ForegroundColor Green

# Verificar si existe el archivo appsettings.json
if (-Not (Test-Path "appsettings.json")) {
    Write-Host "appsettings.json no encontrado" -ForegroundColor Red
    Write-Host "Sigue las instrucciones en README.md para crear el archivo"
    Write-Host "https://github.com/mcNets/gitBackup"
    return
}

# Leer el archivo appsettings.json
$appsettings = Get-Content -Raw -Path "appsettings.json" | ConvertFrom-Json

$backupFolder = $appsettings.AppSettings.BackupFolder
$repositories = $appsettings.Repositories

Write-Host "BackupFolder: $backupFolder"

# Asegurarse de que la carpeta de respaldo exista
Write-Host "Verificando la carpeta de respaldo: $backupFolder`n"
if (-Not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
    if (-Not (Test-Path $backupFolder)) {
        Write-Host "No se pudo crear la carpeta de respaldo: $backupFolder" -ForegroundColor Red
        return
    }
}

# Realizar la copia de seguridad de cada repositorio
foreach ($repository in $repositories) {
    Write-Host "Realizando copia de seguridad del repositorio: $($repository.Name)"
    
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
        Write-Host "Copia de seguridad del repositorio $($repository.Name) completada con éxito`n" -ForegroundColor Green
    } else {
        Write-Host $error -ForegroundColor Red
    }
}