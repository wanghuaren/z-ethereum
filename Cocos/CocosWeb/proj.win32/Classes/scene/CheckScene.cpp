#include "CheckScene.h"

CheckScene *CheckScene::createScene(){
	Scene* _scene = new Scene();
	Layer* _layer = new CheckScene();
	_layer->init();
	_scene->addChild(_layer);
	return static_cast<CheckScene*>(_layer);
}
bool CheckScene::init(){
	if (!Layer::init()){
		return false;
	}
	showUI("CheckScene");
	btnBack = static_cast<Button*>(rootNode->getChildByName("btnBack"));
	btnSubmit = static_cast<Button*>(rootNode->getChildByName("btnSubmit"));
	btnNewPost = static_cast<Button*>(rootNode->getChildByName("btnNewPost"));
	scrollView = trans(ScrollView*, rootNode->getChildByName("ScrollView"))


	addWidgetTouchListener(btnBack);
	addWidgetTouchListener(btnSubmit);
	addWidgetTouchListener(btnNewPost);
	refresh();
	return true;
}
void CheckScene::widgetTouchUp(Widget *_widget){
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
			TextField* _txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
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
	else if (btnNewPost == _widget)
	{
		TickScene* _tickScene = (TickScene*)SceneManager::instance()->showScene("tickScene");
			_tickScene->setData(tool->ID);
	}
}
void CheckScene::getTickData(){
	tabCheck* _tabTick = new tabCheck();
	_tabTick->act = "4";
	_tabTick->customid = customID;
	requestData(_tabTick);
}
void CheckScene::setData(string _customID,tabCustom* _tabCustom){
	customID = _customID;
	TextField* _txt;
	for (std::map<string, tabCustom::AttType>::iterator it = _tabCustom->mapAtt.begin(); it != _tabCustom->mapAtt.end(); it++)
	{
		_txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
		if (_txt != NULL)
			_txt->setString(_tabCustom->*(it->second));
	}
	getTickData();
}
void CheckScene::refresh(){

}
void CheckScene::setTool(tabCheck* _tool){
	TextField* _txt;
	tool = _tool;
	for (std::map<string, tabCheck::AttType>::iterator it = _tool->mapAtt.begin(); it != _tool->mapAtt.end(); it++)
	{
		_txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
		if (_txt != NULL)
			_txt->setString(_tool->*(it->second));
	}
}
void CheckScene::setEdit(bool _isEdit){
	isEdit = _isEdit;
	if (isEdit){
		btnNewPost->setVisible(true);
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("编辑");
	}
	else{
		btnNewPost->setVisible(false);
		tool = new tabCheck();
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("提交");

		for (std::map<string, tabCheck::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			TextField* _txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
			if (_txt != NULL&&_txt->isTouchEnabled()){
				_txt->setString("");
				_txt->setPlaceHolderColor(Color3B::GRAY);
			}
		}
	}

}
void CheckScene::callBack(vector<PBase*> _callBackData){
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