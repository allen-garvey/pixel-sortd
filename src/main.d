module pixel_sortd.main;

import std.stdio;
import arsd.color;
import arsd.png;
import pixel_sortd.file;
import pixel_sortd.image;


int printUsage(string programName){
	stderr.writef("usage: %s image_filename\n", programName);
	return 1;
}

int main(string[] args){
	//check for image filename argument
	if(args.length != 2){
		return printUsage(args[0]);
	}

	PixelImage image;
	image.path = args[1];
	image.fileType = imageFileTypeFor(image.path);

	if(!isValidFilename(image.path)){
		stderr.writef("%s doesn't exist or is a directory\n", image.path);
		return 1;
	}

	switch(image.fileType){
		case ImageFileType.Png:
			image.memoryImage = readPng(image.path);
			break;
		case ImageFileType.Jpeg:
			import arsd.jpeg;
			image.memoryImage = readJpeg(image.path);
			break;
		default:
			stderr.writef("%s is not a jpeg or png file\n", image.path);
			return 1;
	}

	for(int x=0;x<image.memoryImage.width() / 2;x++){
		for(int y=0;y<image.memoryImage.height();y++){
			Color black = Color(0,0,0,255);
			image.memoryImage.setPixel(x, y, black);
		}
	}

	//no functions to write jpegs
	writePng(defaultModifiedFilePath(image.path), image.memoryImage);
	


	return 0;
}