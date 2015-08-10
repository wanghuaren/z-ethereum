#ifndef __MainScene_SCENE_H__
#define __MainScene_SCENE_H__
#include "../webnet/WebNet.h"
#include "../core/UIManager.h"
#include "../core/SceneManager.h"
#include "../protocol/tabUser.h"
#include "NoticeScene.h"
class MainScene : public UIManager,public WebNet
{
public:
	
public:
    // there's no 'id' in cpp, so we recommend returning the class instance pointer
	MainScene* createScene();

    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();

    // implement the "static create()" method manually
    CREATE_FUNC(MainScene);

	void widgetTouchUp(Widget *_widget);


private:
	Button *btnSubmit;
	TextField* TextField_user;
	TextField* TextField_pass;
	void callBack(vector<PBase*> _callBackData);
};

#endif // __MainScene_SCENE_H__
