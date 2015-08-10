#pragma once
#include "cocos2d.h"
#include "../templet/Singleton.h"
using namespace cocos2d;
using namespace std;
class ImagCache :public Singleton<ImagCache>
{
public:
	void initGameRes();
	std::map<string, Image*> mapImgRes;
	void addCacheImgRes(std::map<string, string> _mapImgPath);
private:
	friend class Singleton<ImagCache>;
};

