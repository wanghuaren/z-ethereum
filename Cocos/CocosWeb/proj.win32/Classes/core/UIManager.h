#pragma once
#include "cocos2d.h"
#include "ui/CocosGUI.h"
#include "cocostudio/CocoStudio.h"
#include "../protocol/PBase.h"
#include "../utils/CppLua.h"
USING_NS_CC;
using namespace std;
using namespace cocos2d::ui;
using namespace cocostudio::timeline;

class SceneManager;
class UIManager :public Layer
{
#define trans(var1, var2) static_cast<var1>(var2);
public:
	Node* rootNode;
	ActionTimeline* rootAction;
public:
	UIManager();
	~UIManager();

	void showUI(string _nodeName, int _begin = 1, int _end = 1, bool _loop = false);
	void addWidgetTouchListener(Widget* _widget);
	void addWidgetClickListener(Widget* _widget);

	void addNodeTouchListener(Node* _node, bool isSwallowTouches = false);
	virtual UIManager* createScene(){
		CCLOG("createScene UIManager");
		return NULL;
	}

	virtual void refresh(){
		CCLOG("refresh UIManager");
	}

	virtual void widgetTouchDown(Widget* _widget){
		CCLOG("UIManager.widgetTouchDown");
	}
	virtual void widgetTouchUp(Widget* _widget){
		CCLOG("UIManager.widgetTouchUp");
	}
	virtual void widgetTouchMove(Widget* _widget){
		CCLOG("UIManager.widgetTouchMove");
	}

	virtual void widgetClick(Widget* _widget){
		CCLOG("UIManager.widgetClickUp");
	}


	virtual void nodeTouchDown(Node* _node){
		CCLOG("UIManager.nodeTouchDown");
	}
	virtual void nodeTouchUp(Node* _node){
		CCLOG("UIManager.nodeTouchUp");
	}
	virtual void nodeTouchMove(Node* _node, Vec2 _pos){
		CCLOG("UIManager.nodeTouchMove");
	}
	virtual void callBack(string* _callBackData){
		CCLOG("WEBNET back data");
	}
private:
	void widgetTouchEvent(Ref* ref, Widget::TouchEventType type, Widget* _widget);
	void widgetClickEvent(Ref* ref);

	void createListener(bool isScroll);
	bool nodeTDown(Touch* touch, Event* event);
	void nodeTUp(Touch* touch, Event* event);
	void nodeTMove(Touch* touch, Event* event);
private:
	EventListenerTouchOneByOne* listener;
};

