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

    gem install knife-acl
    # or if the gem has yet to be published to Rubygems
    gem install knife-acl-x.y.z.gem

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



