lsc -c gulpfile.coffee
lsc -c ./core/*
regenerator --include-runtime gulpfile.js gulpfile.js
regenerator --include-runtime ./core ./core
replace \.coffee \.js ./core/*.js -r
replace \.coffee \.js gulpfile.js
jx package gulpfile.js tavmant.jx -add "core/*.js" -slim @dev,@prod,assets,layouts,node_modules,pages,partials,settings,site_root,gulpfile.coffee,index.js,jx.sh,package.json
rm gulpfile.js
rm *.jxp
rm core/*.js
rm core/.module-cache/*.js
rm core/.module-cache/manifest/*.json
zip tavmant-$(git describe).zip package.json server.sh build.sh reinstall.sh tavmant.jx
rm tavmant.jx

