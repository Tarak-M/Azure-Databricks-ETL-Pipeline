# Azure Logic App – Pipeline Failure Notification

## Overview

This Logic App is used to send an email notification when an Azure Data Factory pipeline encounters a failure during data processing.

The Logic App is integrated with Azure Data Factory through an HTTP request trigger and a Web activity.

## Purpose

The Logic App provides a simple failure-notification mechanism for the ETL pipeline.

When a pipeline activity fails:

1. Azure Data Factory detects the failure.
2. The failure path triggers a Web activity.
3. The Web activity sends an HTTP GET request to the Logic App.
4. The Logic App receives the request.
5. The Logic App sends an email notification using Gmail.
6. The notification indicates that an issue occurred during table processing.

## Architecture


Azure Data Factory
        |
        | On Failure
        v
    Web Activity
        |
        | HTTP GET
        v
   Azure Logic App
        |
        v
  HTTP Request Trigger
        |
        v
   Send Gmail V2
        |
        v
   Failure Notification


Logic App Configuration
Trigger

Trigger: When an HTTP request is received

Request Method: GET

The Logic App exposes an HTTP endpoint that can be called by the Azure Data Factory Web activity.

The actual Logic App HTTP endpoint is intentionally not stored in this repository because it may contain access information.

Email Notification

The Logic App uses the Send Gmail V2 action to send the failure notification.

Subject
pipeline failed
Body
issue occurred during table names

The email notification is intended to alert the user when the pipeline encounters an issue during table processing.

Azure Data Factory Integration

The Logic App is called from Azure Data Factory using a Web activity.

The Web activity is connected to the failure path of the relevant pipeline activity.

Web Activity Configuration
Setting	Value
Activity	Web
Method	GET
Trigger	Logic App HTTP Request
Connection	Logic App HTTP endpoint
Execution path	On Failure

The actual Logic App URL is configured directly in Azure Data Factory and is not included in this GitHub repository.

Failure Handling Flow
ADF Pipeline
     |
     v
Copy Data Activity
     |
     +---- Success ----> Success Stored Procedure
     |
     +---- Failure ----> Failure Stored Procedure
                              |
                              v
                         Web Activity
                              |
                              v
                         Logic App
                              |
                              v
                       Gmail Notification
Security

The following information is intentionally excluded from this repository:

Logic App HTTP trigger URL
Gmail credentials
API keys
Access tokens
Passwords
Azure Key Vault secrets
Connection strings containing credentials

These values should be stored and managed through Azure services and application configuration rather than committed to a public GitHub repository.

Technologies Used
Azure Data Factory
Azure Logic Apps
Gmail
HTTP Request Trigger
Web Activity
Azure Data Factory failure handling
