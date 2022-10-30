default: node_modules mdi-material-ui-inline | esbuild rollup parcel webpack

node_modules:
	npm ci

mdi-material-ui-inline:
	node generate-inline.js

esbuild:
	time -p node_modules/.bin/esbuild --bundle single-icon.js --outdir=dist/esbuild
	time -p node_modules/.bin/esbuild --bundle single-icon-inline.js --outdir=dist/esbuild
	time -p node_modules/.bin/esbuild --bundle all-icons.js --outdir=dist/esbuild
	time -p node_modules/.bin/esbuild --bundle all-icons-inline.js --outdir=dist/esbuild

rollup:
	time -p node_modules/.bin/rollup single-icon.js -p @rollup/plugin-node-resolve -p @rollup/plugin-commonjs -d dist/rollup
	time -p node_modules/.bin/rollup single-icon-inline.js -p @rollup/plugin-node-resolve -p @rollup/plugin-commonjs -d dist/rollup
	time -p node_modules/.bin/rollup all-icons.js -p @rollup/plugin-node-resolve -p @rollup/plugin-commonjs -d dist/rollup
	time -p node_modules/.bin/rollup all-icons-inline.js -p @rollup/plugin-node-resolve -p @rollup/plugin-commonjs -d dist/rollup

parcel:
	rm -fr .parcel-cache && time -p node_modules/.bin/parcel build single-icon.js --dist-dir dist/parcel
	rm -fr .parcel-cache && time -p node_modules/.bin/parcel build single-icon-inline.js --dist-dir dist/parcel
	rm -fr .parcel-cache && time -p node_modules/.bin/parcel build all-icons.js --dist-dir dist/parcel
	rm -fr .parcel-cache && time -p node_modules/.bin/parcel build all-icons-inline.js --dist-dir dist/parcel

webpack:
	time -p node_modules/.bin/webpack --mode=production ./single-icon.js --output-path dist/webpack --output-filename single-icon.js
	time -p node_modules/.bin/webpack --mode=production ./single-icon-inline.js --output-path dist/webpack --output-filename single-icon-inline.js
	time -p node_modules/.bin/webpack --mode=production ./all-icons.js --output-path dist/webpack --output-filename all-icons.js
	time -p node_modules/.bin/webpack --mode=production ./all-icons-inline.js --output-path dist/webpack --output-filename all-icons-inline.js
