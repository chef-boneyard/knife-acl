# knife-acl

# Description

This is a Chef Software, Inc.-supported knife plugin which provides some user/group
ACL operations for Chef server. All commands assume a working knife
configuration for an organization on a Chef server.

# User Specific Association Groups

User Specific Association Groups (USAGs) are a mechanism to grant access to
organization objects to users such that it is possible to quickly revoke the
access without touching all objects in the organization.

Each USAG contains a single user. The USAG is then added to other groups or
directly to the ACLs of an object as needed.

When the user is dissociated from an organization only the user's USAG needs to
be deleted thereby quickly revoking access to all objects in the organization.

USAGs and their membership within other normal groups are not visible in the
[management console's web interface](https://manage.chef.io).

## STOP managing group membership with the web interface

USAGs are currently the correct way to add/remove users to/from groups in an
organization.

**Be warned**, once you start managing a group's membership using `knife-acl`
you should **avoid managing that group's membership using the [management
console's web interface](https://manage.chef.io)**.

You can add USAGs to a group using `knife-acl` but if you click "Save Group" in
the web interface then all USAGs will be removed from the group erasing any
`knife-acl` work that was done on the group. This will happen even if no
changes were made to the group's members in the web interface.

The "users" group is a special group. When a user is associated with an
organization the user's USAG is automatically made a member of the
"users" group. You can remove USAGs from the "users" group using `knife-acl`
but if you click "Save Group" in the web interface then all USAGs in the
organization will be added back to the "users" group erasing any `knife-acl`
work that was done on the "users" group. This will happen even if no changes
were made to the group's members in the web interface.

# Example: Manage a read-only Group

You can use these commands to manage a read-only group.  To do so:

1. Run `knife actor map` to create/update a local actor map file
   `actor-map.yaml`:

        knife actor map

2. Create a group that will hold read-only users:

        knife group create read-only

3. For each user you wish to have read only access as defined by
   permissions given to the "read-only" group do the following:

        knife group add actor read-only USER
        knife group remove actor users USER

   This adds the user to the "read-only" group and removes them from the
   "users" group which has more permissions by default (users are
   added to "users" when added to an organizaton).

# Installation

This knife plugin is packaged as a gem.  To install it, enter the
following:

## With [Chef DK](https://downloads.chef.io/chef-dk/)

    chef gem install knife-acl

## On the shell of a Chef server active backend

As root:

    /opt/opscode/embedded/bin/gem install knife-acl

## With chef-client installed from a RubyGems

    gem install knife-acl

# Subcommands

## knife user list

Show a list of users associated with your organization

## knife actor map

Create a local map file named "actor-map.yaml" that maps users to their USAG
and stores a list of clients.

This command creates a local cache of the user to USAG mapping as well
as a local cache of clients and is used by the following commands:

- `knife group show`
- `knife group add actor`
- `knife group remove actor`

## knife group create

Create a new group.

## knife group list

List groups in the organization.

## knife group show GROUP

Show the details membership details for `GROUP`. If you have run
`knife actor map`, the user map file will be used to annotate USAGs so
you can see what user they represent.

## knife group add actor GROUP ACTOR

Add ACTOR to GROUP.  ACTOR can be a user name or a client
name. Requires an up-to-date actor map as created by `knife actor
map`.  The user's USAG will be added as a subgroup of GROUP if ACTOR
is a user.

## knife group remove actor GROUP ACTOR

Remove ACTOR from GROUP. Requires an up-to-date actor map as created by
`knife actor map`.  The user's USAG will be removed from the subgroups
of GROUP if ACTOR is a user.

## knife group destroy GROUP

Removes `GROUP` from the organization.  All members of the group (both
actors and groups) remain in the system, only `GROUP` is removed.

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
