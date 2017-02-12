SRC = $(shell find ./src -type f -name '*.d')
ARSD = lib/arsd/color.d lib/arsd/png.d lib/arsd/jpeg.d

all: dev

dev:
	dmd $(SRC) $(ARSD) -of./bin/pixel-sortd -od./bin -unittest

release:
	dmd $(SRC) $(ARSD) -of./bin/pixel-sortd -od./bin -O -inline