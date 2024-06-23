# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script. Please run this script as an Administrator."
    exit
}

# Function to check if a command exists
function Test-Command {
    param(
        [string]$Command
    )
    $commandExists = Get-Command $Command -ErrorAction SilentlyContinue
    if (-not $commandExists) {
        Write-Error "Command '$Command' not found. Please install it and try again."
        exit 1
    }
}

# Install Chocolatey if not installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey not found. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Error "Chocolatey installation failed."
        exit 1
    }
} else {
    Write-Output "Chocolatey is already installed."
}

# Install kubectl
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Output "kubectl not found. Installing kubectl..."
    choco install kubernetes-cli -y
    Test-Command kubectl
} else {
    Write-Output "kubectl is already installed."
}

# Install Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Output "Docker not found. Installing Docker Desktop..."
    choco install docker-desktop -y
    Write-Output "Docker installed. Please restart your computer and run this script again to complete the installation."
    exit
} else {
    Write-Output "Docker is already installed."
}

# Start Docker service if not running
if (-not (Get-Service -Name com.docker.service -ErrorAction SilentlyContinue)) {
    Write-Output "Starting Docker service..."
    Start-Service -Name com.docker.service
    Start-Sleep -s 10
}

# Install Minikube
if (-not (Get-Command minikube -ErrorAction SilentlyContinue)) {
    Write-Output "Minikube not found. Installing Minikube..."
    choco install minikube -y --force
    Test-Command minikube
} else {
    Write-Output "Minikube is already installed."
}

# Add Minikube to PATH if not already added
$minikubePath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
if ($minikubePath -notlike "*C:\ProgramData\chocolatey\bin*") {
    [System.Environment]::SetEnvironmentVariable("PATH", $minikubePath + ";C:\ProgramData\chocolatey\bin", [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Added Minikube to system PATH. Please restart your computer or PowerShell session to apply changes."
}

# Function to check if Chocolatey is installed
function Ensure-Chocolatey {
    $choco = Get-Command choco -ErrorAction SilentlyContinue
    if (-not $choco) {
        Write-Output "Chocolatey is not installed. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
}

# Check if k9s is installed
$k9s = Get-Command k9s -ErrorAction SilentlyContinue

if (-not $k9s) {
    Write-Output "k9s is not installed. Installing k9s..."

    # Ensure Chocolatey is installed
    Ensure-Chocolatey

    # Install k9s using Chocolatey
    choco install k9s -y
} else {
    Write-Output "k9s is already installed."
}

# Function to check if Minikube is running
function Is-MinikubeRunning {
    $minikubeStatus = & minikube status --format "{{.Host}}"
    return $minikubeStatus -eq "Running"
}

# Start Minikube with Docker driver if not already running
if (-not (Is-MinikubeRunning)) {
    Write-Output "Starting Minikube with Docker driver..."
    C:\ProgramData\chocolatey\bin\minikube.exe start --driver=docker
} else {
    Write-Output "Minikube is already running."
}

# Verify Minikube installation
Write-Output "Verifying Minikube installation..."
C:\ProgramData\chocolatey\bin\minikube.exe status

Write-Output "Minikube installation and setup complete."
