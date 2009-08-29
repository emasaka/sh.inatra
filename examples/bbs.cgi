#!/bin/bash
# require commands: sqlite3, cat

. /opt/sh.inatra/sh.inatra.sh

dbfile=/tmp/bbs.sqlite3
[ -e "$dbfile" ] || sqlite3 $dbfile 'CREATE TABLE bbs (user text, comment text, created_at text)'

get '/' && {
    cat <<EOF
<html><head><title>BBS</title></head><body>
<form method="POST" action="$SCRIPT_NAME/comment">
<p>Name: <input type="text" name="user" size="16" /></p>
<p>Comment: <input type="text" name="comment" size="60" /></p>
<input type="submit" value="Post"></form>
<table>
EOF
    sqlite3 $dbfile <<'SQL'
.mode html
SELECT * FROM bbs;
SQL
    echo '</table></body></html>'
}

post '/comment' && {
    sqlite3 $dbfile "INSERT INTO bbs (user, comment, created_at) VALUES ('$params_user', '$params_comment', '$(LANG=C date)')"
    redirect '/'
}
