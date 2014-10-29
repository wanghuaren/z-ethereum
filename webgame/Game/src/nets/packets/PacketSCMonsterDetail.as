package nets.packets
{
	import flash.utils.ByteArray;
	import engine.support.IPacket;
	import engine.support.ISerializable;
	import engine.net.packet.PacketFactory;
	/** 
	 *玩家状态更新
	 */
	public class PacketSCMonsterDetail implements IPacket
	{
		/**
		 *id
		 */
		public static const id:int = 1998;
		
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
		 * 角色名
		 */
		public var name:String = new String();
		/**
		 * 形象0
		 */
		public var outlook:int;
		/**
		 * 阵营
		 */
		public var campid:int;
		/**
		 * 是否NPC
		 */
		public var isnpc:int;
		/**
		 * 所属玩家名字
		*/
		public var PlayerName:String = new String();
		/**
		 *地图区域类型,1打怪区，只允许攻击敌对NPC	2阵营区，允许攻击敌对阵营 3安全区，不允许任何形势的攻击
		 */
		public var  MapZoneType:int 
		/**
		 *攻击速度
		 */
		public var  AtkSpeed:int;//


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
				var king_nameLength:int = ar.readInt();
				name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				name = null;
			}
			
			if (flags & (1<<2)) {
				outlook = ar.readInt();
			}		
			else{
				outlook = -1;
			}	
			
			if (flags & (1<<3)) {
				campid = ar.readInt();
			}
			else{
				campid = -1;
			}

			if (flags & (1<<4)) {
				isnpc = ar.readInt();
			}			
			else{
				isnpc = -1;
			}
			
			if (flags & (1<<5)) {
				var PlayerNameLength:int = ar.readInt();
				PlayerName = ar.readMultiByte(PlayerNameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
				PlayerName = null;
			}

			if(flags &(1<<6)){
				MapZoneType=ar.readInt();
			}
			else{
				MapZoneType=-1;
			}

			if (flags & (1<<7)) {
				AtkSpeed = ar.readInt();
			}
			else{
				AtkSpeed = -1;
			}
		}
	}
}
