package engine.utils
{
	 /**
	  * saiman 
	  */	 
	import flash.net.LocalConnection;

	public class SystemGC
	{
		/**
		 * 强制回收 
		 * 
		 */		
		public static function gc():void
		{
			try{
				new LocalConnection().connect('saiman');
				new LocalConnection().connect('saiman');
			}catch(e:Error){}
		}
		
		
	}
}