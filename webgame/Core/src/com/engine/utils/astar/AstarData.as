
package com.engine.utils.astar
{
	import com.engine.core.tile.Pt;
	/**
	 * a星寻路基本单位
	 * code saiman 
	 */
	public class AstarData
	{
		public var key:String
		public var pt:Pt
		public var G:int=0;
		public var F:int=0;
		public var parent:AstarData
		public function AstarData(g:int,f:int,pt:Pt)
		{
		
			this.G=g;
			this.F=f
			if(pt)this.key=pt.key
			this.pt=pt
		}
		
		
		

	}
}