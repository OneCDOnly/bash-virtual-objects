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

Objects.Create()
    {

    if [[ $(type -t "$1.Index") = 'function' ]]; then
        echo "can't create new virtual object '$1': already exists" 1>&2
        return 1
    fi

    [[ $(type -t Objects.Index) != 'function' ]] && [[ -z $1 || $1 != Objects ]] && Objects.Create Objects

    local public_function_name="$1"
    local safe_var_name_prefix="${public_function_name/./_}"
    local object_functions=''

    _placehold_index_="${safe_var_name_prefix}_index_integer"
    _placehold_description_="${safe_var_name_prefix}_description_string"
    _placehold_value_="${safe_var_name_prefix}_value_integer"
    _placehold_text_="${safe_var_name_prefix}_text_string"
    _placehold_switch_="${safe_var_name_prefix}_switch_boolean"
    _placeholder_array_="${safe_var_name_prefix}_list_array"

    if [[ $(type -t Objects.Index) = 'function' ]]; then
        Objects.Increment
        Objects.AddItem "$public_function_name"
    fi

object_functions="
$public_function_name.AddItem(){
    $_placeholder_array_+=(\"\$1\")
    }
$public_function_name.Clear(){
[[ \$$_placehold_switch_ = false ]] && return
    $_placehold_switch_=false
    }
$public_function_name.CountItems(){
    echo "\${#$_placeholder_array_[@]}"
    }
$public_function_name.Decrement(){
    if [[ -n \$1 && \$1 = 'by' ]]; then
        local temp=\$2
        $_placehold_value_=\$(($_placehold_value_-temp))
    else
        (($_placehold_value_--))
    fi
    }
$public_function_name.Description(){
    if [[ -n \$1 && \$1 = '=' ]]; then
        $_placehold_description_="\$2"
    else
        echo -n "\$$_placehold_description_"
    fi
    }
$public_function_name.Env(){
    echo \"* object internal environment *\"
    echo \"object index: '\$$_placehold_index_'\"
    echo \"object name: '$public_function_name'\"
    echo \"object description: '\$$_placehold_description_'\"
    echo \"object value: '\$$_placehold_value_'\"
    echo \"object text: '\$$_placehold_text_'\"
    echo \"object switch: '\$$_placehold_switch_'\"
    echo \"object array: '\${$_placeholder_array_[*]}'\"
    }
$public_function_name.Increment(){
    local -i amount
    if [[ -n \$1 && \$1 = 'by' ]]; then
        amount=\$2
    else
        amount=1
    fi
    $_placehold_value_=\$(($_placehold_value_+amount))
    }
$public_function_name.Init(){
    declare -ig $_placehold_index_=\$(Objects.Value)
    $_placehold_description_=''
    declare -ig $_placehold_value_=0
    $_placehold_text_=''
    $_placehold_switch_=false
    declare -ag $_placeholder_array_+=()
    }
$public_function_name.IsNot(){
    [[ \$$_placehold_switch_ = false ]]
    }
$public_function_name.IsSet(){
    [[ \$$_placehold_switch_ = true ]]
    }
$public_function_name.FirstItem(){
    echo \"\${$_placeholder_array_[0]}\"
    }

$public_function_name.Index(){
    if [[ ${FUNCNAME[1]} = 'Objects.Create' ]]; then
        $_placehold_index_=1
    else
        echo \$$_placehold_index_
    fi
    }
$public_function_name.ExportList(){
    printf '%s|' "\${$_placeholder_array_[@]}"
    }
$public_function_name.PrintList(){
    echo \"\${$_placeholder_array_[*]}\"
    }
$public_function_name.Set(){
    [[ \$$_placehold_switch_ = true ]] && return
    $_placehold_switch_=true
    }
$public_function_name.Text(){
    if [[ -n \$1 && \$1 = '=' ]]; then
        $_placehold_text_="\$2"
    else
        echo -n \"\$$_placehold_text_\"
    fi
    }
$public_function_name.Value(){
    if [[ -n \$1 && \$1 = '=' ]]; then
        $_placehold_value_=\$2
    else
        echo \$$_placehold_value_
    fi
    }
"
    eval "$object_functions"

    $public_function_name.Init

    if [[ $public_function_name = Objects ]]; then
        $public_function_name.Index
        $public_function_name.Description = 'this object holds metadata on every other object'
        $public_function_name.Value = 1
        $public_function_name.AddItem 'Objects'
    fi

    return 0

    }

# a few test commands to check operation

#
# Objects.Create MyUserObj.flags
# Objects.Create second
# Objects.Create third
#
# MyUserObj.flags.Set
# MyUserObj.flags.Value = 10
# MyUserObj.flags.Text = 'something to print onscreen'
# MyUserObj.flags.Description = 'holds current script flags and switches'
# MyUserObj.flags.Clear
# MyUserObj.flags.Increment by 4
# MyUserObj.flags.AddItem 'this is the first element in the array'
# MyUserObj.flags.AddItem 'and this is the second element in the array'
#
# second.Description = 'this should be the 2nd user object created but the 3rd created overall'
#
# Objects.Env
# echo
# MyUserObj.flags.Env
# echo
# second.Env
# echo
# third.Env
# echo
# echo "current object count is: $(Objects.Value)"
# echo "first array first element is: [$(MyUserObj.flags.FirstItem)]"
# exit


# third.Index

# Objects.Create second
# echo
# second.Env
# echo
#
# oldIFS=$IFS; IFS="|"; test=($(MyUserObj.flags.ExportList)); IFS="$oldIFS"
#
# for e in "${test[@]}"; do
#     echo "[$e]"
# done
#
# echo "... this array has ${#test[@]} elements and the IFS is: [$IFS]"
#

# echo
echo "How long to create 1,000 objects?"

time {
    for ((lop=1; lop<=1000; lop++)); do
        Objects.Create "testname_$lop"
    done
}
echo
echo "total objects: $(Objects.Value)"

# ### speed tests ###
# i7-7700k
# How long to create 1,000 objects?
#
# real    0m5.190s
# user    0m3.348s
# sys     0m1.969s
#
# 1004

# Atom D2700
# How long to create 1,000 objects?
#
# real    0m32.402s
# user    0m8.360s
# sys     0m24.515s
#
# 1004

# Too slow! Need to work on this.

# Less characters appears to be the secret. After removing comments, linespacing, tabs:
# i7-7700k
# How long to create 1,000 objects?
#
# real    0m3.929s
# user    0m2.621s
# sys     0m1.420s
#
# 1004

# Atom D2700
# How long to create 1,000 objects?
#
# real    0m24.033s
# user    0m7.253s
# sys     0m17.178s
#
# 1004

# removed 'read' and put object functions directly into a variable:
# i7-7700k
# How long to create 1,000 objects?
#
# real    0m3.423s
# user    0m2.522s
# sys     0m1.048s
#
# total objects: 1001

# Atom D2700
# How long to create 1,000 objects?
#
# real    0m21.234s
# user    0m7.018s
# sys     0m14.878s
#
# total objects: 1001
