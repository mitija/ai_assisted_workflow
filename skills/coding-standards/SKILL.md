---
name: coding-standards
description: Coding standards to apply when writing or reviewing application code. Use whenever adding or modifying code that runs as an application, script, or service. Currently covers logging requirements.
allowed-tools: Read, Grep, Glob, Edit, Write
---

# Coding Standards

Apply these standards when writing or modifying application code (apps, scripts,
services, background workers). They define what the produced code should look
like, independent of any specific project.

## Logging

The application should write logs. At a minimum, record:

- Start of the application with a summary of key configuration parameters
- Key use cases:
  - Login
  - Logout
  - Interfaces with external systems
  - Other important use cases
- Errors
- Summary of the action done — especially important when:
  - this is a headless script
  - this is a background process
  - the action relates to a 3rd-party interface
- End of the application

Each log entry must be timestamped.

Where possible, use the logging library that ships with the language or
framework in use rather than rolling your own.
