#!/bin/bash

status_code=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost)

if [[ "$status_code" -ne 200 ]] ; then
  echo "Getting error $status_code" | mail -s "Check HTTP status" "sandeepv.sit@gmail.com" -r "STATUS_CHECKER"
else
  echo $status_code
  exit 0
fi
