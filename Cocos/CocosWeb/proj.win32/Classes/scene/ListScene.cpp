#include "ListScene.h"

ListScene *ListScene::createScene(){
	Scene* _scene = new Scene();
	Layer* _layer = new ListScene();
	_layer->init();
	_scene->addChild(_layer);
	return static_cast<ListScene*>(_layer);
}
bool ListScene::init(){
	if (!Layer::init()){
		return false;
	}
	showUI("ListScene");
	btnExit = static_cast<Button*>(rootNode->getChildByName("btnExit"));
	btnNew = static_cast<Button*>(rootNode->getChildByName("btnNew"));
	btnCustom = trans(Button*, rootNode->getChildByName("btnCustom"));
	btnCheck = trans(Button*, rootNode->getChildByName("btnCheck"));
	btnPost = trans(Button*, rootNode->getChildByName("btnPost"));
	btnTick = trans(Button*, rootNode->getChildByName("btnTick"));
	textState = trans(Text*, rootNode->getChildByName("textState"));
	scrollView = static_cast<ListView*>(rootNode->getChildByName("scrollView"));
	scrollView->addEventListener(CC_CALLBACK_2(ListScene::scrollViewMoveCallback, this));
	scrollView->setLayoutType(Layout::Type::VERTICAL);

	addWidgetTouchListener(btnExit);
	addWidgetTouchListener(btnNew);
	addWidgetTouchListener(btnCustom);
	addWidgetTouchListener(btnCheck);
	addWidgetTouchListener(btnPost);
	addWidgetTouchListener(btnTick);


	textureBg1 = new Texture2D();
	textureBg1->initWithImage(ImagCache::instance()->mapImgRes["res/resource/itembg1.png"]);
	textureBg2 = new Texture2D();
	textureBg2->initWithImage(ImagCache::instance()->mapImgRes["res/resource/itembg2.png"]);

	canClickTab = false;
	editNum = 1;
	refresh();
	return true;
}

void ListScene::scrollViewMoveCallback(cocos2d::Ref *pSender, cocos2d::ui::ScrollView::EventType eventType) {
	switch (eventType) {
	case ui::ScrollView::EventType::SCROLLING:
		CCLOG("scrolling");
		scrollCount++;
		if (scrollCount > 5)
			isCanClick = false;
		break;
	}
}

