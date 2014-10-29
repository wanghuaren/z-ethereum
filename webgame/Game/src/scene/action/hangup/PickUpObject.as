package scene.action.hangup
{
	/**
	 * 挂机中需要捡取的物品
	 * @author steven guo
	 * 
	 */	
	public class PickUpObject
	{
		/** 
		 *掉落id
		 */
		public var objid:int;
		
		/** 
		 *掉落物品索引
		 */
		public var index:int;
		
		/**
		 * 物品ID 
		 */		
		public var itemID:int; 
		
		public var posx:int;
		public var posy:int;
		
		public var color:int;
		
		//是不是自己的？ 0表示未知，1表示是自己的，2表示不是自己的
		public var isSelf:int = 0;
		
		
		public function PickUpObject(oid:int,idx:int,iID:int,x:int,y:int,color:int=-1,self:int = 0)
		{
			objid = oid;
			index = idx;
			itemID = iID;
			posx = x;
			posy = y;
			color = -1;
			isSelf = self;
		}
		
		
	}
}