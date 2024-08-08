#!/bin/bash

docker run --rm --name ursim-e-series -d -p 5900:5900 -p 29999:29999 -p 30001-30004:30001-30004 nvt/ursim-e-series
