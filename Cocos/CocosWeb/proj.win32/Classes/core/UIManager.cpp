
#include "UIManager.h"

UIManager::UIManager()
{

}

UIManager::~UIManager()
{
}

void UIManager::showUI(string _nodeName, int _begin, int _end, bool _loop){
	/*rootNode = CSLoader::createNode(path);
	rootAction = CSLoader::createTimeline(path);
	rootNode->runAction(rootAction);
	rootAction->gotoFrameAndPlay(_begin, _end, _loop);*/

	rootNode = CppLua::instance()->callLuaNode(_nodeName);
	rootAction = CppLua::instance()->callLuaAnima(_nodeName);
	rootNode->runAction(rootAction);
	rootAction->gotoFrameAndPlay(_begin, _end, _loop); 

	addChild(rootNode);
}

void UIManager::addWidgetTouchListener(Widget* _widget){
	_widget->addTouchEventListener(CC_CALLBACK_2(UIManager::widgetTouchEvent, this, _widget));
}
void UIManager::widgetTouchEvent(Ref* _ref, Widget::TouchEventType type, Widget* _widget){
	switch (type){
	case Widget::TouchEventType::BEGAN:
		widgetTouchDown(_widget);
		break;
	case Widget::TouchEventType::ENDED:
		widgetTouchUp(_widget);
		break;
	case Widget::TouchEventType::MOVED:
		widgetTouchMove(_widget);
		break;
	}
}
void UIManager::addWidgetClickListener(Widget* _widget){
	_widget->addClickEventListener(CC_CALLBACK_1(UIManager::widgetClickEvent, this));
}
void UIManager::widgetClickEvent(Ref* _ref){
	// Widget::TouchEventType::ENDED:
	widgetClick(static_cast<Widget*>(_ref));
}

void UIManager::addNodeTouchListener(Node* _node, bool isScroll){
	// 创建一个排队的触控事件监听器 ( 同时仅仅处理一个触控事件 )
	listener = EventListenerTouchOneByOne::create();
	// 当 "swallow touches" 设置为 true, 然后，在 onTouchBegan 方法发返回 'true' 将会吃掉触控事件, 防止其他监听器使用这个事件.
	createListener(isScroll);
	_eventDispatcher->addEventListenerWithSceneGraphPriority(listener, _node);
}

void UIManager::createListener(bool isSwallowTouches){
	// 使用 lambda 表达式实现 onTouchBegan 事件的回调函数
	listener->setSwallowTouches(isSwallowTouches);
		listener->onTouchBegan = CC_CALLBACK_2(UIManager::nodeTDown, this);
	listener->onTouchMoved = CC_CALLBACK_2(UIManager::nodeTMove, this);
	listener->onTouchEnded = CC_CALLBACK_2(UIManager::nodeTUp, this);
}
bool UIManager::nodeTDown(Touch* touch, Event* event){
	// event->getCurrentTarget() 返回 *listener's* sceneGraphPriority 节点.
	Node* target = static_cast<Node*>(event->getCurrentTarget());

	// 获取当前触控点相对与按钮的位置
	Point locationInNode = target->convertToNodeSpace(touch->getLocation());
	Size s = target->getContentSize();
	Rect rect = Rect(0, 0, s.width, s.height);
	// 检测点击区域
	if (rect.containsPoint(locationInNode))
	{
		nodeTouchDown(target);
		return true;
	}
	return false;
}

// 当移动触控的时候
void UIManager::nodeTMove(Touch* touch, Event* event){
	auto target = static_cast<Sprite*>(event->getCurrentTarget());
	// 移动当前的精灵
	nodeTouchMove(target, target->getPosition() + touch->getDelta());
}

// 结束
void UIManager::nodeTUp(Touch* touch, Event* event){
	auto target = static_cast<Sprite*>(event->getCurrentTarget());
	nodeTouchUp(target);
}