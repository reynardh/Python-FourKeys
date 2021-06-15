# Experimental Terraform setup

This folder contains terraform scripts to provision all of the infrastructure in a Four Keys GCP project. 

**DO NOT USE!** This isn't ready for production yet (though it's close!)

## How to use
1. run `setup.sh`; this will:
  * create a project for Four Keys
  * purge all terraform state [useful during tf development]
  * build containers using Cloud Build
  * create a `terraform.tfvars` file
  * invoke terraform
1. run the following commands to retrieve values needed for your SCM:
  * ```
    echo `terraform output -raw event-handler-endpoint`
    echo `terraform output -raw event-handler-secret`
    ```


Current functionality:
- Create a GCP project (outside of terraform)
- Build the event-handler container image and push to GCR [TODO: use AR instead]
- Deploy the event-handler container as a Cloud Run service
- Emit the event-handler endpoint as an output
- Create and store webhook secret
- Create pubsub
- Set up BigQuery
- Build and deploy bigquery workers
- Emit the secret as an output
- Establish BigQuery scheduled queries
- Generate test data
- Launch Data Studio connector flow
- Support using an existing project
- Allow user to choose whether to generate test data

Open questions:
- Should we create a service account and run TF as that, or keep the current process of using application default credentials of the user who invokes the script?

Answered questions:
- What's an elegant way to support those user inputs (VCS, CI/CD) as conditionals in the TF? (see implementation: generate a list of parsers to create)
- Should we create the GCP project in terraform? No. The auth gets really complicated, especially when considering that the project may or may not be in an organization and/or folder