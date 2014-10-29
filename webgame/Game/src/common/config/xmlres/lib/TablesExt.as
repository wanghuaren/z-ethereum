package common.config.xmlres.lib
{
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_Equip_ResolveResModel;
	import common.config.xmlres.server.Pub_Equip_SuitResModel;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.config.xmlres.server.Pub_SeekResModel;
	
	import flash.utils.Dictionary;

	public class TablesExt
	{
		public function TablesExt()
		{
		}
		private static var _instance:TablesExt;

		public static function get instance():TablesExt
		{
			if (_instance == null)
			{
				_instance=new TablesExt();
			}
			return _instance;
		}
		//二次封装数据的缓存池
		private var dicData:Dictionary=new Dictionary()

		public function getResPath4(m_tableName:String, m_args:Array, table:IXMLLib):Object
		{
			dicTableData=table;
			var m_data:Object;
			switch (m_tableName)
			{
				case "Pub_Shop_Normal":
					var key:String=m_args[0] + "_" + m_args[1];
					if (dicData["Pub_Shop_Normal"]!=null&&dicData["Pub_Shop_Normal"][key] != null)
					{
						m_data=dicData["Pub_Shop_Normal"][key];
					}
					else
					{
						if(dicData["Pub_Shop_Normal"]==null)dicData["Pub_Shop_Normal"]=[];
//						resid=xml.C_Pub_Shop_Normal.(@shop_id == m_args[0] && m_args[1] == @tool_id);
						for each (var resid:IResModel in table.contentXml)
						{
							if (resid["shop_id"] == m_args[0] && m_args[1] == resid["tool_id"])
							{
								m_data=resid
								dicData["Pub_Shop_Normal"][key]=m_data;
							}
						}
					}
					break;
			}
			return m_data;
		}

		public function getResPath3(m_tableName:String, m_args:Array, table:IXMLLib):Object
		{
			dicTableData=table;
			var m_data:Object;
			if (dicData[m_tableName] == null)
			{
				dicData[m_tableName]=new Dictionary();
			}
			switch (m_tableName)
			{
				case "Pub_Equip_Strong_2":
				case "Pub_Colour_Strong":
				case "Pub_Equip_Soul_Strong":
				case "Pub_Equip_Soul_Strong":
					var ret:Dictionary=new Dictionary();
//					var list:XMLList=xml.C_Pub_Equip_Strong_2;
					var lv:int=0;
					var maxLevel:int=20;
					for each (var resid:IResModel in table.contentXml)
					{
						if (lv > maxLevel)
							break;
						if (lv == resid["lv"] && 1 == resid["tool_pos"])
						{
							ret[lv]=String(resid["strong_dis"]);
							lv++;
						}
					}
					m_data=ret;
					break;
				case "Pub_Compose":
//					var list:XMLList=xml.C_Pub_Compose;
					var arr:Array=[];
					if (dicData["Pub_Compose"][m_args[0]] != null)
					{
						m_data=dicData["Pub_Compose"][m_args[0]];
					}
					else
					{
						for each (var resid:IResModel in table.contentXml)
						{
							if (m_args[0] == resid["para_int"])
							{
								arr.push(data(resid["make_id"]));
							}
						}
						if(m_args[0]==1){
							arr.sortOn("need_value1",Array.NUMERIC);
						}else if(m_args[0]==4){
							arr.sortOn("need_value4",Array.NUMERIC);
						}else{
							arr.sortOn("stuff_num2",Array.NUMERIC);
						}
						m_data=arr;
						dicData["Pub_Compose"][m_args[0]]=m_data;
					}	
					
					break;
				case "Pub_FamilyBoss":
//					resid=xml.C_Pub_FamilyBoss.(m_args[0] == @boss_level);
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["boss_level"])
						{
							m_data=data(resid["id"]);
						}
					}
					break;
				case "Pub_Help_Data":
//					resid=xml.C_Pub_Help_Data.(m_args[0] == @menu2_id && m_args[1] == @menu3_id);
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["menu2_id"] && m_args[1] == resid["menu3_id"])
						{
							m_data=resid;
						}
					}
					break;
			}
			return m_data;
		}

		private var dicTableData:IXMLLib;

		private function data(id:*):Object
		{
			return dicTableData.contentXml[id];
		}

