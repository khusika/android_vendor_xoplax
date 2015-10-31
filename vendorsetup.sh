for combo in $(curl -s https://raw.githubusercontent.com/XoplaxOS/hudson/master/xoplax-build-targets | sed -e 's/#.*$//' | grep xos-1.0 | awk {'print $1'})
do
    add_lunch_combo $combo
done
