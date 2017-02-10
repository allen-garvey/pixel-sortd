module pixel_sortd.sort;

import std.algorithm.sorting;
import arsd.color;


enum RgbSortType{
	red,
	green,
	blue
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