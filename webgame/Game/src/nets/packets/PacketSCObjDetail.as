package nets.packets
{
	import engine.support.IPacket;
	
	import flash.utils.ByteArray;

	/** 
	 *玩家状态更新
	 */
	public class PacketSCObjDetail implements IPacket
	{
		/**
		 *id
		 */
		public static const id:int = 1803;
		
		/**
		 * 标志位
		 */
		public var flags:int;
		/**
		 * 编号
		 */
		public var objid:int;
		/**
		 * 移动速度
		 */
		public var movspeed:int;
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
		 * 技能特效
		 */
		public var buffeffect:int;


		public function GetId():int{return id;}
		public function Serialize(ar:ByteArray):void
		{			
			
		}
		public function Deserialize(ar:ByteArray):void
		{
			objid = ar.readInt();
			flags = ar.readInt();			
			
			if (flags & (1<<0)) {
				movspeed = ar.readInt();
			}
			else{
				movspeed = -1;
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
				buffeffect = ar.readInt();
			}			
			else{
				buffeffect = -1;
			}			
		}
	}
}
