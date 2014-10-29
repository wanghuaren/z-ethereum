package com.bellaxu.res
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * 位图资源
	 * @author BellaXu
	 */
	internal class ResBmd
	{
		private static var bmdDic:Dictionary = new Dictionary();

		public static function saveBmd(url:String, bmd:BitmapData):void
		{
			if(!bmdDic[url])
				bmdDic[url] = bmd;
		}
		
		public static function saveLinkBmd(url:String, link:String, bmd:BitmapData):void
		{
			if(!bmdDic[url])
				bmdDic[url] = new Dictionary();
			if(!bmdDic[url][link])
				bmdDic[url][link] = bmd;
		}
		
		public static function delBmd(url:String):void
		{
			if(bmdDic[url] is Dictionary)
			{
				for(var k:String in bmdDic[url])
				{
					BitmapData(bmdDic[url][k]).dispose();
					delete bmdDic[url][k];
				}
			}
			else
			{
				if(bmdDic[url])
				{
					BitmapData(bmdDic[url]).dispose();
					delete bmdDic[url];
				}
			}
		}
		public static function delAllBmd():void
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
		public static function getBmd(url:String, link:String = null):BitmapData
		{
			return link ? (bmdDic[url] ? bmdDic[url][link] : null) : bmdDic[url];
		}
	}
}