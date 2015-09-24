lsc -c gulpfile.coffee ./core/*
replace \.coffee \.js ./core/*.js -r
replace \.coffee \.js gulpfile.js
mv node_modules node_modules1
nexe -i gulpfile.js -o tavmant
mv node_modules1 node_modules
rm gulpfile.js core/*.js
chmod -R 777 tavmant
zip tavmant-$(git describe).zip node_modules server.sh build.sh tavmant
rm tavmant
