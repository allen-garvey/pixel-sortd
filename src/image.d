module pixel_sortd.image;

import arsd.color;
import pixel_sortd.file;

struct PixelImage{
	string path;
	ImageFileType fileType;
	MemoryImage memoryImage;
}