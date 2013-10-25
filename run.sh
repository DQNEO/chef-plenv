#!/bin/bash
cd $(dirname $0)
chef-solo -c solo.rb -j ./localhost.json
