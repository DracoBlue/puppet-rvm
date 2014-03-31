define rvm::bash_exec (
  $command = $name,
  $user,
  $creates = undef,
  $cwd = undef,
  $environment = undef,
  $group = undef,
  $logoutput = undef,
  $onlyif = undef,
  $path = undef,
  $provider = "posix",
  $refresh = undef,
  $refreshonly = undef,
  $returns = undef,
  $timeout = undef,
  $tries = undef,
  $try_sleep = undef,
  $umask = undef,
  $unless = undef
) {
  if $cwd == undef {
    $command_prefix = "/bin/su -l ${user} -c \"/bin/bash --login -c \\\""
  } else {
    $command_prefix = "/bin/su -l ${user} -c \"/bin/bash --login -c \\\"cd ${cwd} && "
  }
  $command_suffix = "\\\"\""

  $escaped_command = regsubst($command, "\"", "\\\"", 'G')

  if $unless == undef {
    $escaped_unless = undef
  } else {
    $unless_with_escaped_quotes = regsubst($unless, "\"", "\\\"", 'G')
    $escaped_unless = "${$command_prefix}${unless_with_escaped_quotes}${command_suffix}"
  }

  if $onlyif == undef {
    $escaped_onlyif = undef
  } else {
    $onlyif_with_escaped_quotes = regsubst($onlyif, "\"", "\\\"", 'G')
    $escaped_onlyif = "${$command_prefix}${onlyif_with_escaped_quotes}${command_suffix}"
  }

  exec { $name:
    command => "${$command_prefix}${escaped_command}${command_suffix}",
    creates => $creates,
    cwd => $cwd,
    environment => $environment,
    group => $group,
    logoutput => $logoutput,
    onlyif => $escaped_onlyif,
    path => $path,
    provider => $provider,
    refresh => $refresh,
    refreshonly => $refreshonly,
    returns => $returns,
    timeout => $timeout,
    tries => $tries,
    try_sleep => $try_sleep,
    umask => $umask,
    unless => $escaped_unless
  }
}
