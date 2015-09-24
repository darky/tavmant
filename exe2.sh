mv node_modules node_modules1
nexe -i tavmant.js -o tavmant
mv node_modules1 node_modules
rm gulpfile.js core/*.js tavmant.js
chmod -R 777 tavmant
