name             'cms'
maintainer       'Masaki Hara'
maintainer_email 'ackie.h.gmai@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures cms'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports "ubuntu"

%w{ build-essential nginx htpasswd database postgresql }.each do|cb|
  depends cb
end

