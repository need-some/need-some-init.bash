#!/bin/bash

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

alternatives=""

if [ ! -d "$alt" ]; then
	echo "no alt dir $alt"
else
	alternatives="$(for file in $alt/*; do stat $file -c "%N" | grep -- "-> '$lib/" ; done | cut -d "'" -f 2)"
fi
if [ ! -z "$alternatives" ]; then
	dels="$(echo "${alternatives}" | while read altFile; do
		echo "' -> '$altFile'"
	done)"
	if [ ! -d "$bin" ]; then
		echo "no bin dir $bin"
	else
		echo "removing links from dir $bin"
		for file in $bin/*; do stat $file -c "%N" | grep -F -- "$dels" ; done | cut -d "'" -f 2 | while read file; do
			rm -v $file
		done
	fi
	if [ ! -d "$sbin" ]; then
		echo "no sbin dir $sbin"
	else
		echo "removing links from dir $sbin"
		for file in $sbin/*; do stat $file -c "%N" | grep -F -- "$dels" ; done | cut -d "'" -f 2 | while read file; do
			rm -v $file
		done
	fi
	echo "removing alternatives from $alt"
	echo "${alternatives}" | while read file; do
		rm -v $file
	done
fi

if [ ! -d "$lib" ]; then
	echo "no lib dir $lib"
else
	echo "removing libs $lib"
	rm -rfv $lib
fi

