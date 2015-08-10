#include "NoticeScene.h"

NoticeScene *NoticeScene::createScene(){
	Scene* _scene = new Scene();
	Layer* _layer = new NoticeScene();
	_layer->init();
	_scene->addChild(_layer);
	return static_cast<NoticeScene*>(_layer);
}
bool NoticeScene::init(){
	if (!Layer::init()){
		return false;
	}
	showUI("NoticeScene");
	btnClose = static_cast<Button*>(rootNode->getChildByName("btnClose"));
	text_desc = static_cast<Text*>(rootNode->getChildByName("Text_desc"));
	text_desc->ignoreContentAdaptWithSize(false);
	addWidgetTouchListener(btnClose);
	refresh();
	return true;
}
void NoticeScene::setTxtDesc(string _desc){
	text_desc->setString(_desc);
}

void NoticeScene::widgetTouchUp(Widget *_widget){
	if (btnClose == _widget){
		SceneManager::instance()->showScene("listScene");;
	}
}
void NoticeScene::refresh(){

}