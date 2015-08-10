#pragma once
#include "cocos2d.h"
#include "../templet/Singleton.h"
#include "UIManager.h"

class SceneManager:public Singleton<SceneManager>
{
private:
	std::map<string, UIManager*> mapScene;
	std::map<string, UIManager*> mapNode;
private:
	void runScene(Scene* _scene);
	void runNode(Node* _node);
public:
	string userid;
public:
	SceneManager();
	~SceneManager();

	UIManager* showScene(string _sceneName);
	UIManager* showNode(string _nodeName);
	
	void registerScene(string _sceneName, UIManager* _scene);
	void registerNode(string _nodeName, UIManager* _node);
};
