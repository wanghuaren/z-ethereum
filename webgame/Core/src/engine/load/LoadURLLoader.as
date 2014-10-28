package engine.load
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LoadURLLoader extends URLLoader
	{
		public var url:String
		public function LoadURLLoader(request:URLRequest=null)
		{
			super(request);
		}
	}
}