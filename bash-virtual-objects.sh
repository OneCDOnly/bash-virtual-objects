#!/usr/bin/env bash
#
# bash-virtual-objects.sh
#
# My attempt to create a few dynamic virtual "objects" containing some simple properties and methods.
# If I can get this to work, I'll integrate it into the sherpa mini-package-manager.
#
# Copyright (C) 2020 OneCD [one.cd.only@gmail.com]
#
# So, blame OneCD if it all goes horribly wrong. ;)

Objects.Create()
    {

    [[ $(type -t "$1") = 'function' ]] && return 1
    [[ $(type -t Objects.Value) != 'function' ]] && [[ -z $1 || $1 != Objects ]] && Objects.Create Objects

    local public_function_name="$1"
    local unique=$RANDOM
    local safe_var_name_prefix="${public_function_name/./_}_${unique}"
    local object_functions=''

    _var_placeholder_index_integer="${safe_var_name_prefix}_index_integer"
    _var_placeholder_description_string="${safe_var_name_prefix}_description_string"
    _var_placeholder_value_integer="${safe_var_name_prefix}_value_integer"
    _var_placeholder_text_string="${safe_var_name_prefix}_text_string"
    _var_placeholder_switch_boolean="${safe_var_name_prefix}_switch_boolean"
    _var_placeholder_list_array="${safe_var_name_prefix}_list_array"

    if [[ $(type -t Objects.Increment) = 'function' ]]; then
        Objects.Increment
        Objects.AddItem "$public_function_name"
    fi

read -d '' object_functions << EndOfObjectDescriptors

    $public_function_name.AddItem()
        {

        $_var_placeholder_list_array+=("\$1")

        return 0

        }

    $public_function_name.Clear()
        {

        [[ \$$_var_placeholder_switch_boolean = false ]] && return

        $_var_placeholder_switch_boolean=false

        return 0

        }

    $public_function_name.CountItems()
        {

        echo "\${#$_var_placeholder_list_array[@]}"

        return 0

        }

    $public_function_name.Decrement()
        {

        if [[ -n \$1 && \$1 = 'by' ]]; then
            # use provided value as decrementer
            local temp=\$2
            $_var_placeholder_value_integer=\$(($_var_placeholder_value_integer-temp))
        else
            (($_var_placeholder_value_integer--))
        fi

        return 0

        }

    $public_function_name.Description()
        {

        if [[ -n \$1 && \$1 = '=' ]]; then
            # assign provided value to internal var
            $_var_placeholder_description_string="\$2"
        else
            # read value from internal var
            echo -n "\$$_var_placeholder_description_string"
        fi

        return 0

        }

    $public_function_name.Disable()
        {

        $public_function_name.Clear

        }

    $public_function_name.Disabled()
        {

        $public_function_name.IsNot

        }

    $public_function_name.Enable()
        {

        $public_function_name.Set

        }

    $public_function_name.Enabled()
        {

        $public_function_name.IsSet

        }

    $public_function_name.Env()
        {

        echo "* object internal environment *"
        echo "object index: '\$$_var_placeholder_index_integer'"
        echo "object name: '$public_function_name'"
        echo "object description: '\$$_var_placeholder_description_string'"
        echo "object value: '\$$_var_placeholder_value_integer'"
        echo "object text: '\$$_var_placeholder_text_string'"
        echo "object switch: '\$$_var_placeholder_switch_boolean'"
        echo "object array: '\${$_var_placeholder_list_array[*]}'"

        return 0

        }

    $public_function_name.FirstItem()
        {

        echo "\${$_var_placeholder_list_array[0]}"

        return 0

        }

    $public_function_name.Increment()
        {

        local -i amount

        if [[ -n \$1 && \$1 = 'by' ]]; then
            amount=\$2
        else
            amount=1
        fi

        $_var_placeholder_value_integer=\$(($_var_placeholder_value_integer+amount))

        return 0

        }

    $public_function_name.Init()
        {

        if [[ $public_function_name = Objects ]]; then
            declare -ig $_var_placeholder_index_integer=1
            $_var_placeholder_description_string='this object holds metadata on every other object'
            declare -ig $_var_placeholder_value_integer=1
            $_var_placeholder_text_string=''
            declare -ag $_var_placeholder_list_array+=('Objects')
        else
            declare -ig $_var_placeholder_index_integer=\$(Objects.Value)
            $_var_placeholder_description_string=''
            declare -ig $_var_placeholder_value_integer=0
            $_var_placeholder_text_string=''
            declare -ag $_var_placeholder_list_array+=()
        fi

        $_var_placeholder_switch_boolean=false

        return 0

        }

    $public_function_name.IsNot()
        {

        [[ \$$_var_placeholder_switch_boolean = false ]]

        }

    $public_function_name.IsSet()
        {

        [[ \$$_var_placeholder_switch_boolean = true ]]

        }

    $public_function_name.ExportList()
        {

        printf '%s|' "\${$_var_placeholder_list_array[@]}"

        return 0

        }

    $public_function_name.PrintList()
        {

        echo "\${$_var_placeholder_list_array[*]}"

        return 0

        }

    $public_function_name.Set()
        {

        [[ \$$_var_placeholder_switch_boolean = true ]] && return

        $_var_placeholder_switch_boolean=true

        return 0

        }

    $public_function_name.Text()
        {

        if [[ -n \$1 && \$1 = '=' ]]; then
            # assign provided value to internal var
            $_var_placeholder_text_string="\$2"
        else
            # read value from internal var
            echo -n "\$$_var_placeholder_text_string"
        fi

        return 0

        }

    $public_function_name.Value()
        {

        if [[ -n \$1 && \$1 = '=' ]]; then
            # assign provided value to internal var
            $_var_placeholder_value_integer=\$2
        else
            # read value from internal var
            echo \$$_var_placeholder_value_integer
        fi

        return 0

        }

EndOfObjectDescriptors

    eval "$object_functions"

    $public_function_name.Init

    return 0

    }

# a few test commands to check operation

Objects.Create MyUserObj.flags
Objects.Create second
Objects.Create third

MyUserObj.flags.Enable
MyUserObj.flags.Value = 10
MyUserObj.flags.Text = "something to print onscreen"
MyUserObj.flags.Description = 'holds current script flags and switches'
MyUserObj.flags.Disable
MyUserObj.flags.Increment by 4
MyUserObj.flags.AddItem 'this is a test sentence'
MyUserObj.flags.AddItem 'and a second test sentence after'

Objects.Env
echo
MyUserObj.flags.Env
echo
second.Env
echo
third.Env
echo
echo "current object count is: $(Objects.Value)"
echo

oldIFS=$IFS; IFS="|"; test=($(MyUserObj.flags.ExportList)); IFS="$oldIFS"

for e in "${test[@]}"; do
    echo "[$e]"
done

echo "... this array has ${#test[@]} elements and the IFS is: [$IFS]"
