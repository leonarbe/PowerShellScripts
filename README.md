# PowerShell Scripts Library

Welcome to the **PowerShell Scripts Library**, a curated collection of PowerShell-based tools designed to support system administration, automation, and Azure integrations. This repository is intended to streamline common tasks, improve operational efficiency, and promote secure infrastructure practices through reusable scripting patterns.

## 🔧 Features

This library includes scripts for:

- ✅ **Azure Automation**:
  - PowerShell scripts for **Azure Functions** that support event-driven automation.
  - Integration with **Azure Log Analytics**, **Key Vault**, and **Managed Identity**.
  - Structured logging to custom tables using **Data Collection Rules (DCR)**.

- 📁 **Shared Folder Utilities**:
  - Collection and aggregation of file and disk usage statistics.
  - Folder monitoring and reporting (e.g., folder size, inactive files).
  - Timestamped logging and file renaming operations.

- 🖥️ **System Administration**:
  - User and session tracking across Windows systems.
  - Scheduled task automation and execution auditing.
  - Scripted role and permission assignments on file systems or network resources.

- 🔐 **Security and Secrets Handling**:
  - Secure retrieval of secrets from **Azure Key Vault**.
  - Connection authentication to cloud and file resources using service accounts or stored credentials.

## 📁 Directory Structure

. ├── AzureFunctions/ │ └── SendToLogAnalytics.ps1 ├── SharedFolders/ │ ├── CollectFolderStats.ps1 │ └── RenameAndArchiveFiles.ps1 ├── AdminTools/ │ ├── ListLoggedInUsers.ps1 │ └── SetScheduledTask.ps1 ├── templates/ │ └── AzureFunctionBindings.json └── README.md
