#include "tabCustom.h"
tabCustom::tabCustom(){
	setTabName("tabCustom");
	
	mapAtt["act"] = &tabCustom::act;
	mapAtt["bankName"] = &tabCustom::bankName;
	mapAtt["bankNum"] = &tabCustom::bankNum;
	mapAtt["bron"] = &tabCustom::bron;
	mapAtt["cName"] = &tabCustom::cName;
	mapAtt["compMode"] = &tabCustom::compMode;
	mapAtt["compName"] = &tabCustom::compName;
	mapAtt["cSize"] = &tabCustom::cSize;
	mapAtt["dispathComp"] = &tabCustom::dispathComp;
	mapAtt["dispathMed1"] = &tabCustom::dispathMed1;
	mapAtt["dispathMed2"] = &tabCustom::dispathMed2;
	mapAtt["facName"] = &tabCustom::facName;
	mapAtt["ID"] = &tabCustom::ID;
	mapAtt["prodName"] = &tabCustom::prodName;
	mapAtt["result"] = &tabCustom::result;
	mapAtt["tabName"] = &tabCustom::tabName;
	mapAtt["taxNum"] = &tabCustom::taxNum;
	mapAtt["tel"] = &tabCustom::tel;
	mapAtt["tickAdd"] = &tabCustom::tickAdd;
	mapAtt["tickComp"] = &tabCustom::tickComp;
	mapAtt["tickTel"] = &tabCustom::tickTel;
	mapAtt["userid"] = &tabCustom::userid;
}
void tabCustom::setTabName(string _name){
	tabName = _name;
	_tabName = _name;
}
string tabCustom::getTabName(){
	return _tabName;
}
string tabCustom::getID(){
	return ID;
}