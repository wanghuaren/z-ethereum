package nets.packets
{
	import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
	/** 
	 *玩家数据更新
	 */
	public class PacketSCPlayerData implements IPacket
	{
		/**
		 *id
		 */
		public static const id:int = 1999;

		/**
		 * 标志位
		 */
		public var flags:int;

		/**
		 * 标志位
		 */
		public var flags1:int;

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
		 * 经验
		 */
		public var exp:Number;				
		/**
		 * 第1位:可否移动 2:Can Action flag1 3:Can Action flag2 
		 */
		public var  State:int;
		/**
		 *攻击速度
		 */
		public var  AtkSpeed:int;//
		/**
		 *攻击
		 */
		public var  Atk:int;
		/**
		 *防御
		 */
		public var  Def:int;
		/**
		 *魔法攻击
		 */
		public var  MAtk:int;
		/**
		 *魔法防御
		 */
		public var  MDef:int;
		/**
		 *攻击
		 */
		public var  AtkMax:int;
		/**
		 *防御
		 */
		public var  DefMax:int;
		/**
		 *魔法攻击
		 */
		public var  MAtkMax:int;
		/**
		 *魔法防御
		 */
		public var  MDefMax:int;
		/**
		 *命中
		 */
		public var  Hit:int;
		/**
		 *闪避
		 */
		public var  Miss:int;
		/**
		 *暴击
		 */
		public var  Cri:int;
		/**
		 *防暴
		 */
		public var  ACri:int;
		/**
		 *命中率
		 */
		public var  HitRate:int;
		/**
		 *闪避率
		 */
		public var  MissRate:int;
		/**
		 *暴击率
		 */
		public var  CriRate:int;
		/**
		 *防暴率
		 */
		public var  ACriRate:int;
		/**
		 *暴击伤害
		 */
		public var  CHAtk:int;

		/**
		 *当前活力值
		 */
		public var  Vim:int; 
		/**
		 *最大活力值
		 */
		public var  MaxVim:int; 
		/**
		 *当前魂值
		 */
		public var  Soul:int; 
		/**
		 *最大魂值
		 */
		public var  MaxSoul:int; 
		/**
		 *战斗状态
		 */
		public var  InCombat:int; 
		/**
		 * 等级
		 */
		public var level:int;
		/**
		 *幸运
		 */
		public var  lucky:int;
		/**
		 *诅咒
		*/
		public var curse:int;
		/**
		 *PK值
		*/
		public var pkvalue:int;
		/**
		 *寻宝积分
		*/
		public var discoveryGrade:int;
		/**
		 *道术攻击
		*/
		public var sAtk:int;
		/**
		 *道术最大攻击
		*/
		public var sAtkMax:int;

		public function GetId():int{return id;}
		public function Serialize(ar:ByteArray):void
		{			
			
		}
		public function Deserialize(ar:ByteArray):void
		{
			objid = ar.readInt();
			flags = ar.readInt();
			flags1 = ar.readInt();
			
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
				exp = ar.readDouble();
			}
			else{
				exp = -1;
			}

			if (flags & (1<<6)) {
				State = ar.readInt();
			}
			else{
				State = -1;
			}

			if (flags & (1<<7)) {
				AtkSpeed = ar.readInt();
			}
			else{
				AtkSpeed = -1;
			}

			if (flags & (1<<8)) {
				Atk = ar.readInt();
			}
			else{
				Atk = -1;
			}

			if (flags & (1<<9)) {
				Def = ar.readInt();
			}
			else{
				Def = -1;
			}

			if (flags & (1<<10)) {
				MAtk = ar.readInt();
			}
			else{
				MAtk = -1;
			}

			if (flags & (1<<11)) {
				MDef = ar.readInt();
			}
			else{
				MDef = -1;
			}

			if (flags & (1<<12)) {
				AtkMax = ar.readInt();
			}
			else{
				AtkMax = -1;
			}

			if (flags & (1<<13)) {
				DefMax = ar.readInt();
			}
			else{
				DefMax = -1;
			}

			if (flags & (1<<14)) {
				MAtkMax = ar.readInt();
			}
			else{
				MAtkMax = -1;
			}

			if (flags & (1<<15)) {
				MDefMax = ar.readInt();
			}
			else{
				MDefMax = -1;
			}
			
			if (flags & (1<<16)) {
				Hit = ar.readInt();
			}
			else{
				Hit = -1;
			}

			if (flags & (1<<17)) {
				Miss = ar.readInt();
			}
			else{
				Miss = -1;
			}

			if (flags & (1<<18)) {
				Cri = ar.readInt();
			}
			else{
				Cri = -1;
			}

			if (flags & (1<<19)) {
				ACri = ar.readInt();
			}
			else{
				ACri = -1;
			}

			if (flags & (1<<20)) {
				HitRate = ar.readInt();
			}
			else{
				HitRate = -1;
			}

			if (flags & (1<<21)) {
				MissRate = ar.readInt();
			}
			else{
				MissRate = -1;
			}

			if (flags & (1<<22)) {
				CriRate = ar.readInt();
			}
			else{
				CriRate = -1;
			}

			if (flags & (1<<23)) {
				ACriRate = ar.readInt();
			}
			else{
				ACriRate = -1;
			}
			if (flags & (1<<24)) {
				CHAtk = ar.readInt();
			}
			else{
				CHAtk = -1;
			}
			if (flags & (1<<25)) {
				Vim = ar.readInt();
			}
			else{
				Vim = -1;
			}
			if (flags & (1<<26)) {
				MaxVim = ar.readInt();
			}
			else{
				MaxVim = -1;
			}
			if (flags & (1<<27)) {
				Soul = ar.readInt();
			}
			else{
				Soul = -1;
			}
			if (flags & (1<<28)) {
				MaxSoul = ar.readInt();
			}
			else{
				MaxSoul = -1;
			}
			if (flags & (1<<29)) {
				InCombat = ar.readInt();
			}
			else{
				InCombat = -1;
			}
			if (flags & (1<<30)) {
				level = ar.readInt();
			}
			else{
				level = -1;
			}

			if (flags & (1<<31)) {
				lucky = ar.readInt();
			}
			else{
			    lucky = -1;
			}

			if (flags1 & (1<<32-32)) {
				curse = ar.readInt();
			}
			else{
			    curse = -1;
			}

			if (flags1 & (1<<33-32)) {
				pkvalue = ar.readInt();
			}
			else{
			    pkvalue = -1;
			}
			if (flags1 & (1<<34-32)) {
				discoveryGrade = ar.readInt();
			}
			else{
			    discoveryGrade = -1;
			}
			if (flags1 & (1<<35-32)) {
				sAtk = ar.readInt();
			}
			else{
			    sAtk = -1;
			}
			if (flags1 & (1<<36-32)) {
				sAtkMax = ar.readInt();
			}
			else{
			    sAtkMax = -1;
			}
		}
	}
}
