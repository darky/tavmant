if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi
cd ../$1
find . -type f ! -name 'CNAME' ! -path './.git/*' -delete
cp ../tavmant/@prod/* .
