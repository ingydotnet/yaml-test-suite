default:

update:
	rm -fr [a-z]*/
	mkdir node_modules
	npm install coffeescript js-yaml jyj lodash testml-compiler
	rm -f package*
	mv node_modules/* .
	mv node_modules/.bin/ .
	rmdir node_modules
	git add -A .
	git rm -fr testml-compiler/test/testml
