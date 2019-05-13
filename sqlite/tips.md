# start up setting
sqlite3 *.db
.headers on
.mode column

# search column for table
select * from table where column = 'title';

# use regex for searching
pre-install:
1. sudo apt install sqlite3-pcre
2. sqlite3 xxx.db
3. .load /usr/lib/sqlite3/pcre.so
select * from table where column regexp ".*keyword.*"
