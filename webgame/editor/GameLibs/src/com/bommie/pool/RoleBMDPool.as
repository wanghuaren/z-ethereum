package com.bommie.pool
{
	import com.bommie.load.ResLoader;
	import com.bommie.role.ResMc;
	import com.bommie.role.struct.BitmapInfo;

	import flash.utils.Dictionary;

	public final class RoleBMDPool
	{
		/**
		 * 模型的方向信息,以XML路径为键值
		 * */
		public var _actDic:Dictionary=new Dictionary(); //swf对应的资源的所有状态的方向列表
		/**
		 * 模型每个动作上位图数量信息,以XML路径为键值
		 * */
		public var _actResLoadedDic:Dictionary=new Dictionary(); //swfd对应所有动作上初始化的资源数量
		/**
		 * 所有的位图BitmapInfo信息,以XML路径为键值
		 * */
		public var _mcDic:Dictionary=new Dictionary();
		/**
		 * 播放列表中的资源
		 * */
		public var _runList:Vector.<ResMc>=new <ResMc>[]; //播放中的资源列表
		/**
		 * 每个动画模型存在的数量,以XML路径为键值
		 * */
		public const COUNT_DIC:Dictionary=new Dictionary(); //索引计数
		private static var _instance:RoleBMDPool;

		public static function get instance():RoleBMDPool
		{
			if (_instance == null)
				_instance=new RoleBMDPool();
			return _instance;
		}

		public function timeGc():void
		{
			var vec:Vector.<BitmapInfo>;
			var tmpResDic:Dictionary;
			var count:int=0;
			var info:BitmapInfo;
			var dic:Dictionary=COUNT_DIC;
			for (var key:String in _mcDic)
			{
				vec=_mcDic[key];
				tmpResDic=_actResLoadedDic[key];
				count=COUNT_DIC[key];
				if (count <= 0)
				{
					for each (info in vec)
					{
						info.destory();
					}
					for (var key1:String in tmpResDic)
					{
						ResLoader.getInstance().disposeRes(key.replace("xml.xml", key1 == "D1" ? "" : key1 + ".swf"));
						delete tmpResDic[key1];
					}
					vec.length=0;
					delete _mcDic[key];
					delete _actResLoadedDic[key]; //清除缓存的资源加载记录
					delete COUNT_DIC[key];
					ResLoader.getInstance().disposeRes(key);
				}
			}
		}
	}
}
