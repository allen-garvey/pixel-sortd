module pixel_sortd.sort;

import std.algorithm.sorting;
import arsd.color;


enum SortType{
	red,
	green,
	blue
}


int compareByRed(Color color1, Color color2){
	return color1.r < color2.r;
}

//sorts horizontal or vertical line of colors
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