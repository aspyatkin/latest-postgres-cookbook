name 'latest-postgres'
maintainer 'Alexander Pyatkin'
maintainer_email 'aspyatkin@gmail.com'
license 'MIT'
version '1.0.0'
description 'Installs and configures Postgres'

recipe 'latest-postgres::default', 'Installs and configures Postgres'
depends 'postgresql', '~> 6.1.1'
depends 'instance', '~> 2.0.0'
depends 'secret', '~> 1.0.0'

source_url 'https://github.com/aspyatkin/latest-postgres' if respond_to?(:source_url)

supports 'ubuntu'
