#pragma once
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../webnet/WebNet.h"

class TickScene :public UIManager,public WebNet
{
public:
	void refresh();
public:
	TickScene *createScene();
	virtual bool init();
	CREATE_FUNC(TickScene);
	void widgetTouchUp(Widget *_widget);
	void setTool(tabTick* tool);
	void setEdit(bool _isEdit);
	void callBack(vector<PBase*> _callBackData);
	void setData(string _checkID);
private:
	string checkID;
	Button* btnBack;
	Button* btnSubmit;
	ScrollView* scrollView;
	bool isEdit;
	tabTick* tool;
private:
	void getTickData();
};

