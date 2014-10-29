package world.cache.res
{
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import flash.utils.Dictionary;
	
	import world.FileManager;
	import world.cache.res.loader.ResLoader;

	/**
	 * @author  WangHuaRen
	 * @version 2012-1-7-下午04:48:13
	 */
	public final class ResImageCache
	{
		private static var _instance:ResImageCache=null;

		public static function get instance():ResImageCache
		{
			if (_instance == null)
			{
				_instance=new ResImageCache();
			}
			return _instance;
		}
		private var _itemVector:Vector.<ResLoader>=null;

		public final function ResImageCache()
		{
			_itemVector=new Vector.<ResLoader>();
		}

		public function getResLoader(packageID:int, resID:int,index:int,resData:Pub_ToolsResModel,resNum:int):ResLoader
		{
			var resultLoader:ResLoader=findItem(resID);
			if (resultLoader == null)
			{
				
				resultLoader=ResLoader.createResLoader()
				if(resultLoader)
				{
					resultLoader.reset(packageID, resID, FileManager.instance.getDropIconSById(resData.tool_dropicon),index,resData,resNum);
				}else{
					resultLoader=new ResLoader(packageID, resID, FileManager.instance.getDropIconSById(resData.tool_dropicon),index,resData,resNum);
				}
				_itemVector.push(resultLoader);
			}
			resultLoader.isuse=true;
			return resultLoader;
		}

		private function findItem(itemID:int):ResLoader
		{
			var len:int=_itemVector.length;
			while (--len > -1)
			{
				if (!_itemVector[len].isuse && _itemVector[len].itemID == itemID)
				{
					return _itemVector[len];
				}
				else if (_itemVector[len].itemID == 0)
				{
					_itemVector.splice(len, 1);
					len--;
				}
			}
			return null;
		}
	}
}