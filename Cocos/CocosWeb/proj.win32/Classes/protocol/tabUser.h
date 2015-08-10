#pragma once
#include "cocos2d.h"
#include "PBase.h"
using namespace std;
using namespace cocos2d;

class tabUser :public PBase
{
public:
	typedef std::string(tabUser::*AttType);
	std::map<std::string, AttType> mapAtt;

	tabUser();
private:
	string _tabName;
public:
	void setTabName(string _name);
	string getTabName();
	string getID();

	string tabName;
	string act;
	string result;

	
	/// <summary>
	/// 通知详情
	/// </summary>
	string desc;
	/// <summary>
	/// 
	/// </summary>
	string ID;
	/// <summary>
	/// 密码
	/// </summary>
	string password;
	/// <summary>
	/// 业务员账号
	/// </summary>
	string userName;
};