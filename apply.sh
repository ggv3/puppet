#!/bin/bash

puppet apply --modulepath /home/niko/git/puppet -e 'class{"curl":}'