//根据表名做标识,返回不同的查询结果
		public function getResPath2(m_tableName:String, m_args:Array, table:IXMLLib):Object
		{
			dicTableData=table;
			var m_data:Object;
			if (dicData[m_tableName] == null)
			{
				dicData[m_tableName]=new Dictionary();
			}
			switch (m_tableName)
			{
				case "Pub_Action_Desc":
					if (dicData["Pub_Action_Desc"][m_args[0]] != null)
					{
						m_data=dicData["Pub_Action_Desc"][m_args[0]];
					}
					else
					{
//						resid=xml.C_Pub_Action_Desc.(@action_group == m_args[0]);
						for each (var resid:IResModel in table.contentXml)
						{
							if (resid["action_group"] == m_args[0])
							{
								m_data=resid;
								dicData["Pub_Action_Desc"][m_args[0]]=m_data;
							}
						}
					}
					break;
				case "Pub_Bone":
//					resid=xml.C_Pub_Bone.(@bone_id == m_args[0] && @bone_sort == m_args[1]);
					for each (var resid:IResModel in table.contentXml)
					{
						if (resid["bone_id"] == m_args[0] && resid["bone_sort"] == m_args[1])
						{
							m_data=data(m_args[0]);
						}
					}
					break;
				case "Pub_Change":
//					resid=xml.C_Pub_Change.(@starttimes <= m_args[0] && @endtimes >= m_args[0]);
					for each (var resid:IResModel in table.contentXml)
					{
						if (resid["starttimes"] <= m_args[0] && resid["endtimes"] >= m_args[0])
						{
							m_data=data(m_args[0])
						}
					}
					break;
				case "Pub_Drop":
					if (dicData["Pub_Drop"][m_args[0]] != null)
					{
						m_data=dicData["Pub_Drop"][m_args[0]];
					}
					else
					{
//						var list:XMLList=xml.C_Pub_Drop;
						var arrDrop:Vector.<Pub_DropResModel>=new Vector.<Pub_DropResModel>();
						var arr:Array=[];
						var tool_index:int=5;
						for each (var resid:IResModel in table.contentXml)
						{

							if (resid != null && resid["drop_id"] == m_args[0])
							{
								arr=[resid["id"],resid["drop_id"], resid["min_level"], resid["max_level"],  resid["drop_data_type"], resid["drop_item_id"], resid["drop_num"]];
								if (resid["drop_data_type"] == 2)
								{
									//如果是掉落，在读取一次数据 2012-09-24 
									var resModelTemp:Pub_DropResModel=data(resid["drop_item_id"]) as Pub_DropResModel;
									if (resModelTemp.drop_data_type == 3)
									{
										//如果是金币，
										arr[tool_index]=TablesLib.YIN_LIANG_TOOL_ID;
										arrDrop.push(new Pub_DropResModel(arr));
									}
									else if (resModelTemp.drop_data_type == 4)
									{
										//如果是元宝
										arr[tool_index]=TablesLib.YUAN_BAO_TOOL_ID;
										arrDrop.push(new Pub_DropResModel(arr));
									}
									else
									{
										arrDrop.push(resModelTemp);
									}
								}
								else if (resid["drop_data_type"] == 3)
								{
									//如果是金币，
									arr[tool_index]=TablesLib.YIN_LIANG_TOOL_ID;
									arrDrop.push(new Pub_DropResModel(arr));
								}
								else if (resid["drop_data_type"] == 4)
								{
									//如果是元宝
									arr[tool_index]=TablesLib.YUAN_BAO_TOOL_ID;
									arrDrop.push(new Pub_DropResModel(arr));
								}
								else
								{
									arrDrop.push(new Pub_DropResModel(arr));
								}
							}
							
						}
						//dicData["Pub_Drop"][m_args[0]]=arrDrop;
						m_data=arrDrop;
					}
					break;
				case "Pub_Equip_Resolve":
//					resid=xml.C_Pub_Equip_Resolve.(@tool_colour == m_args[2]);
					var m_resid:Pub_Equip_ResolveResModel;
					for each (var resid:IResModel in table.contentXml)
					{
						if (resid["tool_colour"] == m_args[2])
						{
							m_resid=resid as Pub_Equip_ResolveResModel;
						}
					}
					if (m_resid != null)
					{
						m_data=m_resid;
//						_contentMap.put(resModel.id, resModel);
					}
					else
					{
//						resid=xml.C_Pub_Equip_Resolve.(@tool_colour == m_args[0] && @min_lv <= m_args[1] && @max_lv >= m_args[1])
						for each (var resid:IResModel in table.contentXml)
						{
							if (resid["tool_colour"] == m_args[0] && resid["min_lv"] <= m_args[1] && resid["max_lv"] >= m_args[1])
							{
								m_resid=resid as Pub_Equip_ResolveResModel;
							}
						}
						if (m_resid != null)
						{
							m_data=m_resid;
//						_contentMap.put(resModel.id, resModel);
						}
					}
					break;
				case "Pub_Equip_Strong_Cost":
//					resid=xml.C_Pub_Equip_Strong_Cost.(m_args[0] == @strong_cost_type && m_args[1] == @strong_lv);
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["strong_cost_type"] && m_args[1] == resid["strong_lv"])
						{
							m_data=data(resid["id"]);
						}
					}
					break;
				case "Pub_Equip_Strong_2":
					var key:String=m_args[0] + "_" + m_args[1];
					if (dicData["Pub_Equip_Strong_2"][key] != null)
					{
						m_data=dicData["Pub_Equip_Strong_2"][key];
					}
					else
					{
//						resid=xml.C_Pub_Equip_Strong_2.(m_args[0] == @strong_id && m_args[1] == @lv);
						for each (var resid:IResModel in table.contentXml)
						{
							if (m_args[0] == resid["strong_id"] && m_args[1] == resid["lv"])
							{
								m_data=data(int(resid["ID"]));
								dicData["Pub_Equip_Strong_2"][key]=m_data;
							}
						}
					}
					break;
				case "Pub_Equip_Suit":
					var m_Pub_Equip_SuitResModel:Vector.<Pub_Equip_SuitResModel>=new Vector.<Pub_Equip_SuitResModel>();
