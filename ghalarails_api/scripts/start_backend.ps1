$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

if (Test-Path 'C:\Ruby32-x64\bin') {
  $env:Path = "C:\Ruby32-x64\bin;$env:Path"
}

if (-not (Get-Command ruby -ErrorAction SilentlyContinue)) {
  throw 'Ruby not found in PATH. Install RubyInstaller with DevKit first.'
}

if (-not (Test-Path '.env')) {
  Copy-Item '.env.example' '.env'
  Write-Host 'Created .env from .env.example. Update DB credentials and API keys before production use.' -ForegroundColor Yellow
}

bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rails s -p 3001
