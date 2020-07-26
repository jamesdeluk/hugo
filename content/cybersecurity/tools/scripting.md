---
title: 'Scripting'
---


chmod +x [script-name-here.sh](http://script-name-here.sh/)

./script-name-here.sh
sh [script-name-here.sh](http://script-name-here.sh/)
bash [script-name-here.sh](http://script-name-here.sh/)

```bash
#variables

variable_name='value' # no spaces!

echo "string string $variable_name string string"
echo "string string ${variable_name} string string" # same

echo "string string `<command>` string string"
result=`<command>`
echo "string string $result string string"

read <variable_name> # user input

# arguments

$n # nth argument

# if

if [[ <a = b> ]]; then # [] is more reliable, but [[]] is better
	<action>
elif [[ <> ]]; then
	<>
else
	<>
fi

-gt -lt -ge -le # greater less than equal

# loops and arguments

for arg in "$@"; do # all arguments
	echo "@arg"
done

# functions

function_name() {
}

function function_name() {
}

function_name <args> # call with args

# running

./<file.sh>

source <file.sh> # keeps variable in shell! also $? quits totally
```

```bash
#!/bin/bash

message="Hello"
echo $message

exit 1 # 1 = okay
exit $?
```