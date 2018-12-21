# minimal-dev
bitbake -g core-image-minimal-dev
    -> pn-buildlist will be created
bitbake -g core-image-minimal-dev && cat pn-buildlist | sort > pn-buildlist_core-image-minimal-dev.sort
