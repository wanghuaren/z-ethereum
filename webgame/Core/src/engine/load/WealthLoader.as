package engine.load
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class WealthLoader extends URLLoader
	{
		public var proto:Object
		public function WealthLoader(request:URLRequest=null)
		{
			super(request);
		}
	}
}