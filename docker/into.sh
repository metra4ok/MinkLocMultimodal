#!/bin/bash

docker exec --user "docker_minklocmultimodal" -it ${USER}_minklocmultimodal \
    /bin/bash -c "cd /home/docker_minklocmultimodal; echo minklocmultimodal container; echo ; /bin/bash"