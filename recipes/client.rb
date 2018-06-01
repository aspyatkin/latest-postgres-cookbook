node.default['postgresql']['pg_gem']['version'] = '0.21.0'
include_recipe 'postgresql::client'
include_recipe 'postgresql::ruby'
