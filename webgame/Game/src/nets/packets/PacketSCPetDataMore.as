package nets.packets
{
	import engine.net.packet.PacketFactory;
	import engine.support.IPacket;
	import engine.support.ISerializable;
	
	import flash.utils.ByteArray;
	
	
	/** 
	 *玩家状态更新
	 * 
	 */
	public class PacketSCPetDataMore implements IPacket
	{
		
		public static const PetAttr_Name_Life_Ralent:int = 0;     //生命资质
		public static const PetAttr_Name_Atk_Ralent:int = 1;      //外功资质
		public static const PetAttr_Name_Matk_Ralent:int = 2;     //内功资质
		public static const PetAttr_Name_Def_Ralent:int = 3;      //防御资质
		public static const PetAttr_Name_Quality:int = 4;         //品质
		public static const PetAttr_Name_Star:int = 5;            //星级
		public static const PetAttr_Name_Point:int = 6;           //剩余潜力点
		public static const PetAttr_Name_UnSeel_Atk:int = 7;      //已经解封外功
		public static const PetAttr_Name_UnSeel_Matk:int = 8;     //已经解封内功
		public static const PetAttr_Name_UnSeel_Def:int = 9;      //已经解封外功防御
		public static const PetAttr_Name_UnSeel_Mdef:int = 10;    //已经解封内功防御
		public static const PetAttr_Name_UnSeel_Life:int = 11;    //已经解封生命
		public static const PetAttr_Name_Add_Str:int = 12;        //附加力量
		public static const PetAttr_Name_Add_Dex:int = 13;        //附加敏捷
		public static const PetAttr_Name_Add_Sta:int = 14;        //附加体质
		public static const PetAttr_Name_Add_Int:int = 15;        //附加智力
		public static const PetAttr_Name_Add_Wis:int = 16;        //附加精神
		public static const PetAttr_Name_Last_Add:int = 17;       //剩余解封次数
		public static const PetAttr_Name_Last_Add_UNSEAL:int = 18;//剩余增加解封次数
		
		
		/**
		 *id
		 */
		public static const id:int = 1804;
		/**
		 *
		 */
		public var flags:int;
		
		public var flags1:int;
		
		public var flags2:int;
		
		public var objid:int;
		
		public var cur_pos:int;
		
		public var attr:Vector.<int> = new Vector.<int>;		
		
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
			
			var i:int = 0;
			
			for(i = 0;i < 32;++i)
			{
				if (flags & (1<<i)) {
					attr[i] = ar.readInt();
				}
				else{
					attr[i] = -1;
				}			
			}
			
			for(i = 0;i < 32;++i)
			{
				if (flags1 & (1<<i)) {
					attr[i+32] = ar.readInt();
				}
				else{
					attr[i+32] = -1;
				}			
			}
			
			for(i = 0;i < 32;++i)
			{
				if (flags2 & (1<<i)) {
					attr[i+64] = ar.readInt();
				}
				else{
					attr[i+64] = -1;
				}			
			}
			
			
		}
	}
}
