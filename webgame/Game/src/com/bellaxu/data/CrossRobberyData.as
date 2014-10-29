package com.bellaxu.data
{
	import com.bellaxu.def.AttrDef;
	import com.bellaxu.def.GameDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.model.lib.Pub_Demon_WorldResModel;
	import com.bellaxu.model.lib.ext.IS;
	
	import common.config.Att;
	
	import netc.Data;

	/**
	 * 渡劫数据
	 * @author BellaXu
	 */
	public class CrossRobberyData extends DataBase
	{
		private static var _instance:CrossRobberyData;
		
		public function CrossRobberyData()
		{
			super();
		}
		
		public static function getInstance():CrossRobberyData
		{
			if(!_instance)
				_instance = new CrossRobberyData();
			return _instance;
		}
		
		override protected function init():void
		{
			
		}
		
		/**
		 * 劫数
		 */
		public function get numState():uint
		{
			return Lib.getDifNum(LibDef.PUB_DEMON_WORLD, AttrDef.step);
		}
		
		/**
		 *  阶数
		 */
		public function getNumFloorById(sid:uint):uint
		{
			var vec:Vector.<Pub_Demon_WorldResModel> = Lib.getVec(LibDef.PUB_DEMON_WORLD, [AttrDef.step, IS, sid]);
			return vec.length;
		}
		
		/**
		 * 根据state和floor查找对应的配置
		 */
		public function getItemByStateAndFloor(s:uint, f:uint):Pub_Demon_WorldResModel
		{
			var vec:Vector.<Pub_Demon_WorldResModel> = Lib.getVec(LibDef.PUB_DEMON_WORLD, [AttrDef.step, IS, s], [AttrDef.floor, IS, f]);
			if(vec && vec.length)
				return vec[0];
			return null;
		}
		
		public function getFloorAdd(str:String, isTotal:Boolean = false):Array
		{
			var result:Array = [];
			var ary:Array = str.split(",");
			var ary2:Array = null;
			var i:int;
			for each(var s:String in ary)
			{
				ary2 = s.split("#");
				if(ary2.length > 2)
				{
					var star:int = ary2[0];
					var attr:int = ary2[1];
					var attrAdd:int = ary2[2];
					var name:String = Att.getAttName2(attr);
					
					if(GameDef.ATTACK_ARY.indexOf(name) > -1 && name != GameDef.ATTACK_ARY[Data.myKing.metier])
						continue;
					if(!result[star])
						result[star] = [];
					
					for(i = 0;i < result[star].length;i++)
					{
						if(result[star][i][0] == name)
						{
							if(result[star][i][1] < attrAdd)
								result[star][i] = [name, result[star][i][1], attrAdd];
							else
								result[star][i] = [name, attrAdd, result[star][i][1]];
							break;
						}
					}
					if(i >= result[star].length)
						result[star].push([name, attrAdd]);
				}
			}
			if(isTotal)
				return result;
			for each(ary in result[4])
			{
				if(ary.length == 2)
				{
					for each(ary2 in result[3])
					{
						if(ary2[0] == ary[0])
						{
							ary[1] = ary[1] - ary2[1];
							break;
						}
					}
				}
				if(ary.length == 3)
				{
					for each(ary2 in result[3])
					{
						if(ary2[0] == ary[0])
						{
							ary[1] = ary[1] - ary2[1];
							ary[2] = ary[2] - ary2[2];
							break;
						}
					}
				}
			}
			for each(ary in result[5])
			{
				if(ary.length == 2)
				{
					for each(ary2 in result[4])
					{
						if(ary2[0] == ary[0])
						{
							ary[1] = ary[1] - ary2[1];
							break;
						}
					}
					for each(ary2 in result[3])
					{
						if(ary2[0] == ary[0])
						{
							ary[1] = ary[1] - ary2[1];
							break;
						}
					}
				}
				if(ary.length == 3)
				{
					for each(ary2 in result[4])
					{
						if(ary2[0] == ary[0])
						{
							ary[1] = ary[1] - ary2[1];
							ary[2] = ary[2] - ary2[2];
							break;
						}
					}
					for each(ary2 in result[3])
					{
						if(ary2[0] == ary[0])
						{
							ary[1] = ary[1] - ary2[1];
							ary[2] = ary[2] - ary2[2];
							break;
						}
					}
				}
			}
			return result;
		}
	}
}