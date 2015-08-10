#include "PFactory.h"

PFactory* PFactory::_instance = NULL;
PFactory* PFactory::instance(){
	if (_instance == NULL)
		_instance = new PFactory();
	return _instance;
}
PFactory::PFactory()
{
}

vector<PBase*> PFactory::getBackData(string* _xml){
	dataTool.clear();
	XMLElement* childElement = rootElement(_xml)->FirstChildElement();
	string _tabName = getTableFromXML(_xml);
	if (_tabName == "tabCheck"){
		tabCheck* _tabCheck;
		while (childElement){
			_tabCheck = new tabCheck();
			XMLElement* childValue = childElement->FirstChildElement();
			while (childValue){
				if (childValue->GetText() != NULL&&_tabCheck->mapAtt[childValue->Name()] != NULL)
					(_tabCheck->*(_tabCheck->mapAtt[childValue->Name()])) = childValue->GetText();
				childValue = childValue->NextSiblingElement();
			}
			dataTool.push_back(_tabCheck);
			childElement = childElement->NextSiblingElement();
		}
	}else if (_tabName == "tabCustom"){
		tabCustom* _tabCustom;
		while (childElement){
			_tabCustom = new tabCustom();
			XMLElement* childValue = childElement->FirstChildElement();
			while (childValue){
				if (childValue->GetText() != NULL&&_tabCustom->mapAtt[childValue->Name()] != NULL)
					(_tabCustom->*(_tabCustom->mapAtt[childValue->Name()])) = childValue->GetText();
				childValue = childValue->NextSiblingElement();
			}
			dataTool.push_back(_tabCustom);
			childElement = childElement->NextSiblingElement();
		}
	}else if (_tabName == "tabTick"){
		tabTick* _tabTick;
		while (childElement){
			_tabTick = new tabTick();
			XMLElement* childValue = childElement->FirstChildElement();
			while (childValue){
				if (childValue->GetText() != NULL&&_tabTick->mapAtt[childValue->Name()] != NULL)
					(_tabTick->*(_tabTick->mapAtt[childValue->Name()])) = childValue->GetText();
				childValue = childValue->NextSiblingElement();
			}
			dataTool.push_back(_tabTick);
			childElement = childElement->NextSiblingElement();
		}
	}else if (_tabName == "tabUser"){
		tabUser* _tabUser;
		while (childElement){
			_tabUser = new tabUser();
			XMLElement* childValue = childElement->FirstChildElement();
			while (childValue){
				if (childValue->GetText() != NULL&&_tabUser->mapAtt[childValue->Name()] != NULL)
					(_tabUser->*(_tabUser->mapAtt[childValue->Name()])) = childValue->GetText();
				childValue = childValue->NextSiblingElement();
			}
			dataTool.push_back(_tabUser);
			childElement = childElement->NextSiblingElement();
		}
	}
	return dataTool;
}
string PFactory::getSendData(PBase* _pBase){
	string _xml;
	if (_pBase->getTabName() == "tabCheck"){
		tabCheck* _tabCheck = static_cast<tabCheck*>(_pBase);

		for (std::map<string, tabCheck::AttType>::iterator it = _tabCheck->mapAtt.begin(); it != _tabCheck->mapAtt.end(); it++)
		{
			if (_tabCheck->*(it->second) != ""){
				_xml += ("&data=" + it->first);
				_xml += ("&data=" + (_tabCheck->*(it->second)));
			}
		}
	}else if (_pBase->getTabName() == "tabCustom"){
		tabCustom* _tabCustom = static_cast<tabCustom*>(_pBase);

		for (std::map<string, tabCustom::AttType>::iterator it = _tabCustom->mapAtt.begin(); it != _tabCustom->mapAtt.end(); it++)
		{
			if (_tabCustom->*(it->second) != ""){
				_xml += ("&data=" + it->first);
				_xml += ("&data=" + (_tabCustom->*(it->second)));
			}
		}
	}else if (_pBase->getTabName() == "tabTick"){
		tabTick* _tabTick = static_cast<tabTick*>(_pBase);

		for (std::map<string, tabTick::AttType>::iterator it = _tabTick->mapAtt.begin(); it != _tabTick->mapAtt.end(); it++)
		{
			if (_tabTick->*(it->second) != ""){
				_xml += ("&data=" + it->first);
				_xml += ("&data=" + (_tabTick->*(it->second)));
			}
		}
	}else if (_pBase->getTabName() == "tabUser"){
		tabUser* _tabUser = static_cast<tabUser*>(_pBase);

		for (std::map<string, tabUser::AttType>::iterator it = _tabUser->mapAtt.begin(); it != _tabUser->mapAtt.end(); it++)
		{
			if (_tabUser->*(it->second) != ""){
				_xml += ("&data=" + it->first);
				_xml += ("&data=" + (_tabUser->*(it->second)));
			}
		}
	}
	free(_pBase);
	return _xml;
}
string PFactory::getTableFromXML(string* _xml){
	if (rootElement(_xml)->FirstChildElement() == NULL) return "";
	if (rootElement(_xml)->FirstChildElement()->FirstChildElement() == NULL) return "";
	if (rootElement(_xml)->FirstChildElement()->FirstChildElement("tabName") == NULL) return "";
	return rootElement(_xml)->FirstChildElement()->FirstChildElement("tabName")->GetText();
}
XMLElement* PFactory::rootElement(string* xmlString){
	tinyxml2::XMLDocument *xmlDoc = new tinyxml2::XMLDocument();
	xmlDoc->Parse(xmlString->c_str());
	return xmlDoc->RootElement()->FirstChildElement("data");
}
