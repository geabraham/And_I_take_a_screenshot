# Minotaur Installation Guide

## Summary ##

This document specifies the how to configure the [Minotaur](https://github.com/mdsol/minotaur) application in Medistrano for a twelve-factor deployment using Corrals.

## Environment Settings

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
| AWS Account         | aws-green (aws-red if production or innovate)               |
| AMI                 | Medidata Ubuntu 14.04 + Ruby v2.1.2                         |
| Instance type /size | m1.medium                                                    |
| Chef bootstrap Type | omnibus - new mdsol_base                                    |
| Chef client v.      | 11.12.4                                                     |
| Ruby version        | no-ruby                                                     |
| Chef runlist        | mdsol_base, mdsol_logging, twelve_factor                    |
| Chef Data Bag       | twelve_factor_environment                                   |

### Chef override values

```
{
  "twelve_factor": {
    "application": "minotaur-<stage>-app-DEFAULT"
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

## Twelve-factor databag settings

```
{

  "deploy_env": {
    "deploy_id": "2014-10-29_18-51-57",
    "deploy_to": "/mnt/minotaur",
    "user": "minotaur",
    "source_type": "git",
    "source_gitpath": "git@github.com:mdsol/minotaur.git",
    "source_gitref": "develop",
    "cmd_build": [
      "gem install bundler",
      "bundle install",
      "bundle exec rake config"
    ],
    "cmd_release": [
      "bundle exec rake release"
    ],
    "processes": {
      "web": "bundle exec rails s -p $HTTP_PORT"
    },
    "ssl_cert": "/etc/secrets/ssl/private/crt.crt",
    "ssl_cert_key": "/etc/secrets/ssl/private/key.key"
  },
  "application_env": {
    "HTTP_PORT": "3300",
    "domain": "minotaur-<stage>.imedidata.net"
  }
}
```

Note:
1) deploy_env.source_gitref should be a tag in production.
2) application_env.domain should be the domain selected in the ELB.
