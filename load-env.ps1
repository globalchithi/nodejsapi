# PowerShell script to load environment variables from .env file
param(
    [string]$EnvFile = ".env"
)

function Load-EnvFile {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "⚠️  .env file not found: $FilePath" -ForegroundColor Yellow
        return
    }
    
    Write-Host "📄 Loading environment variables from: $FilePath" -ForegroundColor Green
    
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
                
                # Set environment variable
                [Environment]::SetEnvironmentVariable($key, $value, "Process")
                Write-Host "   $key = $value" -ForegroundColor Gray
            }
        }
    }
    
    Write-Host "✅ Environment variables loaded successfully" -ForegroundColor Green
}

# Load the .env file
Load-EnvFile -FilePath $EnvFile

# Also try to load .env.local if it exists (for local overrides)
if (Test-Path ".env.local") {
    Write-Host "📄 Loading local environment overrides from: .env.local" -ForegroundColor Cyan
    Load-EnvFile -FilePath ".env.local"
}
