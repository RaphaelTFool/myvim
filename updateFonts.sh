#!/bin/bash

sudo cp -fpR fonts/* /usr/share/fonts/truetype
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -f -v
