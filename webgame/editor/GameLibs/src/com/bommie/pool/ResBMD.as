package com.bommie.pool
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * 除了角色形色外的图片,都存在这里.
	 * 角色形像的图片信息存在ResMCMgr的_mcDic对象中,以每个XML路径为键值存储
	 * */
	public final class ResBMD
	{
		private static var _instance:ResBMD;

		public static function get instance():ResBMD
		{
			if (_instance == null)
				_instance=new ResBMD();
			return _instance;
		}
		private var bmdDic:Dictionary=new Dictionary();

		public function saveBmd(url:String, bmd:BitmapData):void
		{
			if (!bmdDic[url])
				bmdDic[url]=bmd;
		}

		public function saveLinkBmd(url:String, link:String, bmd:BitmapData):void
		{
			if (!bmdDic[url])
				bmdDic[url]=new Dictionary();
			if (!bmdDic[url][link])
				bmdDic[url][link]=bmd;
		}

		public function delBmd(url:String):void
		{
			if (bmdDic[url] is Dictionary)
			{
				for (var k:String in bmdDic[url])
				{
					BitmapData(bmdDic[url][k]).dispose();
					delete bmdDic[url][k];
				}
			}
			else
			{
				if (bmdDic[url])
				{
					BitmapData(bmdDic[url]).dispose();
					delete bmdDic[url];
				}
			}
		}

		public function delAllBmd():void
		{
			for (var url:String in bmdDic)
			{
				if (bmdDic[url] is Dictionary)
				{
					for (var k:String in bmdDic[url])
					{
						BitmapData(bmdDic[url][k]).dispose();
						delete bmdDic[url][k];
					}
				}
				else
				{
					if (bmdDic[url])
					{
						BitmapData(bmdDic[url]).dispose();
						delete bmdDic[url];
					}
				}
			}
		}

		public function getBmd(url:String, link:String=null):BitmapData
		{
			return link ? (bmdDic[url] ? bmdDic[url][link] : null) : bmdDic[url];
		}
	}
}