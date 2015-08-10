#include "TickScene.h"

TickScene *TickScene::createScene(){
	Scene* _scene = new Scene();
	Layer* _layer = new TickScene();
	_layer->init();
	_scene->addChild(_layer);
	return static_cast<TickScene*>(_layer);
}
bool TickScene::init(){
	if (!Layer::init()){
		return false;
	}
	showUI("TickScene");
	btnBack = static_cast<Button*>(rootNode->getChildByName("btnBack"));
	btnSubmit = static_cast<Button*>(rootNode->getChildByName("btnSubmit"));
	scrollView = trans(ScrollView*, rootNode->getChildByName("ScrollView"));
	addWidgetTouchListener(btnBack);
	addWidgetTouchListener(btnSubmit);
	return true;
}
void TickScene::widgetTouchUp(Widget *_widget){
	if (btnBack == _widget){
		SceneManager::instance()->showScene("listScene");;
	}
	else if (btnSubmit == _widget){
		if (isEdit)
			tool->act = "3";
		else
			tool->act = "1";
		tool->userid = SceneManager::instance()->userid;
		tool->checkID = checkID;
		for (std::map<string, tabTick::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			TextField* _txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
			//if (_txt != NULL&&_txt->getString() != "")
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

void TickScene::refresh(){

}
void TickScene::getTickData(){
	tabTick* _tabTick = new tabTick();
	_tabTick->act = "4";
	_tabTick->checkID = checkID;
	requestData(_tabTick);
}
void TickScene::setData(string _checkID){
	checkID = _checkID;
	getTickData();
}
void TickScene::setTool(tabTick* _tool){
	TextField* _txt;
	tool = _tool;
	checkID = tool->checkID;
	for (std::map<string, tabTick::AttType>::iterator it = _tool->mapAtt.begin(); it != _tool->mapAtt.end(); it++)
	{
		_txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
		if (_txt != NULL)
			_txt->setString(_tool->*(it->second));
	}
}
void TickScene::setEdit(bool _isEdit){
	isEdit = _isEdit;
	if (isEdit)
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("编辑");
	else{
		tool = new tabTick();
		static_cast<Button*>(rootNode->getChildByName("btnSubmit"))->setTitleText("提交");

		for (std::map<string, tabTick::AttType>::iterator it = tool->mapAtt.begin(); it != tool->mapAtt.end(); it++)
		{
			TextField* _txt = static_cast<TextField*>(scrollView->getChildByName(it->first));
			if (_txt != NULL){
				_txt->setString("");
				_txt->setPlaceHolderColor(Color3B::GRAY);
			}
		}
	}

}
void TickScene::callBack(vector<PBase*> _callBackData){
	if (_callBackData.size() == 1){
		if (_callBackData.at(0)->getID() == ""){
			SceneManager::instance()->showScene("listScene");;
		}
		else{
			setTool(static_cast<tabTick*>(_callBackData.at(0)));
			setEdit(true);
		}
	}
	else{
		setEdit(false);
	}
}