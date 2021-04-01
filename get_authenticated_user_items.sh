#!/bin/bash

G_PAGE=1; G_PER_PAGE=5;
# echo "$#"
if [ "$#" -eq 2 ]; then
    if [ "$1" -gt 0 -a "$2" -gt 0 ]; then
        G_PAGE=$1; G_PER_PAGE=$2
    fi
fi

source ./.env
access_token="$ACCESSTOKEN"
auth="Authorization: Bearer ${access_token}"
curl -sH "${auth}" "https://qiita.com/api/v2/authenticated_user/items?page=${G_PAGE}&per_page=${G_PER_PAGE}" | \
jq -r '.[] | [.id] | @csv' | \
awk -v AUTH="${auth}" -F, \
'
BEGIN {
    cmd_sleep = "sleep 5"
}
{
    gsub("\"", "", $1)
    url = "https://qiita.com/api/v2/items/" $1
    cmd_curl = "-sH" " \"" AUTH "\" " "\"" url "\""
    system("curl "cmd_curl"")
    system(cmd_sleep)
}
'
exit 0