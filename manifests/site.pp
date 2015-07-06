# Explictly set to avoid warning message
Package {
  allow_virtual => false,
}

class { 'java':
  distribution => 'jdk',
}

node /^ubuntu/ {

  exec { 'update-apt-packages':
    command => '/usr/bin/apt-get update -y',
    creates => '/vagrant/.locks/update-apt-packages',
    require => Exec['elasticsearch-apt-repo']
  }

  elasticsearch::instance { 'd':
    config => { 'node.master' => 'true', 'node.data' => 'true', 'cluster.name' => 'boundary'},
  }

  class { 'elasticsearch':
    config => { 'cluster.name' => 'boundary' },
    require => [Exec['update-apt-packages'], Class['java']]
  }

  exec { 'elasticsearch-apt-repo-gpg-key':
    command => '/usr/bin/wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo /usr/bin/apt-key add -',
    creates => '/vagrant/.locks/add-elasticsearch-apt-repo-gpg-key'
  }

  exec { 'elasticsearch-apt-repo':
    command => '/bin/echo "deb http://packages.elastic.co/elasticsearch/1.6/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.6.list',
    creates => '/vagrant/.locks/add-elasticsearch-apt-repo',
    require => Exec['elasticsearch-apt-repo-gpg-key']
  }

  elasticsearch::instance { 'd':
    config => { 'node.master' => 'true', 'node.data' => 'true', 'cluster.name' => 'boundary'},
  }

  class { 'boundary':
    token => $boundary_api_token,
    require => Elasticsearch::Instance['d']
  }

}

# Separate the Cento 7.0 install until the boundary meter puppet package is fixed
node /^centos-7-0/ {
  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    require => Class['elasticsearch'],
    source  => '/vagrant/manifests/bash_profile'
  }

  package {'jq':
    ensure => 'installed',
    require => Package['epel-release']
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  # Add the GPG key to our system
  exec { 'elasticsearch-rpm-repo-gpg-key':
    command => '/bin/rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch',
    creates => '/vagrant/.locks/add-elasticsearch-rpm-repo',
    require => Exec['update-rpm-packages']
  }

  # Update our yum repository
  file { 'elasticsearch-rpm-repo':
    path    => '/etc/yum.repos.d/elasticsearch.repo',
    ensure  => file,
    require => Exec['elasticsearch-rpm-repo-gpg-key'],
    source  => '/vagrant/manifests/elasticsearch.repo'
  }

  class { 'elasticsearch':
    config => { 'cluster.name' => 'boundary' },
    require => [File['elasticsearch-rpm-repo'], Class['java']]
  }

  elasticsearch::instance { 'd':
    config => { 'node.master' => 'true', 'node.data' => 'true', 'cluster.name' => 'boundary'},
  }

}

node /^centos/ {

  file { 'bash_profile':
    path    => '/home/vagrant/.bash_profile',
    ensure  => file,
    require => Class['elasticsearch'],
    source  => '/vagrant/manifests/bash_profile'
  }

  package {'jq':
    ensure => 'installed',
    require => Package['epel-release']
  }

  exec { 'update-rpm-packages':
    command => '/usr/bin/yum update -y',
    creates => '/vagrant/.locks/update-rpm-packages',
  }

  package {'epel-release':
    ensure => 'installed',
    require => Exec['update-rpm-packages']
  }

  # Add the GPG key to our system
  exec { 'elasticsearch-rpm-repo-gpg-key':
    command => '/bin/rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch',
    creates => '/vagrant/.locks/add-elasticsearch-rpm-repo',
    require => Exec['update-rpm-packages']
  }

  # Update our yum repository
  file { 'elasticsearch-rpm-repo':
    path    => '/etc/yum.repos.d/elasticsearch.repo',
    ensure  => file,
    require => Exec['elasticsearch-rpm-repo-gpg-key'],
    source  => '/vagrant/manifests/elasticsearch.repo'
  }

  class { 'elasticsearch':
    config => { 'cluster.name' => 'boundary' },
    require => [File['elasticsearch-rpm-repo'], Class['java']]
  }

  elasticsearch::instance { 'd':
    config => { 'node.master' => 'true', 'node.data' => 'true', 'cluster.name' => 'boundary'},
  }

  class { 'boundary':
    token => $boundary_api_token,
    require => Elasticsearch::Instance['d']
  }

}
