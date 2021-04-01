#!/bin/bash

MAX_PER_PAGE=100
items_count=$(./get_authenticated_user.sh | jq -r '.items_count')
# echo "items_count""${items_count}"

# Header print
echo likes_count,page_views_count,title,id,created_at
page_count=1
per_page=$items_count
page_left=$items_count
if [ $page_left -gt $MAX_PER_PAGE ]; then
    per_page=$MAX_PER_PAGE
fi

while [ 0 -lt "${page_left}" ]
do
    # echo 'befor page_count='"$page_count"
    # echo 'per_page'"$per_page"
    # echo 'page_left'"$page_left"

    ./get_authenticated_user_items.sh "${page_count}" "${per_page}" | \
    jq '[.likes_count, .page_views_count, .title, .id, .created_at]' | \
    jq -r '@csv'

    if [ $page_left -gt $MAX_PER_PAGE ]; then
        page_left=$(($page_left - $MAX_PER_PAGE))
        per_page=$MAX_PER_PAGE
        page_count=$((page_count + 1))
    else
        page_left=$(($page_left - $MAX_PER_PAGE))
        per_page=$page_left
        page_count=$((page_count + 1))
    fi
done
exit 0