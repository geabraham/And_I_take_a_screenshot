# Minotaur Installation Guide

## Summary ##

This document specifies the how to configure the [Minotaur](https://github.com/mdsol/minotaur) application in Medistrano for a twelve-factor deployment using Corrals.

## Environment Settings

AWS account should be one of:

- aws-green
- aws-red if production or innovate

New Relic Account should be one of:

- Medidata PaaS Development
- Medidata PaaS Production

Both of the following should be selected

- Enable Application Monitoring
- Enable Server Monitoring

## Corral Settings

### App Node Configuration Values
| Attribute           | Value                                                       |
| -------------       | ---------------                                             |
| Role                | app                                                         |
| AMI                 | Medidata Ubuntu 14.04 + Ruby v2.1.2                         |
| Instance type /size | m3.large                                                   |
| HTTP(S) Access Level| public                                                      |
| Chef client v.      | 11.12.4                                                     |
| Chef runlist        | mdsol_base, mdsol_logging, twelve_factor                    |
| 12-Factor Deployments? | true                                                 |

### Chef override values

```
{
  "twelve_factor": {
    "application": "minotaur-<stage>-app-web"
  },
  "mdsol": {
    "logging": {
      "local_log_sources": [
        {
          "name": "Minotaur<Stage>AppLog",
          "description": "",
          "pathExpression": "/mnt/minotaur/current/log/web/current",
          "category": "Application",
          "sourceType": "LocalFile"
        }
      ]
    }
  }
}
```

## Add Patient Cloud Registration app in iMedidata

You must be logged in to iMedidata as an admin user. Navigate to apps management. Create a new app with the following attributes:

* name: **Patient Cloud Registration**
* base_url:
    * development stages: **`shield-<stage>.imedidata.net/patient_management`**
    * innovate: **`shield-innovate.imedidata.com/patient_management`**
    * production: **`shield.imedidata.com/patient_management`**
* public_key: a valid public key

No other attibutes are required. Save the app. If successful, a uuid will be generated and displayed on the app's show page.

**Use the app uuid and public key for mAuth registration. The app uuid and the private key paired with the public key must be used in the twelve-factor databag.**

**Add the app_uuid to the Subjects' app_uuids whitelist and re-deploy Subjects.**

## Twelve-factor databag settings

Use the template databag [baseline_app_databag.json](baseline_app_databag.json) and modify placeholders, marked \<PLACEHOLDER\>, as required.

Note:

1. deploy_env.source_gitref should be a tag in production.
2. application_env.domain should be the domain selected in the ELB.
3. id should match twelve_factor.application in chef overrides
