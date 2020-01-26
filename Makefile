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
	@mkdir -p $@
	cp -r fonts/* $@
	font-spider --no-backup $(BUILD_INDEX_FILE) $(BUILD_HTML_FILES)
	cp -rf fonts/Latin/* $@
	
$(BUILD_INDEX_FILE): index.md template/$(HOMEPAGE).html css/$(HOMEPAGE).css
	@echo index.md
	mkdir -p $(CSS_FILES)
	cp css/$(HOMEPAGE).css $(CSS_FILES)
	pandoc -o $@ \
		--katex \
		-d default/$(HOMEPAGE).yaml \
		--css css/$(HOMEPAGE).css \
		--metadata date="$$(date +"%Y-%m-%d")" \
		--lua-filter filter/links-to-html.lua \
		--template $(HOMEPAGE) $<

$(BUILD_HTML_FILES): $(MD_FILES) template/$(ARTICLE).html css/$(ARTICLE).css
	@echo $(MD_FILES)
	mkdir -p $(@D) $(CSS_FILES)
	cp css/$(ARTICLE).css $(CSS_FILES)
	pandoc -o $@ \
		--katex \
		--toc \
		-d default/$(ARTICLE).yaml \
		--css ../css/$(ARTICLE).css \
		--metadata date="$$(date +"%Y-%m-%d")" \
		--lua-filter filter/links-to-html.lua \
		--template $(ARTICLE) $<

clean:
	rm -rf build/*	

test:
