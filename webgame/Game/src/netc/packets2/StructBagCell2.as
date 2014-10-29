/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *
 */
package netc.packets2
{
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.utils.bit.BitUtil;
	import nets.packets.StructBagCell;

	/**
	 *角色列表
	 */
	public class StructBagCell2 extends StructBagCell
	{
		public var config:Pub_ToolsResModel=null
		public var icon:String="";
		public var iconBig:String="";
		public var iconBigBig:String="";
		public var tool_icon:int=0;
		public var level:int=0;
		public var itemname:String="";
		public var desc:String="";
		//金币价格
		public var buyprice1:int=0;
		//元宝价格
		public var buyprice3:int=0;
		//是否转圈
		public var effect:int=0;
		//数据是否填充
		public var hasDataFilled:Boolean=false;
		/**
		 * 允许购买货币类型 1.元宝2.礼金3.银两 2014-01-01
		 */
		public var moneyType:int=0;
		public var sellprice:int=0;
		public var isused:int=0;
		/**
		 *	是否绑定模板数据【请不要再外部调用】
		 */
		private var _isBind:int=0;

		public function set isBind(v:int):void
		{
			_isBind=v;
		}
		/**
		 *	是否绑定【外部调用】
		 */
		private var _isTrade:Boolean=false;

		public function get isTrade():Boolean
		{
			if (pos > 0)
			{
				return BitUtil.getBitByPos(ruler, 1) == 1 ? false : true;
			}
			else
			{
				return _isBind == 1 ? false : true;
			}
		}
		//public var dbsort:int=0;
		public var _dbsort:int=0;

		public function set dbsort(v:int):void
		{
			_dbsort=v;
		}

		public function get dbsort():int
		{
			return _dbsort;
		}
		public var sex:int=0;
		public var sort:int=0;
		public var sortName:String="";
		public var cooldown_id:int;
		public var metier:int=0;
		//2013-09-26 物品品质=(道具模板品质+colorLvl)
		private var _toolColor:int=0;

		public function set toolColor(v:int):void
		{
			_toolColor=v;
		}

		public function get toolColor():int
		{
			return _toolColor + colorLvl;
		}
		public var isSale:Boolean=true;
		public var useMaxTimes:int=0;
		public var para_int:int=0;
		public var para_str:String="";
		//2013-06-08 装备操作限制
		public var equip_limit:int=0;
		//2013-07-30 道具菜单限制
		public var menu_limit:int=0;
		//2013-07-31 寻路id
		public var seek_id:int=0;
		//2014-05-19 天劫等级
		public var soar_lv:int=0;
		//如果是可叠加物品，表示最近一次增加的数量
		public var addCount:int=0;
		//该字段 若是装备则是基本属性战力值
		public var gradeValue:int=0;
		//装备
		public var equip_type:int=0;
		public var equip_typeName:String="";
		public var equip_jobName:String="";
		public var equip_usedCount:int=0;
		public var equip_usedCountMax:int=0;

		public function set equip_strongLevel(v:int):void
		{
			super.para=v;
		}

		public function get equip_strongLevel():int
		{
			return super.para;
		}
		public var equip_att1:Vector.<StructItemAttr2>;
		//2012-11-15 装备最大强化等级
		public var equip_strongLevelMax:int=0;
		//2012-12-11 魔纹孔数 2013-10-14 神武后额外增加一个孔
		private var _equip_hole:int=0;

		public function set equip_hole(v:int):void
		{
			_equip_hole=v;
		}

		public function get equip_hole():int
		{
			return _equip_hole + colorLvl;
		}
		public var strongId:int=0;
		public var holeIndex:int=0;
		public var sort_para1:int=0;
		//合成后ID
		public var resultId:int=0;
		//帮派贡献
		public var contribute:int=0;
		//帮派贡献商店
		public var need_contribute:int=0;
		//活动
		public var huodong_pos:int=0;
		//套装
		public var suit_id:int=0;
		/**
		 * 装备存放位置类型
		 *  0.包裹 1.伙伴身上 2.npc商店 3.任务奖励4.自定义装备【排行榜,装备升级后】5.摆摊中6.玩家
		 */
		public var equip_source:int=0;
		//叠加上限
		public var plie_num:int=0;
		//兑换商店
		public var need_id:int=0;
		public var need_num:int=0;
		public var need_coin1:int=0;
		public var need_coin3:int=0;
		public var odd:int=0;
		public var need_name:String="";
		public var need_color:int=0;
		//升级后装备战力值未知，增加“+”
		public var addJia:String="";
		//2013-02-25 摊位售价
		public var booth_price:int=0;
		//2013-02-25 是否上架
		public var lock:Boolean=false;
		//2013-03-04 是否批量使用
		public var isBatch:Boolean=false;
		//2013-09-11 是否自动提示使用
		public var is_autouse:int=0;

		//2013-10-24 宝石等级
		public function get stoneLevel():int
		{
			return int(itemid.toString().substr(7, 1));
		}
	}
}
