package com.engine.utils
{
	import com.engine.core.Core;
	import com.engine.utils.Hash;
	
	import flash.utils.getQualifiedClassName;

	/**
	 * @author saiman
	 * 2012-7-20  下午2:53:12
	 **/
	public class Track
	{
		
		public static function track(...arg):void
		{
			if(Core.track!=null)
			{
				Core.track.apply(null,arg)
			}else {
				trace(arg)
			}
		}
		
	}
}