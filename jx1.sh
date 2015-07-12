lsc -c gulpfile.coffee ./core/*
replace \.coffee \.js ./core/*.js -r
replace \.coffee \.js gulpfile.js
browserify --entry gulpfile.js --exclude "key.js" --exclude "node_modules/**/*.*" --node --outfile tavmant_temp.js
regenerator --include-runtime tavmant_temp.js > tavmant.js
uglifyjs tavmant.js -c -m -o tavmant.js
