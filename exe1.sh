lsc -c gulpfile.coffee ./core/*
replace \.coffee \.js ./core/*.js -r
replace \.coffee \.js gulpfile.js
node tools/build_tavmant.js
uglifyjs --output tavmant.js tavmant.js
