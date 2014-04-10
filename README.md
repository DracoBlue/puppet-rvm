# puppet-rvm

This module can be used to install ruby+gems for a single user by using rvm internally. It depends on eirc's `single_user_rvm`
module.

* Latest Release: [![GitHub version](https://badge.fury.io/gh/DracoBlue%2Fpuppet-rvm.png)](https://github.com/DracoBlue/puppet-rvm/releases)
* Official Site: http://dracoblue.net/

puppet-rvm is copyright 2014 by DracoBlue http://dracoblue.net

# Installation

Latest version from [puppet forge](http://forge.puppetlabs.com/DracoBlue/rvm):

``` console
$ puppet module install DracoBlue-rvm
```

Latest version from git.

``` console
$ cd modules
$ git clone https://github.com/DracoBlue/puppet-rvm.git rvm
```

# Dependencies

* `puppetlabs/stdlib >= 4.0.0`
* `eirc/single_user_rvm >= 0.3.0`

# Usage

## Example

``` ruby
rvm::ruby { "my blog":
    user => "blog",
    version => "ruby-2.0.0-p247"
}

rvm::gem { "jekyll":
    ruby => Rvm::Ruby["my blog"],
    ensure => "1.5.0"
}

rvm::gem { ["jekyll-sass", "sass", "sass-globbing", "therubyracer"]:
    ruby => Rvm::Ruby["blog"],
    require => [Rvm::Gem["jekyll"]]
}
```

Result:

* `/home/blog/.rvm` contains a rvm installation
* `ruby` is available as version `ruby-2.0.0-p247`
* the gem `jekyll` is available in version `1.5.0`
* the gems `jekyll-sass`, ... are present on the system

## Types

### `rvm::ruby`

Define which `$version` of ruby is installed for the `$user`.

``` ruby
rvm::ruby { "my blog":
    user => "blog",
    version => "ruby-2.0.0-p247"
}
```

### `rvm::gem`

Define which version (in `$ensure`) of `$gem` must be installed. You may use `$name` as shortcut for `$gem`.

``` ruby
rvm::gem { "my blog's jekyll":
    ruby => Rvm::Ruby["my blog"],
    gem => "jekyll",
    ensure => "1.5.0"
}
```

To make gem present in at least one version:

``` ruby
rvm::gem { "jekyll":
    ruby => Rvm::Ruby["my blog"],
}
```

To ensure it's uninstalled:

``` ruby
rvm::gem { "jekyll":
    ruby => Rvm::Ruby["my blog"],
    ensure => 'absent'
}
```

### `rvm::bash_exec`

Is a shell provider based version of exec, which runs the command in a bash login shell. This makes `rvm` and a proper
`$PATH` available in the environment.

The `rvm::bash_exec` command is used by `rvm::gem` and `rvm::ruby` to set up and work in the users environment.

``` ruby
rvm::bash_exec { "run jekyll":
    user => "blog",
    command => "jekyll build"
}
```

Hint: `rvm::bash_exec` tries to behave exactly like `exec`. Internally it does a `su - $USER` + `bash --login` and heavy
eascaping on quotation marks. So if you want to run a command only under certian conditions, use puppets `unless` and
`onlyif` parameters instead of such: `if [ ... ]; then ... else; fi` stuff.

# Changelog

* 0.2.1 (2014/04/10)
  - replaced self made shell arg escaping with puppets shellquote #1
* 0.2.0 (2014/03/31)
  - fixed cwd in `rvm::bash_exec` #1
  - renamed `rvm::bash-exec` to `rvm::bash_exec`
* 0.1.0 (2014/03/30)
  - Initial release

# TODOs

* make tests available (before 1.x release)

# License

puppet-rvm is licensed under the terms of MIT.
