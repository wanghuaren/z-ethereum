#include "MainScene.h"

using namespace cocostudio::timeline;
using namespace cocos2d::ui;

MainScene* MainScene::createScene()
{
	// 'scene' is an autorelease object
	Scene* _scene = new Scene();

	// 'layer' is an autorelease object
	Layer* _layer = new MainScene();
	_layer->init();
	// add layer as a child to scene
	_scene->addChild(_layer);

	return static_cast<MainScene*>(_layer);
}

// on "init" you need to initialize your instance
bool MainScene::init()
{
	//////////////////////////////
	// 1. super init first
	if (!Layer::init())
	{
		return false;
	}

	showUI("MainScene");

	btnSubmit = trans(Button*, rootNode->getChildByName("btnLogin"));
	TextField_user = trans(TextField*,rootNode->getChildByName("TextField_user"));
	TextField_pass = trans(TextField*,rootNode->getChildByName("TextField_user"));
	addWidgetTouchListener(btnSubmit);
	return true;
}
void MainScene::widgetTouchUp(Widget *_widget){
	if (btnSubmit == _widget){
		tabUser* _tabuser=new tabUser();
		_tabuser->act = "4";
		_tabuser->userName = TextField_user->getString();
		_tabuser->password = TextField_pass->getString();
		/*_tabuser->userName = "admin";
		_tabuser->password = "admin";*/
		requestData(_tabuser);
		//request("checkUser", "data=admin&data=admin");
	}
}
void MainScene::callBack(vector<PBase*> _callBackData){
	if (_callBackData.size() == 1){
		tabUser* _tu = trans(tabUser*, _callBackData.at(0));
		SceneManager::instance()->userid = _tu->ID;
		NoticeScene* _noticeScene = (NoticeScene*)SceneManager::instance()->showScene("noticeScene");
		_noticeScene->setTxtDesc(_tu->desc);
	}
	else{
		CCLOG("LOGIN ERROR--------------");
	}
}
