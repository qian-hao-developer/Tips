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
