#!/usr/bin/env pwsh

# Check if Azure CLI is installed
if (-not (Get-Command "az" -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI is not installed. Please install it before running this script."
    exit 1
}

$azVersion = az version | ConvertFrom-Json | Select-Object -ExpandProperty "azure-cli"
if ([version]$azVersion -lt [version]"2.66.0") {
    Write-Error "Azure CLI version 2.66.0 or higher is required. Current version: $azVersion"
    exit 1
}

az config set extension.dynamic_install_allow_preview=true 

az config set extension.use_dynamic_install=yes_without_prompt

$testId = "demo-load-test"

az load test create --load-test-resource ${env:AZURE_LOADTEST_NAME} --test-id $testId --test-type Locust --test-plan .\infra\modules\locust.py --resource-group ${env:AZURE_RG_NAME} --env LOCUST_RUN_TIME=300 LOCUST_HOST=${env:AZURE_API_HOST}
