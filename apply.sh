#!/bin/bash

sudo puppet apply --modulepath /home/niko/git/puppet -e 'class{"curl":}'
sudo puppet apply --modulepath /home/niko/git/puppet -e 'class{"nodejs":}'
sudo puppet apply --modulepath /home/niko/git/puppet -e 'class{"phonegap":}'
