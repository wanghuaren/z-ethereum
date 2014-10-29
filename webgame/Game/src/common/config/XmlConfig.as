package common.config
{
	import common.managers.Lang;
	
	import engine.utils.compress.Zip;
	
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *	xml加载配置中心
	 *  本地化资源
	 */
	public class XmlConfig
	{
		private static var _zipXml:Zip;
		public static const zipXmlFileName:String="db.zip";
		public static var current_game_servers:String="";
		private static var libLoader:Loader;

		public static function get zipXmlFileFullName():String
		{
			if ("" == current_game_servers)
			{
				current_game_servers=GameIni.GAMESERVERS;
			}
			return current_game_servers + "localres/" + zipXmlFileName + "?ver=" + GameIni.LOCAL_RES_VER;
		}

		public static function get mapDatasPath():String
		{
			if ("" == current_game_servers)
			{
				current_game_servers=GameIni.GAMESERVERS;
			}
			return current_game_servers + "Map/DataMap/DataMap.zip?ver=" + GameIni.LOCAL_RES_VER;
		}

		/**
		 * xml本地资源打包后的lib.swf目录
		 */
		public static function get swfXmlLibFullName():String
		{
			return "lib.swf";
			if ("" == current_game_servers)
			{
				current_game_servers=GameIni.GAMESERVERS;
			}
			return current_game_servers + "localres/lib.swf?ver=" + GameIni.LOCAL_RES_VER;
		}

		public function XmlConfig()
		{
		}

		public static function get xmlLibLoader():Loader
		{
			if (libLoader == null)
			{
				libLoader=new Loader();
			}
			return libLoader;
		}

		public static function get zipXml():Zip
		{
			if (null == _zipXml)
			{
				_zipXml=new Zip();
			}
			return _zipXml;
		}

		/**
		 * 双线程下载模式
		 */
		public static function get TwoThreadDownMode():Boolean
		{
			//
			return true;
		}

		public static function get MsgXmlPath():String
		{
			return "localres/msg.amd?ver=" + GameIni.LOCAL_RES_VER;
		}

		public static function get LangXmlPath():String
		{
			return "localres/lang.amd?ver=" + GameIni.LOCAL_RES_VER;
		}
		/**************文件内容************/
		//msg
		public static var MSGXML:XML=null;
		//lang
		public static var LANGXML:XML=null;

		private static function Dc1(table_name:String):ByteArray
		{
			currentFileName=table_name.replace(".txt", "");
			//xjcs/是压缩文件中的目录名
			//var data1:ByteArray = zipXml.readFileByByte(zipXmlFileFullName.toLowerCase(),"xjcs/" + table_name.toLowerCase());						
			//由于数据库生成的zip有问题,compressedSize有问题，现去除
			var data1:ByteArray=zipXml.readFileByByte(zipXmlFileFullName, table_name);
			return data1;
		}

		private static function Dc2(data1:ByteArray):String
		{
			if (data1 == null)
				return null;
//			var data2:String=EncryptTXML.instance.DeCode(data1, Loadxml._XOR);
//			return data2;
//			return data1.readUTFBytes(data1.bytesAvailable);
			data1.position=0;
			return strToXML(data1.readUTFBytes(data1.bytesAvailable));
		}
		private static var currentFileName:String;

		private static function strToXML(str:String):String
		{
			var enterChar:String="\r\n";
			var splitChar:String="\t";
			var arrayData:Array=str.split(splitChar + enterChar);
			var fieldName:Array=arrayData.shift().split(splitChar);
			var itemArray:Array;
			var xmlStr:String="<?xml version=\"1.0\" encoding=\"utf-8\"?><" + currentFileName + ">";
			var m_item:String;
			var fieldName_length:int=fieldName.length;
//			arrayData.pop();
			for each (m_item in arrayData)
				//			for (var n:int=1; n < arrayData.length-1; n++)
			{
				xmlStr+="<C_" + currentFileName;
				//				arrayData[n]=arrayData[n].replace(/</g, "&lt;");
				//				arrayData[n]=arrayData[n].replace(/>/g, "&gt;");
				//				arrayData[n]=arrayData[n].replace(/\"/g, "&quot;");
				//				itemArray=arrayData[n].split(splitChar)
				m_item=m_item.replace(/</g, "&lt;");
				m_item=m_item.replace(/>/g, "&gt;");
				m_item=m_item.replace(/\"/g, "&quot;");
				itemArray=m_item.split(splitChar)
				//				for (var i:int=0; i < fieldName_length; i++)
				var i:int=0;
				while (i < fieldName_length)
				{
					xmlStr+=" " + fieldName[i] + "=\"" + itemArray[i] + "\"";
					i++;
				}
				xmlStr+="/>";
			}
			xmlStr+="</" + currentFileName + ">";
			str=null;
			return xmlStr;
		}

		/**
		 * 获得技能数据对象。
		 * @param className
		 * @return
		 *
		 */
		public static function getPSDInstanceByName(className:String):Array
		{
			var clazz:Class=libLoader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
			var _data:*=new clazz();
			var _arr:Array=_data.contentXml as Array;
			return _arr;
		}
		private static var dicXML:Dictionary=new Dictionary();

		/**
		 * 根据xml文件名获取对应的xml实例对象
		 * @className xml文件名即绑定的类名
		 */
		public static function getXMLInstanceByName(className:String):String
		{
			return className;
			if (dicXML[className] == null)
			{
				var value:String="";
				if (libLoader.contentLoaderInfo.applicationDomain.hasDefinition(className))
				{
					var clazz:Class=libLoader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
					var buffer:ByteArray=new clazz();
					value=buffer.readUTFBytes(buffer.length);
					buffer.clear();
					buffer=null;
					if (GameIni.pf() == GameIni.PF_3366)
					{
						value=value.replace(/\$2000/g, "蓝钻");
					}
					else
					{
						value=value.replace(/\$2000/g, "黄钻");
					}
				}
				dicXML[className]=new XML(value);
			}
			return dicXML[className];
		}

		/**
		 *
		 */
		public static function get TASKXML():String
		{
			return getXMLInstanceByName("Pub_Task");
			var data1:ByteArray=Dc1("Pub_Task");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get Action_TargetXML():String
		{
			return getXMLInstanceByName("Pub_Action_Target");
			var data1:ByteArray=Dc1("Pub_Action_Target");
			;
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 道具
		 */
		public static function get TOOLXML():String
		{
			return getXMLInstanceByName("Pub_Tools");
			var data1:ByteArray=Dc1("Pub_Tools.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 星魂
		 */
		public static function get STARXML():String
		{
			return getXMLInstanceByName("Pub_Star");
			var data1:ByteArray=Dc1("Pub_Star.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 我要变强
		 */
		public static function get CHANGE_STRONG_DESC_XML():String
		{
			return getXMLInstanceByName("Pub_Change_Strong_Desc");
			var data1:ByteArray=Dc1("Pub_Change_Strong_Desc.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 星魂 兑换
		 */
		public static function get STAREXCHANGEXML():String
		{
			return getXMLInstanceByName("Pub_Star_Exchange");
			var data1:ByteArray=Dc1("Pub_Star_Exchange.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * NPC数据
		 */
		public static function get PUBNPCXML():String
		{
			return getXMLInstanceByName("Pub_Npc");
			var data1:ByteArray=Dc1("Pub_Npc.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 复活面板上的随机提示
		 */
		public static function get HINTXML():String
		{
			return getXMLInstanceByName("Pub_Hint");
			var data1:ByteArray=Dc1("Pub_Hint.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 任务步骤
		 */
		public static function get TASKSTEPXML():String
		{
			return getXMLInstanceByName("Pub_Task_Step");
			var data1:ByteArray=Dc1("Pub_Task_Step.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 阵营
		 */
		public static function get CAMPXML():String
		{
			return getXMLInstanceByName("Pub_Camp");
			var data1:ByteArray=Dc1("Pub_Camp.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get CONFIGXML():String
		{
			return getXMLInstanceByName("Pub_Config");
			var data1:ByteArray=Dc1("Pub_Config.txt");
			if (data1 == null)
				return null;
			var data2:String=Dc2(data1);
			var xml:XML=XML(data2);
			return XML(data2);
		}

		/**
		 * 头像
		 */
		public static function get HEADICONXML():String
		{
			return getXMLInstanceByName("Pub_HeadIcon");
			var data1:ByteArray=Dc1("Pub_HeadIcon.txt");
			if (data1 == null)
				return null;
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 姓名库
		 */
		public static function get KINGNAMEXML():String
		{
			return getXMLInstanceByName("Pub_Kingname");
			var data1:ByteArray=Dc1("Pub_Kingname.txt");
			if (data1 == null)
				return null;
			var data2:String=Dc2(data1);
			var xml:XML=XML(data2);
			return XML(data2);
		}

		/**
		 *
		 */
		public static function get MAPXML():String
		{
			return getXMLInstanceByName("Pub_Map");
			var data1:ByteArray=Dc1("Pub_Map.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 *
		 */
		public static function get NPC_FUNCXML():String
		{
			return getXMLInstanceByName("Pub_Npc_Func");
			var data1:ByteArray=Dc1("Pub_Npc_Func.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 *
		 */
		public static function get SKILLXML():String
		{
			return getXMLInstanceByName("Pub_Skill");
			var data1:ByteArray=Dc1("Pub_Skill.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get PUBSKILLTREEXML():String
		{
			return getXMLInstanceByName("Pub_Skill_Tree");
			var data1:ByteArray=Dc1('Pub_Skill_Tree.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBSKILLTREECONFIGXML():String
		{
			return getXMLInstanceByName("Pub_Skill_Tree_Config");
			var data1:ByteArray=Dc1('Pub_Skill_Tree_Config.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBTALENTSTUDYXML():String
		{
			return getXMLInstanceByName('Pub_Talent_Study');
			var data1:ByteArray=Dc1('Pub_Talent_Study.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		/**
		 *
		 */
		public static function get SKILLSPECIALXML():String
		{
			return getXMLInstanceByName("Pub_Skill_Special");
			var data1:ByteArray=Dc1("Pub_Skill_Special.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 *
		 */
		public static function get TASK_PRIZEXML():String
		{
			return getXMLInstanceByName("Pub_Task_Prize");
			var data1:ByteArray=Dc1("Pub_Task_Prize.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 装备强化配置信息
		 */
		public static function get EQUIP_STRONGXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Strong_2");
			var data1:ByteArray=Dc1("Pub_Equip_Strong_2.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 套装表配置信息
		 * @return
		 *
		 */
		public static function get EQUIP_SUITXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Suit");
			var data1:ByteArray=Dc1("Pub_Equip_Suit.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 人物等级经验
		 */
		public static function get EXPXML():String
		{
			return getXMLInstanceByName("Pub_Exp");
			var data1:ByteArray=Dc1("Pub_Exp.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 九字真言配置信息
		 */
		public static function get BONEBASEXML():String
		{
			return getXMLInstanceByName("Pub_Bone_Base");
			var data1:ByteArray=Dc1("Pub_Bone_Base.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get PAYMENT_DAY_XML():String
		{
			return getXMLInstanceByName("Pub_Payment_Day");
			var data1:ByteArray=Dc1("Pub_Payment_Day.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get BONESTARXML():String
		{
			return getXMLInstanceByName("Pub_Bourn_Star");
			var data1:ByteArray=Dc1("Pub_Bourn_Star.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 炼骨配置信息
		 */
		public static function get BONEXML():String
		{
			return getXMLInstanceByName("Pub_Bone");
			var data1:ByteArray=Dc1("Pub_Bone.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 玄仙宝典
		 * @return
		 *
		 */
		public static function get BOOKXML():String
		{
			return getXMLInstanceByName("Pub_Book");
			var data1:ByteArray=Dc1("Pub_Book.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 装备重铸配置信息
		 */
		public static function get REFOUNDXML():String
		{
			return getXMLInstanceByName("Pub_Refound");
			var data1:ByteArray=Dc1("Pub_Refound.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 地图npc寻路信息
		 */
		public static function get SEEKXML():String
		{
			return getXMLInstanceByName("Pub_Seek");
			var data1:ByteArray=Dc1("Pub_Seek.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 地图传送点信息
		 */
		public static function get MAPSEEKXML():String
		{
			return getXMLInstanceByName("Pub_Map_Seek");
			var data1:ByteArray=Dc1("Pub_Map_Seek.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 地图采集资源
		 */
		public static function get MODELXML():String
		{
			return getXMLInstanceByName("Pub_Model");
			var data1:ByteArray=Dc1("Pub_Model.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * NPC商店菜单
		 */
		public static function get SHOPPAGEXML():String
		{
			return getXMLInstanceByName("Pub_Shop_Page");
			var data1:ByteArray=Dc1("Pub_Shop_Page.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * NPC商店物品列
		 */
		public static function get SHOPNORMALXML():String
		{
			return getXMLInstanceByName("Pub_Shop_Normal");
			var data1:ByteArray=Dc1("Pub_Shop_Normal.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 百服皇城数据
		 **/
		public static function get HUNDREDFIGHT():String
		{
			return getXMLInstanceByName("Pub_Hundred_Fight");
			var data1:ByteArray=Dc1("Pub_Hundred_Fight.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 传承 装备物品列
		 */
		public static function get INHERITXML():String
		{
			return getXMLInstanceByName("Pub_Inherit");
			var data1:ByteArray=Dc1("Pub_Inherit.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 伙伴
		 */
		public static function get PETXML():String
		{
			return getXMLInstanceByName("Pub_Pet");
			var data1:ByteArray=Dc1("Pub_Pet.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 伙伴 加点
		 */
		public static function get PET_ADD_COMMEND_XML():String
		{
			return getXMLInstanceByName("Pub_Add_Commend");
			var data1:ByteArray=Dc1("Pub_Add_Commend.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 装备 分解
		 */
		public static function get ZHUANGBEI_XML():String
		{
			return getXMLInstanceByName("Pub_Equip_Resolve");
			var data1:ByteArray=Dc1("Pub_Equip_Resolve.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 伙伴 强化
		 */
		public static function get PETSTRONGXML():String
		{
			return getXMLInstanceByName("Pub_Pet_Strong");
			var data1:ByteArray=Dc1("Pub_Pet_Strong.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 伙伴 封印
		 */
		public static function get PET_SEAL_XML():String
		{
			return getXMLInstanceByName("Pub_Pet_Seal");
			var data1:ByteArray=Dc1("Pub_Pet_Seal.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 伙伴技能
		 */
		public static function get PETSKILLXML():String
		{
			return getXMLInstanceByName("Pub_Pet_Skill");
			var data1:ByteArray=Dc1("Pub_Pet_Skill.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 坐骑进阶
		 */
		public static function get SITZUPXML():String
		{
			return getXMLInstanceByName("Pub_Sitzup");
			var data1:ByteArray=Dc1("Pub_Sitzup.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 副本
		 */
		public static function get INSTANCEXML():String
		{
			return getXMLInstanceByName("Pub_Instance");
			var data1:ByteArray=Dc1("Pub_Instance.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 合服表
		 */
		public static function get COMBINE():String
		{
			return getXMLInstanceByName("Pub_Combine");
			var data1:ByteArray=Dc1("Pub_Combine.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 帮助
		 */
		public static function get HELPXML():String
		{
			return getXMLInstanceByName("Pub_Help");
			var data1:ByteArray=Dc1("Pub_Help.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 帮助二级菜单
		 */
		public static function get HELPDATAXML():String
		{
			return getXMLInstanceByName("Pub_Help_Data");
			var data1:ByteArray=Dc1("Pub_Help_Data.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 限制时间表
		 */
		public static function get LIMITTIMESXML():String
		{
			return getXMLInstanceByName("Pub_Limit_Times");
			var data1:ByteArray=Dc1("Pub_Limit_Times.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 技能buff
		 */
		public static function get SKILLBUFFXML():String
		{
			return getXMLInstanceByName("Pub_Skill_Buff");
			var data1:ByteArray=Dc1("Pub_Skill_Buff.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 地图区域
		 */
		public static function get MAPZONESXML():String
		{
			return getXMLInstanceByName("Pub_Map_Zones");
			var data1:ByteArray=Dc1("Pub_Map_Zones.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 炼丹
		 */
		public static function get COMPOSEXML():String
		{
			return getXMLInstanceByName("Pub_Compose");
			var data1:ByteArray=Dc1("Pub_Compose.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * vip表
		 */
		public static function get VIPXML():String
		{
			return getXMLInstanceByName("Pub_Vip");
			var data1:ByteArray=Dc1("Pub_Vip.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 每日活动，每日任务表
		 */
		public static function get ACTIONDESCXML():String
		{
			return getXMLInstanceByName("Pub_Action_Desc");
			var data1:ByteArray=Dc1("Pub_Action_Desc.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 成就，每日推荐
		 */
		public static function get ACHIEVEMENTXML():String
		{
			return getXMLInstanceByName("Pub_Achievement");
			var data1:ByteArray=Dc1("Pub_Achievement.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 新手目标
		 */
		public static function get ACTION_NEW():String
		{
			return getXMLInstanceByName("Pub_Action_New");
			var data1:ByteArray=Dc1("Pub_Action_New.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 评分提示表
		 */
		public static function get GRADEXML():String
		{
			return getXMLInstanceByName("Pub_Grade");
			var data1:ByteArray=Dc1("Pub_Grade.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 好友签名类型
		 */
		public static function get UNDERWRITETYPEXML():String
		{
			return getXMLInstanceByName("Pub_Underwrite_Type");
			var data1:ByteArray=Dc1("Pub_Underwrite_Type.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 角色升级属性
		 */
		public static function get ROLEPROPERTYXML():String
		{
			return getXMLInstanceByName("Pub_Role_Property");
			var data1:ByteArray=Dc1("Pub_Role_Property.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 会考答题
		 */
		public static function get THEMEXML():String
		{
			return getXMLInstanceByName("Pub_Theme");
			var data1:ByteArray=Dc1("Pub_Theme.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 境界表
		 */
		public static function get BOURNXML():String
		{
			return getXMLInstanceByName("Pub_Bourn");
			var data1:ByteArray=Dc1("Pub_Bourn.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * npc喊话表
		 */
		public static function get NPCSHOUTXML():String
		{
			return getXMLInstanceByName("Pub_Npc_Shout");
			var data1:ByteArray=Dc1("Pub_Npc_Shout.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 掉落表
		 */
		public static function get DROPXML():String
		{
			return getXMLInstanceByName("Pub_Drop");
			var data1:ByteArray=Dc1("Pub_Drop.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 神秘商店表
		 */
		public static function get SHOPMYSTERIOUSXML():String
		{
			return getXMLInstanceByName("Pub_Shop_Mysterious");
			var data1:ByteArray=Dc1("Pub_Shop_Mysterious.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 找回经验
		 */
		public static function get EXPBACKXML():String
		{
			return getXMLInstanceByName("Pub_Exp_Back");
			var data1:ByteArray=Dc1("Pub_Exp_Back.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 装备属性
		 */
		public static function get EQUIPPROPERTYXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Property");
			var data1:ByteArray=Dc1("Pub_Equip_Property.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 魔天万界
		 */
		public static function get DEMONWORLDXML():String
		{
			return getXMLInstanceByName("Pub_Demon_World");
			var data1:ByteArray=Dc1("Pub_Demon_World.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 魔天万界地图
		 */
		public static function get DEMONMAPXML():String
		{
			return getXMLInstanceByName("Pub_Demon_Map");
			var data1:ByteArray=Dc1("Pub_Demon_Map.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 未开放功能
		 */
		public static function get INTERFACECLEWXML():String
		{
			return getXMLInstanceByName("Pub_Interface_Clew");
			var data1:ByteArray=Dc1("Pub_Interface_Clew.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 通配符
		 */
		public static function get VARXML():String
		{
			return getXMLInstanceByName("Pub_Variable");
			var data1:ByteArray=Dc1("Pub_Variable.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 运营活动
		 * @return
		 *
		 */
		public static function get MANAGEACTIONXML():String
		{
			return getXMLInstanceByName("Pub_Manage_Action");
			var data1:ByteArray=Dc1("Pub_Manage_Action.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 升级目标
		 * @return
		 *
		 */
		public static function get UPTARGETXML():String
		{
			return getXMLInstanceByName("Pub_Uptarget");
			var data1:ByteArray=Dc1("Pub_Uptarget.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 装备附加属性固定
		 * @return
		 *
		 */
		public static function get PropertytackXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Propertytack");
			var data1:ByteArray=Dc1("Pub_Equip_Propertytack.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 套装表 2012-08-10
		 * @return
		 *
		 */
		public static function get SuitcomposeXML():String
		{
			return getXMLInstanceByName("Pub_Suitcompose");
			var data1:ByteArray=Dc1("Pub_Suitcompose.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 家族表
		 *
		 */
		public static function get FAMILYXML():String
		{
			return getXMLInstanceByName("Pub_Family");
			var data1:ByteArray=Dc1("Pub_Family.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 家族技能表
		 *
		 */
		public static function get FamilySkillXML():String
		{
			return getXMLInstanceByName("Pub_FamilySkill");
			var data1:ByteArray=Dc1("Pub_FamilySkill.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 技能升级表
		 */
		public static function get SkillLearnXML():String
		{
			return getXMLInstanceByName("Pub_Skilllearn");
			var data1:ByteArray=Dc1("Pub_Skilllearn.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get TopPrizeXML():String
		{
			return getXMLInstanceByName("Pub_Top_Prize");
			var data1:ByteArray=Dc1("Pub_Top_Prize.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 神武升级表【60级以上紫色装备】
		 *
		 */
		public static function get ToolcolorupXML():String
		{
			return getXMLInstanceByName("Pub_Toolcolorup");
			var data1:ByteArray=Dc1("Pub_Toolcolorup.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get ActionStartXML():String
		{
			return getXMLInstanceByName("Pub_Action_Start");
			var data1:ByteArray=Dc1("Pub_Action_Start.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}
		public static function get PubModelXML():String
		{
			return getXMLInstanceByName("Pub_Model");
		}

		public static function get NpcTalkXML():String
		{
			return getXMLInstanceByName("Pub_Npc_Talk");
			var data1:ByteArray=Dc1("Pub_Npc_Talk.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get QQYellowXML():String
		{
			return getXMLInstanceByName("Pub_Yellow");
//			var data1:ByteArray=Dc1("Pub_Yellow.txt");
//			var data2:String=Dc2(data1);
//			
//			return XML(data2);
		}

		public static function get COMMENDXML():String
		{
			return getXMLInstanceByName("Pub_Commend");
			var data1:ByteArray=Dc1("Pub_Commend.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get SHOUTXML():String
		{
			return getXMLInstanceByName("Pub_Shout_Content");
			var data1:ByteArray=Dc1("Pub_Shout_Content.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}
		public static function get NPCXML():String
		{
			return getXMLInstanceByName("Pub_Npc");
		}
		
		public static function get SKILLDATAXML():String
		{
			return getXMLInstanceByName("Pub_Skill_Data");
		}

		public static function get NPCSEEKXML():String
		{
			return getXMLInstanceByName("Pub_Action_Npc_Seek");
			var data1:ByteArray=Dc1("Pub_Action_Npc_Seek.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get NETSHOPXML():String
		{
			return getXMLInstanceByName("Pub_NetShop");
			var data1:ByteArray=Dc1("Pub_NetShop.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get UPDATEXML():String
		{
			return getXMLInstanceByName("Pub_UpDate");
			var data1:ByteArray=Dc1("Pub_UpDate.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get ENTERPRIZEXML():String
		{
			return getXMLInstanceByName("Pub_Enter_Prize");
			var data1:ByteArray=Dc1("Pub_Enter_Prize.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get REFOUND2XML():String
		{
			return getXMLInstanceByName("Pub_Equip_Refound_2");
			var data1:ByteArray=Dc1("Pub_Equip_Refound_2.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get EQUIPSOUlXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Soul");
			var data1:ByteArray=Dc1("Pub_Equip_Soul.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get EQUIPSOUlSTRONGXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Soul_Strong");
			var data1:ByteArray=Dc1("Pub_Equip_Soul_Strong.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get CONVOYXML():String
		{
			return getXMLInstanceByName("Pub_Convoy");
			var data1:ByteArray=Dc1("Pub_Convoy.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get SITZUPSTRONGXML():String
		{
			return getXMLInstanceByName("Pub_Sitzup_Strong");
			var data1:ByteArray=Dc1("Pub_Sitzup_Strong.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get ACTIONPAYXML():String
		{
			return getXMLInstanceByName("Pub_Action_Pay");
			var data1:ByteArray=Dc1("Pub_Action_Pay.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get QQINVITEFRIENDXML():String
		{
			return getXMLInstanceByName("Pub_QQInviteFriend");
			var data1:ByteArray=Dc1("Pub_QQInviteFriend.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get TOOLATTRXML():String
		{
			return getXMLInstanceByName("Pub_Tool_Attr");
			var data1:ByteArray=Dc1("Pub_Tool_Attr.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get COLORSTRONGXML():String
		{
			return getXMLInstanceByName("Pub_Colour_Strong");
			var data1:ByteArray=Dc1("Pub_Colour_Strong.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get GEMCOMPOSEXML():String
		{
			return getXMLInstanceByName("Pub_Gem_Compose");
			var data1:ByteArray=Dc1("Pub_Gem_Compose.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get PUBESOTERICAXML():String
		{
			return getXMLInstanceByName("Pub_Esoterica");
			var data1:ByteArray=Dc1('Pub_Esoterica.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBSYSEFFECTXML():String
		{
			return getXMLInstanceByName("Pub_Sys_Effect");
			var data1:ByteArray=Dc1('Pub_Sys_Effect.txt');
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get PubBournStarXML():String
		{
			return getXMLInstanceByName("Pub_Bourn_Star");
			var data1:ByteArray=Dc1('Pub_Bourn_Star.txt');
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get PUBSITZUPSKILLXML():String
		{
			return getXMLInstanceByName("Pub_Sitzup_Skill");
			var data1:ByteArray=Dc1('Pub_Sitzup_Skill.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBSITZUPUPXML():String
		{
			return getXMLInstanceByName("Pub_Sitzup_Up");
			var data1:ByteArray=Dc1('Pub_Sitzup_Up.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBSITZUPSHOWXML():String
		{
			return getXMLInstanceByName("Pub_Sitzup_Show");
			var data1:ByteArray=Dc1('Pub_Sitzup_Show.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBSITZUPNAMEXML():String
		{
			return getXMLInstanceByName("Pub_Sitzup_Name");
			var data1:ByteArray=Dc1('Pub_Sitzup_Name.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYITEMSHOPXML():String
		{
			return getXMLInstanceByName("Pub_Family_ItemShop");
			var data1:ByteArray=Dc1('Pub_Family_ItemShop.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYSKILLTREECONFIGXML():String
		{
			return getXMLInstanceByName("Pub_Family_Skill_Tree_Config");
			var data1:ByteArray=Dc1('Pub_Family_Skill_Tree_Config.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYSKILLTREEXML():String
		{
			return getXMLInstanceByName("Pub_Family_Skill_Tree");
			var data1:ByteArray=Dc1('Pub_Family_Skill_Tree.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYBOSSXML():String
		{
			return getXMLInstanceByName("Pub_FamilyBoss");
			var data1:ByteArray=Dc1('Pub_FamilyBoss.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYITEMXML():String
		{
			return getXMLInstanceByName("Pub_FamilyItem");
			var data1:ByteArray=Dc1('Pub_FamilyItem.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYXML():String
		{
			return getXMLInstanceByName("Pub_Family");
			var data1:ByteArray=Dc1('Pub_Family.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYSKILLLEARNXML():String
		{
			return getXMLInstanceByName("Pub_FamilySkill_Learn");
			var data1:ByteArray=Dc1('Pub_FamilySkill_Learn.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYSKILLXML():String
		{
			return getXMLInstanceByName("Pub_FamilySkill");
			var data1:ByteArray=Dc1('Pub_FamilySkill.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFLYMASKPATHXML():String
		{
			return getXMLInstanceByName("Pub_Fly_Mask_Path");
			var data1:ByteArray=Dc1('Pub_Fly_Mask_Path.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBPLAYDEMESNEXML():String
		{
			return getXMLInstanceByName("Pub_Play_Demesne");
			var data1:ByteArray=Dc1('Pub_Play_Demesne.txt');
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		public static function get PUBFAMILYSKILLLISTXML():String
		{
			return getXMLInstanceByName("Pub_FamilySkillList");
			var data1:ByteArray=Dc1('Pub_FamilySkillList.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBLIMITTIMESXML():String
		{
			return getXMLInstanceByName("Pub_Limit_Times");
			var data1:ByteArray=Dc1('Pub_Limit_Times.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYITEMLISTXML():String
		{
			return getXMLInstanceByName("Pub_FamilyItemList");
			var data1:ByteArray=Dc1('Pub_FamilyItemList.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYBOSSLISTXML():String
		{
			return getXMLInstanceByName("Pub_FamilyBossList");
			var data1:ByteArray=Dc1('Pub_FamilyBossList.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBFAMILYLEAGUERLVXML():String
		{
			return getXMLInstanceByName("Pub_Family_Leaguer_Lv");
			var data1:ByteArray=Dc1('Pub_Family_Leaguer_Lv.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBSOUNDXML():String
		{
			return getXMLInstanceByName("Pub_Sound");
			var data1:ByteArray=Dc1('Pub_Sound.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get TITLEXML():String
		{
			return getXMLInstanceByName("Pub_Title");
			var data1:ByteArray=Dc1('Pub_Title.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBEFFECTSOUNDXML():String
		{
			return getXMLInstanceByName("Pub_Effect_Sound");
			var data1:ByteArray=Dc1('Pub_Effect_Sound.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBCHANGEXML():String
		{
			return getXMLInstanceByName("Pub_Change");
			var data1:ByteArray=Dc1('Pub_Change.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBESOTERICALISTXMLXML():String
		{
			return getXMLInstanceByName('Pub_Esoterica_List');
			var data1:ByteArray=Dc1('Pub_Esoterica_List.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBACTIONFOREXML():String
		{
			return getXMLInstanceByName('Pub_Action_Fore');
			var data1:ByteArray=Dc1('Pub_Action_Fore.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBPAYMENTSTARTXML():String
		{
			return getXMLInstanceByName('Pub_Payment_Start');
			var data1:ByteArray=Dc1('Pub_Payment_Start.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBBLADEXML():String
		{
			return getXMLInstanceByName('Pub_Blade');
			var data1:ByteArray=Dc1('Pub_Blade.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		/*************初始化策略**************/
		public static function init():void
		{
			initServerMsg();
		}

		/**
		 *	msg.xml 2012-10-17
		 */
		private static function initServerMsg():void
		{
			var obj:Object=null;
			var start:int=flash.utils.getTimer();
			for each (var item:XML in XmlConfig.MSGXML..e)
			{
				obj={type: int(item.@p), msg: String(item.@m), t: int(item.@t), l: int(item.@l), s: int(item.@s), ui: int(item.@ui)};
				Lang.mapServerMsg.put(int(item.@i), obj);
			}
		}

		/**
		 *至尊 vip表
		 */
		public static function get VIPTYPEXML():String
		{
			return getXMLInstanceByName("Pub_Vip_Type");
			var data1:ByteArray=Dc1("Pub_Vip_Type.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 *鉴定表
		 */
		public static function get IDENTIFYXML():String
		{
			return getXMLInstanceByName("Pub_Identify");
			var data1:ByteArray=Dc1("Pub_Identify.txt");
			var data2:String=Dc2(data1);
			return XML(data2);
		}

		/**
		 * 珍宝阁表
		 */
		public static function get PUBSHOPIBXML():String
		{
			return getXMLInstanceByName("Pub_Shop_Ib");
		}

		/**
		 * 珍宝阁分页表
		 */
		public static function get PUBIBSHOPPAGEXML():String
		{
			return getXMLInstanceByName("Pub_Ibshop_Page");
		}

		/**
		 * 传承等级差限制表
		 */
		public static function get PUBEQUIPHEIRXML():String
		{
			return getXMLInstanceByName("Pub_Equip_Heir");
		}

		public static function get PUBQQSHARERESMODELXML():String
		{
			return getXMLInstanceByName('Pub_QQShare');
			var data1:ByteArray=Dc1('Pub_QQShare.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBPACKOPENXML():String
		{
			return getXMLInstanceByName('Pub_Pack_Open');
			var data1:ByteArray=Dc1('Pub_Pack_Open.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get SOARXML():String
		{
			return getXMLInstanceByName('Pub_Soar');
			var data1:ByteArray=Dc1('Pub_Soar.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get WINGXML():String
		{
			return getXMLInstanceByName('Pub_Wing');
			var data1:ByteArray=Dc1('Pub_Wing.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}
		public static function get GODXML():String
		{
			return getXMLInstanceByName('Pub_God');
			var data1:ByteArray=Dc1('Pub_God.txt');
			var data2:String=Dc2(data1);
			
			return XML(data2)
			
		}
		public static function get PUBVIPPROMPTXML():String
		{
			return getXMLInstanceByName('Pub_Vip_Prompt');
			var data1:ByteArray=Dc1('Pub_Vip_Prompt.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBEQUPSTRONGCONSTXML():String
		{
			return getXMLInstanceByName('Pub_Equip_Strong_Cost');
			var data1:ByteArray=Dc1('Pub_Equip_Strong_Cost.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBEXPLOITXML():String
		{
			return getXMLInstanceByName('Pub_Exploit');
			var data1:ByteArray=Dc1('Pub_Exploit.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBEXPACTIONPRIZEXML():String
		{
			return getXMLInstanceByName('Pub_Exp_Action_Prize');
			var data1:ByteArray=Dc1('Pub_Exp_Action_Prize.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		/**
		 *天书
		 * @return
		 */
		public static function get PUBTIANSHUXML():String
		{
			return getXMLInstanceByName('Pub_Heaven');
			var data1:ByteArray=Dc1('Pub_Heaven.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PUBGEMXML():String
		{
			return getXMLInstanceByName('Pub_Gem');
			var data1:ByteArray=Dc1('Pub_Gem.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		/**
		 *结婚的三个礼包
		 * @return
		 *
		 */
		public static function get PubMarriagePackXML():String
		{
			return getXMLInstanceByName("Pub_Marriage_Pack");
			var data1:ByteArray=Dc1('Pub_Marriage_Pack.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}

		public static function get PubMarriageBeatitudeXML():String
		{
			return getXMLInstanceByName("Pub_Marriage_Beatitude");
			var data1:ByteArray=Dc1('Pub_Marriage_Beatitude.txt');
			var data2:String=Dc2(data1);
			return XML(data2)
		}
		
		public static function get PUBINVESTXML():String
		{
				return getXMLInstanceByName('Pub_Invest');
				
		}
		public static function get PUBINVESTREPAYXML():String
		{
				return getXMLInstanceByName('Pub_Invest_Repay');
				
		}
	}
}
