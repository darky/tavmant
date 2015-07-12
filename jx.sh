lsc -c gulpfile.coffee ./core/*
replace \.coffee \.js ./core/*.js -r
replace \.coffee \.js gulpfile.js
browserify --entry gulpfile.js --exclude "key.js" --exclude "node_modules/**/*.*" --node --outfile tavmant_temp.js
regenerator --include-runtime tavmant_temp.js > tavmant.js
jx package tavmant.js tavmant.jx -add tavmant.js
rm gulpfile.js core/*.js tavmant.js tavmant_temp.js *.jxp
zip tavmant-$(git describe).zip package.json server.sh build.sh reinstall.sh tavmant.jx
rm tavmant.jx