//					var list:XMLList=xml.C_Pub_Equip_Suit;
					for each (var resid:IResModel in table.contentXml)
					{
						if (resid["suit_id"] == m_args[0])
						{
							m_Pub_Equip_SuitResModel.push(resid);
						}
					}
					m_data=m_Pub_Equip_SuitResModel;
					break;
				case "Pub_Exp_Back":
					var key:String=m_args[0] + "_" + m_args[1];
					if (dicData["Pub_Exp_Back"][key] != null)
					{
						m_data=dicData["Pub_Exp_Back"][key];
					}
					else
					{
//						resid=xml.C_Pub_Equip_Soul.(m_args[0] == @lv && m_args[1] == @action_group);
						for each (var resid:IResModel in table.contentXml)
						{
							if (m_args[0] == resid["lv"] && m_args[1] == resid["action_group"])
							{
								m_data=resid
								dicData["Pub_Exp_Back"][key]=m_data;
							}
						}
					}
					break;
				case "Pub_Family_Leaguer_Lv":
//					resid=xml.C_Pub_Family_Leaguer_Lv.(m_args[0] >= @min_value && m_args[0] <= @max_value)
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] >= resid["min_value"] && m_args[0] <= resid["max_value"])
						{
							m_data=data(resid["id"]);
						}
					}
					break;
				case "Pub_Gem_Compose":
//					resid=xml.C_Pub_Gem_Compose.(m_args[0] == @lv && m_arags[1] == @sort);
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["lv"] && m_args[1] == resid["sort"])
						{
							m_data=data(resid["id"]);
						}
					}
					break;
				case "Pub_HeadIcon":
//					var list:XMLList=xml.C_Pub_HeadIcon;
					var resModel:Array=new Array;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["metier"])
						{
							resModel.push(resid);
						}
					}
					m_data=resModel;
					break;
				case "Pub_Help_Data":
//					var list:XMLList=xml.C_Pub_Help_Data;
					var resModel:Array=new Array;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["menu2_id"])
						{
							resModel.push(resid);
						}
					}
					m_data=resModel;
					break;
				case "Pub_Help":
//					var list:XMLList=xml.C_Pub_Help;
					var resModel:Array=new Array;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["menu1_id"])
						{
							resModel.push(resid);
						}
					}
					m_data=resModel;
					break;
				case "Pub_Instance":
//					var list:XMLList=xml.C_Pub_Instance;
					var resMode_instancel:Vector.<Pub_InstanceResModel>=new Vector.<Pub_InstanceResModel>();
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] >= resid["instance_level"])
						{
							if (-1 == m_args[1] || resid["instancesort"] == m_args[1])
							{
								resMode_instancel.push(data(resid["instance_id"]));
							}
						}
					}
					m_data=resMode_instancel;
					break;
				case "Pub_Kingname":
