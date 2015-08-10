#pragma once
#include "cocos2d.h"
#include "network\HttpRequest.h"
#include "network\HttpClient.h"
#include "network\HttpResponse.h"
#include "../protocol/PBase.h"
#include "../protocol/PFactory.h"

using namespace std;
using namespace cocos2d;
using namespace network;
class WebNet
{
private:
	//string serviceURL="http://localhost:2496/WebService1.asmx/";
	//string serviceURL = "http://127.0.0.1/webservice1.asmx/";
	//string serviceURL = "http://192.168.31.222/webservice1.asmx/";
	string serviceURL = "http://104632.vhost74.boxcdn.cn/webservice1.asmx/";
public:
	virtual void callBack(vector<PBase*> _callBackData){
		CCLOG("WEBNET back data");
	}
private:
	void onHttpRequestCompleted(HttpClient *httpClient, void *data);
public:
	void request(string serviceName, string requestData = "", bool isUseCallBack=true);
	void requestData(PBase* _pBase);
};

