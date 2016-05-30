## Allow nodes to update data bags from recipes

The blog post from https://www.chef.io/blog/2014/11/10/security-update-hosted-chef/ is now out of date. So this section covers the ACLs to update data bags from within recipe code, like this sample code to fetch and change `items` from a `dbedit` data bag:

```ruby
ruby_block 'set_databag_item' do
  block do
    items = data_bag_item('dbedit', 'items')
    items['foo'] = 'baz'

    new_databag_item = Chef::DataBagItem.from_hash(items)
    new_databag_item.data_bag('dbedit')
    new_databag_item.save
  end
end
```

Unless you change the default ACLs for the chef server org this will result in a '403 Forbidden'  To allow any client to just update the `dbedit` data bag:

```
knife acl bulk add group clients data 'dbedit' update
```

To allow all clients to update all existing data bags:

```
knife acl bulk add group clients data '.*' update
```

To allow all clients to update any future (yet-to-be-created) data bags:

```
knife acl add group clients containers data update
```

You may want to review your ACLs before/after these changes with: `knife show /acls/containers/data.json`
