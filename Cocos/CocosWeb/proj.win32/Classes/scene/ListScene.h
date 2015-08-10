#pragma once
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../webnet/WebNet.h"
#include "../protocol/tabCustom.h"
#include "../protocol/PBase.h"
#include "CustomScene.h"
#include "CheckScene.h"
#include "TickScene.h"
#include "PostScene.h"
#include "../core/ImagCache.h"
class ListScene :public WebNet,public UIManager
{
public:
	 tabCustom dataTool;
public:
	ListScene *createScene();
	virtual bool init();
	CREATE_FUNC(ListScene);
	void widgetTouchUp(Widget *_widget);

	void nodeTouchDown(Node* _node);
	void nodeTouchUp(Node* _node);
public:
	void callBack(vector<PBase*> _callBackData);
	void refresh();
private:
	Button* btnExit;

	Button* btnCustom;
	Button* btnPost;
	Button* btnCheck;
	Button* btnTick;

	Button* btnNew;
	ScrollView* scrollView;
	bool isCanClick;
	int scrollCount;
	vector<PBase*> callBackData;
	int editNum;
	Texture2D* textureBg1;
	Texture2D* textureBg2;

	int checkState1;
	int checkState2;
	int checkState3;

	Text* textState;
	bool canClickTab;
private:
	Layout * createItem();
	void showListView(vector<PBase*> _callBackData);
	void scrollViewMoveCallback(cocos2d::Ref *pSender, cocos2d::ui::ScrollView::EventType eventType);
	
};

