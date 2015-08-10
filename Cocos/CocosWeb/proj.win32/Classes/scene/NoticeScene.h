#pragma once
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../webnet/WebNet.h"

class NoticeScene :public WebNet,public UIManager
{
public:
	void refresh();
public:
	NoticeScene *createScene();
	virtual bool init();
	CREATE_FUNC(NoticeScene);
	void widgetTouchUp(Widget *_widget);
	void setTxtDesc(string _desc);
private:
	Button* btnClose;
	Text* text_desc;
};

