def read(file, default = '')
  IO.read(File.join(File.dirname(__FILE__), file)).strip
rescue Errno::ENOENT
  default
end

name             'transip'
maintainer       'Jean Mertz'
maintainer_email 'jean@mertz.fm'
license          'MIT'
description      'Transip API LWRPs'
long_description read('README.md')
version          read('VERSION', '0.1.0')

supports 'ubuntu'
supports 'debian'