//					var list:XMLList=xml.C_Pub_Kingname;
					var resModel:Array=new Array;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["sort"])
						{
							resModel.push(resid);
						}
					}
					m_data=resModel;
					break;
				case "Pub_Map_Seek":
//					var list:XMLList=xml.C_Pub_Map_Seek;
					var resModel:Array=new Array;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["map_id"])
						{
							resModel.push(resid);
						}
					}
					m_data=resModel;
					break;
				case "Pub_Seek":
					var vec:Vector.<Pub_SeekResModel>=new Vector.<Pub_SeekResModel>;
					if (m_args[0] > 0&&m_args[1]>0)
					{
//						var list:XMLList=xml.C_Pub_Seek;
						
						for each (var seek:Pub_SeekResModel in table.contentXml)
						{
							if (m_args[0] == int(seek["map_id"]) && m_args[1] == int(seek["sort"]))
							{
								vec.push(seek);
							}
						}
					}
					else
					{
						for each (var seek:Pub_SeekResModel in table.contentXml)
						{
							if (m_args[0] == seek.map_id)
							{
								vec.push(seek);
							}
						}
					}
					m_data=vec;
					break;
				case "Pub_Shop_Normal":
					var key:String=m_args[0]+"_"+m_args[1];
					if (dicData["Pub_Shop_Normal"][key] != null)
					{
						m_data=dicData["Pub_Shop_Normal"][key];
					}
					else
					{
						var resArray:Array=new Array();
//						var list:XMLList=xml.C_Pub_Shop_Normal;
						for each (var resid:IResModel in table.contentXml)
						{
							if (m_args[0] == resid["shop_id"] && m_args[1] == resid["page_id"])
							{
								resArray.push(resid);
							}
						}
						resArray.sortOn("show_id", Array.NUMERIC | Array.DESCENDING);
						m_data=resArray;
						dicData["Pub_Shop_Normal"][key]=m_data;
					}
					break;
				case "Pub_Shop_Page":
//					var list:XMLList=xml.C_Pub_Shop_Page;
					var resModel:Array=new Array;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["shop_id"])
						{
							resModel.push(resid);
						}
					}
					m_data=resModel;
					break;
				case "Pub_Sitzup_Skill":
//					resid=xml.C_Pub_Sitzup_Skill.(m_args[0] == @skill_icon);
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["skill_icon"])
						{
							m_data=data(resid["tool_id"]);
						}
					}
					break;
				case "Pub_Task_Prize":
					var key:String=m_args[0];
					if (dicData["Pub_Task_Prize"][key] != null)
					{
						m_data=dicData["Pub_Task_Prize"][key];
					}
					else
					{
						var resArray:Array=new Array();
//						var list:XMLList=xml.C_Pub_Task_Prize;
						for each (var resid:IResModel in table.contentXml)
						{
							if (m_args[0] == resid["task_id"])
							{
								resArray.push(resid);
							}
						}
						m_data=resArray;
						dicData["Pub_Task_Prize"][key]=m_data;
					}
					break;
				case "Pub_Task_Step":
					var resArray:Array=new Array();
//					var list:XMLList=xml.C_Pub_Task_Step;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["task_id"])
						{
							resArray.push(resid);
						}
					}
					m_data=resArray;
					break;
				case "Pub_Tool_Attr":
//					resid=xml.C_Pub_Tool_Attr.(m_args[0] == @min_attr || m_args[0] == @max_attr);
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["min_attr"] || m_args[0] == resid["max_attr"])
						{
							m_data=data(resid["id"])
						}
					}
					break;
				case "Pub_Vip_Prompt":
					var resArray:Array=new Array();
//					var list:XMLList=xml.C_Pub_Vip_Prompt;
					for each (var resid:IResModel in table.contentXml)
					{
						if (m_args[0] == resid["vip_sort"])
						{
							resArray.push(data(resid["id"]));
						}
					}
					m_data=resArray;
					break;
				case "Pub_Uptarget":
					var resArray:Array=new Array();
//					var list:XMLList=xml.C_Pub_Uptarget;
					for each (var resid:IResModel in table.contentXml)
					{
						resArray.push(data(resid["id"]));
					}
					m_data=resArray;
					break;
			}
			return m_data;
		}
	}
}
