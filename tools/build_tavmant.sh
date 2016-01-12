lsc -c ./electron_frontend/routes.ls ./electron_frontend/**/*.ls ./gulp/*.ls common.ls
replace "\.ls\"" ".js\"" ./gulp/*.js -r
replace "\.ls\"" ".js\"" ./electron_frontend/**/*.js -r
replace "\.ls\"" ".js\"" ./electron_frontend/routes.js -r
replace "\.ls\"" ".js\"" common.js
cp index.js tavmant.js
replace "\.ls\"" ".js\"" tavmant.js
lsc tools/concat_tavmant.ls
uglifyjs --output tavmant2.js tavmant2.js
lsc tools/encrypt_tavmant.ls
rm common.js gulp/*.js tavmant.js tavmant2.js ./electron_frontend/**/*.js ./electron_frontend/routes.js
