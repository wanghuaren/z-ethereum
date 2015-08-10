#pragma once
#include "cocos2d.h"
#include "PBase.h"
using namespace std;
using namespace cocos2d;

class tabTick :public PBase
{
public:
	typedef std::string(tabTick::*AttType);
	std::map<std::string, AttType> mapAtt;

	tabTick();
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
	/// 备注
	/// </summary>
	string cDesc;
	/// <summary>
	/// 所属订单ID
	/// </summary>
	string checkID;
	/// <summary>
	/// 
	/// </summary>
	string ID;
	/// <summary>
	/// 开票人地址
	/// </summary>
	string pAddress;
	/// <summary>
	/// 开票人开户行
	/// </summary>
	string pBankName;
	/// <summary>
	/// 开票人账号
	/// </summary>
	string pBankNum;
	/// <summary>
	/// 开票人单位
	/// </summary>
	string pCompName;
	/// <summary>
	/// 邮寄发票联系人
	/// </summary>
	string pContacts;
	/// <summary>
	/// 邮寄发票地址
	/// </summary>
	string pContactsAdd;
	/// <summary>
	/// 邮寄发票联系人电话
	/// </summary>
	string pContactsTel;
	/// <summary>
	/// 开票人传真
	/// </summary>
	string pFax;
	/// <summary>
	/// 邮寄发票邮编
	/// </summary>
	string pMailNum;
	/// <summary>
	/// 开票申请人
	/// </summary>
	string pName;
	/// <summary>
	/// 开票物品数量
	/// </summary>
	string pNum;
	/// <summary>
	/// 开票物品单价
	/// </summary>
	string pPrice;
	/// <summary>
	/// 开票物品名
	/// </summary>
	string pProName;
	/// <summary>
	/// 开票物品规格
	/// </summary>
	string pSize;
	/// <summary>
	/// 开票金额
	/// </summary>
	string pSumPrice;
	/// <summary>
	/// 开票人税号
	/// </summary>
	string pTaxNum;
	/// <summary>
	/// 所属业务员
	/// </summary>
	string userid;
};