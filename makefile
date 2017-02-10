SRC = $(shell find ./src -type f -name '*.d')

all: dev

dev:
	dmd $(SRC) lib/arsd/color.d lib/arsd/png.d lib/arsd/jpeg.d -of./bin/pixel-sortd -od./bin -unittest

release:
	dmd $(SRC) lib/arsd/color.d lib/arsd/png.d lib/arsd/jpeg.d -of./bin/pixel-sortd -od./bin -O -inline