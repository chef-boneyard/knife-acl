# knife-acl

# Description

This is a Chef Software, Inc.-supported knife plugin which provides some user/group
ACL operations for Chef server.

All commands assume a working knife configuration for an admin user of a Chef organization.

Reference:

1. [Chef Server Permissions](http://docs.chef.io/server/server_orgs.html#permissions)
2. [Chef Server Groups](http://docs.chef.io/server/server_orgs.html#groups)

### _Warning about Users group_

The "Users" group is a special group and should not be managed with knife-acl.
As such, knife-acl will give an error if either `knife acl group add user users USER`
or `knife acl group remove user users USER` are run.

### Chef Server Roles Based Access Control (RBAC) Summary

In the context of the Chef Server's API a container is just the API endpoint used
when creating a new object of a particular object type.

For example, the container for creating client objects is called `clients` and
the container for creating node objects is called `nodes`.

Two containers are used when creating (uploading) cookbooks.
The `cookbooks` and `sandboxes` containers.

Here is a full list of the containers in a Chef Server.

- clients
- cookbooks
- data
- environments
- groups
- nodes
- roles
- sandboxes

The permissions assigned to a container are inherited by the objects
that the container creates. When a permission is changed on a container
that change will only affect new objects. The change does not propagate to
existing objects.

For reference and restoral purposes the
[Default Permissions for Containers](#default-permissions-for-containers) section
of this document contains `knife-acl` commands that will set the default
permissions for the admins, clients and users groups on all containers.
These can be helpful if you need to restore container permissions back to their
default values.

#### Deny-by-Default Access for Non-admin Users

The "Users" group by default provides regular users a lot of access to modify objects
in the Chef Server. If you want to restrict access the first thing to do is remove the
"Users" group from the Access Control Entries (ACEs) of those objects and their containers.

This will create a Deny-by-Default as far as regular users are considered.
Admin users will still have admin access to objects.

For example, the following commands will completely remove the `users` group from all ACEs of
every container and object in a Chef organization.

```
knife acl remove containers clients create,read,update,delete,grant group users
knife acl bulk remove clients '.*' create,read,update,delete,grant group users


knife acl remove containers sandboxes create,read,update,delete,grant group users
knife acl remove containers cookbooks create,read,update,delete,grant group users
knife acl bulk remove cookbooks '.*' create,read,update,delete,grant group users


knife acl remove containers data create,read,update,delete,grant group users
knife acl bulk remove data '.*' create,read,update,delete,grant group users


knife acl remove containers environments create,read,update,delete,grant group users
knife acl bulk remove environments '.*' create,read,update,delete,grant group users


knife acl remove containers nodes create,read,update,delete,grant group users
knife acl bulk remove nodes '.*' create,read,update,delete,grant group users


knife acl remove containers roles create,read,update,delete,grant group users
knife acl bulk remove roles '.*' create,read,update,delete,grant group users
```

#### Selectively Allow Access

Now you can create a new group and manage its members with knife-acl or the Manage web interface.

Then add this group to the ACEs of all appropriate containers and/or objects according to your requirements.

#### Create read-only group with read only access

The following set of commands creates a group named `read-only` and
gives it `read` access on all objects.

```
knife group create read-only


knife acl add containers clients read group read-only
knife acl bulk add clients '.*' read group read-only


knife acl add containers sandboxes read group read-only
knife acl add containers cookbooks read group read-only
knife acl bulk add cookbooks '.*' read group read-only


knife acl add containers data read group read-only
knife acl bulk add data '.*' read group read-only


knife acl add containers environments read group read-only
knife acl bulk add environments '.*' read group read-only


knife acl add containers nodes read group read-only
knife acl bulk add nodes '.*' read group read-only


knife acl add containers roles read group read-only
knife acl bulk add roles '.*' read group read-only
```

## Installation

This knife plugin is packaged as a gem. The 1.0.0.beta version of knife-acl is currently recommended
so be sure to tell the gem command to install the prerelease.

To install it, enter the following:

## With [Chef DK](https://downloads.chef.io/chef-dk/)

    chef gem install knife-acl --pre

## On the shell of a Chef server active backend

As root:

    /opt/opscode/embedded/bin/gem install knife-acl --pre

## With chef-client installed from a RubyGems

    gem install knife-acl --pre

# Subcommands

## knife user list

Show a list of users associated with your organization

## knife group list

List groups in the organization.

## knife group create GROUP_NAME

Create a new group `GROUP_NAME` to the organization.

## knife group show GROUP_NAME

Show the membership details for `GROUP_NAME`.

## knife group add GROUP_NAME MEMBER_TYPE MEMBER_NAME

Add MEMBER_NAME to `GROUP_NAME`.

Valid `MEMBER_TYPE` values are

- client
- group
- user

## knife group remove GROUP_NAME MEMBER_TYPE MEMBER_NAME

Remove `MEMBER_NAME` from `GROUP_NAME`.

See the `knife group add` documentation above for valid `MEMBER_TYPE` values.

## knife group destroy GROUP_NAME

Removes group `GROUP_NAME` from the organization.  All members of the group
(clients, groups and users) remain in the system, only `GROUP_NAME` is removed.

The `admins`, `billing-admins`, `clients` and `users` groups are special groups
so knife-acl will not allow them to be destroyed.

## knife acl show OBJECT_TYPE OBJECT_NAME

Shows the ACL for the specified object.  Objects are identified by the
combination of their type and name.

Valid `OBJECT_TYPE` values are

- clients
- containers
- cookbooks
- data
- environments
- groups
- nodes
- roles

For example, use the following command to obtain the ACL for a node
named "web.example.com":

    knife acl show nodes web.example.com

## knife acl add OBJECT_TYPE OBJECT_NAME PERMS MEMBER_TYPE MEMBER_NAME

Add `MEMBER_NAME` to the `PERMS` access control entry of `OBJECT_NAME`.
Objects are specified by the combination of their type and name.

Valid `OBJECT_TYPE` values are

- clients
- containers
- cookbooks
- data
- environments
- groups
- nodes
- roles

Valid `PERMS` are:

- create
- read
- update
- delete
- grant

Multiple `PERMS` can be given in a single command by separating them
with a comma with no extra spaces.

Valid `MEMBER_TYPE` values are

- client
- group
- user

For example, use the following command to give the superusers group
the ability to delete and update the node called "web.example.com":

    knife acl add nodes web.example.com delete,update group superusers

## knife acl bulk add OBJECT_TYPE REGEX PERMS MEMBER_TYPE MEMBER_NAME

Add `MEMBER_NAME` to the `PERMS` access control entry for each object in a
set of objects of `OBJECT_TYPE`.

The set of objects are specified by matching the objects' names with the
given REGEX regular expression surrounded by quotes.

See the `knife acl add` documentation above for valid `OBJECT_TYPE`, `PERMS` and `MEMBER_TYPE` values.

For example, use the following command to give the superusers group
the ability to delete and update all nodes matching the regular expression 'WIN-.*':

    knife acl bulk add nodes 'WIN-.*' delete,update group superusers

## knife acl remove OBJECT_TYPE OBJECT_NAME PERMS MEMBER_TYPE MEMBER_NAME

Remove `MEMBER_NAME` from the `PERMS` access control entry of `OBJECT_NAME`.
Objects are specified by the combination of their type and name.

Valid `OBJECT_TYPE` values are

- clients
- containers
- cookbooks
- data
- environments
- groups
- nodes
- roles

Valid `PERMS` are:

- create
- read
- update
- delete
- grant

Multiple `PERMS` can be given in a single command by separating them
with a comma with no extra spaces.

Valid `MEMBER_TYPE` values are

- client
- group
- user

For example, use the following command to remove the superusers group from the delete and
update access control entries for the node called "web.example.com":

    knife acl remove nodes web.example.com delete,update group superusers

## knife acl bulk remove OBJECT_TYPE REGEX PERMS MEMBER_TYPE MEMBER_NAME

Remove `MEMBER_NAME` from the `PERMS` access control entry for each object in a
set of objects of `OBJECT_TYPE`.

The set of objects are specified by matching the objects' names with the
given REGEX regular expression surrounded by quotes.

See the `knife acl remove` documentation above for valid `OBJECT_TYPE`, `PERMS` and `MEMBER_TYPE` values.

For example, use the following command to remove the superusers group from the delete and
update access control entries for all nodes matching the regular expression 'WIN-.*':

    knife acl bulk remove nodes 'WIN-.*' delete,update group superusers

## Default Permissions for Containers

The following commands will set the default permissions for the
admins, clients and users groups on all containers. These can
be helpful if you need to restore container permissions back to their
default values.

```
knife acl add containers clients create,read,update,delete,grant group admins
knife acl remove containers clients create,read,update,delete,grant group clients
knife acl add containers clients read,delete group users
knife acl remove containers clients create,update,grant group users

knife acl add containers cookbooks create,read,update,delete,grant group admins
knife acl add containers cookbooks read group clients
knife acl remove containers cookbooks create,update,delete,grant group clients
knife acl add containers cookbooks create,read,update,delete group users
knife acl remove containers cookbooks grant group users

knife acl add containers data create,read,update,delete,grant group admins
knife acl add containers data read group clients
knife acl remove containers data create,update,delete,grant group clients
knife acl add containers data create,read,update,delete group users
knife acl remove containers data grant group users

knife acl add containers environments create,read,update,delete,grant group admins
knife acl add containers environments read group clients
knife acl remove containers environments create,update,delete,grant group clients
knife acl add containers environments create,read,update,delete group users
knife acl remove containers environments grant group users

knife acl add containers nodes create,read,update,delete,grant group admins
knife acl add containers nodes create,read group clients
knife acl remove containers nodes update,delete,grant group clients
knife acl add containers nodes create,read,update,delete group users
knife acl remove containers nodes grant group users

knife acl add containers roles create,read,update,delete,grant group admins
knife acl add containers roles read group clients
knife acl remove containers roles create,update,delete,grant group clients
knife acl add containers roles create,read,update,delete group users
knife acl remove containers roles grant group users

knife acl add containers sandboxes create,read,update,delete,grant group admins
knife acl remove containers sandboxes create,read,update,delete,grant group clients
knife acl add containers sandboxes create group users
knife acl remove containers sandboxes read,update,delete,grant group users
```

## LICENSE

Unless otherwise specified all works in this repository are

Copyright 2013-2015 Chef Software, Inc.

|||
| ------------- |-------------:|
| Author      |Seth Falcon (seth@chef.io)|
| Author      |Jeremiah Snapp (jeremiah@chef.io)|
| Copyright  |Copyright (c) 2013-2015 Chef Software, Inc.|
| License     |Apache License, Version 2.0|

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
