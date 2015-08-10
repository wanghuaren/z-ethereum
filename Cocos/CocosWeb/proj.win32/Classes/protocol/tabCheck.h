#pragma once
#include "cocos2d.h"
#include "PBase.h"
using namespace std;
using namespace cocos2d;

class tabCheck :public PBase
{
public:
	typedef std::string(tabCheck::*AttType);
	std::map<std::string, AttType> mapAtt;

	tabCheck();
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
	/// 区域
	/// </summary>
	string area;
	/// <summary>
	/// 备注
	/// </summary>
	string cDesc;
	/// <summary>
	/// 总额
	/// </summary>
	string cMoney;
	/// <summary>
	/// 客户
	/// </summary>
	string cName;
	/// <summary>
	/// 件数
	/// </summary>
	string cNum;
	/// <summary>
	/// 公司
	/// </summary>
	string compName;
	/// <summary>
	/// 单价
	/// </summary>
	string cPrice;
	/// <summary>
	/// 规格-mg-ml-kg-个
	/// </summary>
	string cSize;
	/// <summary>
	/// 所属客户ID
	/// </summary>
	string customid;
	/// <summary>
	/// 厂家
	/// </summary>
	string facName;
	/// <summary>
	/// 订单日期
	/// </summary>
	string hDate;
	/// <summary>
	/// 品名
	/// </summary>
	string hName;
	/// <summary>
	/// 
	/// </summary>
	string ID;
	/// <summary>
	/// 付款方式
	/// </summary>
	string payMode;
	/// <summary>
	/// 收货地址
	/// </summary>
	string reciveAdd;
	/// <summary>
	/// 收货人
	/// </summary>
	string reciveMan;
	/// <summary>
	/// 收货人电话
	/// </summary>
	string reciveTel;
	/// <summary>
	/// 发送方名称
	/// </summary>
	string sendName;
	/// <summary>
	/// 发送单号
	/// </summary>
	string sendNum;
	/// <summary>
	/// 发送查询电话
	/// </summary>
	string sendTel;
	/// <summary>
	/// 货运方式
	/// </summary>
	string sendWay;
	/// <summary>
	/// 订单状态 0未完成 1处理中 2已完成
	/// </summary>
	string state;
	/// <summary>
	/// 所属业务员
	/// </summary>
	string userid;
};