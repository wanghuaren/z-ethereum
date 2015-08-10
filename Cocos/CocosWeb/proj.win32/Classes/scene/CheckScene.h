#pragma once
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../webnet/WebNet.h"
#include "../protocol/tabCheck.h"
#include "TickScene.h"
class CheckScene :public UIManager,public WebNet
{
public:
	void refresh();
public:
	CheckScene *createScene();
	virtual bool init();
	CREATE_FUNC(CheckScene);
	void widgetTouchUp(Widget *_widget);
	void setTool(tabCheck* tool);
	void setEdit(bool _isEdit);
	void callBack(vector<PBase*> _callBackData);
	void setData(string _customID,tabCustom* _tabCustom=NULL);
private:
	void getTickData();
private:
	Button* btnBack;
	Button* btnSubmit;
	Button* btnNewPost;
	ScrollView* scrollView;
	tabCustom* _tabCustom;
	bool isEdit;
	tabCheck* tool;
	string customID;
};

