# find $WORKDIR
bitbake -e {recipe_name} > env
grep -rin "workdir=" env
