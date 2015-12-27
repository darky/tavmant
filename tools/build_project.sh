cd ../$1
find . -type f ! -name 'CNAME' ! -path './.git/*' -delete
cp ../tavmant/@prod/* .
