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

enum ImageSortDirection{
	row,
	column
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


///Used to initialize variables in sort image functions
// call sortImageinitFunc(); after instantiating the mixin
mixin template sortImageInit(T)
if (is(T : HslSortType) || is(T : RgbSortType)){
	int height = memoryImage.height();
	int width = memoryImage.width();
	int i;
	int j;
	int *x = null;
	int *y = null;
	int outerLoopMax;
	int innerLoopMax;
	static if(is(T : HslSortType)){
		real[][] line;
	}
	//RgbSortType
	else{
		Color[] line;
	}

	void sortImageinitFunc(){
		if(sortDirection == ImageSortDirection.row){
			static if(is(T : HslSortType)){
				line = new real[][](width, 3);
			}
			//RgbSortType
			else{
				line = new Color[width];
			}
			outerLoopMax = height;
			innerLoopMax = width;
			x = &j;
			y = &i;
		}
		//column
		else{
			static if(is(T : HslSortType)){
				line = new real[][](height, 3);
			}
			//RgbSortType
			else{
				line = new Color[height];
			}
			outerLoopMax = width;
			innerLoopMax = height;
			x = &i;
			y = &j;
		}
	}

	//saves pixel from memory image to line array at index 
	void savePixel(int index){
		static if(is(T : HslSortType)){
			line[index] = toHsl(memoryImage.getPixel(*x, *y));
		}
		//RgbSortType
		else{
			line[index] = memoryImage.getPixel(*x, *y);
		}
	}

	//writes pixel from line array at index to memory image
	void writePixel(int index){
		static if(is(T : HslSortType)){
			memoryImage.setPixel(*x, *y, fromHsl(line[index][0], line[index][1], line[index][2]));
		}
		//RgbSortType
		else{
			memoryImage.setPixel(*x, *y, line[index]);
		}
	}
	
}



void sortImage(T)(MemoryImage memoryImage, T sortType, ImageSortDirection sortDirection) 
if (is(T : HslSortType) || is(T : RgbSortType)){
	mixin sortImageInit!(T);
	sortImageinitFunc();

	for(i=0; i < outerLoopMax; i++){
		for(j=0; j < innerLoopMax; j++){
			savePixel(j);
		}
		
		sortLine(line, sortType);
		
		for(j=0; j < innerLoopMax; j++){
			writePixel(j);
		}
	}
}

//sorts image
//alternates between sorting lines and skipping them
//laneSize dictates how large the lanes of sorted and skipped lines are
//laneSize of 1 will sort whole image, laneSize of 2 sorts every other line, and so on
void sortImageLanes(T)(MemoryImage memoryImage, T sortType, ImageSortDirection sortDirection, int laneSize=1) 
if (is(T : HslSortType) || is(T : RgbSortType))
in{
	assert(laneSize > 0);
}
body{
	mixin sortImageInit!(T);
	sortImageinitFunc();

	int linesSortedInLane = 0;
	for(i=0; i < outerLoopMax; i++){
		for(j=0; j < innerLoopMax; j++){
			savePixel(j);
		}
		
		sortLine(line, sortType);
		
		for(j=0; j < innerLoopMax; j++){
			writePixel(j);
		}
		linesSortedInLane++;
		if(linesSortedInLane == laneSize - 1){
			i += laneSize;
			linesSortedInLane = 0;
		}
	}
}


//sorts image
//alternates sorting lines by different values in sortType enum
//laneSize dictates how large the alternating colored lanes are
//laneSize of 1 will sort whole image with same sortType
void sortImageColorLanes(T)(MemoryImage memoryImage, ImageSortDirection sortDirection, int laneSize=1) 
if (is(T : HslSortType) || is(T : RgbSortType))
in{
	assert(laneSize > 0);
}
body{
	mixin sortImageInit!(T);
	sortImageinitFunc();

	static if(is(T : HslSortType)){
		HslSortType[3] sortTypes = [HslSortType.hue, HslSortType.saturation, HslSortType.lightness];
	}
	//RgbSortType
	else{
		RgbSortType[3] sortTypes = [RgbSortType.red, RgbSortType.green, RgbSortType.blue];
	}
	int currentSortTypeIndex = 0;
	int linesSortedInLane = 0;
	for(i=0; i < outerLoopMax; i++){
		for(j=0; j < innerLoopMax; j++){
			savePixel(j);
		}
		
		sortLine(line, sortTypes[currentSortTypeIndex]);
		
		for(j=0; j < innerLoopMax; j++){
			writePixel(j);
		}
		linesSortedInLane++;
		if(linesSortedInLane == laneSize - 1){
			linesSortedInLane = 0;
			currentSortTypeIndex++;
			if(currentSortTypeIndex == sortTypes.length){
				currentSortTypeIndex = 0;
			}
		}
	}
}