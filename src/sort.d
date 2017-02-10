module pixel_sortd.sort;

import std.algorithm.sorting;
import arsd.color;


enum SortType{
	red,
	green,
	blue
}

//sorts horizontal or vertical line of colors
//for some reason it is almost twice as fast to sort
//by passing in string than using function
void sortLine(Color[] line, SortType sortType){
	switch(sortType){
		case SortType.red:
			line.sort!("a.r < b.r");
			break;
		case SortType.green:
			line.sort!("a.g < b.g");
			break;
		case SortType.blue:
			line.sort!("a.b < b.b");
			break;
		default:
			break;
	}

}


void sortByColumn(MemoryImage memoryImage, SortType sortType){
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

void sortByRow(MemoryImage memoryImage, SortType sortType){
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