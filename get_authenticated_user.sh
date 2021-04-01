#!/bin/bash

source ./.env
access_token="$ACCESSTOKEN"
auth="Authorization: Bearer ${access_token}"
curl -sH "${auth}" "https://qiita.com/api/v2/authenticated_user"
exit 0
