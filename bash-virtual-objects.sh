#!/usr/bin/env bash
#
# bash-virtual-objects.sh
#
# My attempt to create a few dynamic virtual "objects" containing simple properties and methods.
# If I can get this to work, I'll integrate it into the sherpa mini-package-manager.
#
# Copyright (C) 2020 OneCD [one.cd.only@gmail.com]
#
# So, blame OneCD if it all goes horribly wrong. ;)

# Must work on at-least:
#   GNU bash, version 3.2.57(2)-release (i686-pc-linux-gnu)
#   Copyright (C) 2007 Free Software Foundation, Inc.

Objects.Add()
    {

	# $1: object name to create

    local public_function_name="$1"
    local safe_function_name="$(tr '[A-Z]' '[a-z]' <<< "${public_function_name//[.-]/_}")"

    _placehold_description_="_object_${safe_function_name}_description_"
    _placehold_value_="_object_${safe_function_name}_value_"
    _placehold_text_="_object_${safe_function_name}_text_"
    _placehold_flag_="_object_${safe_function_name}_flag_"
    _placehold_enable_="_object_${safe_function_name}_enable_"
    _placehold_list_array_="_object_${safe_function_name}_list_"
    _placehold_list_pointer_="_object_${safe_function_name}_list_pointer_"
    _placehold_path_="_object_${safe_function_name}_path_"

    echo $public_function_name'.Clear()
	{
	[[ $'$_placehold_flag_' != "true" ]] && return
	'$_placehold_flag_'=false
	}

'$public_function_name'.Description()
	{
	if [[ -n $1 && $1 = "=" ]]; then
		'$_placehold_description_'="$2"
	else
		echo -n "'$_placehold_description_'"
	fi
	}

'$public_function_name'.Disable()
	{
	[[ $'$_placehold_enable_' != "true" ]] && return
	'$_placehold_enable_'=false
	}

'$public_function_name'.Enable()
	{
	[[ $'$_placehold_enable_' = "true" ]] && return
	'$_placehold_enable_'=true
	}

'$public_function_name'.Env()
	{
	echo "* object internal environment *"
	echo "object name: '\'$public_function_name\''"
	echo "object description: '\'\$$_placehold_description_\''"
	echo "object value: '\'\$$_placehold_value_\''"
	echo "object text: '\'\$$_placehold_text_\''"
	echo "object flag: '\'\$$_placehold_flag_\''"
	echo "object enable: '\'\$$_placehold_enable_\''"
	echo "object list: '\'\${$_placehold_list_array_[*]}\''"
	echo "object list pointer: '\'\$$_placehold_list_pointer_\''"
	echo "object path: '\'\$$_placehold_path_\''"
	}

'$public_function_name'.Init()
	{
	'$_placehold_description_'=''
	'$_placehold_value_'=0
	'$_placehold_text_'=''
	'$_placehold_flag_'=false
	'$_placehold_enable_'=false
	'$_placehold_list_array_'+=()
	'$_placehold_list_pointer_'=1
	'$_placehold_path_'=''
	}

'$public_function_name'.IsDisabled()
	{
	[[ $'$_placehold_enable_' != "true" ]]
	}

'$public_function_name'.IsEnabled()
	{
	[[ $'$_placehold_enable_' = "true" ]]
	}

'$public_function_name'.IsNot()
	{
	[[ $'$_placehold_flag_' != "true" ]]
	}

'$public_function_name'.IsSet()
	{
	[[ $'$_placehold_flag_' = "true" ]]
	}

'$public_function_name'.Items.Add()
	{
	'$_placehold_list_array_'+=("$1")
	}

'$public_function_name'.Items.Count()
	{
	echo "${#'$_placehold_list_array_'[@]}"
	}

'$public_function_name'.Items.First()
	{
	echo "${'$_placehold_list_array_'[0]}"
	}

'$public_function_name'.Items.Enumerate()
	{
	(('$_placehold_list_pointer_'++))
	if [[ $'$_placehold_list_pointer_' -gt ${#'$_placehold_list_array_'[@]} ]]; then
		'$_placehold_list_pointer_'=1
	fi
	}

'$public_function_name'.Items.GetCurrent()
	{
	echo -n "${'$_placehold_list_array_'[(('$_placehold_list_pointer_'-1))]}"
	}

'$public_function_name'.Items.GetThis()
	{
	local -i index="$1"
	[[ $index -lt 1 ]] && index=1
	[[ $index -gt ${#'$_placehold_list_array_'[@]} ]] && index=${#'$_placehold_list_array_'[@]}
	echo -n "${'$_placehold_list_array_'[((index-1))]}"
	}

'$public_function_name'.Items.Pointer()
	{
	if [[ -n $1 && $1 = "=" ]]; then
		if [[ $2 -gt ${#'$_placehold_list_array_'[@]} ]]; then
			'$_placehold_list_pointer_'=${#'$_placehold_list_array_'[@]}
		else
			'$_placehold_list_pointer_'=$2
		fi
	else
		echo -n $'$_placehold_list_pointer_'
	fi
	}

'$public_function_name'.Path()
	{
	if [[ -n $1 && $1 = "=" ]]; then
		'$_placehold_path_'="$2"
	else
		echo -n "$'$_placehold_path_'"
	fi
	}

'$public_function_name'.Set()
	{
	[[ $'$_placehold_flag_' = "true" ]] && return
	'$_placehold_flag_'=true
	}

'$public_function_name'.Text()
	{
	if [[ -n $1 && $1 = "=" ]]; then
		'$_placehold_text_'="$2"
	else
		echo -n "$'$_placehold_text_'"
	fi
	}

'$public_function_name'.Value()
	{
	if [[ -n $1 && $1 = "=" ]]; then
		'$_placehold_value_'=$2
	else
		echo -n $'$_placehold_value_'
	fi
	}

'$public_function_name'.Value.Decrement()
	{
	local -i amount
	if [[ -n $1 && $1 = "by" ]]; then
		amount=$2
	else
		amount=1
	fi
	'$_placehold_value_'=$(('$_placehold_value_'-amount))
	}

'$public_function_name'.Value.Increment()
	{
	local -i amount
	if [[ -n $1 && $1 = "by" ]]; then
		amount=$2
	else
		amount=1
	fi
	'$_placehold_value_'=$(('$_placehold_value_'+amount))
	}' >> $compiled_objects

    return 0

    }

Objects.Construct()
	{

	compiled_objects=compiled.objects
	reference_hash=9bf9184c5929c123d018e546edcf2e97

	[[ -e $compiled_objects ]] && ! FileMatchesMD5 "$compiled_objects" "$reference_hash" && rm -f "$compiled_objects"

	if [[ ! -e $compiled_objects ]]; then
		echo "compiling objects ..."
		Objects.Add MyUserObj.flags

		for lop in {1..200}; do
			Objects.Add "test-object-$lop"
		done
	fi

	. compiled.objects

	return 0

	}

DebugTimerStageStart()
    {

    # output:
    #   stdout = current time in seconds

    $DATE_CMD +%s%N

    }

DebugTimerStageEnd()
    {

    # input:
    #   $1 = start time in seconds

    echo "elapsed time: $((($($DATE_CMD +%s%N) - $1)/1000000)) milliseconds" # using this method: https://stackoverflow.com/a/16961051/14072675


    }

FileMatchesMD5()
    {

    # input:
    #   $1 = pathfilename to generate an MD5 checksum for
    #   $2 = MD5 checksum to compare against

    [[ -z $1 || -z $2 ]] && return 1

    [[ $($MD5SUM_CMD "$1" | $CUT_CMD -f1 -d' ') = "$2" ]]

    }

MD5SUM_CMD=/bin/md5sum
CUT_CMD=/usr/bin/cut
DATE_CMD=/usr/bin/date
starttime=$(DebugTimerStageStart)

Objects.Construct

test-object-200.Text = 'sumthin'

MyUserObj.flags.Set
MyUserObj.flags.Value = 10
MyUserObj.flags.Text = 'something to print onscreen'
MyUserObj.flags.Description = "this one will hold the user script's flags and switches"
MyUserObj.flags.Clear
MyUserObj.flags.Value.Increment by 4
MyUserObj.flags.Value.Increment
MyUserObj.flags.Items.Add 'this is the first element in the array'
MyUserObj.flags.Items.Add 'and this is the second element in the array'
MyUserObj.flags.Items.Add 'finally this is the third element in the array'
MyUserObj.flags.Enable

test-object-200.Env

MyUserObj.flags.Env

DebugTimerStageEnd "$starttime"
