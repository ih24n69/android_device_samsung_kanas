#!/bin/bash
# Credits to anyone and everyone who wrote this
# I tried playing with this. This now leverages the powers of bash shell
# But, this is not equivalent to the sh version.
# ~ <enriquezmark36@gmail.com>

shopt -s globstar # recurse all directories

# vendorsetup.sh is sourced by build/envsetup.sh in root of android build tree. Hope that nobody can correctly source it not from root of android tree.
build_root=$(pwd)
patches_path="$build_root/device/samsung/kanas/patches/"

cd $patches_path
echo "======================= Applying patches: start ======================="

for patch in **/*.patch; do
	cd $patches_path
	
	# Strip patch title to get git commit title - git ignore [text] prefixes in beginning of patch title during git am
	title=$(sed -rn "s/Subject: (\[[^]]+] *)*//p" "$patch")
	absolute_patch_path="$patches_path/$patch"
	
	# Supported both path/to/repo_with_underlines/file.patch and path_to_repo+with+underlines/file.patch (both leads to path/to/repo_with_underlines)
	repo_to_patch=`dirname $patch`
	repo_to_patch=${repo_to_patch//[_+]//} # changes all _ or + to /

	echo -n "Is $repo_to_patch patched for '$title' ?.. "
	cd $build_root/$repo_to_patch

	commit_hash=(`git log --grep "$title" --oneline`)

	if [ ! -z $commit_hash ]; then
		echo -n Yes
		commit_id=($(git show $commit_hash | git patch-id))
		patch_id=($(git patch-id < $absolute_patch_path))
		if [ "$commit_id" = "$patch_id" ]; then
			echo ', patch matches'
		else
			echo -n ', patch mismatches!'
			echo -e  "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			diff -u <(sed '0,/^$/d' $absolute_patch_path | head -n -3) \
			        <(git show --stat $commit_hash -p --pretty=format:%b)
			echo -en "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
			echo -e  "\n~~~~~~~~~~~~Resetting branch! Well, not really.~~~~~~~~~~~~~~"
#			git checkout $commit_hash~1
#			git am $absolute_patch_path || git am --abort
		fi
	else
		echo No
		echo -e "Trying to apply patch $(basename "$patch") to '$repo_to_patch'"
		if ! git am --ignore-whitespace $absolute_patch_path; then
			echo "!!!!!!!!!!!! Failed, aborting git am !!!!!!!!!!!!!!"
			git am --abort
		fi
	fi
done

echo "======================= Applying patches: finished ======================="
