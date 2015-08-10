#include "PostScene.h"

PostScene *PostScene::createScene(){
	Scene* _scene = new Scene();
	Layer* _layer = new PostScene();
	_layer->init();
	_scene->addChild(_layer);
	return static_cast<PostScene*>(_layer);
}
bool PostScene::init(){
	if (!Layer::init()){
		return false;
	}
	showUI("PostScene");
	btnBack = static_cast<Button*>(rootNode->getChildByName("btnBack"));
	btnSubmit = static_cast<Button*>(rootNode->getChildByName("btnSubmit"));


	addWidgetTouchListener(btnBack);
	addWidgetTouchListener(btnSubmit);
	refresh();
	return true;
}
void PostScene::widgetTouchUp(Widget *_widget){
	if (btnBack == _widget){
		SceneManager::instance()->showScene("listScene");
	}
	else if (btnSubmit == _widget){
		if (isEdit)
			tool->act = "3";
		else
			tool->act = "1";
		tool->userid = SceneManager::instance()->userid;
		tool->customid = customID;
		for (std::map<string, tabCheck::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			TextField* _txt = static_cast<TextField*>(rootNode->getChildByName(it->first));
			//	if (_txt != NULL&&_txt->getString() != ""){
			if (_txt != NULL){
				if (_txt->getString() == "" || _txt->getString() == "完善此处信息"){
					_txt->setPlaceHolder("完善此处信息");
					_txt->setPlaceHolderColor(Color3B::RED);
					return;
				}
				_txt->setPlaceHolderColor(Color3B::GRAY);
				tool->*(it->second) = _txt->getString();
			}
		}
		requestData(tool);
	}
}
void PostScene::getTickData(){
	tabCheck* _tabTick = new tabCheck();
	_tabTick->act = "4";
	_tabTick->customid = customID;
	requestData(_tabTick);
}
void PostScene::setData(string _customID,tabCustom* _tabCustom){
	customID = _customID;
	TextField* _txt;
	for (std::map<string, tabCustom::AttType>::iterator it = _tabCustom->mapAtt.begin(); it != _tabCustom->mapAtt.end(); it++)
	{
		_txt = static_cast<TextField*>(rootNode->getChildByName(it->first));
		if (_txt != NULL)
			_txt->setString(_tabCustom->*(it->second));
	}
	getTickData();
}
void PostScene::refresh(){

}
void PostScene::setTool(tabCheck* _tool){
	TextField* _txt;
	tool = _tool;
	for (std::map<string, tabCheck::AttType>::iterator it = _tool->mapAtt.begin(); it != _tool->mapAtt.end(); it++)
	{
		_txt = static_cast<TextField*>(rootNode->getChildByName(it->first));
		if (_txt != NULL)
			_txt->setString(_tool->*(it->second));
	}
}
void PostScene::setEdit(bool _isEdit){
	isEdit = _isEdit;
	if (isEdit){
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("编辑");
	}
	else{
		tool = new tabCheck();
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("提交");

		for (std::map<string, tabCheck::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			TextField* _txt = static_cast<TextField*>(rootNode->getChildByName(it->first));
			if (_txt != NULL&&_txt->isTouchEnabled()){
				_txt->setString("");
				_txt->setPlaceHolderColor(Color3B::GRAY);
			}
		}
	}

}
void PostScene::callBack(vector<PBase*> _callBackData){
	if (_callBackData.size() == 1){
		if (_callBackData.at(0)->getID() == ""){
			SceneManager::instance()->showScene("listScene");
		}
		else{
			setTool(static_cast<tabCheck*>(_callBackData.at(0)));
			setEdit(true);
		}
	}
	else{
		setEdit(false);
	}
}