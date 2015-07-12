jx package tavmant.js tavmant.jx -add tavmant.js
rm gulpfile.js core/*.js tavmant.js tavmant_temp.js *.jxp
zip tavmant-$(git describe).zip package.json server.sh build.sh reinstall.sh tavmant.jx
rm tavmant.jx
