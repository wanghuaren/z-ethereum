#include "tabUser.h"
tabUser::tabUser(){
	setTabName("tabUser");
	
	mapAtt["act"] = &tabUser::act;
	mapAtt["desc"] = &tabUser::desc;
	mapAtt["ID"] = &tabUser::ID;
	mapAtt["password"] = &tabUser::password;
	mapAtt["result"] = &tabUser::result;
	mapAtt["tabName"] = &tabUser::tabName;
	mapAtt["userName"] = &tabUser::userName;
}
void tabUser::setTabName(string _name){
	tabName = _name;
	_tabName = _name;
}
string tabUser::getTabName(){
	return _tabName;
}
string tabUser::getID(){
	return ID;
}