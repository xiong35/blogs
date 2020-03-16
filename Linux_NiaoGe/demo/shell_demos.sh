
# #!/bin/bash
# PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:~/bin
# export PATH

################################################################

# demo1: Hello World

# #!/bin/bash
# # Program:
# #   this program shows 'Hello World' on the screen
# # History:
# # 20/02/07  Xiong35
# PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:~/bin
# export PATH

# echo -e "Hello World! \a \n"
# exit 0

#######################################################

# demo2: show name

# #!/bin/bash
# # Program:
# #   input first and last name, output full name
# # History:
# # 20/02/07  Xiong35
# PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:~/bin
# export PATH

# read -p 'Please enter your first name: ' firstName
# read -p 'Please enter your last name: ' lastName
# echo -e "Your full name is: ${firstName} ${lastName}"

################################################################

# demo3: date

# #!/bin/bash
# # Program:
# #   create 3 files, named according to input and date
# # History:
# # 20/02/07  Xiong35
# PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:~/bin
# export PATH

# read -p "Please enter your filename: " filename
# filename=${filename:-'filename'}  # assign a default filename

# date1=$(date --date='2 days ago' +%Y%m%d)
# date2=$(date --date='1 day ago' +%Y%m%d) # show the date in the format YYYY-MM-DD 
# date3=$(date +%Y%m%d)

# file1=${filename}${date1}
# file2=${filename}${date2}
# file3=${filename}${date3}

# touch ${file1}
# touch ${file2}
# touch ${file3}

################################################################

# demo4: multiplication

# #!/bin/bash
# # program:
# #   enter two ints, and multiply them
# # History:
# # 20/02/07  xiong35
# PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:~/bin
# export PATH

# read -p "enter the first int: " num1
# read -p "enter the second int: " num2

# result=$((num1*num2))  # in (()) there can be blank spaces
# echo -e "the result is ${result}"
# echo "${num1}*${num2}" | bc  # bc for calculator

################################################################

# demo5: condition

# #!/bin/bash
# # Program:
# #   a demo of condition control
# # History:
# # 20/02/07  xiong35
# PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:~/bin
# export PATH

# read -p "Enter (y/n): " yn
# if [ "${yn}" == "y" ] || [ "${yn}" == "Y" ]; then
#     echo "ok"
#     exit 0
# elif [ "${yn}" == "n" ] || [ "${yn}" == "N" ]; then
#     echo "nope"
#     exit 1
# else
#     echo "try again"
# fi

################################################################

# demo6: case

# #!/bin/bash

# case ${1} in
# "hello")
#     echo "hello"
#     ;;
# "")
#     echo "say sth"
#     ;;
# *)
#     echo "default"
#     ;;
# esac

################################################################

# demo7: function

# #!/bin/bash

# function print(){
#     echo "${1}"
# }
# print 2
# print 3
# echo "${0}"
# exit 0

################################################################

# demo8: loop

#!/bin/bash
# ~
n=0
while [ "${i}" -lt 4 ]
do
    echo ${i}
    i=$((${i}+1))
done

until [ "${n}" == "3" ]
do
    echo "${n}"
    n=$((${n}+1))
done

for animal in dog cat mouse
do
    echo "${animal}"
done

for alpha in $(echo {a..z})
do
    echo "${alpha}"
done

for ((i = 0; i < 6 ; i++))
do
    echo "${i}"
done


