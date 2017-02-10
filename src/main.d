module pixel_sortd.main;

import std.stdio;
import arsd.color;
import pixel_sortd.file;
import pixel_sortd.image;
import pixel_sortd.sort;


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

	if(!isValidFilename(image.path)){
		stderr.writef("%s doesn't exist or is a directory\n", image.path);
		return 1;
	}

	image.fileType = imageFileTypeFor(image.path);

	if(image.fileType == ImageFileType.Unsupported){
		stderr.writef("%s is not a jpeg or png file\n", image.path);
		return 1;
	}

	image.memoryImage = loadMemoryImage(image);

	sortByColumn(image.memoryImage, SortType.red);

	//has to save to png for now
	saveToFile(image, defaultModifiedFilePath(image.path));


	return 0;
}
