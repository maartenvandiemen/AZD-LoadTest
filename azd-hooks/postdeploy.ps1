#!/usr/bin/env pwsh

az config set extension.dynamic_install_allow_preview=true 

az config set extension.use_dynamic_install=yes_without_prompt

$testId = "demo-load-test"

az load test create --load-test-resource ${env:AZURE_LOADTEST_NAME} --test-id $testId --test-type Locust --test-plan .\infra\modules\locust.py --resource-group ${env:AZURE_RG_NAME} --env LOCUST_RUN_TIME=300 LOCUST_HOST=${env:AZURE_API_HOST}
