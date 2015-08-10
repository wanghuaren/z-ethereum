#include <iostream>
#include "cocos2d.h"
#include "cocostudio/CocoStudio.h"
#include "CCLuaEngine.h"
#include "../templet/Singleton.h"

using namespace cocos2d;
using namespace std;
using namespace cocostudio::timeline;


extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
};

class CppLua :public Singleton<CppLua>{
public:
	CppLua();
	~CppLua();

	static int cppFunction(lua_State* ls);
	void callCppFunction(lua_State* ls);
	Node* callLuaNode(string _sceneName, int _index = 0, bool _bool = true);
	ActionTimeline* callLuaAnima(string _sceneName, int _index = 0, bool _bool = true);
private:
	friend class Singleton<CppLua>;
};