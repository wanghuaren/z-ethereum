#pragma once
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../webnet/WebNet.h"
#include "../protocol/tabCustom.h"
#include "CheckScene.h"
class CustomScene :public UIManager, public WebNet
{
public:
	void refresh();
public:
	CustomScene *createScene();
	virtual bool init();
	CREATE_FUNC(CustomScene);
	void widgetTouchUp(Widget *_widget);
	void setTool(tabCustom* tool);
	void setEdit(bool _isEdit);
	void callBack(vector<PBase*> _callBackData);
private:
	Button* btnBack;
	Button* btnSubmit;
	Button* btnNewCheck;
	ScrollView* scrollView;
	bool isEdit;
	tabCustom* tool;
};

