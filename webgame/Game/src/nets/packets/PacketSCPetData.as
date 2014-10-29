package nets.packets
{
	import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;


	/** 
	 *玩家状态更新
	 */
	public class PacketSCPetData implements IPacket
	{

		/**
		 *id
		*/
		public static const id:int = 1995;
		/**
		 *
		*/
		public var flags:int;

		public var flags1:int;
		
		public var flags2:int;
		
		public var objid:int;

		public var cur_pos:int;


		/**
		 *
		*/
		public var name:String = new String();

		/**
		 *
		*/
		public var Hp:int;

		/**
		 *
		*/
		public var MaxHp:int;

		/**
		 *
		*/
		public var Mp:int;
		
		/**
		 *
		*/
		public var MaxMp:int;

		/**
		 *
		*/
		public var Level:int;

		/**
		 *阵营
		*/
		public var CampId:int;

		/**
		 *是否npc
		*/
		public var IsNpc:int;

		/**
		 *外观
		*/
		public var OutLook:int;
		/**
		 *移动速度
		*/
		public var MovSpeed:int;
		/**
		 *经验
		*/
		public var Exp:Number;
		/**
		 *技能状态 第1位：技能1状态 2：技能2状态 3:... 4:...
		*/
		public var SkillState:int;
		/**
		 *战力值
		*/
		public var FightValue:int;
		/**
		 *第1位:可否移动 2:Can Action flag1 3:Can Action flag2 
		*/
		public var State:int;
		/**
		 *
		*/
		public var AtkSpeed:int;
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
		 *物理破甲
		 */
		public var  Pierce:int;
		/**
		 *魔法破甲
		 */
		public var  MPierce:int;
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
		 *格挡
		 */
		public var  Block:int;
		/**
		 *破格
		 */
		public var  ABlock:int;
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
		 *格挡率
		 */
		public var  BlockRate:int;
		/**
		 *破格率
		 */
		public var  ABlockRate:int;
		/**
		 *物理破甲率
		 */
		public var  PierceRate:int;
		/**
		 *魔法破甲率
		 */
		public var  MPierceRate:int;
		/**
		 *冰攻
		 */
		public var  AtkCold:int;
		/**
		 *冰防
		 */
		public var  DefCold:int;
		/**
		 *火攻
		 */
		public var  AtkFire:int;
		/**
		 *火防
		 */
		public var  DefFire:int;
		/**
		 *电攻
		 */
		public var  AtkLight:int;
		/**
		 *电防
		 */
		public var  DefLight:int;
		/**
		 *防减速
		 */
		public var  SlowResist:int;
		/**
		 *防定身
		 */
		public var  RootResist:int;
		/**
		 *防眩晕
		 */
		public var  StunResist:int;
		/**
		 *防沉默
		 */
		public var  SilenceResist:int;
		/**
		 *防混乱
		 */
		public var  ConfusionResist:int;

		/**
		 *暴击伤害
		 */
		public var  CHAtk:int;
		/**
		 *伙伴状态
		*/
		public var PetState:int;
		/**
		 *伙伴模版id
		*/
		public var PetId:int;
		/**
		 *伙伴栏位置
		*/
		public var Pos:int;
		/**
		 *是否出战
		*/
		public var FightState:int;
		/**
		 *体质
		 */
		public var  sta:int;
		/**
		 *力量
		*/
		public var str:int;
		/**
		 *敏捷
		*/
		public var dex:int;
		/**
		 *法术
		*/
		public var intAttr:int;
		/**
		 *智慧
		*/
		public var wis:int;
	

		public function GetId():int{return id;}

		public function Serialize(ar:ByteArray):void
		{			

		}
		public function Deserialize(ar:ByteArray):void
		{
			objid = ar.readInt();
			cur_pos = ar.readInt();
			flags = ar.readInt();
			flags1 = ar.readInt();
			flags2 = ar.readInt();
			
			if (flags & (1<<0)) {
				var king_nameLength:int = ar.readInt();
				name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
			}
			else{
			    name = null;
			}

			if (flags & (1<<1)) {
				PetId = ar.readInt();
			}
			else{
			    PetId = -1;
			}


			if (flags & (1<<2)) {
				Hp = ar.readInt();
			}
			else{
			    Hp = -1;
			}	

			if (flags & (1<<3)) {
				MaxHp = ar.readInt();
			}
			else{
			    MaxHp = -1;
			}

			if (flags & (1<<4)) {
				Mp = ar.readInt();
			}
			else{
			    Mp = -1;
			}

			if (flags & (1<<5)) {
				MaxMp = ar.readInt();
			}
			else{
			    MaxMp = -1;
			}

			if (flags & (1<<6)) {
				Level = ar.readInt();
			}
			else{
			    Level = -1;
			}

			if (flags & (1<<7)) {
				CampId = ar.readInt();
			}
			else{
			    CampId = -1;
			}

			if (flags & (1<<8)) {
				IsNpc = ar.readInt();
			}
			else{
			    IsNpc = -1;
			}

			if (flags & (1<<9)) {
				OutLook = ar.readInt();
			}
			else{
			    OutLook = -1;
			}

			if (flags & (1<<10)) {
				MovSpeed = ar.readInt();
			}
			else{
			    MovSpeed = -1;
			}

			if (flags & (1<<11)) {
				Exp = ar.readDouble();
			}
			else{
			    Exp = -1;
			}

			if (flags & (1<<12)) {
				SkillState = ar.readInt();
			}
			else{
			    SkillState = -1;
			}

			if (flags & (1<<13)) {
				FightValue = ar.readInt();
			}
			else{
			    FightValue = -1;
			}

			if (flags & (1<<14)) {
				State = ar.readInt();
			}
			else{
			    State = -1;
			}

			if (flags & (1<<15)) {
				AtkSpeed = ar.readInt();
			}
			else{
			    AtkSpeed = -1;
			}

			if (flags & (1<<16)) {
				Atk = ar.readInt();
			}
			else{
			    Atk = -1;
			}

			if (flags & (1<<17)) {
				Def = ar.readInt();
			}
			else{
			    Def = -1;
			}

			if (flags & (1<<18)) {
				MAtk = ar.readInt();
			}
			else{
				MAtk = -1;
			}

			if (flags & (1<<19)) {
				MDef = ar.readInt();
			}
			else{
				MDef = -1;
			}

			if (flags & (1<<20)) {
				Pierce = ar.readInt();
			}
			else{
				Pierce = -1;
			}

			if (flags & (1<<21)) {
				MPierce = ar.readInt();
			}
			else{
				MPierce = -1;
			}

			if (flags & (1<<22)) {
				PierceRate = ar.readInt();
			}
			else{
				PierceRate = -1;
			}

			if (flags & (1<<23)) {
				MPierceRate = ar.readInt();
			}
			else{
				MPierceRate = -1;
			}

			if (flags & (1<<24)) {
				Hit = ar.readInt();
			}
			else{
				Hit = -1;
			}

			if (flags & (1<<25)) {
				Miss = ar.readInt();
			}
			else{
				Miss = -1;
			}

			if (flags & (1<<26)) {
				Cri = ar.readInt();
			}
			else{
				Cri = -1;
			}

			if (flags & (1<<27)) {
				ACri = ar.readInt();
			}
			else{
				ACri = -1;
			}

			if (flags & (1<<28)) {
				Block = ar.readInt();
			}
			else{
				Block = -1;
			}

			if (flags & (1<<29)) {
				ABlock = ar.readInt();
			}
			else{
				ABlock = -1;
			}

			if (flags & (1<<30)) {
				HitRate = ar.readInt();
			}
			else{
				HitRate = -1;
			}

			if (flags & (1<<31)) {
				MissRate = ar.readInt();
			}
			else{
				MissRate = -1;
			}

			if (flags1 & (1<<0)) {
				CriRate = ar.readInt();
			}
			else{
				CriRate = -1;
			}

			if (flags1 & (1<<1)) {
				ACriRate = ar.readInt();
			}
			else{
				ACriRate = -1;
			}
			if (flags1 & (1<<2)) {
				BlockRate = ar.readInt();
			}
			else{
				BlockRate = -1;
			}

			if (flags1 & (1<<3)) {
				ABlockRate = ar.readInt();
			}
			else{
				ABlockRate = -1;
			}

			if (flags1 & (1<<4)) {
				AtkCold = ar.readInt();
			}
			else{
				AtkCold = -1;
			}

			if (flags1 & (1<<5)) {
				DefCold = ar.readInt();
			}
			else{
				DefCold = -1;
			}

			if (flags1 & (1<<6)) {
				AtkFire = ar.readInt();
			}
			else{
				AtkFire = -1;
			}
			
			if (flags1 & (1<<7)) {
				DefFire=ar.readInt();
			}
			else{
				DefFire=-1;
			}
			if (flags1 & (1<<8)) {
				AtkLight=ar.readInt();
			}
			else{
				AtkLight=-1;
			}
			if (flags1 & (1<<9)) {
				DefLight=ar.readInt();
			}
			else{
				DefLight=-1;
			}
			if (flags1 & (1<<10)) {
				SlowResist = ar.readInt();
			}
			else{
				SlowResist = -1;
			}
			if (flags1 & (1<<11)) {
				RootResist = ar.readInt();
			}
			else{
				RootResist = -1;
			}
			if (flags1 & (1<<12)) {
				StunResist = ar.readInt();
			}
			else{
				StunResist = -1;
			}
			if (flags1 & (1<<13)) {
				SilenceResist = ar.readInt();
			}
			else{
				SilenceResist = -1;
			}
			if (flags1 & (1<<14)) {
				ConfusionResist = ar.readInt();
			}
			else{
				ConfusionResist = -1;
			}
			if (flags1 & (1<<15)) {
				CHAtk = ar.readInt();
			}
			else{
				CHAtk = -1;
			}

			if (flags1 & (1<<16)) {
				PetState = ar.readInt();
			}
			else{
			    PetState = -1;
			}

			if (flags1 & (1<<17)) {
				Pos = ar.readInt();
			}
			else{
			    Pos = -1;
			}
			if (flags1 & (1<<18)) {
				FightState = ar.readInt();
			}
			else{
			    FightState = -1;
			}

			if (flags1 & (1<<19)) {
				sta = ar.readInt();
			}
			else{
			    sta = -1;
			}

			if (flags1 & (1<<20)) {
				str = ar.readInt();
			}
			else{
			    str = -1;
			}

			if (flags1 & (1<<21)) {
				dex = ar.readInt();
			}
			else{
			    dex = -1;
			}

			if (flags1 & (1<<22)) {
				intAttr = ar.readInt();
			}
			else{
			    intAttr = -1;
			}

			if (flags1 & (1<<23)) {
				wis = ar.readInt();
			}
			else{
			    wis = -1;
			}		
		}
	}
}
