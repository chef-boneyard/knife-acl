## Setup Default Read-Only Access for Non-admin Users

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
