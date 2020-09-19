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

Objects.Create()
    {

    if [[ $(type -t "$1.Index") = 'function' ]]; then
        echo "unable to create new virtual object '$1': already exists" 1>&2
        return 1
    fi

    [[ $(type -t Objects.Index) != 'function' ]] && [[ -z $1 || $1 != Objects ]] && Objects.Create Objects

    local public_function_name="$1"
    local safe_var_name_prefix="${public_function_name//./_}"
    local object_functions=''

    _placehold_index_="${safe_var_name_prefix}_index_integer"
    _placehold_description_="${safe_var_name_prefix}_description_string"
    _placehold_value_="${safe_var_name_prefix}_value_integer"
    _placehold_text_="${safe_var_name_prefix}_text_string"
    _placehold_set_switch_="${safe_var_name_prefix}_set_boolean"
    _placehold_enable_switch_="${safe_var_name_prefix}_enable_boolean"
    _placehold_list_array_="${safe_var_name_prefix}_list_array"
    _placehold_list_pointer_="${safe_var_name_prefix}_array_index_integer"

    if [[ $(type -t Objects.Index) = 'function' ]]; then
        Objects.Items.Add "$public_function_name"
    fi

    object_functions='
        '$public_function_name'.Clear()
            {
            [[ '$_placehold_set_switch_' = false ]] && return
            '$_placehold_set_switch_'=false
            }

        '$public_function_name'.Description()
            {
            if [[ -n $1 && $1 = '=' ]]; then
                '$_placehold_description_'="$2"
            else
                echo -n "'$_placehold_description_'"
            fi
            }

        '$public_function_name'.Disable()
            {
            [[ '$_placehold_enable_switch_' = false ]] && return
            '$_placehold_enable_switch_'=false
            }

        '$public_function_name'.Enable()
            {
            [[ $'$_placehold_enable_switch_' = true ]] && return
            '$_placehold_enable_switch_'=true
            }

        '$public_function_name'.Env()
            {
            echo "* object internal environment *"
            echo "object index: '\'\$$_placehold_index_\''"
            echo "object name: '\'$public_function_name\''"
            echo "object description: '\'\$$_placehold_description_\''"
            echo "object value: '\'\$$_placehold_value_\''"
            echo "object text: '\'\$$_placehold_text_\''"
            echo "object set: '\'\$$_placehold_set_switch_\''"
            echo "object enable: '\'\$$_placehold_enable_switch_\''"
            echo "object list: '\'\${$_placehold_list_array_[*]}\''"
            echo "object list pointer: '\'\$$_placehold_list_pointer_\''"
            }

        '$public_function_name'.Index()
            {
            if [[ ${FUNCNAME[1]} = 'Objects.Create' ]]; then
                '$_placehold_index_'=1
            else
                echo $'$_placehold_index_'
            fi
            }

        '$public_function_name'.Init()
            {
            '$_placehold_index_'=$(Objects.Items.Count)
            '$_placehold_description_'=''
            '$_placehold_value_'=0
            '$_placehold_text_'=''
            '$_placehold_set_switch_'=false
            '$_placehold_enable_switch_'=false
            '$_placehold_list_array_'+=()
            '$_placehold_list_pointer_'=1
            }

        '$public_function_name'.IsDisabled()
            {
            [[ $'$_placehold_enable_switch_' = true ]]
            }

        '$public_function_name'.IsEnabled()
            {
            [[ $'$_placehold_enable_switch_' = false ]]
            }

        '$public_function_name'.IsNot()
            {
            [[ $'$_placehold_set_switch_' = false ]]
            }

        '$public_function_name'.IsSet()
            {
            [[ $'$_placehold_set_switch_' = true ]]
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

        '$public_function_name'.Set()
            {
            [[ $'$_placehold_set_switch_' = true ]] && return
            '$_placehold_set_switch_'=true
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
            }
    '
    eval "$object_functions"

    $public_function_name.Init

    if [[ $public_function_name = Objects ]]; then
        $public_function_name.Index
        $public_function_name.Description = 'this object holds metadata on every other object'
        $public_function_name.Value = 1
        $public_function_name.Items.Add 'Objects'
    fi

    return 0

    }

# a few test commands to check operation

Objects.Create MyUserObj.flags
Objects.Create second
Objects.Create third

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
second.Description = 'this should be the 2nd user object created but the 3rd created overall'

MyUserObj.flags.Env
echo
second.Env
echo
third.Env
echo

#including an intentional duplicate object to check error works
for obj in {lights,camera,lights,action}; do
    Objects.Create "$obj"
done

lights.Description = "lighting information for this scene"
camera.Description = "where should the camera be put?"
action.Description = "what's going on?"

for obj in {lights,camera,action}; do
  "$obj".Env
done
Objects.Env

echo
echo "first user object, array & first element is: [$(MyUserObj.flags.Items.First)]"
echo "current object count is: $(Objects.Items.Count)"


echo "$(MyUserObj.flags.Items.GetCurrent)"
MyUserObj.flags.Items.Enumerate
echo "$(MyUserObj.flags.Items.GetCurrent)"
MyUserObj.flags.Items.Enumerate
echo "$(MyUserObj.flags.Items.GetCurrent)"
echo "$(MyUserObj.flags.Items.GetThis 2)"
