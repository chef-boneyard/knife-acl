# knife-acl

# Description

This is a Chef Software, Inc.-supported knife plugin which provides some user/group
ACL operations for Chef server. All commands assume a working knife
configuration for an organization on a Chef server.

# Warning about Users group

The "Users" group is a special group and should not be managed with knife-acl.
As such, knife-acl will give an error if either `knife acl group add user users USER`
or `knife acl group remove user users USER` are run.

# Restrict Access to Chef Server Objects

The "Users" group by default provides regular users a lot of access to modify objects
in the Chef Server. If you want to restrict access the first thing to do is remove the
"Users" group from the Access Control Entries (ACEs) of those objects. This will create
a Deny-by-Default environment.

Now you can create a new group and manage its members with knife-acl or the Manage web interface.
Then assign permissions to this group as you see fit.

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

Valid `MEMBER_TYPE`s are

- client
- group
- user

## knife group remove GROUP_NAME MEMBER_TYPE MEMBER_NAME

Remove `MEMBER_NAME` from `GROUP_NAME`.

See the `knife group add` documentation above for valid `MEMBER_TYPE`s.

## knife group destroy GROUP_NAME

Removes group `GROUP_NAME` from the organization.  All members of the group
(clients, groups and users) remain in the system, only `GROUP_NAME` is removed.

The `admins`, `billing-admins`, `clients` and `users` groups are special groups
so knife-acl will not allow them to be destroyed.

## knife acl show OBJECT_TYPE OBJECT_NAME

Shows the ACL for the specified object.  Objects are identified by the
combination of their type and name.

Valid `OBJECT_TYPE`s are

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

Add `MEMBER_NAME` to the `PERMS` access control entry of the `OBJECT_NAME`.
Objects are specified by the combination of their type and name.

See the `knife acl show` documentation above for valid `OBJECT_TYPE`s.

Valid `MEMBER_TYPE`s are

- client
- group
- user

Valid `PERMS` are:

- create
- read
- update
- delete
- grant

Multiple `PERMS` can be given in a single command by separating them
with a comma with no extra spaces.

For example, use the following command to give the superusers group
the ability to delete and update the node called "api.example.com":

    knife acl add nodes web.example.com delete,update group superusers

## knife acl remove OBJECT_TYPE OBJECT_NAME PERMS MEMBER_TYPE MEMBER_NAME

Remove `MEMBER_NAME` from the `PERMS` access control entry of `OBJECT_NAME`.
Objects are specified by the combination of their type and name.

See the `knife acl show` documentation above for valid `OBJECT_TYPE`s.
See the `knife acl add` documentation above for the valid `MEMBER_TYPE`s and `PERMS`.

For example, use the following command to remove the superusers group's
ability to delete and update the node called "api.example.com":

    knife acl remove nodes web.example.com delete,update group superusers

## knife acl bulk add OBJECT_TYPE REGEX PERMS MEMBER_TYPE MEMBER_NAME

Add `MEMBER_NAME` to the `PERMS` access control entry for each object in a
set of objects of `OBJECT_TYPE`.

The set of objects are specified by matching the objects' names with the
given REGEX regular expression surrounded by quotes.

See the `knife acl show` documentation above for valid `OBJECT_TYPE`s.
See the `knife acl add` documentation above for the valid `MEMBER_TYPE`s and `PERMS`.

For example, use the following command to add the superusers group's
ability to delete and update all nodes matching the regular expression 'WIN-.*':

    knife acl bulk add nodes 'WIN-.*' delete,update group superusers

## knife acl bulk remove OBJECT_TYPE REGEX PERMS MEMBER_TYPE MEMBER_NAME

Remove `MEMBER_NAME` from the `PERMS` access control entry for each object in a
set of objects of `OBJECT_TYPE`.

The set of objects are specified by matching the objects' names with the
given REGEX regular expression surrounded by quotes.

See the `knife acl show` documentation above for valid `OBJECT_TYPE`s.
See the `knife acl add` documentation above for the valid `MEMBER_TYPE`s and `PERMS`.

For example, use the following command to remove the superusers group's
ability to delete and update all nodes matching the regular expression 'WIN-.*':

    knife acl bulk remove nodes 'WIN-.*' delete,update group superusers

## LICENSE

Unless otherwise specified all works in this repository are

Copyright 2013-2015 Chef Software, Inc.

|||
| ------------- |-------------:|
| Author      |Seth Falcon (seth@chef.io)|
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
