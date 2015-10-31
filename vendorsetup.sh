for combo in $(curl -s https://raw.githubusercontent.com/XoplaxOS/hudson/master/xoplax-build-targets | sed -e 's/#.*$//' | grep xos-2.1 | awk '{printf "xos_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done
