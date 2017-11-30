id = 'latest-postgres'

secret = ::ChefCookbook::Secret::Helper.new(node)

node.default['postgresql']['config']['listen_addresses'] = '127.0.0.1'
node.default['postgresql']['config']['port'] = 5432

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

include_recipe 'postgresql::contrib'
include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'postgresql::ruby'
