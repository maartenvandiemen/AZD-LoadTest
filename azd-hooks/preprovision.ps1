$testId = "demo-load-test"

$output = az load test delete --load-test-resource ${env:AZURE_LOADTEST_NAME} --test-id $testId --resource-group ${env:AZURE_RG_NAME} --yes
