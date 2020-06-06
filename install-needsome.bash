#!/bin/bash

if [ $# -eq 0 ]; then
	echo no package to install
fi

#NEEDSOME_ALTERNATIVES=$HOME/var/alternatives
#NEEDSOME_BIN=$HOME/bin
#NEEDSOME_SBIN=$HOME/bin
#NEEDSOME_LIB=$HOME/var/lib/need-some

if [ ! -z "$NEEDSOME_ALTERNATIVES" ]; then
	alt="$NEEDSOME_ALTERNATIVES"
else
	alt=/etc/alternatives
fi

if [ ! -z "$NEEDSOME_BIN" ]; then
	bin="$NEEDSOME_BIN"
else
	bin=/usr/local/bin
fi

if [ ! -z "$NEEDSOME_SBIN" ]; then
	sbin="$NEEDSOME_SBIN"
else
	sbin=/usr/local/sbin
fi

if [ ! -z "$NEEDSOME_LIB" ]; then
	lib="$NEEDSOME_LIB"
else
	lib=/usr/local/lib/need-some
fi

if [ ! -d "$lib" ]; then
	mkdir "$lib"
	if [ $? -ne 0 ]; then
		echo "Could not mkdir $lib" 1>&2
		exit 2
	fi
fi

if [ ! -d "$alt" ]; then
	echo "$alt is no directory" 1>&2
	exit 2
fi
if [ ! -d "$bin" ]; then
	echo "$bin is no directory" 1>&2
	exit 2
fi
if [ ! -d "$sbin" ]; then
	echo "$sbin is no directory" 1>&2
	exit 2
fi

function createLink() {
	from="$2"
	to="$1"
	if [ -L "$from" ]; then
		oldtarget="$(readlink "$from")"
		if [ "$oldtarget" != "$to" ]; then
			echo "Replace $from -> $oldtarget"
			rm "$from"
			ln -s "$to" "$from"
		fi
	else
		ln -s "$to" "$from"
	fi
}

while [ $# -gt 0 ]; do
	dir="$1"
	shift
	echo Install $dir
	if [ ! -d "$dir" ]; then
		echo "$dir is no directory" 1>&2
		exit 1
	fi
	pack="$(basename "$dir")"
	if [ -d "$lib/$pack" ]; then
		# TODO: remove superfluous links
		# TODO: create backup
		# TODO: keep contents with rsync
		rm -rfv "$lib/$pack"
	fi
	mkdir "$lib/$pack"
	cp -a "$dir"/src/* "$lib/$pack/"
	cp -a "$dir"/LICENSE "$lib/$pack/"
	cp -a "$dir"/README.* "$lib/$pack/"
	cp -a "$dir"/NEEDSOME-VERSION "$lib/$pack/" || echo "no version file"
	for file in "$lib/$pack/bin"/*; do
		if [ "$(basename "$file")" = "*" ]; then
			echo "no bin files in $lib/$pack"
		else
			echo link $file
			cmd="$(basename "$file")"
			createLink "$file" "$alt/$cmd"
			createLink "$alt/$cmd" "$bin/$cmd"
		fi
	done
	for file in "$lib/$pack/sbin"/*; do
		if [ "$(basename "$file")" = "*" ]; then
			echo "no sbin files in $lib/$pack"
		else
			echo link $file
			cmd="$(basename "$file")"
			createLink "$file" "$alt/$cmd"
			createLink "$alt/$cmd" "$sbin/$cmd"
		fi
	done
done

