id = 'latest-postgres'

secret = ::ChefCookbook::Secret::Helper.new(node)

node.default['postgresql']['config']['listen_addresses'] = node[id]['listen']['address']
node.default['postgresql']['config']['port'] = node[id]['listen']['port']

contrib_package_list = node['postgresql']['contrib'].to_h.fetch('packages', [])
node.default['postgresql']['contrib']['packages'] = contrib_package_list

extension_list = node['postgresql']['contrib'].to_h.fetch('extensions', [])
if node[id]['extension']['citext']
  extension_list << 'citext'
end

node.default['postgresql']['contrib']['extensions'] = extension_list

require 'digest/md5'

postgres_root_username = 'postgres'
postgres_pwd_digest = ::Digest::MD5.hexdigest("#{secret.get('postgres:password:' + postgres_root_username)}#{postgres_root_username}")
node.default['postgresql']['password'][postgres_root_username] = \
  "md5#{postgres_pwd_digest}"

node.default['postgresql']['pg_gem']['version'] = '0.21.0'

include_recipe 'postgresql::contrib'
include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'postgresql::ruby'
