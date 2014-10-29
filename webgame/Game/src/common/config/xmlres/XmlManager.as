package common.config.xmlres
{
	import flash.utils.getTimer;
	
	public class XmlManager
	{
		
		/**
		 * 
		 */ 
		private static var _instance:XmlManager; 
		
		
		public static function get instance():XmlManager
		{
			if(!_instance)
			{
				_instance = new XmlManager();
			}
			
			return _instance;
		}
		
		/**
		 * localres/数据库导出资源
		 */
		private static var _localRes:LocalResXml;
				
		public static function get localres():LocalResXml
		{
			if(null == _localRes)
			{
				_localRes = new LocalResXml();
			}
			
			return _localRes;
		}
		
		
		
		
		
	}
}