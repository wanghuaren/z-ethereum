package engine.load
{
	import engine.utils.Debug;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;

	public final class GamelibS
	{

		public static function getswf(names:String):Object
		{
			var Res:Object=Loadres.resSWF[names];
			if (Res != null)
			{
				return Res.content;
			}
			else
			{
				return null;
			}
		}

		public static function getswflink(names:String, links:String):DisplayObject
		{
			//			names=names.toLowerCase();
			var linkmc:Class=getswflinkClass(names, links);
			if (linkmc != null)
			{
				return DisplayObject(new linkmc());
			}
			else
			{
				return null;
			}
		}

		public static function getbmdlink(names:String, links:String):BitmapData
		{
			//			names=names.toLowerCase();
			var linkmc:Class=getswflinkClass(names, links);
			if (linkmc != null)
			{
				return BitmapData(new linkmc());
			}
			else
			{
				return null;
			}
		}

		//-----Warren----------
		public static function getAppplicationDomain(names:String):ApplicationDomain
		{
			return Loadres.resAPP[names]
		}

		public static function getXMLWithAppplicationDomain(names:String):XML
		{
			return Loadres.resAPP[names] as XML;
		}

		//------------------
		public static function getswflinkClass(names:String, links:String):Class
		{
			var linkmc:Class=null;
			var APP:ApplicationDomain=Loadres.resAPP[names];
			if (APP != null && APP.hasDefinition(links))
			{
				linkmc=APP.getDefinition(links) as Class;
			}
			if (linkmc != null)
			{
				return linkmc;
			}
			else
			{
				return null;
			}
		}

		/**
		 *	看game_index作用域是否存在某些class
		 *  @links
		 *
		 */
		public static function isApplicationClass(links:String):Boolean
		{
			try
			{
				var APP:ApplicationDomain=Loadres.resAPP["game_index"];
				if (APP != null && APP.hasDefinition(links))
				{
					return true;
				}
			}
			catch (e:Error)
			{
				Debug.instance.traceMsg("对象池中不存在对象：" + links);
			}
			return false;
		}

		public static function getlist():String
		{
			var str:String="";
			for (var s:String in Loadres.resAPP)
			{
				//	Debug.instance.traceMsg(s + ":" + Loadres.resAPP[s]);
				str+=s + ":" + Loadres.resAPP[s] + "\n";
			}
			return str;
		}

		public static function hasOwnSWF(names:String):Boolean
		{
//			names=names.toLowerCase();
			return Loadres.resSWF.hasOwnProperty(names); //&& Loadres.resSWF[names] != Loadres.nullApplication;
		}



		public static function getFileName(names:String):String
		{
			var na:int=names.lastIndexOf("/");
			na=na == -1 ? 0 : na + 1;
			names=names.substr(na, names.length);
			return names.substr(0, names.lastIndexOf("."));
		}
	}
}
