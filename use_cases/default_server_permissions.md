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
