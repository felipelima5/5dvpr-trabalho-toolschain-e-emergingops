#!/bin/bash

if [ $CREATE_TERRAFORM_WORKSPACE == true ]; then 
  terraform workspace new $ENV 
else 
  terraform workspace select $ENV 
fi