void ListScene::widgetTouchUp(Widget *_widget){
	if (btnExit == _widget){
		SceneManager::instance()->showScene("mainScene");
	}
	else if (btnNew == _widget){
		CustomScene* _customScene = (CustomScene*)SceneManager::instance()->showScene("customScene");
		_customScene->setEdit(false);
	}
	else if (canClickTab&&btnCustom == _widget){
		editNum = 1;
		refresh();

	}
	else if (canClickTab&&btnCheck == _widget){
		editNum = 2;
		refresh();

	}
	else if (canClickTab&&btnTick == _widget){
		editNum = 3;
		refresh();

	}
	else if (canClickTab&&btnPost == _widget){
		editNum = 4;
		refresh();

	}
}
void ListScene::nodeTouchDown(Node* _node){
	if (UINT_MAX != scrollView->getChildren().getIndex(_node)){
		scrollCount = 0;
		_node->getChildByName("bg1")->setVisible(false);
		_node->getChildByName("bg2")->setVisible(true);
		isCanClick = true;
	}
}
void ListScene::nodeTouchUp(Node* _node){
	if (UINT_MAX != scrollView->getChildren().getIndex(_node)){
		_node->getChildByName("bg1")->setVisible(true);
		_node->getChildByName("bg2")->setVisible(false);
		if (isCanClick){
			if (editNum == 1){
				CustomScene* _customScene = (CustomScene*)SceneManager::instance()->showScene("customScene");
				_customScene->setEdit(true);
				_customScene->setTool(static_cast<tabCustom*>(callBackData.at(_node->getTag())));
			}
			else if (editNum == 2){
				CheckScene* _checkScene = (CheckScene*)SceneManager::instance()->showScene("checkScene");
				_checkScene->setEdit(true);
				_checkScene->setTool(static_cast<tabCheck*>(callBackData.at(_node->getTag())));
			}
			else if (editNum == 3){
				TickScene* _tickScene = (TickScene*)SceneManager::instance()->showScene("tickScene");
				_tickScene->setEdit(true);
				_tickScene->setTool(static_cast<tabTick*>(callBackData.at(_node->getTag())));
			}
			else if (editNum == 4){
				PostScene* _checkScene2 = (PostScene*)SceneManager::instance()->showScene("postScene");
				_checkScene2->setEdit(true);
				_checkScene2->setTool(static_cast<tabCheck*>(callBackData.at(_node->getTag())));
			}
		}
	}
}
void ListScene::refresh(){
	canClickTab = false;
	switch (editNum)
	{
	case 1:
	{
			  tabCustom* _tc=new tabCustom();
			  _tc->act = "4";
			  _tc->userid = SceneManager::instance()->userid;
			  requestData(_tc);

			  btnCustom->setColor(Color3B::WHITE);
			  btnCheck->setColor(Color3B::GRAY);
			  btnTick->setColor(Color3B::GRAY);
			  btnPost->setColor(Color3B::GRAY);
			  break;
	}
	case 2:{
			   tabCheck* _tch=new tabCheck();
			   _tch->act = "4";
			   _tch->userid = SceneManager::instance()->userid;
			   requestData(_tch);

			   btnCustom->setColor(Color3B::GRAY);
			   btnCheck->setColor(Color3B::WHITE);
			   btnTick->setColor(Color3B::GRAY);
			   btnPost->setColor(Color3B::GRAY);
			   break;
	}
	case 3:
	{
			  tabTick* _tt = new tabTick();
			  _tt->act = "4";
			  _tt->userid = SceneManager::instance()->userid;
			  requestData(_tt);

			  btnCustom->setColor(Color3B::GRAY);
			  btnCheck->setColor(Color3B::GRAY);
			  btnTick->setColor(Color3B::WHITE);
			  btnPost->setColor(Color3B::GRAY);
			  break;
	}
	case 4:
	{
			  tabCheck* _tch2 = new tabCheck();
			  _tch2->act = "4";
			  _tch2->userid = SceneManager::instance()->userid;
			  requestData(_tch2);

			  btnCustom->setColor(Color3B::GRAY);
			  btnCheck->setColor(Color3B::GRAY);
			  btnTick->setColor(Color3B::GRAY);
			  btnPost->setColor(Color3B::WHITE);
			  break;
	}
	}
}
void ListScene::callBack(vector<PBase*> _callBackData){
	callBackData = _callBackData;
	scrollView->removeAllChildren();
	showListView(_callBackData);
}
Layout* ListScene::createItem(){
	Layout* _layout;
	Size* itemSize = new Size(440, 100);
	Vec2* anchorPoint = new Vec2(0, 0);
	Sprite* spriteBg1 = Sprite::createWithTexture(textureBg1);
	spriteBg1->setScaleX(itemSize->width / textureBg1->getContentSize().width);
	spriteBg1->setScaleY(itemSize->height / textureBg1->getContentSize().height);
	spriteBg1->setAnchorPoint(*anchorPoint);

	Sprite* spriteBg2 = Sprite::createWithTexture(textureBg2);
	spriteBg2->setScaleX(itemSize->width / textureBg2->getContentSize().width);
	spriteBg2->setScaleY(itemSize->height / textureBg2->getContentSize().height);
	spriteBg2->setAnchorPoint(*anchorPoint);

	_layout = Layout::create();
	_layout->setAnchorPoint(*anchorPoint);
	_layout->setContentSize(*itemSize);
	_layout->addChild(spriteBg1);

	spriteBg1->setVisible(true);
	spriteBg1->setName("bg1");
	_layout->addChild(spriteBg2);
	spriteBg2->setName("bg2");
	spriteBg2->setVisible(false);

	Label* label = Label::createWithSystemFont("", "/resource/Msyh.ttf", 32);
	label->setName("label");
	label->setAnchorPoint(*anchorPoint);
	label->setPositionX(20);
	label->setPositionY(30);

	_layout->addChild(label);

	return _layout;
}
void ListScene::showListView(vector<PBase*> _callBackData){
	checkState1 = 0;
	checkState2 = 0;
	checkState3 = 0;
	textState->setVisible(false);
	Size* itemSize = new Size(440, 100);
	Layout* _layout;
	for (std::vector<PBase*>::size_type i = 0; i < _callBackData.size(); i++){
		_layout = createItem();
		Label* _label = trans(Label*, _layout->getChildByName("label"));
		_layout->setName(_callBackData.at(i)->getID());
		switch (editNum)
		{
		case 1:{
				   tabCustom* _tc = trans(tabCustom*, _callBackData.at(i));
				   _label->setString("客户:" + _tc->cName); }
			break;
		case 2:{
				   tabCheck* _tch = trans(tabCheck*, _callBackData.at(i));
				   _label->setString("订单:" + _tch->hName);
				   if (_tch->state == "2"){
					   checkState1 += 1;
					   _label->setString("订单:" + _tch->hName + "[已完成]");
				   }
				   else if (_tch->state == "1"){
					   checkState2 += 1;
					   _label->setString("订单:" + _tch->hName + "[处理中]");
				   }
				   else{
					   checkState3 += 1;
					   _label->setString("订单:" + _tch->hName + "[新订单]");
				   }
				   textState->setVisible(true);
				   textState->setString("订单：已完成:" + Value(checkState1).asString() + "，处理中:" + Value(checkState2).asString() + "，未完成:" + Value(checkState3).asString());
			break;
		}
		case 3:{
				   tabTick* _tt = trans(tabTick*, _callBackData.at(i));
				   _label->setString("票据:" + _tt->pName);
				   break;
		}
		case 4:{
				   tabCheck* _tch2 = trans(tabCheck*, _callBackData.at(i));
				   _label->setString("物流:" + _tch2->hName);
				  break;
		}
		default:
			break;
		}

		_layout->setTag(i);
		addNodeTouchListener(_layout);
		_layout->setPositionX(350);
		_layout->setPositionY(itemSize->height * i + 30);
		scrollView->addChild(_layout);
	}
	scrollView->setInnerContainerSize(*(new Size(itemSize->width, itemSize->height * (_callBackData.size() + 1))));
	canClickTab = true;
	itemSize = NULL;
}