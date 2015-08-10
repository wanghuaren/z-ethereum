#pragma once
#include "cocos2d.h"
#include "tinyxml2\tinyxml2.h"
#include "PBase.h"

#include "tabCheck.h"
#include "tabCustom.h"
#include "tabTick.h"
#include "tabUser.h"
using namespace cocos2d;
using namespace std;
using namespace tinyxml2;
class PFactory
{
public:
	PFactory();
private:
	static PFactory* _instance;
	vector<PBase*> dataTool;
public:

	static PFactory* instance();
	vector<PBase*> getBackData(string* _xml);
	string getSendData(PBase* _pBase);
private:
	string getTableFromXML(string* _xml);
	XMLElement* rootElement(string* xmlString);
};

