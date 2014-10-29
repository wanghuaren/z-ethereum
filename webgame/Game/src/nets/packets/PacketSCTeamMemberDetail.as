package nets.packets
{
	import engine.support.IPacket;
	
	import flash.utils.ByteArray;

	/** 
	 *队伍成员状态更新
	 */
	public class PacketSCTeamMemberDetail implements IPacket
	{
		/**
		 *id
		 */
		public static const id:int = 1996;
		
		/**
		 * 标志位
		 */
		public var flags:int;
		/**
		 * 编号
		 */
		public var objid:int;
		/**
		 * 等级
		 */
		public var level:int;	
		/**
		 * 当前HP
		 */
		public var hp:int;
		/**
		 * 最大HP
		 */
		public var maxhp:int;
		/**
		 * 当前MP
		 */
		public var mp:int;
		/**
		 * 最大MP
		 */
		public var maxmp:int;
		/**
		 * 地图id
		 */
		public var mapid:int;
		/**
		 * posx
		 */
		public var posx:int;
		/**
		 * posy
		 */
		public var posy:int;

		
		public function GetId():int{return id;}

		public function Serialize(ar:ByteArray):void
		{			

		}
		public function Deserialize(ar:ByteArray):void
		{
			objid = ar.readInt();
			flags = ar.readInt();
			
			if (flags & (1<<0)) {
				level = ar.readInt();
			}
			else{
			    level = -1;
			}
						
			if (flags & (1<<1)) {
				hp = ar.readInt();
			}
			else{
			    hp = -1;
			}
			
			if (flags & (1<<2)) {
				maxhp = ar.readInt();
			}
			else{
			    maxhp = -1;
			}
			
			if (flags & (1<<3)) {
				mp = ar.readInt();
			}
			else{
			    mp = -1;
			}
			
			if (flags & (1<<4)) {
				maxmp = ar.readInt();
			}
			else{
			    maxmp = -1;
			}

			if (flags & (1<<5)) {
				mapid = ar.readInt();
			}
			else{
			    mapid = -1;
			}

			if (flags & (1<<6)) {
				posx = ar.readInt();
			}
			else{
			    posx = -1;
			}

			if (flags & (1<<7)) {
				posy = ar.readInt();
			}
			else{
			    posy = -1;
			}
		}
	}
}
