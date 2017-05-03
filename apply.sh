#!/bin/bash

sudo puppet apply --modulepath modules -e 'class{"curl":}'
sudo puppet apply --modulepath modules -e 'class{"nodejs":}'
sudo puppet apply --modulepath modules -e 'class{"phonegap":}'
