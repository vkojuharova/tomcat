class tomcat {

  $tomcat_port = 8080
  $tomcat_password = 'badwolf' 

  notice("Establishing http://$hostname:$tomcat_port/")

  Package { # defaults
    ensure => installed,
  }

  package { 'tomcat6':
  }

  package { 'tomcat6-webapps':
    require => Package['tomcat6'],
  }
 
  package { 'tomcat6-admin-webapps':
    require => Package['tomcat6'],
  }

  file { "/etc/tomcat6/tomcat-users.xml":
    owner => 'root',
    require => Package['tomcat6'],
    notify => Service['tomcat6'],
    content => template('tomcat/tomcat-users.xml.erb')
  }

  file { '/etc/tomcat6/server.xml':
     owner => 'root',
     require => Package['tomcat6'],
     notify => Service['tomcat6'],
     content => template('tomcat/server.xml.erb'),
  }

######### add setenv.sh ############
#file { '/etc/tomcat6/bin/setenv.sh':
#    source  => 'puppet:///modules/tomcat/setenv.sh',
#    owner   => 'root',
#    require => Package['tomcat6'],
#    notify  => Service['tomcat6'],
#    content => template('tomcat/setenv.xml.erb'),
#  }
###########

  service { 'tomcat6':
    ensure => running,
    require => Package['tomcat6'],
  }   

}

define tomcat::deployment(
   $shutdown_port = '8005',
   $http_port_enabled='true',
   $http_port='8080',
   $ajp_port='8009',
   $ssl_enabled = 'true'
   $ssl_port='8443',
   $path,

) {

  include tomcat

  notice("Establishing http://$hostname:${tomcat::tomcat_port}/$name/")
  notice("Deploying $name to $path")


  file { "/var/lib/tomcat6/webapps/${name}.war":
    owner => 'root',
    source => $path,
  }

}

