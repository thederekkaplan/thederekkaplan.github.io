EJS := $(wildcard src/*.ejs)
HTML := $(patsubst src/%.ejs,dist/%.html,$(EJS))
YAML := $(wildcard src/*.yaml)
JSON := $(patsubst src/%.yaml,build/%.json,$(YAML))
TEX := $(wildcard src/*.tex)
PDF := $(patsubst src/%.tex,dist/%.pdf,$(TEX))
SCSS := $(wildcard src/*.scss)
CSS := $(patsubst src/%.scss,dist/%.css,$(SCSS))

$(shell mkdir -p build dist)

.PHONY: all
all: $(HTML) $(PDF) $(CSS)

dist/%.html: src/%.ejs build/index.json
	ejs $< -f build/index.json -o $@
	html-minifier --collapse-boolean-attributes --collapse-whitespace --minify-css \
	--minify-js --minify-urls --remove-attribute-quotes --remove-empty-attributes \
	--remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes \
	--remove-style-link-type-attributes --sort-attributes --sort-class-name $@ -o $@

dist/%.pdf: build/%.pdf
	cp $< $@

dist/%.css: src/%.scss
	sass --sourcemap=none --style compressed $< $@

build/index.json: $(JSON)
	jq -n 'reduce inputs as $$i (.; .[input_filename|rtrimstr(".json")|ltrimstr("build/")] = $$i)' $^ > $@

build/%.json: src/%.yaml
	yq . $< > $@

build/%.pdf: src/%.tex src/%.lua $(YAML)
	latexmk -lualatex -outdir=build -shell-escape -interaction=nonstopmode $<

.PHONY: clean
clean:
	rm -rf dist build .sass-cache .texlive_cache