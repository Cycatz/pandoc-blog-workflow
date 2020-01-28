MD_FILES:=$(shell find . ! -name "index.md"  -name "*.md")
HTML_FILES:=$(MD_FILES:.md=.html)
BUILD_HTML_FILES:=$(HTML_FILES:%=build/%)

BUILD_INDEX_FILE:=build/index.html

HOMEPAGE=blog-homepage
ARTICLE=blog-article

OPTIMIZED_FONTS=build/fonts/
CSS_FILES=build/css/


all: $(BUILD_HTML_FILES) $(BUILD_INDEX_FILE) $(OPTIMIZED_FONTS)

build/assets/%: assets/%
	@mkdir -p $$(dirname $@)
	cp $? $@

$(OPTIMIZED_FONTS): fonts/ $(BUILD_INDEX_FILE) $(BUILD_HTML_FILES) 
	rm -rf $@
	mkdir -p $@
	cp -r fonts/* $@
	font-spider --no-backup $(BUILD_INDEX_FILE) $(BUILD_HTML_FILES)
	$$(bash ./add-timestamp.sh)
	
build/index.html: index.md template/$(HOMEPAGE).html css/$(HOMEPAGE).css css/font.css
	@echo index.md
	mkdir -p $(CSS_FILES)
	cp css/font.css $(CSS_FILES)
	cp css/$(HOMEPAGE).css $(CSS_FILES)
	pandoc -o $@ \
		--katex \
		-d default/$(HOMEPAGE).yaml \
		--css css/$(HOMEPAGE).css \
		--lua-filter filter/links-to-html.lua \
		--template $(HOMEPAGE) $<

build/%.html: %.md template/$(ARTICLE).html css/$(ARTICLE).css css/font.css
	@echo $<
	mkdir -p $(@D) $(CSS_FILES)
	cp css/font.css $(CSS_FILES)
	cp css/$(ARTICLE).css $(CSS_FILES)
	pandoc -o $@ \
		--katex \
		--toc \
		--toc-depth 1\
		-d default/$(ARTICLE).yaml \
		--css ../css/$(ARTICLE).css \
		--lua-filter filter/links-to-html.lua \
		--template $(ARTICLE) $<

clean:
	rm -rf build/*	

test:
