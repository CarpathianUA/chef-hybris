name 'hybris'
maintainer 'Lachlan Munro'
maintainer_email 'lachlan.munro@rackspace.co.uk'
license 'Apache 2.0'
description 'Provides mysql_service, mysql_config, and mysql_client resources'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'

supports 'centos'

depends 'yum'

source_url 'https://github.com/lmunro/hybris' if respond_to?(:source_url)
issues_url 'https://github.com/lmunro/hybris/issues' if respond_to?(:issues_url)
