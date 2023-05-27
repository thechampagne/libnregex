LIBS := build/libnregex.a build/libnregex.so

.PHONY: all
all: $(LIBS)

build/libnregex.a: nregex.nim
	nim c --noMain --app:staticlib -d:release --outdir:build $<

build/libnregex.so: nregex.nim
	nim c --noMain --app:lib -d:release --outdir:build $<

.PHONY: clean
clean:
	find build -type f \( -name '*.so' -o -name '*.a' \) -delete

.PHONY: install-deps
install-deps:
	nimble install regex
