#include "tabTick.h"
tabTick::tabTick(){
	setTabName("tabTick");
	
	mapAtt["act"] = &tabTick::act;
	mapAtt["cDesc"] = &tabTick::cDesc;
	mapAtt["checkID"] = &tabTick::checkID;
	mapAtt["ID"] = &tabTick::ID;
	mapAtt["pAddress"] = &tabTick::pAddress;
	mapAtt["pBankName"] = &tabTick::pBankName;
	mapAtt["pBankNum"] = &tabTick::pBankNum;
	mapAtt["pCompName"] = &tabTick::pCompName;
	mapAtt["pContacts"] = &tabTick::pContacts;
	mapAtt["pContactsAdd"] = &tabTick::pContactsAdd;
	mapAtt["pContactsTel"] = &tabTick::pContactsTel;
	mapAtt["pFax"] = &tabTick::pFax;
	mapAtt["pMailNum"] = &tabTick::pMailNum;
	mapAtt["pName"] = &tabTick::pName;
	mapAtt["pNum"] = &tabTick::pNum;
	mapAtt["pPrice"] = &tabTick::pPrice;
	mapAtt["pProName"] = &tabTick::pProName;
	mapAtt["pSize"] = &tabTick::pSize;
	mapAtt["pSumPrice"] = &tabTick::pSumPrice;
	mapAtt["pTaxNum"] = &tabTick::pTaxNum;
	mapAtt["result"] = &tabTick::result;
	mapAtt["tabName"] = &tabTick::tabName;
	mapAtt["userid"] = &tabTick::userid;
}
void tabTick::setTabName(string _name){
	tabName = _name;
	_tabName = _name;
}
string tabTick::getTabName(){
	return _tabName;
}
string tabTick::getID(){
	return ID;
}