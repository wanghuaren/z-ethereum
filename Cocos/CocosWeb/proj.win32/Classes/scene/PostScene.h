#pragma once
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../webnet/WebNet.h"
#include "../protocol/tabCheck.h"
class PostScene :public UIManager,public WebNet
{
public:
	void refresh();
public:
	PostScene *createScene();
	virtual bool init();
	CREATE_FUNC(PostScene);
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
	tabCustom* _tabCustom;
	bool isEdit;
	tabCheck* tool;
	string customID;
};

