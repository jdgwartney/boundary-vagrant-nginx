# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

node /^ubuntu/ {

  exec { 'update-apt-packages':
    command => '/usr/bin/apt-get update -y',
    creates => '/vagrant/.locks/update-apt-packages',
  }

  package { 'apache2-utils':
    ensure => 'installed',
    require => Exec['update-apt-packages']
  }

  class { 'nginx': 
    require => Package['apache2-utils']
  }

  class { 'boundary':
    token => $boundary_api_token,
    require => Class['nginx']
  }

  exec { 'configure-password':
    command => '/usr/bin/sudo /usr/bin/htpasswd -bc /etc/nginx/.htpasswd boundary onesecond',
    creates => '/etc/nginx/.htpasswd',
    require => Class['nginx']
  }

  file { 'boundary-nginx-conf':
    notify  => Service['nginx'],
    path    => '/etc/nginx/conf.d/boundary.conf',
    ensure  => file,
    source  => '/vagrant/manifests/boundary.conf',
  }
}

# Separate the Cento 7.0 install until the boundary meter puppet package is fixed
node /^centos-7-0/ {

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  package { 'httpd-tools':
    ensure => 'installed',
    require => Package['epel-release']
  }

  class { 'nginx': 
    require => Package['httpd-tools']
  }

  exec { 'configure-password':
    command => '/usr/bin/sudo /usr/bin/htpasswd -bc /etc/nginx/.htpasswd boundary onesecond',
    creates => '/etc/nginx/.htpasswd',
    require => Class['nginx']
  }

  file { 'boundary-nginx-conf':
    notify  => Service['nginx'],
    path    => '/etc/nginx/conf.d/boundary.conf',
    ensure  => file,
    source  => '/vagrant/manifests/boundary.conf',
  }

}

node /^centos/ {

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  package { 'httpd-tools':
    ensure => 'installed',
    require => Package['epel-release']
  }

  class { 'nginx': 
    require => Package['httpd-tools']
  }

  exec { 'configure-password':
    command => '/usr/bin/sudo /usr/bin/htpasswd -bc /etc/nginx/.htpasswd boundary onesecond',
    creates => '/etc/nginx/.htpasswd',
    require => Class['nginx']
  }

  file { 'boundary-nginx-conf':
    notify  => Service['nginx'],
    path    => '/etc/nginx/conf.d/boundary.conf',
    ensure  => file,
    source  => '/vagrant/manifests/boundary.conf',
  }

  class { 'boundary':
    token => $boundary_api_token,
    require => Class['nginx']
  }

}
