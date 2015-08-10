#include "SceneManager.h"
SceneManager::~SceneManager(){
}
SceneManager::SceneManager(){
}
UIManager* SceneManager::showScene(string _sceneName){
	mapScene[_sceneName]->refresh();
	runScene(mapScene[_sceneName]->getScene());
	return mapScene[_sceneName];
}
UIManager* SceneManager::showNode(string _nodeName){
	runNode(mapNode[_nodeName]);
	return mapNode[_nodeName];
}

void SceneManager::registerScene(string _sceneName, UIManager* _scene){
	mapScene.insert(std::map<string, UIManager*>::value_type(_sceneName, _scene->createScene()));
}
void SceneManager::registerNode(string _nodeName, UIManager* _node){
	mapNode.insert(std::map<string, UIManager*>::value_type(_nodeName, _node));
}
void SceneManager::runScene(Scene* _scene){
	//Director::getInstance()->replaceScene(_scene);
	if (_scene->isRunning())
		CCLOG("RUN");
	else
		Director::getInstance()->runWithScene(_scene);
	SceneManager::instance()->mapScene;
}
void SceneManager::runNode(Node* _node){
	
}