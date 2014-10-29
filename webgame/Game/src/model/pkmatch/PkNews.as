package model.pkmatch
{
	
	public class PkNews
	{
		/** 
		 *玩家id
		 */
		public var userid:int;
		/** 
		 *玩家名称
		 */
		public var username:String = new String();
		/** 
		 *对手玩家id
		 */
		public var oppid:int;
		/** 
		 *对手玩家名称
		 */
		public var oppname:String = new String();
		/** 
		 *获得金币
		 */
		public var coin:int;
		/** 
		 *获得声望
		 */
		public var renown:int;
		/** 
		 *消息id
		 */
		public var msg_id:int;
		/** 
		 *连胜次数
		 */
		public var win:int;
		
		public function PkNews()
		{
		}
	}
}