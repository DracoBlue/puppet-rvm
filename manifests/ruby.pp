define rvm::ruby (
  $user,
  $version
) {
  # FIXME: we need to use $user as name here, since single_user_rvm::install_ruby expects it!
  single_user_rvm::install { "${user}":
    user => $user
  }

  single_user_rvm::install_ruby { "ruby-${version}-for-${user}":
    user => $user,
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