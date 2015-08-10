#pragma once
#include "cocos2d.h"
#include "PBase.h"
using namespace std;
using namespace cocos2d;

class tabCustom :public PBase
{
public:
	typedef std::string(tabCustom::*AttType);
	std::map<std::string, AttType> mapAtt;

	tabCustom();
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
	/// 开户行
	/// </summary>
	string bankName;
	/// <summary>
	/// 账号
	/// </summary>
	string bankNum;
	/// <summary>
	/// 出生
	/// </summary>
	string bron;
	/// <summary>
	/// 客户名
	/// </summary>
	string cName;
	/// <summary>
	/// 营业方式,如:直营
	/// </summary>
	string compMode;
	/// <summary>
	/// 公司名
	/// </summary>
	string compName;
	/// <summary>
	/// 规格
	/// </summary>
	string cSize;
	/// <summary>
	/// 配送公司
	/// </summary>
	string dispathComp;
	/// <summary>
	/// 配送医院1
	/// </summary>
	string dispathMed1;
	/// <summary>
	/// 配送医院2
	/// </summary>
	string dispathMed2;
	/// <summary>
	/// 厂家名
	/// </summary>
	string facName;
	/// <summary>
	/// 
	/// </summary>
	string ID;
	/// <summary>
	/// 产品
	/// </summary>
	string prodName;
	/// <summary>
	/// 税号
	/// </summary>
	string taxNum;
	/// <summary>
	/// 电话
	/// </summary>
	string tel;
	/// <summary>
	/// 发票地址
	/// </summary>
	string tickAdd;
	/// <summary>
	/// 发票单件名称
	/// </summary>
	string tickComp;
	/// <summary>
	/// 发票电话
	/// </summary>
	string tickTel;
	/// <summary>
	/// 所属业务员
	/// </summary>
	string userid;
};