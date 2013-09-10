# knife ACL

# Description

This is an UNOFFICIAL and EXPERIMENTAL knife plugin to support basic
user/group operations for Hosted Chef. All commands assume a working
knife config for an org on Hosted Chef.

You can use these commands to manage a read-only group.  To do so:

1. Run `knife actor map` to create/update a local actor map file
   `actor-map.yaml`:

        knife actor map

2. In the webUI, create a group that will hold read-only users.

3. For each user you wish to have read only access as defined by
   permissions given to the "read-only" group do the following:

        knife group add actor read-only USER
        knife group remove actor users USER

   This adds the user to the 'read-only' group and removes them from the
   'users' group which has more permissions by default (users are
   added to 'users' when added to an org).

# Installation

This knife plugin is packaged as a gem.  To install it, enter the
following:

#### Gem installed chef-client on a workstation
    gem install knife-acl

    # or if the gem has yet to be published to Rubygems
    gem build knife-acl.gemspec
    gem install knife-acl-x.y.z.gem

#### Opscode hosted Enterprise Chef (OHC) with an Omnibus-installed chef-client on a workstation
/opt/chef/embedded/bin/gem install knife-acl

#### Opscode Enterprise Chef (OPC) Directly on the active backend
as root: /opt/opscode/embedded/bin/gem install knife-acl

# Subcommands

## knife user list

Show a list of users associated with your org

## knife actor map

Create a local map file actor-map.yaml" that maps users to their User
Specific Association Group (USAG) and stores a list of clients.  USAGs
are an implementation detail that will likely be hidden or otherwise
change in the future.  USAGs are currently the correct way to
add/remove users to/from groups in an org.

This command creates a local cache of the user to USAG mapping as well
as a local cache of clients and is used by the following commands:
- `knife group show`,
- `knife group add actor`, and
- `knife group remove actor`.

## knife group list

List groups in the org.

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

## knife acl show OBJECT_TYPE OBJECT_NAME

Shows the ACL for the specified object.  Objects are identified by the
combination of their type and name.

Valid `OBJECT_TYPE`'s are

- clients
- groups
- containers
- data
- nodes
- roles
- cookbooks
- environments

For example, use the following command to obtain the ACL for a node
named "web.example.com":

    knife acl show nodes web.example.com

## knife acl add OBJECT_TYPE OBJECT_NAME PERM [group|client] NAME

Add the group or client with NAME to the PERM access control entry of
the object.  Objects are specified by the combination of
their type and name.  See the `knife acl show` documentation above for
the permitted types.

Valid `PERM`s are:

- create
- read
- update
- delete
- grant

For example, use the following command to give the superuser group
the ability to delete the node called "api.example.com":

    knife acl add node api.exmaple.com delete group superusers

## knife acl remove OBJECT_TYPE OBJECT_NAME PERM [group|client] NAME

Remove group or client with NAME from the PERM access control entry of
the specified object.  Objects are specified by the combination of
their type and name.  See the `knife acl show` documentation above for
the permitted types.  See the `knife acl add` documentation abouve for
the permitted `PERMS`s.

For example, use the following command to remove the superuser group's
ability to delete the node called "api.example.com":

    knife acl remove node api.exmaple.com delete group superusers


## TODO

- Feature: create/delete groups
- Feature: build group membership graph
- Remove duplication in commands
- Staleness detector for actor map
- Improve error messages when actor map is missing
- Don't save group if it will be a no-op

## LICENSE

Unless otherwise specified all works in this repository are

Copyright 2013 Opscode, Inc

||| 
| ------------- |-------------:|
| Author      |Seth Falcon (seth@opscode.com)|
| Copyright  |Copyright (c) 2013 Opscode, Inc.|
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
