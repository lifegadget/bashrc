#!/bin/bash
# Zip and upload lambda function to AWS
#

set -o errexit

function lambda_usage() {
  echo "Usage: lambda <function.js>"
}

function lambda() {
	if [ $# -lt 1 ]
	then
	  echo 'Missing parameters'
	  lambda_usage
	  exit 1
	fi
	
	# eventually we'll add in other commands 
	# but for now it just publishes to lamda
	main=${1%.js}
	file="./${main}.js"
	zip="./${main}.zip"
	
	role='arn:aws:iam::638281126589:role/lambda_exec_role'
	region='eu-west-1'
	
	# main
	zip_package
	upload_package
}

zip_package() {
  zip -r $zip $file lib node_modules
}

upload_package() {
  aws lambda upload-function \
     --region $region \
     --role $role\
     --function-name $main  \
     --function-zip $zip \
     --mode event \
     --handler $main.handler \
     --runtime nodejs \
     --debug \
     --timeout 10 \
     --memory-size 128
}

