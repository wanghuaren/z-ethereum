package world.cache.res
{
	/**
	 * 缓存池
	 * @author BellaXu
	 */
	public class ResItemPool
	{
		private static var _vec:Vector.<ResItem>=new Vector.<ResItem>();
		
		public static function pop():ResItem
		{
			var len:int;
			if(_vec.length < 1)
			{
				len = 100;
				while(len-- > 0)
					_vec.push(new ResItem());
			}
			return _vec.pop();
		}
	}
}