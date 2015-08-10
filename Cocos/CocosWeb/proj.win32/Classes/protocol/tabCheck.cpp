#include "tabCheck.h"
tabCheck::tabCheck(){
	setTabName("tabCheck");
	
	mapAtt["act"] = &tabCheck::act;
	mapAtt["area"] = &tabCheck::area;
	mapAtt["cDesc"] = &tabCheck::cDesc;
	mapAtt["cMoney"] = &tabCheck::cMoney;
	mapAtt["cName"] = &tabCheck::cName;
	mapAtt["cNum"] = &tabCheck::cNum;
	mapAtt["compName"] = &tabCheck::compName;
	mapAtt["cPrice"] = &tabCheck::cPrice;
	mapAtt["cSize"] = &tabCheck::cSize;
	mapAtt["customid"] = &tabCheck::customid;
	mapAtt["facName"] = &tabCheck::facName;
	mapAtt["hDate"] = &tabCheck::hDate;
	mapAtt["hName"] = &tabCheck::hName;
	mapAtt["ID"] = &tabCheck::ID;
	mapAtt["payMode"] = &tabCheck::payMode;
	mapAtt["reciveAdd"] = &tabCheck::reciveAdd;
	mapAtt["reciveMan"] = &tabCheck::reciveMan;
	mapAtt["reciveTel"] = &tabCheck::reciveTel;
	mapAtt["result"] = &tabCheck::result;
	mapAtt["sendName"] = &tabCheck::sendName;
	mapAtt["sendNum"] = &tabCheck::sendNum;
	mapAtt["sendTel"] = &tabCheck::sendTel;
	mapAtt["sendWay"] = &tabCheck::sendWay;
	mapAtt["state"] = &tabCheck::state;
	mapAtt["tabName"] = &tabCheck::tabName;
	mapAtt["userid"] = &tabCheck::userid;
}
void tabCheck::setTabName(string _name){
	tabName = _name;
	_tabName = _name;
}
string tabCheck::getTabName(){
	return _tabName;
}
string tabCheck::getID(){
	return ID;
}