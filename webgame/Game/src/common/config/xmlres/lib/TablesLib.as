package common.config.xmlres.lib
{
	import common.config.XmlConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	
	import flash.utils.Dictionary;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;

	public class TablesLib
	{
		protected var _contentMap:Dictionary;
		private const MOD_NAME:String="Xml_lib";
		private const PACKET_NAME:String="db.";
		//所有表的对像池
		private var dicTableData:Dictionary=new Dictionary();
		//表名
		private var tableName:String;
		private static var _instance:TablesLib;

		public static function get instance():TablesLib
		{
			if (_instance == null)
			{
				_instance=new TablesLib();
			}
			return _instance;
		}

		public function TablesLib()
		{
//			DBClass;
		}

		public function initXML(value:String):void
		{
			tableName=value;
			if (dicTableData[tableName] == null&&XmlConfig.xmlLibLoader.contentLoaderInfo.applicationDomain)
			{
				var m_class:Class=XmlConfig.xmlLibLoader.contentLoaderInfo.applicationDomain.getDefinition(PACKET_NAME + tableName + MOD_NAME) as Class;
//				var m_class:Class=ApplicationDomain.currentDomain.getDefinition(PACKET_NAME + tableName + MOD_NAME) as Class;
				dicTableData[tableName]=new m_class();
			}
		}

		public function get xmlLength():int
		{
			return dicTableData[tableName].contentXml.length;
		}

		public function get contentData():IXMLLib
		{
			return dicTableData[tableName];
		}

		public function getResPath(id:*):IResModel
		{
			return contentData.contentXml[id + ""];
		}
		//元宝道具id大图标
		public static const YUAN_BAO_TOOL_ID:int=11600005;
		//银两道具id
		public static const YIN_LIANG_TOOL_ID:int=11600006;

		public function getResPath2(id:int, field1:*=-1, field2:*=null):Object
		{
			return TablesExt.instance.getResPath2(tableName, [id, field1, field2], contentData);
		}

		public function getResPath3(id:int=0, field:*=null):Object
		{
			return TablesExt.instance.getResPath3(tableName, [id, field], contentData);
		}

		//=======================
		public function getResPath4(shop_id:int, tool_id:int=1):Object
		{
			return TablesExt.instance.getResPath4(tableName, [shop_id, tool_id], contentData);
		}
//阵营数量
		private var _count:int=-1;

		public function getCount():int
		{
			if (-1 != _count)
			{
				return _count;
			}
			return contentData.contentXml.length;
		}

		public function getIdListBySort(sort:int):Array
		{
			var modelList:Array=[];
			for each (var resid:IResModel in contentData.contentXml)
			{
				if (sort == resid["sort"])
				{
					modelList.push(resid as Pub_AchievementResModel);
				}
			}
			return modelList;
		}

		public function getzhanpaoByGroup(action:int):Array
		{
			var idList:Array=[];
			//			var list:XMLList=contentXml.C_Pub_Action_Desc;
			for each (var resid:IResModel in contentData.contentXml)
			{
				if (action == resid["para_int"])
				{
					idList.push(resid["make_id"]);
				}
			}
			return idList;
		}

		public function getIdListByGroup(action_group:int):Array
		{
			var idList:Array=[];
			for each (var resid:IResModel in contentData.contentXml)
			{
				if (action_group == resid["action_group"])
				{
					idList.push(resid["action_id"]);
				}
			}
			return idList;
		}

		public function getM(level:int, metier:int):Pub_Role_PropertyResModel
		{
			var resModel:Pub_Role_PropertyResModel;
			for each (var resid:IResModel in contentData.contentXml)
			{
				if (resid["level"] == level && resid["metier"] == metier)
				{
					resModel=this.getResPath(resid["id"]) as Pub_Role_PropertyResModel;
				}
			}
			return resModel;
		}
		/**
		 * 某一天的活动详情数据表
		 * */
		private static var ACT_DES_LIST:Array=[];

		/**
		 * 取得活动列表
		 * */
		public function getActionList():Vector.<Pub_Action_DescResModel>
		{
			var m_day:int=Data.date.nowDate.day;
			m_day=m_day == 0 ? 7 : m_day;
			var returnValue:Vector.<Pub_Action_DescResModel>=new Vector.<Pub_Action_DescResModel>();
			var m_action:Vector.<Pub_Action_DescResModel>=new Vector.<Pub_Action_DescResModel>();
			if (ACT_DES_LIST[m_day] == null)
			{
				for each (var resid:IResModel in contentData.contentXml)
				{
					if (resid["Date" + m_day] == 1)
					{
						m_action.push(this.getResPath(resid["action_id"]));
					}
				}
				m_action.sort(viewSort);
				ACT_DES_LIST[m_day]=m_action;
			}
			m_action=ACT_DES_LIST[m_day];
			var m_currTime:String=Data.date.nowDate.hours + ""
			m_currTime+=(Data.date.nowDate.minutes + "").length < 2 ? "0" + Data.date.nowDate.minutes : Data.date.nowDate.minutes;
			m_currTime+=(Data.date.nowDate.seconds + "").length < 2 ? "0" + Data.date.nowDate.seconds : Data.date.nowDate.seconds;
			var m_time:int=int(m_currTime);
			var m_temp:Pub_Action_DescResModel=null;
			var m_len:int=m_action.length;
			while (m_len--)
			{
				returnValue.unshift(m_action[m_len]);
				if (int(m_action[m_len].action_start.replace(/:/g, "")) < m_time)
				{
					if (int(m_action[m_len].action_end.replace(/:/g, "")) > m_time)
					{
					}
					else
					{
						returnValue[0]=null;
					}
					break;
				}
			}
			return returnValue;
		}

		private function viewSort(a:Object, b:Object):int
		{
			var a_start_str:String=a.action_start.replace(/:/g, "");
			var b_start_str:String=b.action_start.replace(/:/g, "");
			var a_start:int=parseInt(a_start_str);
			var b_start:int=parseInt(b_start_str);
			if (a_start > b_start)
			{
				return 1;
			}
			if (a_start < b_start)
			{
				return -1;
			}
			return 0;
		}

		public function getResPath_ByRandom(hint_sort:int=1):Pub_HintResModel
		{
			var len:int=contentData.contentXml.length;
			var ran:int=Math.floor(Math.random() * len);
			var index:int=0;
			for each (var resid:IResModel in contentData.contentXml)
			{
				if (ran == index)
				{
					return this.getResPath(resid["hint_id"]) as Pub_HintResModel;
				}
				index++;
			}
			var defLine:String=Lang.getLabel("30027_hintDefLine");
			return new Pub_HintResModel([-1, -1, defLine, "xxx"]);
		}

		public function getS1(situp_id:int, strong_lv:int):Object
		{
			var m_data:Object;
			switch (tableName)
			{
				case "Pub_Sitzup_Name":
					for each (var resid:IResModel in contentData.contentXml)
					{
						if (resid["situp_id"] == situp_id && resid["strong_lv"] == strong_lv)
						{
							m_data=resid;
						}
					}
					break;
				case "Pub_Sitzup_Show":
					for each (var resid:IResModel in contentData.contentXml)
					{
						if (resid["situp_id"] == situp_id && resid["strong_lv"] == strong_lv)
						{
							m_data=resid;
						}
					}
					break;
			}
			return m_data;
		}

		public function getListBySort(sort:int=0):Object
		{
			var m_data:Object;
			switch (tableName)
			{
				case "Pub_Action_Desc":
					var resultList_action:Vector.<Object>=new Vector.<Object>();
//					var list:XMLList=contentXml.C_Pub_Action_Desc;
					for each (var resid:IResModel in contentData.contentXml)
					{
						var action_id:int=resid["action_id"];
						var action_sort:int=resid["sort"];
						if (sort == action_sort)
						{
							//注意，已toObject()，减少引用和内存消耗
							resultList_action.push(this.getResPath(action_id));
						}
					}
					m_data=resultList_action;
					break;
				case "Pub_Combine":
					var resultList_combine:Vector.<Pub_CombineResModel>=new Vector.<Pub_CombineResModel>();
//					var list:XMLList=contentXml.C_Pub_Combine
					for each (var resid:IResModel in contentData.contentXml)
					{
						if (sort == resid["sort"])
						{
							resultList_combine.push(this.getResPath(resid["id"]));
						}
					}
					m_data=resultList_combine;
					break;
				case "Pub_Hundred_Fight":
					var resultList_hundred:Vector.<Vector.<Pub_Hundred_FightResModel>>=new Vector.<Vector.<Pub_Hundred_FightResModel>>();
					resultList_hundred.push(new Vector.<Pub_Hundred_FightResModel>());
					resultList_hundred.push(new Vector.<Pub_Hundred_FightResModel>());
					resultList_hundred.push(new Vector.<Pub_Hundred_FightResModel>());
//					var list:XMLList=contentXml.C_Pub_Hundred_Fight
					for each (var resid:IResModel in contentData.contentXml)
					{
						if (Data.myKing.metier == int((resid["sort_id"] / 10) % 10))
						{
							//注意，已toObject()，减少引用和内存消耗
							resultList_hundred[int(resid["sort_id"] / 100) - 1].push(this.getResPath(resid["id"]));
						}
					}
					m_data=resultList_hundred;
					break;
			}
			return m_data;
		}

		public function fillItemData(data:Array):void
		{
			var size:int=data.length;
			var tempDataArr:Array=[];
			tempDataArr=tempDataArr.concat(data);
//			var list:XMLList=contentXml.C_Pub_Tools;
			var resModel:Pub_ToolsResModel;
			var tId:int=0;
			var bag:StructBagCell2;
			for each (var resid:IResModel in contentData.contentXml)
			{
				tId=int(resid["tool_id"]);
				var index:int=0;
				var len:int=tempDataArr.length;
				while (index < len)
				{
					bag=tempDataArr[index];
					if (bag.itemid == tId)
					{
						if (this.getResPath(tId) != null)
						{
							resModel=this.getResPath(tId) as Pub_ToolsResModel;
						}
						else
						{
							resModel=resid as Pub_ToolsResModel;
//							this.getResPath(resModel.tool_id)=resModel;
						}
						Data.beiBao.fillCahceData(bag, resModel);
						tempDataArr.splice(index, 1);
						break;
					}
					index++;
				}
				if (len == 0)
				{
					break;
				}
			}
		}

		public function getListByActionGroup(act:int):Pub_Action_DescResModel
		{
			var resultList:Vector.<Pub_Action_DescResModel>=new Vector.<Pub_Action_DescResModel>();
//			var list:XMLList=contentXml.C_Pub_Action_Desc;
			for each (var resid:IResModel in contentData.contentXml)
			{
				var action_group:int=resid["action_group"];
				var action_id:int=resid["action_id"];
				var action_sort:int=resid["sort"];
				if (act == action_group)
				{
					return this.getResPath(action_id) as Pub_Action_DescResModel;
				}
			}
			return null;
		}
		private var m_list:Array

		public function getList(id:int=0, field1:*=null, field2:*=null, field3:*=null):Object
		{
			var m_data:Object;
			switch (tableName)
			{
				case "Pub_Book":
					if (m_list == null)
					{
						m_list=[];
						for each (var m_item:Pub_BookResModel in contentData.contentXml)
						{
							m_list.push(m_item);
						}
					}
					m_data=m_list;
					break;
				case "Pub_Commend":
					var resultList_commend:Vector.<Pub_CommendResModel>=new Vector.<Pub_CommendResModel>();
//					var list:XMLList=contentXml.C_Pub_Commend;
					for each (var resid:IResModel in contentData.contentXml)
					{
						if (resid["id"] != "")
						{
							resultList_commend.push(resid as Pub_CommendResModel);
						}
					}
					m_data=resultList_commend;
					break;
			}
			return m_data;
		}

		public function getListBySortEnhance(sort:int, sort2:int=-1, sort3:int=-1):Vector.<Pub_Action_DescResModel>
		{
			var resultList:Vector.<Pub_Action_DescResModel>=new Vector.<Pub_Action_DescResModel>();
//			var list:XMLList=contentXml.C_Pub_Action_Desc;
			for each (var resid:IResModel in contentData.contentXml)
			{
				var action_id:int=resid["action_id"];
				var action_sort:int=resid["sort"];
				if (sort == action_sort || sort2 == action_sort || sort3 == action_sort)
				{
					resultList.push(this.getResPath(action_id));
				}
			}
			return resultList;
		}

		public function getWindowResource(userLv:int):Array
		{
//			var list:XMLList=contentXml.C_Pub_Interface_Clew;
			var resArray:Array=[];
			var uiName:String=null;
			var uiLoadLevel:int;
			var uiLoadMaxLevel:int;
			for each (var resid:IResModel in contentData.contentXml)
			{
				uiName=resid["ui_name"];
				uiLoadLevel=resid["ui_load_level"];
				uiLoadMaxLevel=resid["ui_load_max_level"];
				if (userLv >= uiLoadLevel && userLv <= uiLoadMaxLevel)
				{
					if (uiName.indexOf("win") == 0)
					{ //根据窗体名称
						resArray.push(uiName);
					}
				}
			}
			return resArray;
		}

		public function getStrong(item_id:int, strong_lv:int):Pub_Sitzup_UpResModel
		{
//			var resid:XMLList=contentXml.C_Pub_Sitzup_Up.(@item_id == item_id && @strong_lv == strong_lv)
			for each (var resid:IResModel in contentData.contentXml)
			{
				if (resid["item_id"] == item_id && resid["strong_lv"] == strong_lv)
				{
					return resid as Pub_Sitzup_UpResModel;
				}
			}
			return null;
		}

		private var metierMap:Dictionary=new Dictionary();
		private var metierMap2:Dictionary=new Dictionary();
		private var sortMap:Dictionary=new Dictionary();

		public function getResPath_BySort(id:int):Object
		{
			var m_data:Object;
			switch (tableName)
			{
				case "Pub_Achievement":
					if (metierMap[id] != null)
					{
						m_data=metierMap[id];
					}
					else
					{
//						var list:XMLList=contentXml.C_Pub_Achievement;
						var resArray1:Vector.<Pub_AchievementResModel>=new Vector.<Pub_AchievementResModel>();
						for each (var resid:IResModel in contentData.contentXml)
						{
							if (id == resid["sort"])
							{
								resArray1.push(this.getResPath(resid["ar_id"]));
							}
						}
						metierMap[id]=resArray1;
						m_data=resArray1;
					}
					break;
				case "Pub_Hint":
					if (sortMap[id])
					{
						m_data=sortMap;
					}
					else
					{
//						var list:XMLList=contentXml.C_Pub_Hint;
						var resArray2:Vector.<Pub_HintResModel>=new Vector.<Pub_HintResModel>();
						for each (var resid:IResModel in contentData.contentXml)
						{
							if (id == resid["hint_sort"])
							{
								resArray2.push(this.getResPath(resid["hint_id"]));
							}
						}
						sortMap[id]=resArray2;
						m_data=resArray2;
					}
					break;
				case "Pub_Interface_Clew":
					if (metierMap2[id] != null)
					{
						m_data=metierMap2[id];
					}
					else
					{
//						var list:XMLList=contentXml.C_Pub_Interface_Clew;
						var resArray3:Vector.<Pub_Interface_ClewResModel>=new Vector.<Pub_Interface_ClewResModel>();
						for each (var resid:IResModel in contentData.contentXml)
						{
							if (id == resid["sort"])
							{
								resArray3.push(this.getResPath(resid["interface_id"]));
							}
						}
						metierMap2[id]=resArray3;
						m_data=resArray3;
					}
					break;
			}
			return m_data;
		}
		//技能列表
		private var m_SkillMetier:Array;

		private function initSkillMetier():void
		{
			if (null != m_SkillMetier)
			{
				return;
			}
			m_SkillMetier=[];
			for each (var item:Pub_SkillResModel in XmlManager.localres.getSkillXml.contentData.contentXml)
			{
				if (null == m_SkillMetier[item.skill_metier])
				{
					m_SkillMetier[item.skill_metier]=new Vector.<Pub_SkillResModel>();
				}
				var resArray:Vector.<Pub_SkillResModel>=m_SkillMetier[item.skill_metier] as Vector.<Pub_SkillResModel>;
				resArray.push(item);
			}
		}

		/**
		 *
		 * @param skill_metier  职业
		 * @param skill_series  这个字段在实际项目中已经废弃了。
		 * @return
		 *
		 */
		public function getResPath_BySkillMetier(skill_metier:int, skill_series:int):Vector.<Pub_SkillResModel>
		{
			if (m_SkillMetier == null)
			{
				initSkillMetier();
			}
			var resArray:Vector.<Pub_SkillResModel>=m_SkillMetier[skill_metier];
			return resArray;
		}
		
		public function getTouZiSortList() :Vector.<Pub_Invest_RepayResModel>
		{
			var resArray:Vector.<Pub_Invest_RepayResModel> = new Vector.<Pub_Invest_RepayResModel>();
			

			var resModel:Pub_Invest_RepayResModel;

			for each (var resid:IResModel in contentData.contentXml)
			{ 
				resModel =new  Pub_Invest_RepayResModel([resid["id"],resid["sort"],resid["index"],resid["day"],resid["item_id"],resid["item_num"]]);
				resArray.push(resModel);
			}
			return resArray;
		}
		
		private var _mapSurfaceListDic:Dictionary;
		
		/**
		 * 地图地表部件数据
		 */
		public function getMapSurfaceListById(mapId:int):Vector.<Pub_Map_Spawn_ClientResModel>
		{
			if (_mapSurfaceListDic == null)
				_mapSurfaceListDic = new Dictionary();
			var list:Vector.<Pub_Map_Spawn_ClientResModel> = _mapSurfaceListDic[mapId];
			if (list == null)
			{
				list = new Vector.<Pub_Map_Spawn_ClientResModel>();
				_mapSurfaceListDic[mapId] = list;
				var rm:Pub_Map_Spawn_ClientResModel;
				for each (rm in contentData.contentXml)
				{
					if (rm.map_id == mapId)
					{
						list.push(rm);
					}
				}
			}
			return list;
		}
	}
}
