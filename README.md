cms Cookbook
============

installs and configures [CMS](https://github.com/cms-dev/cms/).

Requirements
------------

These cookbooks are direct dependencies of this cookbook.

* build-essentials (for cms)
* nginx (for cms::proxy)
* htpasswd (for cms::proxy)
* postgresql (for cms::db)

Platforms
------------

Currently, this cookbook supports only Ubuntu.

Attributes
----------

#### cms::default

* `node['cms']['services']` - Corresponds to `core_services` and `other_services` in `cms.conf`.
* `node['cms']['contest_server']` - which port to listen on
* `node['cms']['admin_server']` - which port to listen on
* `node['cms']['ranking_server']` - which port to listen on
* `node['cms']['ranking_server_id']` - which of the configuration to use in `cms.ranking.conf`
* `node['cms']['cmsuser']` - which user to add to the group `cmsuser`
* `node['cms']['db']['password']` - database option
* `node['cms']['db']['database']` - database option
* `node['cms']['db']['server']` - database option.
* `node['cms']['db']['debug']` - Corresponds to `database_debug` in `cms.conf`.
* `node['cms']['twophase_commit']` - Corresponds to `twophase_commit` in `cms.conf`.
* `node['cms']['keep_sandbox']` - whether to keep sandbox in /tmp or delete
* `node['cms']['tornado_debug']` - whether Tornado prints debug information on stdout
* `node['cms']['cookie_duration']` - login cookie duration in seconds
* `node['cms']['submit_local_copy']` - whether to save submissions to disk before storing them in the DB.
* `node['cms']['submit_local_copy_path']` - the path for `submit_local_copy`
* `node['cms']['ip_lock']` - whether to use IP lock or not
* `node['cms']['block_hidden_users']` - whether to block login to hidden users
* `node['cms']['is_proxy_used']` - whether ContestWebServer is behind reverse proxy or not
* `node['cms']['max_submission_length']` - maximum size of a submission in bytes
* `node['cms']['max_input_length']` - maximum size of an input in bytes
* `node['cms']['stl_path']` - STL documentation path in the system
* `node['cms']['allow_communication']` - whether questions and messages are enabled
* `node['cms']['process_cmdline']` - used for process heartbeat check by ResourceService
* `node['cms']['color_shell_log']` - whether to print ANSI color codes
* `node['cms']['color_file_log']` - whether to print ANSI color codes
* `node['cms']['color_remote_shell_log']` - whether to print ANSI color codes
* `node['cms']['color_remote_file_log']` - whether to print ANSI color codes
* `node['cms']['secret_key']` - used to encode information that can be seen by the user
* `node['cms']['auth']['auth_types']` - which instruments to use for logging in
* `node['cms']['auth']['twitter_consumer_key']` - Twitter Consumer Key for logging in via Twitter
* `node['cms']['auth']['twitter_consumer_secret']` - Twitter Consumer Secret for logging in via Twitter
* `node['cms']['auth']['facebook_app_id']` - Facebook App ID for logging in via Facebook
* `node['cms']['auth']['facebook_app_secret']` - Facebook App Secret for logging in via Facebook

#### cms::git

* `node['cms']['git']['repo']` - git repository used in `cms::git`.
* `node['cms']['git']['ref']` - git branch/tag name used in `cms::git`.

Usage
-----

For example, assume there are three servers:
* 192.168.30.11 - for Web server & DB server, and miscellaneous
* 192.168.30.12 - for Judge server 1
* 192.168.30.13 - for Judge server 2

Write three roles, cms, dbserver and webserver.

`roles/cms.json`:

```json
{
  "name": "cms",
  "json_class": "Chef::Role",
  "description": "CMS",
  "chef_type": "role",
  "run_list" : [
    "recipe[cms::git]"
  ],
  "default_attributes": {},
  "override_attributes": {
    "cms": {
      "services": {
        "Worker":            [
          ["192.168.30.12", 26000],
          ["192.168.30.13", 26000]
        ],
        "ResourceService":   [
          ["192.168.30.11", 28000],
          ["192.168.30.12", 28000],
          ["192.168.30.13", 28000]
        ],
        "LogService":        [["192.168.30.11", 29000]],
        "ScoringService":    [["192.168.30.11", 28500]],
        "Checker":           [["192.168.30.11", 22000]],
        "EvaluationService": [["192.168.30.11", 25000]],
        "ContestWebServer":  [["192.168.30.11", 21000]],
        "AdminWebServer":    [["192.168.30.11", 21100]],
        "TestFileCacher":    []
      },
      "is_proxy_used": true,
      "contest_server": [{
        "host": "192.168.30.11",
        "port": 8888
      }],
      "admin_server": [{
        "host": "192.168.30.11",
        "port": 8889
      }],
      "ranking_server": [{
        "username": "SOME_ARBITRARY_USERNAME",
        "password": "SOME_ARBITRARY_PASSWORD",
        "host": "192.168.30.11",
        "port": 8890
      }],
      "cmsuser": ["ubuntu"],
      "db": {
        "password": "SOME_SECURE_PASSWORD_FOR_CMSDB",
        "database": "cmsdb",
        "host": "192.168.30.11"
      },
      "proxy_contest": {
        "host": "cms.example.com",
        "port": 28888
      },
      "proxy_ranking": {
        "host": "cms.example.com",
        "port": 28890
      },
      "proxy_admin": {
        "host": "cms.example.com",
        "port": 28889,
        "username": "ADMIN_USERNAME",
        "password": "ADMIN_PASSWORD"
      },
      "git": {
        "repo": "git://github.com/cms-dev/cms.git",
        "ref": "master"
      },
      "secret_key": "SOME_SECURE_SECRET_KEY",
      "auth": {
        "auth_types": ["Password", "Twitter", "Facebook"],
        "twitter_consumer_key": "TWITTER_CONSUMER_KEY",
        "twitter_consumer_secret": "TWITTER_CONSUMER_SECRET",
        "facebook_app_id": "FACEBOOK_APP_ID",
        "facebook_app_secret": "FACEBOOK_APP_SECRET"
      }
    }
  }
}
```

There are two ways to fetch CMS:
* cms (cms::default): fetch CMS as a tarball
* cms::git: fetch CMS from a git repository

Also note that auth_types are not available in the current master branch of CMS.

`roles/dbserver.json`:

```json
{
  "name": "dbserver",
  "json_class": "Chef::Role",
  "description": "DB Server for CMS",
  "chef_type": "role",
  "run_list" : [
    "role[cms]",
    "recipe[cms::db]"
  ],
  "override_attributes": {},
  "default_attributes": {
    "postgresql": {
      "config": {
        "listen_addresses": "*"
      },
      "password": {
        "postgres": "SOME_SECURE_PASSWORD_FOR_POSTGRES"
      },
      "pg_hba": [
        {"type": "local", "db": "all", "user": "postgres", "addr":           null, "method": "ident"},
        {"type": "local", "db": "all", "user":      "all", "addr":           null, "method": "ident"},
        {"type":  "host", "db": "all", "user":      "all", "addr": "127.0.0.1/32", "method": "md5"},
        {"type":  "host", "db": "all", "user":      "all", "addr":      "::1/128", "method": "md5"},
        {"type": "host", "db": "cmsdb", "user": "cmsuser", "addr": "0.0.0.0/0", "method": "md5"}
      ]
    }
  }
}
```

`roles/dbserver.json`:

```json
{
  "name": "webserver",
  "default_attributes": {},
  "override_attributes": {},
  "json_class": "Chef::Role",
  "description": "Web Server for CMS",
  "chef_type": "role",
  "run_list" : [
    "role[cms]",
    "recipe[cms::proxy]"
  ]
}
```

Then write a node.

`nodes/192.168.30.11.json`:

```json
{
  "run_list": [
    "role[dbserver]",
    "role[webserver]"
  ]
}
```

`nodes/192.168.30.12.json`:

```json
{
  "run_list": [
    "role[cms]"
  ]
}
```

`nodes/192.168.30.13.json`:

```json
{
  "run_list": [
    "role[cms]"
  ]
}
```

Then cook:

```
knife solo cook 192.168.30.11
knife solo cook 192.168.30.12
knife solo cook 192.168.30.13
```

Currently, this cookbook only installs and configures CMS. You have to run CMS by hand.

Contributing
------------

If you can contribute to this cookbook, fork this repository and pull-req!

License and Authors
-------------------

License: The Apache License, Version 2.0
Authors: Masaki Hara (ackie.h.gmai@gmail.com)

