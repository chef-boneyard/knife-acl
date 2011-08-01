# knife ACL

# Description

This is an UNOFFICIAL and EXPERIMENTAL knife plugin to support basic
user/group operations for Hosted Chef. All commands assume a working
knife config for an org on Hosted Chef.

You can use these commands to manage a read-only group.  To do so:

1. Run `knife user map` to create/update a local user map file
   `user-map.yaml`.

2. In the webUI, create a group that will hold read-only users.

3. For each user you wish to have read only access as defined by
   permissions given to the "read-only" group do the following:

       knife group add read-only USER
       knife group remove users USER

# Installation

Place all the `*.rb` files in `~/.chef/plugins/knife`.

# Subcommands

## knife user list

Show a list of users associated with your org

## knife user map

Create a local map file "user-map.yaml" that maps users to their User
Specific Association Group (USAG).  USAGs are an implementation detail
that will likely be hidden or otherwise change in the future.  USAGs
are currently the correct way to add/remove users to/from groups in an
org.

This command created a local cache of the user to USAG mapping and is
used by `knife group show`, `knife group add`, and `knife group
remove`.

## knife group list

List groups in the org.

## knife group show GROUP

Show the details membership details for `GROUP`. If you have run
`knife user map`, the user map file will be used to annotate USAGs so
you can see what user they represent.

## knife group add GROUP USER

Add USER to GROUP.  Requires an up-to-date user map as created by
`knife user map`.  The user's USAG will be added as a subgroup of
GROUP.

## knife group remove GROUP USER

Remove USER from GROUP. Requires an up-to-date user map as created by
`knife user map`.  The user's USAG will be removed from the subgroups
of GROUP.



