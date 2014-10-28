package engine.load
{
	/*游戏资源池【资源查取】*/
	import flash.display.DisplayObject;
	import flash.system.*;
	
	import engine.utils.Debug;

	public class Gamelib
	{
		private static var _instance:Gamelib;
		public static function getInstance():Gamelib{
			if(_instance==null)
				_instance=new Gamelib();
			return _instance;
		}
		public function Gamelib():void
		{
		}

		public function getswf(names:String):Object
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

		public function getswflink(names:String, links:String):DisplayObject
		{

//			names=names();

			var linkmc:Class=getswflinkClass(names, links);

			if (linkmc != null)
			{

				return DisplayObject(new linkmc);
			}
			else
			{

				return null;
			}
		}

		public function getswflinkClass(names:String, links:String):Class
		{
//			names=names.toLowerCase();
			var linkmc:Class=null;
			try
			{
				var APP:ApplicationDomain=Loadres.resAPP[names];
			}
			catch (e:Error)
			{
				Debug.instance.traceMsg("对象池中不存在对象：" + names);
			}
			try
			{
				if (APP != null)
				{
					linkmc=APP.getDefinition(links) as Class;
				}
			}
			catch (e:Error)
			{
				//Debug.instance.traceMsg("对象池[" + names + "]中没有链接对象：" + links);
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

		public function getlist():String
		{
			var str:String="";
			for (var s:String in Loadres.resAPP)
			{
				//	Debug.instance.traceMsg(s+":"+Loadres.resAPP[s]);
				str+=s + ":" + Loadres.resAPP[s] + "\n";
			}
			return str;
		}

		public function removeswf(names:String):Boolean
		{
//			names=names.toLowerCase();
			var Res:Object=Loadres.resSWF[names];
			if (Res != null)
			{
				Loadres.resSWF[names]=null;
				Loadres.resAPP[names]=null;
				return true;
			}
			else
			{
				return false;
			}
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