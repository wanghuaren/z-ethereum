#pragma comment(lib, "comctl32.lib")
#include "AppDelegate.h"
#include "core/ImagCache.h"
#include "CCLuaEngine.h"
#include "lua_module_register.h"
#include "Cocos2dxLuaLoader.h"
#include "scene/GameInitiali.h"
#include "core/LuaLoader.h"
USING_NS_CC;

AppDelegate::AppDelegate() {

}

AppDelegate::~AppDelegate()
{
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
	//set OpenGL context attributions,now can only set six attributions:
	//red,green,blue,alpha,depth,stencil
	GLContextAttrs glContextAttrs = { 8, 8, 8, 8, 24, 8 };

	GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching() {
	// initialize director
	auto director = Director::getInstance();
	auto glview = director->getOpenGLView();
	if (!glview) {
		glview = GLViewImpl::createWithRect("CocosWeb", Rect(0, 0, 6400, 9600));
		director->setOpenGLView(glview);
	}
#if ISTEST 
	director->getOpenGLView()->setFrameSize(320, 480);
#else
	director->getOpenGLView()->setFrameSize(glview->getVisibleRect().size.width, glview->getVisibleRect().size.height);
#endif
	director->getOpenGLView()->setDesignResolutionSize(640, 960, ResolutionPolicy::SHOW_ALL);

	// turn on display FPS
	director->setDisplayStats(true);

	// set FPS. the default value is 1.0/60 if you don't call this
	director->setAnimationInterval(1.0 / 30);


	LuaEngine* pEngine = LuaEngine::getInstance();
	ScriptEngineManager::getInstance()->setScriptEngine(pEngine);
	lua_State* L = pEngine->getLuaStack()->getLuaState();
	lua_module_register(L);
#if ISTEST
	AllocConsole();
	HWND _hwndConsole = GetConsoleWindow();
	if (_hwndConsole != NULL)
	{
		ShowWindow(_hwndConsole, SW_SHOW);
		BringWindowToTop(_hwndConsole);
		freopen("CONOUT$", "wt", stdout);
		freopen("CONOUT$", "wt", stderr);

		HMENU hmenu = GetSystemMenu(_hwndConsole, FALSE);
		if (hmenu != NULL)
		{
			DeleteMenu(hmenu, SC_CLOSE, MF_BYCOMMAND);
		}
	}
	//pEngine->executeString("print=release_print");
	FileUtils::getInstance()->addSearchPath("../../Resources/res");
#else
	FileUtils::getInstance()->addSearchPath("res");
	FileUtils::getInstance()->addSearchPath("LuaScript");
	pEngine->getInstance()->addLuaLoader(decode_lua_loader);
#endif
	pEngine->executeScriptFile("main.lua");

	new GameInitiali();

	SceneManager::instance()->showScene("mainScene");
	return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
	Director::getInstance()->stopAnimation();

	// if you use SimpleAudioEngine, it must be pause
	// SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
	Director::getInstance()->startAnimation();

	// if you use SimpleAudioEngine, it must resume here
	// SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
