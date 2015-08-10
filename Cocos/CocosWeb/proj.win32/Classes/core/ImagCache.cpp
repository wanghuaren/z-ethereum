#include "ImagCache.h"
#include "ui/UIImageView.h"
void ImagCache::addCacheImgRes(std::map<string, string> _mapImgPath)
{
	Image* image;
	for (std::map<string, string>::iterator _it = _mapImgPath.begin(); _it != _mapImgPath.end(); _it++){
		image = new Image();
		image->initWithImageFile(_it->second);
		Director::getInstance()->getTextureCache()->addImage(image, _it->first);
		mapImgRes[_it->first] = image;
	}
}
void ImagCache::initGameRes(){
	Data codeBuffer = FileUtils::getInstance()->getDataFromFile("Res.MPQ");
	unsigned char* _char = codeBuffer.getBytes();
	int _position = 0;
	while (_position < codeBuffer.getSize())
	{
		unsigned char _version = *(unsigned char*)_char;
		_position++;
		_char++;

		int _nameSize = *((int*)_char);
		_position += 4;
		_char += 4;

		string _name = string((char*)_char);
		_position += _nameSize + 1;
		_char += _nameSize + 1;

		int _imageSize = *((int*)_char);
		_position += 4;
		_char += 4;

		Image *_image=new Image();
		_image->initWithImageData(_char, _imageSize);
		_position += _imageSize;
		_char += _imageSize;

		Director::getInstance()->getTextureCache()->addImage(_image, FileUtils::getInstance()->fullPathForFilename(_name));
		mapImgRes[_name] = _image;
	}
}