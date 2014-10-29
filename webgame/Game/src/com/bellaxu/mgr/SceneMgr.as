package com.bellaxu.mgr
{
	import flash.utils.Dictionary;

	/**
	 * 场景管理
	 * @author BellaXu
	 */
	public class SceneMgr
	{
		private static var _instance:SceneMgr;
		
		private var _roleDic:Dictionary; //人物
		private var _monsterDic:Dictionary; //怪物
		private var _npcDic:Dictionary; //npc
		private var _dropDic:Dictionary; //掉落
		
		public function SceneMgr()
		{
			
		}
		
		public static function getInstance():SceneMgr
		{
			if(!_instance)
				_instance = new SceneMgr();
			return _instance;
		}
	}
}