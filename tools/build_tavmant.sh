lsc -c gulpfile.coffee ./core/*
replace \.coffee \.js ./core/*.js -r
replace \.coffee \.js gulpfile.js
lsc tools/concat_tavmant.coffee
uglifyjs --output tavmant.js tavmant.js
rm gulpfile.js core/*.js tavmant.js
