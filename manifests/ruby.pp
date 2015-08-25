define rvm::ruby (
  $home = "/home/${user}",
  $user,
  $version
) {
  # FIXME: we need to use $user as name here, since single_user_rvm::install_ruby expects it!
  single_user_rvm::install { "${user}":
    user => $user,
    home => $home,
    require => [Exec['rvm-fix-to-install-single-user-rvm-gpg-key']]
  }

  if ! defined(Package['gnupg2']) {
    package { 'gnupg2':
       ensure => present
    }
  }

  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present
    }
  }

  # FIXME: single_user_rvm 0.3.0 does not support the gpg key, so we need to download it on
  # our own
  exec { 'rvm-fix-to-install-single-user-rvm-gpg-key':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => 'curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -',
    user        => "${user}",
    unless      => 'gpg2 --list-keys D39DC0E3',
    require     => [Package['gnupg2'], Package['curl']],
  }

  single_user_rvm::install_ruby { "ruby-${version}-for-${user}":
    user => $user,
    home => $home,
    ruby_string => $version,
    require => [Single_User_Rvm::Install[$user]]
  }

  rvm::bash_exec { "rvm-switched-for-${user}":
    command => "rvm use --default ${version}",
    user => $user,
    logoutput => false,
    require => Single_user_rvm::Install_Ruby["ruby-${version}-for-${user}"],
    unless => "rvm current | grep '${version}'"
  }
}
