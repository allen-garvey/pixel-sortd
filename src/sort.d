module pixel_sortd.sort;

import std.algorithm.sorting;
import arsd.color;


enum RgbSortType{
	red,
	green,
	blue
}

enum HslSortType{
	hue,
	saturation,
	lightness
}

//sorts horizontal or vertical line of colors
//for some reason it is almost twice as fast to sort
//by passing in string than using function
void sortLine(Color[] line, RgbSortType sortType){
	switch(sortType){
		case RgbSortType.red:
			line.sort!("a.r < b.r");
			break;
		case RgbSortType.green:
			line.sort!("a.g < b.g");
			break;
		case RgbSortType.blue:
			line.sort!("a.b < b.b");
			break;
		default:
			break;
	}
}


//sorts horizontal or vertical line of hues
//for some reason it is almost twice as fast to sort
//by passing in string than using function
void sortLine(real[][] line, HslSortType sortType){
	switch(sortType){
		case HslSortType.hue:
			line.sort!("a[0] < b[0]");
			break;
		case HslSortType.saturation:
			line.sort!("a[1] < b[1]");
			break;
		case HslSortType.lightness:
			line.sort!("a[2] < b[2]");
			break;
		default:
			break;
	}
}

void sortByColumn(MemoryImage memoryImage, HslSortType sortType){
	int height = memoryImage.height();
	int width = memoryImage.width();
	real[][] column = new real[][](height, 3);

	for(int x=0; x < width; x++){
		for(int y=0; y < height; y++){
			column[y] = toHsl(memoryImage.getPixel(x, y));
		}
		
		sortLine(column, sortType);
		
		for(int y=0; y < height; y++){
			memoryImage.setPixel(x, y, fromHsl(column[y][0], column[y][1], column[y][2]));
		}

	}
}



void sortByColumn(MemoryImage memoryImage, RgbSortType sortType){
	int height = memoryImage.height();
	int width = memoryImage.width();
	Color[] column = new Color[height];

	for(int x=0; x < width; x++){
		for(int y=0; y < height; y++){
			column[y] = memoryImage.getPixel(x, y);
		}
		
		sortLine(column, sortType);
		
		for(int y=0; y < height; y++){
			memoryImage.setPixel(x, y, column[y]);
		}

	}
}

void sortByRow(MemoryImage memoryImage, RgbSortType sortType){
	int height = memoryImage.height();
	int width = memoryImage.width();
	Color[] row = new Color[width];

	for(int y=0; y < height; y++){
		for(int x=0; x < width; x++){
			row[x] = memoryImage.getPixel(x, y);
		}
		
		sortLine(row, sortType);
		
		for(int x=0; x < width; x++){
			memoryImage.setPixel(x, y, row[x]);
		}

	}
}

void sortByRow(MemoryImage memoryImage, HslSortType sortType){
	int height = memoryImage.height();
	int width = memoryImage.width();
	real[][] row = new real[][](width, 3);

	for(int y=0; y < height; y++){
		for(int x=0; x < width; x++){
			row[x] = toHsl(memoryImage.getPixel(x, y));
		}
		
		sortLine(row, sortType);
		
		for(int x=0; x < width; x++){
			memoryImage.setPixel(x, y, fromHsl(row[x][0], row[x][1], row[x][2]));
		}

	}
}
