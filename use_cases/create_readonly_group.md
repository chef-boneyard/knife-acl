## Selectively Allow Access

You can also create a new group and manage its members with knife-acl or the Manage web interface.

Then add this group to the ACEs of all appropriate containers and/or objects according to your requirements.

### Create read-only group with read only access

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
