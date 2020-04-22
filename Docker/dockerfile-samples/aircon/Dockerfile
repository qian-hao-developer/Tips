FROM crops/poky:ubuntu-18.04

USER root
RUN apt-get update && apt-get install -y libpng-dev
RUN git config --system url."https://git.ti.com/git/tidl/tidl-api.git".insteadof git://git.ti.com/tidl/tidl-api.git && git config --system url."https://git.alsa-project.org/http/tinycompress.git".insteadof git://git.alsa-project.org/tinycompress.git && git config --system url."htytps://".insteadof git:/
