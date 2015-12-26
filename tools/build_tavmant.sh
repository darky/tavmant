lsc -c ./electron_frontend/routes.coffee ./electron_frontend/**/*.coffee ./gulp/*.coffee common.coffee
replace \.coffee \.js ./gulp/*.js -r
replace \.coffee \.js ./electron_frontend/**/*.js -r
replace \.coffee \.js ./electron_frontend/routes.js -r
replace \.coffee \.js common.js
cp index.js tavmant.js
replace \.coffee \.js tavmant.js
lsc tools/concat_tavmant.coffee
uglifyjs --output tavmant2.js tavmant2.js
lsc tools/encrypt_tavmant.coffee
rm common.js gulp/*.js tavmant.js tavmant2.js ./electron_frontend/**/*.js ./electron_frontend/routes.js
