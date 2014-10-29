package com.bellaxu.data
{
	import com.bellaxu.def.AttrDef;
	import com.bellaxu.def.EquipTypeDef;
	import com.bellaxu.def.GameDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.model.lib.Pub_SitzupResModel;
	import com.bellaxu.model.lib.Pub_Sitzup_UpResModel;
	import com.bellaxu.model.lib.Pub_Tool_AttrResModel;
	import com.bellaxu.model.lib.ext.IS;
	import com.bellaxu.view.role.ZuoQiMain;
	
	import common.config.Att;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;

	/**
	 * 坐骑数据
	 * @author BellaXu
	 */
	public class HorseData extends DataBase
	{
		private static var _instance:HorseData;
		
		public function HorseData()
		{
			super();
		}
		
		public static function getInstance():HorseData
		{
			if(!_instance)
				_instance = new HorseData();
			return _instance;
		}
		
		public function getEquipNameByPos(pos:int):String
		{
			switch(pos)
			{
				case 1:
					return "鞍具";
				case 2:
					return "蹬具";
				case 3:
					return "缰绳";
				case 4:
					return "蹄铁";
				default:
					return "未知";
			}
		}
		
		public function getHorseData(horseId:uint, slv:uint):Pub_Sitzup_UpResModel
		{
			var vec:Vector.<Pub_Sitzup_UpResModel> = Lib.getVec(LibDef.PUB_SITZUP_UP, [AttrDef.item_id, IS, horseId], [AttrDef.strong_lv, IS, slv]);
			if(vec && vec.length)
				return vec[0];
			return null;
		}
		
		public function getAttackAdd(data:Pub_Sitzup_UpResModel):uint
		{
			var metier:uint = Data.myKing.metier;
			var neededFunc:uint = 0;
			if(metier == GameDef.METIER_1)
			{//战士
				neededFunc = Att.HURT_WAI_GONG_2;
			}
			else
			{//法师 or道士
				neededFunc = Att.HURT_NEI_GONG_2;
			}
			var i:int = 0;
			var data2:Pub_Tool_AttrResModel = Att.getAttModel(neededFunc);
			if(!data2)
				return 0;
			//先找最大
			for(i = 1;i < ZuoQiMain.FV_NUM;i++)
			{
				if(data['func' + i] == data2.max_attr)
					return data['value' + i];
			}
			//最大没有就找最小
			for(i = 1;i < ZuoQiMain.FV_NUM;i++)
			{
				if(data['func' + i] == data2.min_attr)
					return data['value' + i];
			}
			return 0;
		}
		
		public function getEquipsByPos(pos:int):Array
		{
			var type:uint;
			if(pos == 1)
				type = EquipTypeDef.HORSE_EQUIP_1;
			else if(pos == 2)
				type = EquipTypeDef.HORSE_EQUIP_2;
			else if(pos == 3)
				type = EquipTypeDef.HORSE_EQUIP_3;
			else if(pos == 4)
				type = EquipTypeDef.HORSE_EQUIP_4;
			else
				return [];
			return Data.beiBao.getBeiBaoByEquipType(type);
		}
		
		public function getSkillSlotOpenLvl(horseid:int, pos:int):int
		{
			var vec:Vector.<Pub_Sitzup_UpResModel> = Lib.getVec(LibDef.PUB_SITZUP_UP, [AttrDef.item_id, IS, horseid], [AttrDef.max_skill_slot, IS, pos]);
			if(vec.length)
				return	vec[0].strong_lv;
			return -1;
		}
	}
}