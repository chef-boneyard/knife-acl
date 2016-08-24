# knife-acl

## Description

This is a Chef Software, Inc.-supported knife plugin which provides some user/group
ACL operations for Chef server.

All commands assume a working knife configuration for an admin user of a Chef organization.

Reference:

1. [Chef Server Permissions PDF](https://github.com/chef/chef-server/blob/master/doc/ChefServerPermissions_v1.3.pdf)
2. [Chef Server Permissions Docs](https://docs.chef.io/server/server_orgs.html#permissions)
3. [Chef Server Groups Docs](https://docs.chef.io/server/server_orgs.html#groups)

### Installation

Install into [Chef DK](https://downloads.chef.io/chef-dk/).

    chef gem install knife-acl

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
- policies
- policy_groups
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

#### Permissions Management Best Practice

The best practice for managing permissions is to only add clients and groups to an objects' permissions.

Adding a user to an objects' permissions is possible by first adding the group to the permissions and
then adding the user to the group. This is much easier to maintain when compared to adding
individual users to each objects' permissions.

To enforce this the `knife acl add` and `knife acl bulk add` commands can only add a client or a group
to an objects' permissions.

If a group ever needs to be removed from the permissions of all objects the group can simply
be deleted.

#### Setup Default Read-Only Access for Non-admin Users

The "Users" group by default provides regular (non-admin) users a lot of access to modify objects in
the Chef Server.

Removing the "Users" group from the "create", "update", "delete" and "grant" Access Control Entries (ACEs)
of all objects and containers will create a default read-only access for non-admin users.

To completely prevent non-admin users from accessing all objects and containers then also remove the
"Users" group from the "read" ACE.

Admin users will still have default admin access to all objects and containers.

**NOTE:** Please note that currently the Chef Manage web UI will appear to allow read-only users to edit
some objects. However, the changes are not actually saved and they disappear when the read-only
user refreshes the page.

```
knife acl remove group users containers clients create,update,delete,grant
knife acl bulk remove group users clients '.*' create,update,delete,grant


knife acl remove group users containers sandboxes create,update,delete,grant
knife acl remove group users containers cookbooks create,update,delete,grant
knife acl bulk remove group users cookbooks '.*' create,update,delete,grant


knife acl remove group users containers data create,update,delete,grant
knife acl bulk remove group users data '.*' create,update,delete,grant


knife acl remove group users containers environments create,update,delete,grant
knife acl bulk remove group users environments '.*' create,update,delete,grant


knife acl remove group users containers nodes create,update,delete,grant
knife acl bulk remove group users nodes '.*' create,update,delete,grant


knife acl remove group users containers policies create,update,delete,grant
knife acl bulk remove group users policies '.*' create,update,delete,grant


knife acl remove group users containers policy_groups create,update,delete,grant
knife acl bulk remove group users policy_groups '.*' create,update,delete,grant


knife acl remove group users containers roles create,update,delete,grant
knife acl bulk remove group users roles '.*' create,update,delete,grant
```

#### Selectively Allow Access

You can also create a new group and manage its members with knife-acl or the Manage web interface.

Then add this group to the ACEs of all appropriate containers and/or objects according to your requirements.

#### Create read-only group with read only access

The following set of commands creates a group named `read-only` and
gives it `read` access on all objects.

```
knife group create read-only


knife acl add group read-only containers clients read
knife acl bulk add group read-only clients '.*' read


knife acl add group read-only containers sandboxes read
knife acl add group read-only containers cookbooks read
knife acl bulk add group read-only cookbooks '.*' read


knife acl add group read-only containers data read
knife acl bulk add group read-only data '.*' read


knife acl add group read-only containers environments read
knife acl bulk add group read-only environments '.*' read


knife acl add group read-only containers nodes read
knife acl bulk add group read-only nodes '.*' read


knife acl add group read-only containers policies read
knife acl bulk add group read-only policies '.*' read


knife acl add group read-only containers policy_groups read
knife acl bulk add group read-only policy_groups '.*' read


knife acl add group read-only containers roles read
knife acl bulk add group read-only roles '.*' read
```

# Subcommands

## knife user list

Show a list of users associated with your organization

## knife group list

List groups in the organization.

## knife group create GROUP_NAME

Create a new group `GROUP_NAME` to the organization.

## knife group show GROUP_NAME

Show the membership details for `GROUP_NAME`.

## knife group add MEMBER_TYPE MEMBER_NAME GROUP_NAME

Add MEMBER_NAME to `GROUP_NAME`.

Valid `MEMBER_TYPE` values are

- client
- group
- user

## knife group remove MEMBER_TYPE MEMBER_NAME GROUP_NAME

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
- policies
- policy_groups
- roles

For example, use the following command to obtain the ACL for a node
named "web.example.com":

    knife acl show nodes web.example.com

## knife acl add MEMBER_TYPE MEMBER_NAME OBJECT_TYPE OBJECT_NAME PERMS

The best practice is to only add clients and groups to ACLs. To enforce this best practice
the `knife acl add` command is only able to add a client or a group to ACLs.

Valid `MEMBER_TYPE` values are

- client
- group

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
- policies
- policy_groups
- roles

Valid `PERMS` are:

- create
- read
- update
- delete
- grant

Multiple `PERMS` can be given in a single command by separating them
with a comma with no extra spaces.

For example, use the following command to give the superusers group
the ability to delete and update the node called "web.example.com":

    knife acl add group superusers nodes web.example.com delete,update

## knife acl bulk add MEMBER_TYPE MEMBER_NAME OBJECT_TYPE REGEX PERMS

The best practice is to only add clients and groups to ACLs. To enforce this best practice
the `knife acl bulk add` command is only able to add a client or a group to ACLs.

Valid `MEMBER_TYPE` values are

- client
- group

Add `MEMBER_NAME` to the `PERMS` access control entry for each object in a
set of objects of `OBJECT_TYPE`.

The set of objects are specified by matching the objects' names with the
given REGEX regular expression surrounded by quotes.

See the `knife acl add` documentation above for valid `OBJECT_TYPE` and `PERMS` values.

Appending `-y` or `--yes` to the `knife acl bulk add` command will run the command
without any prompts for confirmation.

For example, use the following command to give the superusers group the ability to
delete and update all nodes matching the regular expression 'WIN-.*':

    knife acl bulk add group superusers nodes 'WIN-.*' delete,update --yes

## knife acl remove MEMBER_TYPE MEMBER_NAME OBJECT_TYPE OBJECT_NAME PERMS

Remove `MEMBER_NAME` from the `PERMS` access control entry of `OBJECT_NAME`.
Objects are specified by the combination of their type and name.

Valid `MEMBER_TYPE` values are

- client
- group
- user

Valid `OBJECT_TYPE` values are

- clients
- containers
- cookbooks
- data
- environments
- groups
- nodes
- policies
- policy_groups
- roles

Valid `PERMS` are:

- create
- read
- update
- delete
- grant

Multiple `PERMS` can be given in a single command by separating them
with a comma with no extra spaces.

For example, use the following command to remove the superusers group from the delete and
update access control entries for the node called "web.example.com":

    knife acl remove group superusers nodes web.example.com delete,update

## knife acl bulk remove MEMBER_TYPE MEMBER_NAME OBJECT_TYPE REGEX PERMS

Remove `MEMBER_NAME` from the `PERMS` access control entry for each object in a
set of objects of `OBJECT_TYPE`.

The set of objects are specified by matching the objects' names with the
given REGEX regular expression surrounded by quotes.

See the `knife acl remove` documentation above for valid `MEMBER_TYPE`, `OBJECT_TYPE` and `PERMS` values.

Appending `-y` or `--yes` to the `knife acl bulk add` command will run the command
without any prompts for confirmation.

For example, use the following command to remove the superusers group from the delete and
update access control entries for all nodes matching the regular expression 'WIN-.*':

    knife acl bulk remove group superusers nodes 'WIN-.*' delete,update --yes

## Default Permissions for Containers

The following commands will set the default permissions for the
admins, clients and users groups on all containers. These can
be helpful if you need to restore container permissions back to their
default values.

```
knife acl add group admins containers clients create,read,update,delete,grant
knife acl remove group clients containers clients create,read,update,delete,grant
knife acl add group users containers clients read,delete
knife acl remove group users containers clients create,update,grant

knife acl add group admins containers cookbook_artifacts create,read,update,delete,grant
knife acl add group clients containers cookbook_artifacts read
knife acl remove group clients containers cookbook_artifacts create,update,delete,grant
knife acl add group users containers cookbook_artifacts create,read,update,delete
knife acl remove group users containers cookbook_artifacts grant

knife acl add group admins containers cookbooks create,read,update,delete,grant
knife acl add group clients containers cookbooks read
knife acl remove group clients containers cookbooks create,update,delete,grant
knife acl add group users containers cookbooks create,read,update,delete
knife acl remove group users containers cookbooks grant

knife acl add group admins containers data create,read,update,delete,grant
knife acl add group clients containers data read
knife acl remove group clients containers data create,update,delete,grant
knife acl add group users containers data create,read,update,delete
knife acl remove group users containers data grant

knife acl add group admins containers environments create,read,update,delete,grant
knife acl add group clients containers environments read
knife acl remove group clients containers environments create,update,delete,grant
knife acl add group users containers environments create,read,update,delete
knife acl remove group users containers environments grant

knife acl add group admins containers groups create,read,update,delete,grant
knife acl remove group clients containers groups create,read,update,delete,grant
knife acl add group users containers groups read
knife acl remove group users containers groups create,update,delete,grant

knife acl add group admins containers nodes create,read,update,delete,grant
knife acl add group clients containers nodes create,read
knife acl remove group clients containers nodes update,delete,grant
knife acl add group users containers nodes create,read,update,delete
knife acl remove group users containers nodes grant

knife acl add group admins containers policies create,read,update,delete,grant
knife acl add group clients containers policies read
knife acl remove group clients containers policies create,update,delete,grant
knife acl add group users containers policies create,read,update,delete
knife acl remove group users containers policies grant

knife acl add group admins containers policy_groups create,read,update,delete,grant
knife acl add group clients containers policy_groups read
knife acl remove group clients containers policy_groups create,update,delete,grant
knife acl add group users containers policy_groups create,read,update,delete
knife acl remove group users containers policy_groups grant

knife acl add group admins containers roles create,read,update,delete,grant
knife acl add group clients containers roles read
knife acl remove group clients containers roles create,update,delete,grant
knife acl add group users containers roles create,read,update,delete
knife acl remove group users containers roles grant

knife acl add group admins containers sandboxes create,read,update,delete,grant
knife acl remove group clients containers sandboxes create,read,update,delete,grant
knife acl add group users containers sandboxes create
knife acl remove group users containers sandboxes read,update,delete,grant
```

## LICENSE

Unless otherwise specified all works in this repository are

Copyright 2013-2016 Chef Software, Inc.

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
