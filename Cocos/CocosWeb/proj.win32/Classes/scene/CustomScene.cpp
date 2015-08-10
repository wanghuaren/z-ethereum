#include "CustomScene.h"

CustomScene *CustomScene::createScene(){
	Scene* _scene = new Scene();
	Layer* _layer = new CustomScene();
	_layer->init();
	_scene->addChild(_layer);
	return static_cast<CustomScene*>(_layer);
}
bool CustomScene::init(){
	if (!Layer::init()){
		return false;
	}
	showUI("CustomScene");
	btnBack = static_cast<Button*>(rootNode->getChildByName("btnBack"));
	btnSubmit = static_cast<Button*>(rootNode->getChildByName("btnSubmit"));
	btnNewCheck = trans(Button*, rootNode->getChildByName("btnNewCheck"));
	scrollView = trans(ScrollView*, rootNode->getChildByName("ScrollView"));
	addWidgetTouchListener(btnBack);
	addWidgetTouchListener(btnSubmit);
	addWidgetTouchListener(btnNewCheck);
	refresh();
	return true;
}
void CustomScene::widgetTouchUp(Widget *_widget){
	if (btnBack == _widget){
		SceneManager::instance()->showScene("listScene");
	}
	else if (btnSubmit == _widget){
		TextField* _txt;
		if (isEdit)
			tool->act = "3";
		else
			tool->act = "1";
		tool->userid = SceneManager::instance()->userid;
		for (std::map<string, tabCustom::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			_txt = trans(TextField*, scrollView->getChildByName(it->first));
			//if (_txt != NULL&&_txt->getString() != ""){
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
		//_txt = NULL;
		//if (tool->cName == "" || tool->cName == "完善此处信息"){
		//	_txt = trans(TextField*, rootNode->getChildByName("cName"));
		//}
		//else if (tool->compName == "" || tool->compName == "完善此处信息"){
		//	_txt = trans(TextField*, rootNode->getChildByName("compName"));
		//}
		//else if (tool->tel == "" || tool->tel == "完善此处信息"){
		//	_txt = trans(TextField*, rootNode->getChildByName("tel"));
		//}
		//if (_txt != NULL){
		//	_txt->setString("完善此处信息");
		//	return;
		//}
		requestData(tool);
	}
	else if (btnNewCheck == _widget){
		CheckScene* _checkScene = (CheckScene*)SceneManager::instance()->showScene("checkScene");
		_checkScene->setData(tool->ID, tool);
	}
}
void CustomScene::refresh(){
	tabCustom _tool;
	_tool.tabName = "tabCheck";
	_tool.act = "2";
	_tool.ID = "12";
}
void CustomScene::setTool(tabCustom* _tool){
	TextField* _txt;
	tool = _tool;
	for (std::map<string, tabCustom::AttType>::iterator it = _tool->mapAtt.begin(); it != _tool->mapAtt.end(); it++)
	{
		_txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
		if (_txt != NULL)
			_txt->setString(_tool->*(it->second));
	}
}
void CustomScene::setEdit(bool _isEdit){
	isEdit = _isEdit;
	if (isEdit){
		btnNewCheck->setVisible(true);
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("编辑");
	}
	else{
		btnNewCheck->setVisible(false);
		tool = new tabCustom();
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("提交");

		for (std::map<string, tabCustom::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			TextField* _txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
			if (_txt != NULL){
				_txt->setString("");
				_txt->setPlaceHolderColor(Color3B::GRAY);
			}
		}
	}
}
void CustomScene::callBack(vector<PBase*> _callBackData){
	if (static_cast<tabCustom*>(_callBackData.at(0))->result == "1")
		SceneManager::instance()->showScene("listScene");
	else
		CCLOG("fail");
}