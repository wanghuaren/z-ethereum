/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量 
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *  
 */ 
package netc.packets2
{
	import engine.net.packet.PacketFactory;
	import engine.support.IPacket;
	import engine.support.ISerializable;
	
	import flash.utils.ByteArray;
	
	import netc.Data;
	
	import nets.packets.PacketWCPlayerLookInfo;

	/** 
	 *
	 */
	public class PacketWCPlayerLookInfo2 extends PacketWCPlayerLookInfo
	{
		public var arrEquip:Array=[];
		public var arrEquipPet:Array=[];
		public var arrJingJie:Array=[];
		/**
		 *	转化服务端类型 
		 */
		public function changeData():void{
			var bag:StructBagCell2
			for each(var equip:StructRankEquipInfo2 in super.arrItemequipInfo){
				bag=new StructBagCell2();
				bag.itemid=equip.equip.itemid;
				Data.beiBao.fillCahceData(bag);
				bag.pos=equip.pos;
				bag.equip_source=6;
				Data.beiBao.fillServerData(bag,equip.equip);
				bag.equip_fightValue=equip.equip.fightValue;
				arrEquip.push(bag);
			}
//			for each(equip in super.arrItempet_equipInfo){
//				bag=new StructBagCell2();
//				bag.itemid=equip.equip.itemid;
//				Data.beiBao.fillCahceData(bag);
//				bag.pos=equip.pos;
//				bag.arrItemattrs=equip.equip.arrItemequipAttrs;
//				bag.equip_strongLevel=equip.equip.strongLevel;
//				bag.equip_usedCount=equip.equip.curDurPoint;
//				bag.equip_fightValue=equip.equip.fightValue;
//				bag.arrItemevilGrains=equip.equip.arrItemevilGrains;
//				bag.equip_type=4;
//				bag.strong_perfectflag=equip.equip.strongPerfect;
//				bag.identify=equip.equip.identify;
//				//			bag.soul_stronglevel=equip.equip.soul_strongLevel;
//				
//				arrEquipPet.push(bag);
//			}
			//境界 星界
			for each(var bourn:StructBourn2 in super.arrItembournsInfo){
				arrJingJie[bourn.pos]=bourn.level;
			}

		}
	}
}
