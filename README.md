# need-some-init.bash
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version: 0.0.1](https://img.shields.io/badge/version-0.0.1-yellowgreen)](0.0.1)
[![need-some-init.bash](https://img.shields.io/badge/need--some-init-ff69b4.svg?logo=github&logoColor=white)](https://github.com/need-some/need-some-init.bash)

_need-some_ is a collection of small yet useful functions.

The init package provides the basis and bootstrapping for the need-some packages.

Installation
Please download the init package and all packages you want to install to a source location

The default installation assumes the following directories which can be set individually:

	export NEEDSOME_ALTERNATIVES=/etc/alternatives
	export NEEDSOME_BIN=/usr/local/bin
	export NEEDSOME_SBIN=/usr/local/sbin
	export NEEDSOME_LIB=/usr/local/lib/need-some

Its recommended to create a common source repository where you download all the packages

	mkdir need-some
	cd need-some
	git clone "https://github.com/need-some/need-some-init.bash.git"
	git clone "https://github.com/need-some/need-some-git.bash.git"
	sudo need-some-init.bash/install-needsome.bash need-some-*

If packages should be upgraded or new ones added, repeat the init script with the same exports (if used)

	sudo need-some-init.bash/install-needsome.bash need-some-*

With the git package installed, you can simply upgrade all

	git all pull

To check if everything is installed, list the currently installed version

	need-some-version


