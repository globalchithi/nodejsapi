# Simple environment loader for batch files
param(
    [string]$EnvFile = ".env"
)

# Function to load environment variables from file
function Load-EnvFile {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        return
    }
    
    $envContent = Get-Content $FilePath -Raw
    $lines = $envContent -split "`n"
    
    foreach ($line in $lines) {
        # Skip empty lines and comments
        if ([string]::IsNullOrWhiteSpace($line) -or $line.Trim().StartsWith("#")) {
            continue
        }
        
        # Parse KEY=VALUE format
        if ($line.Contains("=")) {
            $parts = $line -split "=", 2
            if ($parts.Length -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                
                # Remove quotes if present
                if ($value.StartsWith('"') -and $value.EndsWith('"')) {
                    $value = $value.Substring(1, $value.Length - 2)
                }
                
                # Set environment variable for current process
                [Environment]::SetEnvironmentVariable($key, $value, "Process")
                Write-Host "Set $key=$value"
            }
        }
    }
}

# Load .env file
if (Test-Path $EnvFile) {
    Load-EnvFile -FilePath $EnvFile
}

# Load .env.local if it exists (overrides .env)
if (Test-Path ".env.local") {
    Load-EnvFile -FilePath ".env.local"
}
