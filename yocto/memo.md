# minimal-dev
bitbake -g core-image-minimal-dev
    -> pn-buildlist will be created
bitbake -g core-image-minimal-dev && cat pn-buildlist | sort > pn-buildlist_core-image-minimal-dev.sort

# run shell in python
bb.build.exec_func('func_name', d)

# run shell command in python
bb.process.run('git rev-parse HEAD', cwd=path)

# make parameters modification global
task_name[vardeps] += "param"

# variable expansion in function(in-line python expression)
def func(d):
    ...
PARAM = "${@func(d)}"
see 3.1.13@bitbake-user-manual

# enable external kernel modules into rootfs' image
add below into local.conf in build folder (must add into build folder, ref_manual)
CORE_IMAGE_EXTRA_INSTALL += " kernel-modules"

# show dependencies in gui
bitbake -g -u taskexp <recipe>
