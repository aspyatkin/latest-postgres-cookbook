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

pg_hba = node['postgresql'].to_h.fetch('pg_hba', [])
pg_hba.concat(node[id]['pg_hba'])
node.default['postgresql']['pg_hba'] = pg_hba

include_recipe 'postgresql::contrib'
include_recipe 'postgresql::server'
include_recipe "#{id}::client"
