#!/bin/sh
## ---------------------------------------------------------------------
## Put licence text here
## ---------------------------------------------------------------------

## DO NOT EDIT
## This file is automatically generated from a file in the repository "krims".
## Edit the original and call the script "update_from_sister_repos.sh" instead.

is_host_up() {
	# Check whether the host is up
	ping -w 2 -c 1 "$@" > /dev/null 2>&1
}

is_url_available() {
	# The url to check
	I_URL="$1"
	# Extract hostname from FROM url
	I_FROMHOST=`echo "$I_URL" | sed -r 's#^https?://([^/]+).*$#\1#'`
	if [ -z "$I_FROMHOST" ]; then
		echo "Invalid url given to is_url_available"
		exit 1
	fi

	is_host_up "$I_FROMHOST"
}

have_checkfile() {
	[ -f "$WHAT/$CHECKFILE" ]
}

mark_update_done() {
	# Flag that the update has been done right now
	#
	# The string used to indicate the last checkout file
	I_WHAT="$1"
	mkdir -p .last_pull
	touch .last_pull/"$I_WHAT"
}

needs_update() {
	# Check the last pull/update time and see if we need update
	#
	# The string used to indicate the last checkout
	I_WHAT="$1"
	#
	# The requested update interval
	I_INTERVAL="$2"
	mkdir -p .last_pull

	I_TMP=`mktemp`
	if ! touch --date="-$I_INTERVAL" $I_TMP; then
		echo "Could not touch temporary file $I_TMP file"
		return 1
	fi
	if [ ! -f ".last_pull/$I_WHAT" -o ".last_pull/$I_WHAT" -ot $I_TMP ]; then
		rm $I_TMP
		return 0
	else
		rm "$I_TMP"
		return 1
	fi
}

checkout_repo () {
	# where to checkout stuff trom
	I_FROM="$1"
	# what repo to checkout
	I_WHAT="$2"
	# the file to check after checkout
	I_CHECKFILE="$3"
	# which branch to checkout
	I_BRANCH="$4"

	# No branch specified
	if [ "$I_BRANCH" ]; then
		I_EXTRA=" (branch: $I_BRANCH)"
		I_ARGS="--branch $I_BRANCH"
	fi

	echo "-- Cloning  $I_WHAT${I_EXTRA}  from git"
	if ! is_url_available "$I_FROM"; then
		echo "   Could not reach url \"$I_FROM\" ... failing." >&2
		return 1
	fi

	git clone $I_ARGS --recursive "$I_FROM" "$I_WHAT" || return 1
	if ! have_checkfile $I_CHECKFILE; then
		echo "   Error ... file $I_CHECKFILE not found after checkout" >&2
		return 1
	fi

	mark_update_done "$I_WHAT" || return 1
	return 0
}

pull_repo() {
	# where to checkout stuff trom
	I_FROM="$1"
	# what repo to checkout
	I_WHAT="$2"
	# The interval after which to perform a pull
	I_INTERVAL="$3"

	if ! needs_update "$I_WHAT" "$I_INTERVAL"; then
		return 0
	fi

	echo "-- Updating  $I_WHAT  from git"
	if is_url_available "$I_FROM"; then
		(
			cd "$I_WHAT" && \
			git pull && \
			git submodule update --init --recursive
		) && \
		mark_update_done "$I_WHAT"
	else
		echo "   No network ... we stay with old version."
	fi
	return 0
}

update_repo() {
	# where to checkout stuff trom
	I_FROM="$1"
	# Name of repo to checkout (i.e. folder to checkout into)
	I_WHAT="$2"
	# File to check inside repo (realative url)
	# if it exists checkout was successful
	I_CHECKFILE="$3"
	# The interval after which to perform a pull
	I_INTERVAL="$4"
	# Optional branch to checkout (if not default)
	I_BRANCH="$5"

	if [ -z "$I_FROM" ]; then
		echo "Please define I_FROM (1st arg) to a non-zero value"
		exit 1
	fi
	if [ -z "$I_WHAT" ]; then
		echo "Please define I_WHAT (2nd arg) to a non-zero value"
		exit 1
	fi
	if [ -z "$I_CHECKFILE" ]; then
		echo "Please define I_CHECKFILE (3rd arg) to a non-zero value"
		exit 1
	fi
	if [ -z "$I_INTERVAL" ]; then
		echo "Please define I_INTERVAL (4th arg) to a non-zero value"
		exit 1
	fi

	if have_checkfile "$I_CHECKFILE"; then
		pull_repo "$I_FROM" "$I_WHAT" && return 0
	else
		checkout_repo "$I_FROM" "$I_WHAT" "$I_CHECKFILE" "$I_BRANCH" && return 0
	fi
	return 1
}