#include "WebNet.h"

void WebNet::requestData(PBase* _pBase){
	request("requestData", PFactory::instance()->getSendData(_pBase));
}
void WebNet::onHttpRequestCompleted(HttpClient *httpClient, void *data)
{
	HttpResponse* response = (HttpResponse*)data;
	if (!response) { CCLOG("Log:response =null,plase check it."); return; }

	//请求失败
	if (!response->isSucceed())
	{
		/*vector<char>* pTemp = response->getResponseData();
		string str(pTemp->begin(), pTemp->end());
		CCLOG("ERROR BUFFER:%s", str);*/
		CCLOG("==============NET ERROR===================");
	}
	else{
		int codeIndex = response->getResponseCode();
		const char* tag = response->getHttpRequest()->getTag();

		//请求成功
		vector<char>* buffer = response->getResponseData();
		string temp(buffer->begin(), buffer->end());
		callBack(PFactory::instance()->getBackData(&temp));
		//tinyxml2::XMLElement *toolElement = root->FirstChildElement("test");
	}
}
void WebNet::request(string serviceName, string requestData, bool isUseCallBack){
	HttpRequest* postRequest = new HttpRequest();
	postRequest->setRequestType(HttpRequest::Type::POST);//设置发送类型
	postRequest->setUrl((serviceURL + serviceName).c_str());//设置网址
	if (isUseCallBack)
		postRequest->setResponseCallback(CC_CALLBACK_2(WebNet::onHttpRequestCompleted, this));//回调函数，处理接收到的信息

	if (requestData != "")
		postRequest->setRequestData(requestData.c_str(), requestData.length());//这里的代码会接在网络地址后面，一起发送。
	postRequest->setTag(serviceName.c_str());
	HttpClient* httpClient = HttpClient::getInstance();
	httpClient->setTimeoutForConnect(10);//设置连接超时时间</span>
	httpClient->setTimeoutForRead(10);//设置发送超时时间
	httpClient->send(postRequest);//设置接收数据类型
	postRequest->release();//释放
}