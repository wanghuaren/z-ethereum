#include "GameInitiali.h"


GameInitiali::GameInitiali()
{
	/*std::map<string, string> _mapImgPath;
	_mapImgPath["itembg1"] = "res/resource/itembg1.png";
	_mapImgPath["itembg2"] = "res/resource/itembg2.png";
	ImagCache::instance()->addCacheImgRes(_mapImgPath);*/
	ImagCache::instance()->initGameRes();

	SceneManager::instance()->registerScene("mainScene", new MainScene());
	SceneManager::instance()->registerScene("customScene", new CustomScene());
	SceneManager::instance()->registerScene("checkScene", new CheckScene());
	SceneManager::instance()->registerScene("listScene", new ListScene());
	SceneManager::instance()->registerScene("noticeScene", new NoticeScene());
	SceneManager::instance()->registerScene("tickScene", new TickScene());
	SceneManager::instance()->registerScene("postScene", new PostScene());
}


GameInitiali::~GameInitiali()
{
}
