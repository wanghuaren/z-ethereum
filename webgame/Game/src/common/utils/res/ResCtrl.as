package common.utils.res
{
	import com.engine.utils.HashMap;
	
	import common.config.Att;
	import common.config.AttModel;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.bit.BitUtil;
	
	import engine.load.Gamelib;
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import scene.kingname.KingNameColor;
	
	import ui.base.beibao.BeiBao;
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.jineng.Jineng;
	import ui.frame.FontColor;
	import ui.frame.Image;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.Metier;
	import ui.view.view2.liandanlu.LianDanLu;
	import ui.view.view2.liandanlu.QH;
	import ui.view.view5.jiazu.JiaZu;
	
	import world.FileManager;

	/**
	 * 悬浮填值
	 * 道具，装备，技能，星魂，阵法
	 * 2011-12-27
	 */
	public class ResCtrl
	{
		/**
		 * 2013-06-08 装备是否可操作
		第1位	穿
		第2位	脱
		第3位	冲星
		第4位	鉴定
		第5位	重铸
		第6位	镶嵌宝石
		第7位	吞噬
		第8位	被吞噬
		第9位	传承
		第10位	神武
		第11位	觉醒
		第12位	升级
		 * */
		public static const CHUAN:int=1;
		public static const TUO:int=2;
		public static const CHONG_XING:int=3;
		public static const JIAN_DING:int=4;
		public static const ZHONG_ZHU:int=5;
		public static const XIANG_QIAN:int=6;
		public static const TUN_SHI:int=7;
		public static const BEI_TUN_SHI:int=8;
		public static const CHUAN_CHNEG:int=9;
		public static const SHEN_WU:int=10;
		public static const JUE_XING:int=11;
		public static const SHENG_JI:int=12;
		private var mc_zhuangBeiArr:Array=[];
		//2012-12-24 神器完美强化 额外增加
		private var arrShenQiStong:Array=[10, 15, 18, 20];
		//悬浮空格 
		private const TIP_SPACE:String="";
		//
		private var _mc_jiNeng:Sprite;
		private var m_skillData:Array=null;
		private var mc_daoJu_uil:Image=new Image
		private var mc_danFang_uil:Image=new Image
		private var panel_uil:Image=new Image;
		private var mc_jiNeng_pet_uil:Image=new Image;
		private var mc_ji_neng_s1234_f1_uil:Image=new Image;
		private var mc_ji_neng_s0_f0_uil:Image=new Image;
		private var mc_xingHun_mc_icon_uil:Image=new Image;
		private var mc_jiNengShu_uil:Image=new Image;
		private var mc_usedTimes_uil:Image=new Image;
		private var mc_basic_mc_icon_uil:Image=new Image
		private var basic_mc_icon_uil:Image=new Image;

		public function get mc_jiNeng():Sprite
		{
			if (null == _mc_jiNeng)
			{
				_mc_jiNeng=gamelib.getswflink("game_index", "mc_ji_neng1") as Sprite;
			}
			return _mc_jiNeng;
		}
		private var _mc_jiNeng2:Sprite;

		public function get mc_jiNeng2():Sprite
		{
			if (null == _mc_jiNeng2)
			{
				_mc_jiNeng2=gamelib.getswflink("game_index", "mc_ji_neng2") as Sprite;
			}
			return _mc_jiNeng2;
		}
		private var _mc_ji_neng_s0_f0:MovieClip;

		public function get mc_ji_neng_s0_f0():MovieClip
		{
			if (null == _mc_ji_neng_s0_f0)
			{
				_mc_ji_neng_s0_f0=gamelib.getswflink("game_index", "mc_ji_neng_s0_f0") as MovieClip;
			}
			return _mc_ji_neng_s0_f0;
		}

		public function has_mc_ji_neng_s0_f0():Boolean
		{
			if (null == _mc_ji_neng_s0_f0)
			{
				return false;
			}
			return true;
		}
		private var _mc_ji_neng_s123_f0:MovieClip;

		public function get mc_ji_neng_s123_f0():MovieClip
		{
			if (null == _mc_ji_neng_s123_f0)
			{
				_mc_ji_neng_s123_f0=gamelib.getswflink("game_index", "mc_ji_neng_s123_f0") as MovieClip;
			}
			return _mc_ji_neng_s123_f0;
		}
		private var _mc_ji_neng_s1234_f1:MovieClip;

		public function get mc_ji_neng_s1234_f1():MovieClip
		{
			if (null == _mc_ji_neng_s1234_f1)
			{
				_mc_ji_neng_s1234_f1=gamelib.getswflink("game_index", "mc_ji_neng_s1234_f1") as MovieClip;
			}
			return _mc_ji_neng_s1234_f1;
		}
		//
		private var _mc_jiNeng3:Sprite;

		public function get mc_jiNeng3():Sprite
		{
			if (null == _mc_jiNeng3)
			{
				_mc_jiNeng3=gamelib.getswflink("game_index", "mc_ji_neng3") as Sprite;
			}
			return _mc_jiNeng3;
		}
		//
		private var _mc_jiNeng4:Sprite;

		public function get mc_jiNeng4():Sprite
		{
			if (null == _mc_jiNeng4)
			{
				_mc_jiNeng4=gamelib.getswflink("game_index", "mc_ji_neng4") as Sprite;
			}
			return _mc_jiNeng4;
		}
		//
		private var _mc_jiNeng5:Sprite;

		public function get mc_jiNeng5():Sprite
		{
			if (null == _mc_jiNeng5)
			{
				_mc_jiNeng5=gamelib.getswflink("game_index", "mc_ji_neng5") as Sprite;
			}
			return _mc_jiNeng5;
		}
		//
		private var _mc_jiNeng6:Sprite;

		public function get mc_jiNeng6():Sprite
		{
			if (null == _mc_jiNeng6)
			{
				_mc_jiNeng6=gamelib.getswflink("game_index", "mc_ji_neng6") as Sprite;
			}
			return _mc_jiNeng6;
		}
		//
		private var _mc_jiNeng7:Sprite;

		public function get mc_jiNeng7():Sprite
		{
			if (null == _mc_jiNeng7)
			{
				_mc_jiNeng7=gamelib.getswflink("game_index", "mc_ji_neng7") as Sprite;
			}
			return _mc_jiNeng7;
		}
		private var _mc_jiNeng_pet:Sprite;

		//活动宠物技能皮肤
		public function get mc_jiNeng_pet():Sprite
		{
			if (null == _mc_jiNeng_pet)
			{
				_mc_jiNeng_pet=gamelib.getswflink("game_index", "mc_ji_neng3") as Sprite;
			}
			return _mc_jiNeng_pet;
		}
		//
		private var _mc_xingHun:Sprite;

		public function get mc_xingHun():Sprite
		{
			if (null == _mc_xingHun)
			{
				_mc_xingHun=gamelib.getswflink("game_index", "mc_xing_hun") as Sprite;
			}
			return _mc_xingHun;
		}
		//
		private var _mc_zhenYing:Sprite;

		public function get mc_zhenYing():Sprite
		{
			if (null == _mc_zhenYing)
			{
				_mc_zhenYing=gamelib.getswflink("game_index", "mc_zhen_ying") as Sprite;
			}
			return _mc_zhenYing;
		}
		//
		private var _mc_jiNengShu:Sprite;

		public function get mc_jiNengShu():Sprite
		{
			if (null == _mc_jiNengShu)
			{
				_mc_jiNengShu=gamelib.getswflink("game_index", "mc_ji_neng_shu") as Sprite;
			}
			return _mc_jiNengShu;
		}
		//
		private var _mc_danFang:Sprite;

		public function get mc_danFang():Sprite
		{
			if (null == _mc_danFang)
			{
				_mc_danFang=gamelib.getswflink("game_index", "mc_dan_fang") as Sprite;
			}
			return _mc_danFang;
		}
		//
		private var _mc_loading:Sprite;

		public function get mc_loading():Sprite
		{
			if (null == _mc_loading)
			{
				_mc_loading=gamelib.getswflink("game_index", "mc_loading") as Sprite;
			}
			return _mc_loading;
		}
		//
		private var _mc_siShenQi:Sprite;

		public function get mc_siShenQi():Sprite
		{
			if (null == _mc_siShenQi)
			{
				_mc_siShenQi=gamelib.getswflink("game_index", "xuanfu_fourShenQi") as Sprite;
			}
			return _mc_siShenQi;
		}
		private var _mc_bag_not_open1:Sprite;

		public function get mc_bag_not_open1():Sprite
		{
			if (null == _mc_bag_not_open1)
			{
				_mc_bag_not_open1=gamelib.getswflink("game_index", "mc_bei_bao_kai_qi1") as Sprite;
			}
			return _mc_bag_not_open1;
		}
		private var _mc_bag_not_open2:Sprite;

		public function get mc_bag_not_open2():Sprite
		{
			if (null == _mc_bag_not_open2)
			{
				_mc_bag_not_open2=gamelib.getswflink("game_index", "mc_bei_bao_kai_qi2") as Sprite;
			}
			return _mc_bag_not_open2;
		}
		//
		private var _mc_daoJu:Sprite;

		public function get mc_daoJu():Sprite
		{
			if (null == _mc_daoJu)
			{
				_mc_daoJu=gamelib.getswflink("game_index", "mc_dao_ju") as Sprite;
			}
			return _mc_daoJu;
		}
		/**
		 *	2012-12-03 道具【使用次数】
		 */
		private var _mc_usedTimes:Sprite;

		public function get mc_usedTimes():Sprite
		{
			if (null == _mc_usedTimes)
			{
				_mc_usedTimes=gamelib.getswflink("game_index", "mc_used_times") as Sprite;
			}
			return _mc_usedTimes;
		}
		/**
		 *	2013-08-12 道具【封印的宠物蛋】
		 */
		private var _mc_chongWuDan:Sprite;

		public function get mc_chongWuDan():Sprite
		{
			if (null == _mc_chongWuDan)
			{
				_mc_chongWuDan=gamelib.getswflink("game_index", "win_chong_wu_dan") as Sprite;
			}
			return _mc_chongWuDan;
		}
		/**
		 * 装备品质1.白色 2.黄色 3.绿色 4.蓝色 5.紫色 6.红色
		*/
		public const arrColor:Array=["", FontColor.COLOR_TOOL_1, FontColor.COLOR_TOOL_2, FontColor.COLOR_TOOL_3, FontColor.COLOR_TOOL_4, FontColor.COLOR_TOOL_5, FontColor.COLOR_TOOL_6];

		//装备品名--wanghuaren
//		<t k='pub_fan_pin'>凡品</t>
//				<t k='pub_ling_pin'>灵品</t>
//				<t k='pub_tian_pin'>天品</t>
//				<t k='pub_xian_pin'>仙品</t>
//				<t k='pub_shen_pin'>神品</t>
		public function get arrTitle():Array
		{
			return [Lang.getLabel("pub_fan_pin"), Lang.getLabel("pub_ling_pin"), Lang.getLabel("pub_tian_pin"), Lang.getLabel("pub_xian_pin"), Lang.getLabel("pub_shen_pin")];
		}
		/**
		 *	装备强化属性名字 黑铁1级
		 */
		private var mapStrongName:HashMap=null;
		private var tf:TextFormat=null;
		private var i:int=0;
		private var bag:StructBagCell2=null;
		private var skillM:Pub_SkillResModel=null;
		private var skillM_pet:Pub_SkillResModel=null;
		private var jzSkill:Pub_SkillResModel=null;
		private var _gamelib:Gamelib;

		public function get gamelib():Gamelib
		{
			if (null == _gamelib)
			{
				_gamelib=new Gamelib();
			}
			return _gamelib;
		}
		private static var _instance:ResCtrl=null;

		public static function instance():ResCtrl
		{
			if (_instance == null)
			{
				_instance=new ResCtrl();
			}
			return _instance;
		}

		public function ResCtrl()
		{
			init();
		}

		/**
		 *	初始化
		 */
		private function init():void
		{
			if (null == m_skillData)
			{
				m_skillData=XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			if (GamelibS.isApplicationClass("mc_zhuang_bei"))
			{
				mc_zhuangBeiArr.push(gamelib.getswflink("game_index", "mc_zhuang_bei") as Sprite);
				mc_zhuangBeiArr.push(gamelib.getswflink("game_index", "mc_zhuang_bei") as Sprite);
				mc_zhuangBeiArr.push(gamelib.getswflink("game_index", "mc_zhuang_bei") as Sprite);
			}
			tf=new TextFormat();
			tf.leading=3;
		}

		/**
		 *	获得悬浮面板信息
		 * 第二个参数是辅助数据,用以其它非常规需求
		 */
		public function getNewDesc(data:Object, data2:Object=null):Sprite
		{
			if (data == null)
				return mc_loading;
			//四神器
			if (data.hasOwnProperty("shenqi_id"))
			{
				return siShenQi(data);
			}
			//2013-11-20 andy 包裹格子未开启悬浮
			if (data.hasOwnProperty("cellId"))
			{
				return this.bagNotOpenTip(data);
			}
			var id:String=getID(data);
			if (id == "")
				id=getID(data[0]);
			var ret:Sprite=null;
			var type:int=int(id.substr(0, 3));
			switch (type)
			{
				case 101:
				case 102:
				case 103:
				case 104:
				case 106:
				case 107:
				case 108:
				case 109:
				case 114:
				case 115:
				case 116:
				case 117:
				case 118:
				case 119:
				case 122:
				case 123:
				case 124:
				case 125:
				case 128:
				case 129:
				case 130:
				case 120:
					ret=daoJu(data);
					break;
				case 105:
					ret=danFang(data);
					break;
				case 110:
				case 111:
					ret=jiNengShu(data);
					break;
				case 112:
					ret=xinghun(data);
					break;
				case 113:
				case 121:
				case 127:
					ret=zhuangBei(data);
					break;
				case 120:
					//ret=usedTimes(data);
					break;
				case 126:
					ret=petEgg(data);
					break;
				case 401:
				case 402:
				case 405:
				case 406:
				case 407:
				case 408:
				case 409:
					ret=jiNeng(data);
					break;
				case 410:
					ret=jzJiNeng(data, data2);
					break;
				case 404:
					ret=jiNengPet(data);
					break;
				default:
					break;
			}
			if (ret == null)
			{
				ret=new Sprite();
			}
			return ret;
		}

		/**
		 *	获得ID
		 */
		public function getID(rowData:Object):String
		{
			if (rowData == null)
				return "";
			var resID:String="";
			if (rowData.hasOwnProperty("id"))
			{
				resID=rowData.id;
			}
			else if (rowData.hasOwnProperty("itemid"))
			{
				resID=rowData.itemid;
			}
			else if (rowData.hasOwnProperty("skill_id"))
			{
				resID=rowData.skill_id;
			}
			else if (rowData.hasOwnProperty("skillId"))
			{
				resID=rowData.skillId;
			}
			else if (rowData.hasOwnProperty("suit_id"))
			{
				resID=rowData.suit_id;
			}
			else
			{
				resID="";
			}
			return resID;
		}

		/**
		 *	家族总成面板，家族技能悬浮
		 */
		public function jzJiNeng(data:Object, data2:Object):Sprite
		{
			jzSkill=data as Pub_SkillResModel;
			if (null == jzSkill)
				return null;
			//等级
			var skillLvl:Vector.<int>=Data.jiaZu.GetGuildMoreInfo().arrItemskillLvlList;
			var skillArr:Array=JiaZu.skill_data;
			var jLen:int=skillArr.length;
			var j:int;
			var lvl:int=0;
			for (j=0; j < jLen; j++)
			{
				if (jzSkill.skill_id == skillArr[j])
				{
					lvl=skillLvl[j];
					break;
				}
			}
			//0 处于已激活，但未学习过的状态
			//技能是从1级开始的，没有0级
			//var skillData:Pub_Skill_DataResModel=XmlManager.localres.SkillDataXml.getResPath(jzSkill.skill_id * 100 + lvl);
			//var skillDataNext:Pub_Skill_DataResModel=XmlManager.localres.SkillDataXml.getResPath(jzSkill.skill_id * 100 + lvl + 1);
			var skillData:Pub_Skill_DataResModel=null;
			var skillDataNext:Pub_Skill_DataResModel=null;
			var skillDataMaxLvl:Pub_Skill_DataResModel=null;
			if (lvl > 0)
			{
				//skillData=XmlManager.localres.SkillDataXml.getResPath(jzSkill.skill_id * 100 + lvl - 1);
				skillData=m_skillData[(jzSkill.skill_id * 100 + lvl - 1)];
			}
			if (lvl >= 0)
			{
				//skillDataNext=XmlManager.localres.SkillDataXml.getResPath(jzSkill.skill_id * 100 + lvl);
				skillDataNext=m_skillData[(jzSkill.skill_id * 100 + lvl)];
			}
			skillDataMaxLvl=m_skillData[(jzSkill.skill_id * 100 + 10 - 1)];
			if (null != mc_jiNeng4 && null != mc_jiNeng5 && null != mc_jiNeng6 && null != mc_jiNeng7)
			{
				var panel:Sprite=mc_jiNeng4;
				//if (data2.toString().indexOf("picSkillUp") >= 0)
				if (data2.toString().indexOf("pic") >= 0)
				{
					if (lvl == 10)
					{
						//已满级
						panel=mc_jiNeng7;
						panel["txt_skill_level"].htmlText="<b>" + lvl.toString() + " " +
							//"级" + 
							Lang.getLabel("pub_ji") + "</b>";
						panel["jihuo"].text=Lang.getLabel("20093_ResCtrl"); //"此技能已达最大等级";
						if (null != skillData)
						{
							panel["miaoshu"].htmlText=skillData.skill_desc;
						}
					}
					else if (lvl > 0)
					{
						panel=mc_jiNeng6;
						panel["miaoshu_next"].htmlText=skillDataNext.skill_desc;
						panel["jihuo"].text=Lang.getLabel("20094_ResCtrl"); //"下一等级";
						panel["txt_skill_level"].htmlText="<b>" + lvl.toString() + " " +
							//"级" + 
							Lang.getLabel("pub_ji") + "</b>";
						if (null != skillData)
						{
							panel["miaoshu"].htmlText=skillData.skill_desc;
						}
					}
					else
					{
						panel=mc_jiNeng5;
						//panel["miaoshu"].htmlText= "升级最终效果：" + skillDataMaxLvl.skill_desc;
						panel["miaoshu"].htmlText=Lang.getLabel("20095_ResCtrl") + "：" + skillDataMaxLvl.skill_desc;
					}
				} //end if
				if (data2.toString().indexOf("picSkillActiva") >= 0)
				{
					//panel["jihuo"].text= "激活后可学习此技能";
					//panel["jihuo"].text= "尚未激活";//激活升级";
					//skillData=XmlManager.localres.SkillDataXml.getResPath(jzSkill.skill_id * 100);
					skillData=m_skillData[(jzSkill.skill_id * 100)];
					//panel["miaoshu"].htmlText= "升级最终效果：" + skillDataMaxLvl.skill_desc;
					panel["miaoshu"].htmlText=Lang.getLabel("20095_ResCtrl") + "：" + skillDataMaxLvl.skill_desc;
				}
				//公共
				panel["skill_name"].text=data.skill_name;
//				if (null != panel["uil"])
//					panel["uil"].source=FileManager.instance.getSkillIconXById(jzSkill.icon);
//				
//				if(!panel_uil.parent)
//				{
//					panel.addChild(panel_uil);
//					
//				}
//				panel_uil.source=FileManager.instance.getSkillIconXById(jzSkill.icon);
//				imageSetup(panel["uil"], panel_uil, FileManager.instance.getSkillIconXById(jzSkill.icon));
				ImageUtils.replaceImage(panel,panel["uil"],FileManager.instance.getSkillIconXById(jzSkill.icon));
				return panel;
			}
			return null;
		}

		/**
		 * 从已经学习的技能列表中找到该技能的数据
		 * @param skillID
		 * @return
		 *
		 */
		private function _findStudySkill(skillID:int):StructSkillItem2
		{
			/*var _studySkillList:Vector.<StructSkillItem2>=Jineng.studySkillList;
			var _length:int=_studySkillList.length;
			var _ret:StructSkillItem2=null;
			for (var i:int=0; i < _length; ++i)
			{
				if (skillID == _studySkillList[i].skillId)
				{
					_ret=_studySkillList[i];
						//break;
				}
			}
			return _ret;
			*/
			return Data.skill.getSkill(skillID);
		}

		public function jiNengPet(data:Object=null):Sprite
		{
			skillM_pet=data as Pub_SkillResModel;
			if (mc_jiNeng_pet != null)
			{
				if (null != mc_jiNeng_pet['skill_name'])
				{
					mc_jiNeng_pet['skill_name'].htmlText=data.skill_name;
				}
//				if (null != mc_jiNeng_pet["uil"])
//				{
//					mc_jiNeng_pet["uil"].source=FileManager.instance.getSkillIconXById(skillM_pet.icon);
//				}
//				if(!mc_jiNeng_pet_uil.parent)
//				{
//					mc_jiNeng_pet.addChild(mc_jiNeng_pet_uil)
//				}
//				
//				mc_jiNeng_pet_uil.source=FileManager.instance.getSkillIconXById(skillM_pet.icon);
//				
//				imageSetup(mc_jiNeng_pet["uil"], mc_jiNeng_pet_uil, FileManager.instance.getSkillIconXById(skillM_pet.icon));
				ImageUtils.replaceImage(mc_jiNeng_pet,mc_jiNeng_pet["uil"],FileManager.instance.getSkillIconXById(skillM_pet.icon));
				if (null != mc_jiNeng_pet["miaoshu"])
				{
					mc_jiNeng_pet["miaoshu"].htmlText=skillM_pet.description;
				}
			}
			return mc_jiNeng_pet;
		}

		/**
		 *	技能悬浮
		 */
		public function jiNeng(data:Object=null):Sprite
		{
			if (null == mc_ji_neng_s0_f0)
			{
				return null;
			}
			if (null == mc_ji_neng_s0_f0["skill_miaoshu"])
			{
				_mc_ji_neng_s0_f0=null;
				mc_ji_neng_s0_f0;
			}
			skillM=data as Pub_SkillResModel;
			if (null == skillM)
			{
				skillM=data.skillModel;
			}
			if (skillM == null)
			{
				return null;
			}
			var skill_level:int=1;
			if (0 >= data.skillLevel)
			{
				skill_level=1;
			}
			else
			{
				skill_level=data.skillLevel;
			}
			//			
			//			
			var _psdr_id:int=data.skillId * 100 + skill_level - 1;
			var _psdr_next_id:int=data.skillId * 100 + skill_level;
			//var psdr:Pub_Skill_DataResModel=XmlManager.localres.SkillDataXml.getResPath(_psdr_id);
			var psdr:Pub_Skill_DataResModel=m_skillData[(_psdr_id)];
			//var psdr_next:Pub_Skill_DataResModel=XmlManager.localres.SkillDataXml.getResPath(_psdr_next_id);
			var psdr_next:Pub_Skill_DataResModel=m_skillData[(_psdr_next_id)];
			//if (skillM.skill_series == 0 && skillM.passive_flag == 0 && mc_ji_neng_s0_f0 != null)
			if (skillM.skill_series == 0 && mc_ji_neng_s0_f0 != null)
			{
				if (skill_level >= data.max_level)
				{
					mc_ji_neng_s0_f0.gotoAndStop(2);
						//mc_ji_neng_s0_f0.gotoAndStop(1);
				}
				else
				{
					mc_ji_neng_s0_f0.gotoAndStop(1);
				}
				//--------------------------------------------------------------
				if (null != mc_ji_neng_s0_f0["mc_study"])
				{
					if (data.hasStudy)
					{
						mc_ji_neng_s0_f0["mc_study"].gotoAndStop(1);
					}
					else
					{
						mc_ji_neng_s0_f0["mc_study"].gotoAndStop(2);
					}
				}
				if (null != mc_ji_neng_s0_f0["skill_name"])
					mc_ji_neng_s0_f0["skill_name"].htmlText=data.skill_name;
				if (null != mc_ji_neng_s0_f0["skill_name_max"])
					mc_ji_neng_s0_f0["skill_name_max"].htmlText=data.skill_name;
				if (null != mc_ji_neng_s0_f0["skill_level"])
					mc_ji_neng_s0_f0["skill_level"].htmlText=skill_level + Lang.getLabel("pub_ji");
				if (null != mc_ji_neng_s0_f0["skill_level_max"])
					mc_ji_neng_s0_f0["skill_level_max"].htmlText=skill_level + Lang.getLabel("pub_ji");
//				imageSetup(mc_ji_neng_s0_f0["uil"], mc_ji_neng_s0_f0_uil, FileManager.instance.getSkillIconXById(skillM.icon));
				ImageUtils.replaceImage(mc_ji_neng_s0_f0,mc_ji_neng_s0_f0["uil"],FileManager.instance.getSkillIconXById(skillM.icon));
				if (null != mc_ji_neng_s0_f0["skill_lengque_shijian"] && psdr != null)
					mc_ji_neng_s0_f0["skill_lengque_shijian"].htmlText=psdr.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
				if (null != mc_ji_neng_s0_f0["skill_lengque_shijian_max"] && psdr != null)
					mc_ji_neng_s0_f0["skill_lengque_shijian_max"].htmlText=psdr.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
				//技能消耗
				if (null != mc_ji_neng_s0_f0["skill_lingli_xiaohao"])
					mc_ji_neng_s0_f0["skill_lingli_xiaohao"].htmlText=getSkillXiaoHaoByXuanFu(psdr);
				if (null != mc_ji_neng_s0_f0["skill_lingli_xiaohao_max"])
					mc_ji_neng_s0_f0["skill_lingli_xiaohao_max"].htmlText=getSkillXiaoHaoByXuanFu(psdr);
				if (null != mc_ji_neng_s0_f0["skill_shifang_juli"])
					mc_ji_neng_s0_f0["skill_shifang_juli"].htmlText=skillM.max_range;
				if (null != mc_ji_neng_s0_f0["skill_shifang_juli_max"])
					mc_ji_neng_s0_f0["skill_shifang_juli_max"].htmlText=skillM.max_range;
				if (null != mc_ji_neng_s0_f0["skill_miaoshu"] && psdr != null)
					mc_ji_neng_s0_f0["skill_miaoshu"].htmlText=psdr.skill_desc+"";
				if (null != mc_ji_neng_s0_f0["skill_miaoshu_max"] && psdr != null)
					mc_ji_neng_s0_f0["skill_miaoshu_max"].htmlText=psdr.skill_desc+"";
				if (null != mc_ji_neng_s0_f0["skill_xiayiji"])
				{
//					if(null == psdr_next)
//					{
//						mc_ji_neng_s0_f0["skill_xiayiji"].htmlText="";
//					
//					}else if (Data.myKing.level >= psdr_next.study_level)
//					{
//						mc_ji_neng_s0_f0["skill_xiayiji"].htmlText="<font color='#16DBFF'>" + psdr_next.study_level.toString() + "</font>"; //Lang.getLabel("20001_jineng_xiayiji", [psdr_next.study_level]);
//					}
//					else
//					{
//						mc_ji_neng_s0_f0["skill_xiayiji"].htmlText="<font color='#FF0000'>" + psdr_next.study_level.toString() + "</font>";
//					}
					if (Data.myKing.level >= psdr.study_level)
					{
						mc_ji_neng_s0_f0["skill_xiayiji"].htmlText="<font color='#16DBFF'>" + psdr.study_level.toString() + "</font>"; //Lang.getLabel("20001_jineng_xiayiji", [psdr_next.study_level]);
					}
					else
					{
						mc_ji_neng_s0_f0["skill_xiayiji"].htmlText="<font color='#FF0000'>" + psdr.study_level.toString() + "</font>";
					}
				}
				if (null != mc_ji_neng_s0_f0["skill_lengque_shijian2"])
					mc_ji_neng_s0_f0["skill_lengque_shijian2"].htmlText=psdr_next.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
				if (null != mc_ji_neng_s0_f0["skill_lingli_xiaohao2"])
					mc_ji_neng_s0_f0["skill_lingli_xiaohao2"].htmlText=getSkillXiaoHaoByXuanFu(psdr_next);
				if (null != mc_ji_neng_s0_f0['skill_yueli2'])
				{
					if (Data.myKing.exp2 >= psdr_next.study_exp)
					{
						mc_ji_neng_s0_f0['skill_yueli2'].htmlText="<font color='#16DBFF'>" + psdr_next.study_exp.toString() + "</font>";
					}
					else
					{
						mc_ji_neng_s0_f0['skill_yueli2'].htmlText="<font color='#FF0000'>" + psdr_next.study_exp.toString() + "</font>";
					}
				}
				if (null != mc_ji_neng_s0_f0["skill_shifang_juli2"])
					mc_ji_neng_s0_f0["skill_shifang_juli2"].htmlText=skillM.max_range;
				if (null != mc_ji_neng_s0_f0["skill_miaoshu2"])
				{
					if (null == psdr_next)
					{
						mc_ji_neng_s0_f0["skill_miaoshu2"].htmlText="";
					}
					else
					{
						mc_ji_neng_s0_f0["skill_miaoshu2"].htmlText=psdr_next.skill_desc;
					}
				}
				if (null != mc_ji_neng_s0_f0["skill_study_money2"])
				{
					if (Data.myKing.coin1 >= psdr_next.study_money)
					{
						mc_ji_neng_s0_f0["skill_study_money2"].htmlText="<font color='#16DBFF'>" + psdr_next.study_money.toString() + "</font>";
					}
					else
					{
						mc_ji_neng_s0_f0["skill_study_money2"].htmlText="<font color='#FF0000'>" + psdr_next.study_money.toString() + "</font>";
					}
				}
				if (null != mc_ji_neng_s0_f0["skill_exp"])
				{
					mc_ji_neng_s0_f0["skill_exp"].htmlText=data.skillExp + "/" + psdr.study_exp.toString();
				}
				//mc_jiNeng2["skill_xueyao_dengji"].text = psdr_next.study_level;
				//mc_jiNeng2["skill_yueli_xiaohao"].text = psdr_next.study_money;
				//mc_jiNeng["jihuo"].htmlText="";
				//人物技能显示达到XX级激活
//				if (psdr.study_level > Data.myKing.level)
//				{
				//mc_jiNeng["jihuo"].htmlText=Lang.getLabel("10036_ji_neng", [psdr.study_level]);
//				}
				//mc_ji_neng_s0_f0["data"]=data;
				//--------------------------------------------------------------
				return mc_ji_neng_s0_f0;
			}
//			if ((skillM.skill_series == 1 || skillM.skill_series == 2 || skillM.skill_series == 3) && skillM.passive_flag == 0 && mc_ji_neng_s123_f0 != null)
//			{
//				if (skill_level >= data.max_level)
//				{
//					mc_ji_neng_s123_f0.gotoAndStop(2);
//				}
//				else
//				{
//					mc_ji_neng_s123_f0.gotoAndStop(1);
//				}
//
//				if (null != mc_ji_neng_s123_f0["skill_name"])
//					mc_ji_neng_s123_f0["skill_name"].htmlText=data.skill_name;
//				if (null != mc_ji_neng_s123_f0["skill_level"])
//					mc_ji_neng_s123_f0["skill_level"].htmlText=skill_level + Lang.getLabel("pub_ji");
//
//				if (null != mc_ji_neng_s123_f0["uil"])
//					mc_ji_neng_s123_f0["uil"].source=FileManager.instance.getSkillIconXById(skillM.icon);
//				if (null != mc_ji_neng_s123_f0["skill_lengque_shijian"])
//					mc_ji_neng_s123_f0["skill_lengque_shijian"].htmlText=psdr.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
//				//技能消耗
//				if (null != mc_ji_neng_s123_f0["skill_lingli_xiaohao"])
//					mc_ji_neng_s123_f0["skill_lingli_xiaohao"].htmlText=getSkillXiaoHaoByXuanFu(psdr);
//				if (null != mc_ji_neng_s123_f0["skill_shifang_juli"])
//					mc_ji_neng_s123_f0["skill_shifang_juli"].htmlText=skillM.max_range;
//
//				if (null != mc_ji_neng_s123_f0["skill_miaoshu"])
//					mc_ji_neng_s123_f0["skill_miaoshu"].htmlText=psdr.skill_desc;
//				if (null != mc_ji_neng_s123_f0["miaoshu"])
//					mc_ji_neng_s123_f0["miaoshu"].htmlText=psdr.skill_desc;
//
//				//mc_ji_neng_s0_f0["skill_xiayiji"].htmlText=Lang.getLabel("20001_jineng_xiayiji", [psdr_next.study_level]);
//
//				if (null != mc_ji_neng_s123_f0["skill_lengque_shijian2"])
//					mc_ji_neng_s123_f0["skill_lengque_shijian2"].htmlText=psdr_next.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
//				if (null != mc_ji_neng_s123_f0["skill_lingli_xiaohao2"])
//					mc_ji_neng_s123_f0["skill_lingli_xiaohao2"].htmlText=getSkillXiaoHaoByXuanFu(psdr_next);
//				if (null != mc_ji_neng_s123_f0["skill_shifang_juli2"])
//					mc_ji_neng_s123_f0["skill_shifang_juli2"].htmlText=skillM.max_range;
//				if (null != mc_ji_neng_s123_f0["skill_miaoshu2"])
//					mc_ji_neng_s123_f0["skill_miaoshu2"].htmlText=psdr_next.skill_desc;
//
//
//				this.jiNeng_Sub_talent(mc_ji_neng_s123_f0, _psdr_next_id, data);
//
//				return mc_ji_neng_s123_f0;
//			}
//
//
//
//			if ((skillM.skill_series == 1 || skillM.skill_series == 2 || skillM.skill_series == 3 || skillM.skill_series == 4) && skillM.passive_flag == 1 && mc_ji_neng_s1234_f1 != null)
//			{
//				if (skill_level >= data.max_level)
//				{
//					mc_ji_neng_s1234_f1.gotoAndStop(2);
//				}
//				else
//				{
//					mc_ji_neng_s1234_f1.gotoAndStop(1);
//				}
//
//				if (null != mc_ji_neng_s1234_f1["skill_name"])
//					mc_ji_neng_s1234_f1["skill_name"].htmlText=data.skill_name;
//				if (null != mc_ji_neng_s1234_f1["skill_level"])
//				{
//					mc_ji_neng_s1234_f1["skill_level"].htmlText=skill_level + Lang.getLabel("pub_ji");
//				}
//
//				if (null != mc_ji_neng_s1234_f1["uil"])
//					mc_ji_neng_s1234_f1["uil"].source=FileManager.instance.getSkillIconXById(skillM.icon);
//				if (null != mc_ji_neng_s1234_f1["skill_lengque_shijian"])
//					mc_ji_neng_s1234_f1["skill_lengque_shijian"].htmlText=psdr.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
//				//技能消耗
//				if (null != mc_ji_neng_s1234_f1["skill_lingli_xiaohao"])
//					mc_ji_neng_s1234_f1["skill_lingli_xiaohao"].htmlText=getSkillXiaoHaoByXuanFu(psdr);
//				if (null != mc_ji_neng_s1234_f1["skill_shifang_juli"])
//					mc_ji_neng_s1234_f1["skill_shifang_juli"].htmlText=skillM.max_range;
//
//				if (null != mc_ji_neng_s1234_f1["skill_miaoshu"])
//					mc_ji_neng_s1234_f1["skill_miaoshu"].htmlText=psdr.skill_desc;
//				//mc_ji_neng_s0_f0["skill_xiayiji"].htmlText=Lang.getLabel("20001_jineng_xiayiji", [psdr_next.study_level]);
//
//				if (null != mc_ji_neng_s1234_f1["skill_lengque_shijian2"])
//					mc_ji_neng_s1234_f1["skill_lengque_shijian2"].htmlText=psdr_next.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
//				if (null != mc_ji_neng_s1234_f1["skill_lingli_xiaohao2"])
//					mc_ji_neng_s1234_f1["skill_lingli_xiaohao2"].htmlText=getSkillXiaoHaoByXuanFu(psdr_next);
//				if (null != mc_ji_neng_s1234_f1["skill_shifang_juli2"])
//					mc_ji_neng_s1234_f1["skill_shifang_juli2"].htmlText=skillM.max_range;
//
//				if (null != mc_ji_neng_s1234_f1["skill_miaoshu2"] && null != psdr_next)
//				{
//
//					mc_ji_neng_s1234_f1["skill_miaoshu2"].htmlText=psdr_next.skill_desc;
//				}
//
//
//
//				this.jiNeng_Sub_talent(mc_ji_neng_s1234_f1, _psdr_next_id, data);
//
//				return mc_ji_neng_s1234_f1;
//			}
//
//
//			if (skillM.skill_series == 0 && skillM.passive_flag == 1 && mc_ji_neng_s1234_f1 != null)
//			{
//				if (skill_level >= data.max_level)
//				{
//					mc_ji_neng_s1234_f1.gotoAndStop(2);
//				}
//				else
//				{
//					mc_ji_neng_s1234_f1.gotoAndStop(1);
//				}
//
//				try
//				{
//					if (null != mc_ji_neng_s1234_f1["skill_name"])
//						mc_ji_neng_s1234_f1["skill_name"].htmlText=data.skill_name;
//					if (null != mc_ji_neng_s1234_f1["skill_level"])
//						mc_ji_neng_s1234_f1["skill_level"].htmlText=skill_level + Lang.getLabel("pub_ji");
//
//					if (null != mc_ji_neng_s1234_f1["uil"])
//						mc_ji_neng_s1234_f1["uil"].source=FileManager.instance.getSkillIconXById(skillM.icon);
//					if (null != mc_ji_neng_s1234_f1["skill_lengque_shijian"])
//						mc_ji_neng_s1234_f1["skill_lengque_shijian"].htmlText=psdr.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
//					//技能消耗
//					if (null != mc_ji_neng_s1234_f1["skill_lingli_xiaohao"])
//						mc_ji_neng_s1234_f1["skill_lingli_xiaohao"].htmlText=getSkillXiaoHaoByXuanFu(psdr);
//					if (null != mc_ji_neng_s1234_f1["skill_shifang_juli"])
//						mc_ji_neng_s1234_f1["skill_shifang_juli"].htmlText=skillM.max_range;
//
//					if (null != mc_ji_neng_s1234_f1["skill_miaoshu"])
//						mc_ji_neng_s1234_f1["skill_miaoshu"].htmlText=psdr.skill_desc;
//					//mc_ji_neng_s0_f0["skill_xiayiji"].htmlText=Lang.getLabel("20001_jineng_xiayiji", [psdr_next.study_level]);
//
//					if (null != mc_ji_neng_s1234_f1["skill_lengque_shijian2"])
//						mc_ji_neng_s1234_f1["skill_lengque_shijian2"].htmlText=psdr_next.cooldown_time / 1000 + Lang.getLabel("20001_jineng_miao");
//					if (null != mc_ji_neng_s1234_f1["skill_lingli_xiaohao2"])
//						mc_ji_neng_s1234_f1["skill_lingli_xiaohao2"].htmlText=getSkillXiaoHaoByXuanFu(psdr_next);
//					if (null != mc_ji_neng_s1234_f1["skill_shifang_juli2"])
//						mc_ji_neng_s1234_f1["skill_shifang_juli2"].htmlText=skillM.max_range;
//					if (null != mc_ji_neng_s1234_f1["skill_miaoshu2"] && null != psdr_next)
//						mc_ji_neng_s1234_f1["skill_miaoshu2"].htmlText=psdr_next.skill_desc;
//				}
//				catch (err:Error)
//				{
//				}
//				return mc_ji_neng_s1234_f1;
//			}
			return null;
		}

		/**
		 *	道具悬浮【共用】
		 */
		public function daoJu(data:Object=null):Sprite
		{
			bag=data as StructBagCell2;
			if (bag == null)
			{
				if (int(data.id) == 0)
					return null;
				bag=new StructBagCell2;
				bag.num=1;
				bag.itemid=data.id;
				Data.beiBao.fillCahceData(bag);
			}
			if (bag == null || mc_daoJu == null || bag == null)
				return null;
			if (null != mc_daoJu["uil"])
			{
//				mc_daoJu["uil"].source=bag.iconBig;
				mc_daoJu["data"]=bag;
				ItemManager.instance().setEquipFace(mc_daoJu as MovieClip);
			}
//			imageSetup(mc_daoJu["uil"], mc_daoJu_uil, bag.iconBig)
			ImageUtils.replaceImage(mc_daoJu,mc_daoJu["uil"],bag.iconBig);
			mc_daoJu["txt_name"].htmlText="<font color='#" + arrColor[bag.toolColor] + "'>" + bag.itemname + "</font>";
			//2013-02-27 绑定状态
			mc_daoJu["txt_bangDing"].htmlText=bag.isTrade ? Lang.getLabel("pub_wei_bang_ding") : Lang.getLabel("pub_bang_ding");
			mc_daoJu["mc_lock"].visible=!bag.isTrade;
			if (Data.myKing.level >= bag.level)
			{
				mc_daoJu["txt_level"].text=bag.level + Lang.getLabel("pub_ji");
			}
			else
			{
				mc_daoJu["txt_level"].htmlText="<font color='#ff0000'>" + bag.level + Lang.getLabel("pub_ji") + "</font>";
			}
			mc_daoJu["txt_type"].text=bag.sortName;
			mc_daoJu["mc_desc"]["txt_desc"].htmlText=bag.desc + Data.beiBao.getExpiredDate(bag.exist_time);
			mc_daoJu["mc_desc"]["txt_desc"].height=mc_daoJu["mc_desc"]["txt_desc"].textHeight + 5;
			mc_daoJu["mc_desc"]["mc_background"].height=mc_daoJu["mc_desc"]["txt_desc"].height;
			mc_daoJu["mc_desc"]["mc_background"].height=mc_daoJu["mc_desc"]["txt_desc"].height;
			mc_daoJu["mc_price"].y=mc_daoJu["mc_desc"].y + mc_daoJu["mc_desc"].height;
			showPrice(mc_daoJu["mc_price"]["txt_price"], bag);
			mc_daoJu["mc_price"]["txt_wear"].visible=bag.pos > 0 && bag.isused;
			return mc_daoJu;
		}

		/**
		 * 显示 星魂 的Tip内容
		 * @param data
		 * @return
		 *
		 */
		public function xinghun(data:Object):Sprite
		{
			bag=data as StructBagCell2;
			if (bag == null)
			{
				if (int(data.id) == 0)
					return null;
				bag=new StructBagCell2;
				bag.num=1;
				bag.itemid=data.id;
				Data.beiBao.fillCahceData(bag);
			}
			if (bag == null)
			{
				return null;
			}
			var _config:Pub_ToolsResModel=XmlManager.localres.getToolsXml.getResPath(bag.itemid) as Pub_ToolsResModel;
			//var _configPub_star
			if (null == _config)
			{
				return null;
			}
			if (null == mc_xingHun)
			{
				return null;
			}
			var _strColor:String=null;
			if (bag.toolColor <= 0)
			{
				_strColor="999999";
			}
			else
			{
				_strColor=ResCtrl.instance().arrColor[bag.toolColor];
			}
//			mc_xingHun["mc_icon"]["uil"].source=FileManager.instance.getWuHunById(bag.tool_icon);
//			
//			if(!mc_xingHun_mc_icon_uil.parent)mc_xingHun["mc_icon"].addChild(mc_xingHun_mc_icon_uil);
//			mc_xingHun_mc_icon_uil.source=FileManager.instance.getWuHunById(bag.tool_icon)
//			
//			imageSetup(mc_xingHun["mc_icon"]["uil"], mc_xingHun_mc_icon_uil, FileManager.instance.getWuHunById(bag.tool_icon))
			ImageUtils.replaceImage(mc_xingHun["mc_icon"],mc_xingHun["mc_icon"]["uil"],FileManager.instance.getWuHunById(bag.tool_icon));
			mc_xingHun["data"]=bag;
			ItemManager.instance().setEquipFace(mc_xingHun as MovieClip);
			if (bag.toolColor <= 0)
			{
				mc_xingHun["star_name"].htmlText="<font color='#" + _strColor + "'>" + bag.itemname + "</font>";
				mc_xingHun["star_pinzhi"].visible=false;
			}
			else
			{
				mc_xingHun["star_name"].htmlText="<font color='#" + _strColor + "'><b>" + bag.itemname + "</b></font>";
				mc_xingHun["star_pinzhi"].visible=true;
				mc_xingHun["star_pinzhi"].gotoAndStop(bag.toolColor);
			}
			mc_xingHun["star_dengji"].text=Lang.getLabel("pub_deng_ji") + _config.tool_level;
			mc_xingHun["star_miaoshu"].htmlText=_config.tool_desc;
			showPrice(mc_xingHun["txt_price"], bag);
			return mc_xingHun;
		}

		/**
		 * 显示 四神器 的Tip内容
		 * @param data
		 * @return
		 *
		 */
		public function siShenQi(data:Object):Sprite
		{
			var _arrWord:Array=Lang.getLabelArr("arrFourShenQi");
			switch (data.shenqi_id)
			{
				case 0:
					mc_siShenQi['tf_title'].text=_arrWord[15];
					mc_siShenQi['tf_src'].text=_arrWord[19];
					(mc_siShenQi as MovieClip).gotoAndStop(1);
					break;
				case 1:
					mc_siShenQi['tf_title'].text=_arrWord[16];
					mc_siShenQi['tf_src'].text=_arrWord[20];
					(mc_siShenQi as MovieClip).gotoAndStop(2);
					break;
				case 2:
					mc_siShenQi['tf_title'].text=_arrWord[17];
					mc_siShenQi['tf_src'].text=_arrWord[21];
					(mc_siShenQi as MovieClip).gotoAndStop(3);
					break;
				case 3:
					mc_siShenQi['tf_title'].text=_arrWord[18];
					mc_siShenQi['tf_src'].text=_arrWord[22];
					(mc_siShenQi as MovieClip).gotoAndStop(4);
					break;
				default:
					break;
			}
			return mc_siShenQi;
		}

		/**
		 * 显示 包裹格子未开启
		 * @param data
		 * @return
		 *
		 */
		public function bagNotOpenTip(data:Object):Sprite
		{
			var mcTip:Sprite=null;
			var cellId:int=data.cellId;
			var cell:Pub_Pack_OpenResModel=XmlManager.localres.packopenXml.getResPath(Data.myKing.BagSize) as Pub_Pack_OpenResModel;
			var cellNext:Pub_Pack_OpenResModel=XmlManager.localres.packopenXml.getResPath(cellId) as Pub_Pack_OpenResModel;
			if (Data.myKing.BagSize + 1 == cellId && cellNext.need_time > 0)
			{
				mcTip=mc_bag_not_open1;
				var remainTime:int=BeiBao.getInstance().gettKuoChongTime(1);
				mcTip["txt_time"].htmlText=CtrlFactory.getUICtrl().formatTime2(remainTime, 2);
			}
			else
			{
				mcTip=mc_bag_not_open2;
			}
			mcTip["txt_index"].htmlText=Lang.getLabel("10240_beibao", [cellId]);
			mcTip["txt_need"].htmlText=Lang.getLabel("10241_beibao", [cellNext.need_coin - cell.need_coin, cellId - Data.myKing.BagSize]);
			return mcTip;
		}

		/**
		 *	道具悬浮【丹方】
		 */
		public function danFang(data:Object=null):Sprite
		{
			bag=data as StructBagCell2;
			if (bag == null)
			{
				if (int(data.id) == 0)
					return null;
				bag=new StructBagCell2;
				bag.num=1;
				bag.itemid=data.id;
				Data.beiBao.fillCahceData(bag);
			}
			if (bag == null)
				return null;
//			mc_danFang["uil"].source=bag.iconBig;
//			if(!mc_danFang_uil.parent)mc_danFang.addChild(mc_danFang_uil);
//			mc_danFang_uil.source=bag.iconBig;
//			imageSetup(mc_danFang["uil"], mc_danFang_uil, bag.iconBig)
			ImageUtils.replaceImage(mc_danFang,mc_danFang["uil"],bag.iconBig);
			mc_danFang["data"]=bag;
			ItemManager.instance().setEquipFace(mc_danFang as MovieClip);
			mc_danFang["txt_name"].htmlText="<font color='#" + arrColor[bag.toolColor] + "'>" + bag.itemname + "</font>";
			mc_danFang["txt_desc"].htmlText=bag.desc;
			//2013-02-27 绑定状态
			mc_danFang["txt_bangDing"].htmlText=bag.isTrade ? Lang.getLabel("pub_wei_bang_ding") : Lang.getLabel("pub_bang_ding");
			mc_danFang["mc_lock"].visible=!bag.isTrade;
			var config:Array=getDanFangConfig(bag.sort_para1);
			var len:int=config.length;
			var item:StructBagCell2=null;
			for (i=1; i <= 4; i++)
			{
				if (i <= len)
				{
					item=config[i - 1];
					//材料包含仓库
					var cnt:int=Data.beiBao.getBeiBaoCountById(item.itemid, true);
					if (cnt < item.need_num)
					{
						mc_danFang["txt" + i].htmlText=item.itemname + " " + cnt + "/" + item.need_num;
					}
					else
					{
						mc_danFang["txt" + i].htmlText="<font color='#00ff12'>" + item.itemname + " " + item.need_num + "/" + item.need_num + "</font>";
					}
				}
				else
				{
					mc_danFang["txt" + i].text="";
				}
			}
			mc_danFang["txt_price"].text=(bag.pos == 0 ? bag.buyprice1 : bag.sellprice) + " " + Lang.getLabel("pub_yin_liang");
			showPrice(mc_danFang["txt_price"], bag);
			return mc_danFang;
		}

		/**
		 *	道具悬浮【技能书】
		 */
		public function jiNengShu(data:Object=null):Sprite
		{
			try
			{
				bag=data as StructBagCell2;
				if (bag == null)
				{
					if (int(data.id) == 0)
						return null;
					bag=new StructBagCell2;
					bag.num=1;
					bag.itemid=data.id;
					Data.beiBao.fillCahceData(bag);
				}
				if (bag == null)
					return null;
//				mc_jiNengShu["uil"].source=bag.iconBig;
//				if(!mc_jiNengShu_uil.parent)mc_jiNengShu.addChild(mc_jiNengShu_uil);
//				mc_jiNengShu_uil.source=bag.iconBig;
//				imageSetup(mc_jiNengShu["uil"], mc_jiNengShu_uil, bag.iconBig)
				ImageUtils.replaceImage(mc_jiNengShu,mc_jiNengShu["uil"],bag.iconBig);
				mc_jiNengShu["data"]=bag;
				ItemManager.instance().setEquipFace(mc_jiNengShu as MovieClip);
				mc_jiNengShu["txt_name"].htmlText="<font color='#" + arrColor[bag.toolColor] + "'>" + bag.itemname + "</font>";
				var _skillID:int=Jineng.instance.checkSkillID(bag.itemid);
				if (Jineng.instance.hasStudySkill(_skillID))
				{
					mc_jiNengShu["txt_name"].htmlText+="<font color='#00FF00'><b>[" + Lang.getLabel("pub_hasStudy") + "]</b></font>";
				}
				mc_jiNengShu["txt_desc"].htmlText=bag.desc;
				//2013-02-27 绑定状态
				mc_jiNengShu["txt_bangDing"].htmlText=bag.isTrade ? Lang.getLabel("pub_wei_bang_ding") : Lang.getLabel("pub_bang_ding");
				mc_jiNengShu["mc_lock"].visible=!bag.isTrade;
				if (Data.myKing.level >= bag.level)
				{
					mc_jiNengShu["txt_level"].text=bag.level + Lang.getLabel("pub_ji");
				}
				else
				{
					mc_jiNengShu["txt_level"].htmlText="<font color='#ff0000'>" + bag.level + Lang.getLabel("pub_ji") + "</font>";
				}
				mc_jiNengShu["txt_metier"].text=XmlRes.GetJobNameById(bag.metier);
				mc_jiNengShu["txt_price"].text=(bag.pos == 0 ? bag.buyprice1 : bag.sellprice) + " " + Lang.getLabel("pub_yin_liang");
				showPrice(mc_jiNengShu["txt_price"], bag);
			}
			catch (e:Error)
			{
				trace("ResCtrl jiNengShu");
			}
			return mc_jiNengShu;
		}

		/**
		 *	道具悬浮【使用次数】
		 */
		public function usedTimes(data:Object=null):Sprite
		{
			bag=data as StructBagCell2;
			if (bag == null)
			{
				if (int(data.id) == 0)
					return null;
				bag=new StructBagCell2;
				bag.num=1;
				bag.itemid=data.id;
				Data.beiBao.fillCahceData(bag);
			}
			if (bag == null || mc_usedTimes == null)
				return null;
//			if(!mc_usedTimes_uil.parent)mc_usedTimes.addChild(mc_usedTimes_uil);
//			mc_usedTimes_uil.source=bag.iconBig;
//			
//			imageSetup(mc_usedTimes["uil"], mc_usedTimes_uil, bag.iconBig)
			ImageUtils.replaceImage(mc_usedTimes,mc_usedTimes["uil"],bag.iconBig);
//			mc_usedTimes["uil"].source=bag.iconBig;
			mc_usedTimes["data"]=bag;
			ItemManager.instance().setEquipFace(mc_usedTimes as MovieClip);
			mc_usedTimes["txt_name"].htmlText="<font color='#" + arrColor[bag.toolColor] + "'>" + bag.itemname + "</font>";
			mc_usedTimes["txt_desc"].htmlText=bag.desc;
			//2013-02-27 绑定状态
			mc_usedTimes["txt_bangDing"].htmlText=bag.isTrade ? Lang.getLabel("pub_wei_bang_ding") : Lang.getLabel("pub_bang_ding");
			mc_usedTimes["mc_lock"].visible=!bag.isTrade;
			if (Data.myKing.level >= bag.level)
			{
				mc_usedTimes["txt_level"].text=bag.level + Lang.getLabel("pub_ji");
			}
			else
			{
				mc_usedTimes["txt_level"].htmlText="<font color='#ff0000'>" + bag.level + Lang.getLabel("pub_ji") + "</font>";
			}
			//mc_usedTimes["txt_type"].text=bag.sortName;
			showPrice(mc_usedTimes["txt_price"], bag);
			mc_usedTimes["txt_wear"].visible=bag.isused;
			mc_usedTimes["txt_expired_date"].htmlText=Data.beiBao.getExpiredDate(bag.exist_time);
			mc_usedTimes["txt_remain_times"].text=bag.para + "/" + bag.useMaxTimes;
			return mc_usedTimes;
		}

		/**
		 *	道具悬浮【封印的宠物蛋】
		 */
		public function petEgg(data:Object=null):Sprite
		{
			bag=data as StructBagCell2;
			var mc_basic:MovieClip=mc_chongWuDan["mc_basic"];
			var mc_att:MovieClip=mc_chongWuDan["mc_att"];
			if (bag == null)
			{
				if (int(data.id) == 0)
					return null;
				bag=new StructBagCell2;
				bag.num=1;
				bag.itemid=data.id;
				Data.beiBao.fillCahceData(bag);
			}
			if (bag == null || mc_chongWuDan == null)
				return null;
			mc_basic["txt_level"].text=bag.soulLvl + Lang.getLabel("pub_ji");
//			mc_basic["mc_icon"]["uil"].source=FileManager.instance.getHeadIconSById(pet.res_id);
//			if(!mc_basic_mc_icon_uil.parent)mc_basic["mc_icon"].addChild(mc_basic_mc_icon_uil);
//			mc_basic_mc_icon_uil.source=FileManager.instance.getHeadIconSById(pet.res_id)
			mc_basic["mc_icon"]["data"]=bag;
			ItemManager.instance().setEquipFace(["mc_basic"]["mc_icon"] as MovieClip);
			for (var p:int=1; p <= 10; p++)
			{
				if (p <= 0)
				{
					mc_basic["mcStar_" + p].gotoAndStop(2);
				}
				else
				{
					mc_basic["mcStar_" + p].gotoAndStop(1);
				}
			}
			mc_basic["mc_icon"].gotoAndStop(bag.toolColor);
			if (bag.identify == 0)
				mc_basic["mc_color"].gotoAndStop(1);
			else
				mc_basic["mc_color"].gotoAndStop(bag.colorLvl + 2);
			mc_basic["txt_zhanDouLi"].htmlText=bag.equip_fightValue;
			//2013-02-27 绑定状态
			mc_basic["txt_bangDing"].htmlText=bag.isTrade ? Lang.getLabel("pub_wei_bang_ding") : Lang.getLabel("pub_bang_ding");
			mc_basic["mc_lock"].visible=!bag.isTrade;
			//mc_basic["txt_desc"].htmlText=pet.pet_desc;
			//2013-10-24 基本属性
			var att:String="";
			att+=Lang.getLabel("10129_resctrl") + "<br/>";
			for each (var st:StructItemAttr2 in bag.arrItemattrs)
			{
				att+=TIP_SPACE + Att.getAttName(st.attrIndex) + " " + Att.getAttValuePercent(st.attrIndex, st.attrValue) + "<br/>";
			}
			//2013-10-24 宠物技能
			att+=Lang.getLabel("10235_resctrl") + "<br/>";
			var skill:Pub_SkillResModel=null;
			var color:int=0;
			for each (var se:StructEvilGrain2 in bag.arrItemevilGrains)
			{
				skill=XmlManager.localres.getSkillXml.getResPath(se.toolId) as Pub_SkillResModel;
				if (skill != null)
				{
					color=skill.skill_id.toString().substr(5, 1) == "1" ? 2 : 3;
					att+=this.getFontByColor(TIP_SPACE + skill.skill_name + " " + skill.description, color) + "<br/>";
				}
			}
			mc_att["txt_att1"].htmlText=att;
			mc_att["txt_att1"].height=mc_att["txt_att1"].textHeight + 5;
			mc_att["mc_background"].height=mc_att["txt_att1"].height + 5;
			showPrice(mc_chongWuDan["mc_desc"]["txt_price"], bag);
			mc_chongWuDan["mc_desc"].y=mc_att.y + mc_att.height;
			return mc_chongWuDan;
		}

		/**
		 *	装备悬浮
		 *  图文混排难点：1.自适应高度，元件本身高度不固定 2. 有的属性不显示，计算下一个坐标过于复杂
		 */
		public function zhuangBei(data:Object=null):Sprite
		{
			var bags:Array;
			bag=data as StructBagCell2;
			if (bag == null)
			{
				bags=data as Array;
			}
			else
			{
				bags=[bag];
			}
			if (bags == null)
				return new Sprite();
			var sprite:Sprite=new Sprite;
			var bagsLen:int=bags.length;
			if (mc_zhuangBeiArr != null && mc_zhuangBeiArr.length == 0)
				init();
			for (var i:int=0; i < bagsLen; i++)
			{
				var tip:Sprite=zhuangBeiSprite(bags[i], mc_zhuangBeiArr[i]);
				if (tip == null)
					continue;
				if (i != 0)
				{
					tip["mc_yizhuangbei"].gotoAndStop(bags[i].pos > 0 ? 2 : 3);
				}
				else
				{
					tip["mc_yizhuangbei"].gotoAndStop(1);
				}
				tip.name="tip" + (i + 1);
				tip.x=sprite.width;
				sprite.addChild(tip);
			}
			return sprite;
		}

		private function zhuangBeiSprite(bag:StructBagCell2, mc_zhuangBei:Sprite):Sprite
		{
			if (bag == null || mc_zhuangBei == null)
				return null;
			//装备分五段显示 1 基本内容 2 属性介绍 3 宝石 4 套装 5 介绍说明
			var basic:Sprite=mc_zhuangBei["mc_basic"];
			var att:Sprite=mc_zhuangBei["mc_att"];
			var att1:Sprite=mc_zhuangBei["mc_att1"];
			var att2:Sprite=mc_zhuangBei["mc_att2"];
			var att3:Sprite=mc_zhuangBei["mc_att3"];
			var desc:Sprite=mc_zhuangBei["mc_desc"];
			//1.基本信息
			basic["txt_name"].htmlText="<font color='#" + arrColor[bag.toolColor] + "'><b>" + bag.itemname + "</b></font>";
			LianDanLu.instance().showStar(basic["txt_strongLevel"], bag.equip_strongLevel);
			//basic["txt_strongLevel"].htmlText=bag.equip_strongLevel"+"+bag.equip_strongLevel;
			basic["txt_leiXing"].text=bag.equip_typeName; //.substr(0, 3);
			basic["txt_fightValue"].text=bag.equip_fightValue;
//			basic["mc_icon"]["uil"].source=bag.iconBig;
//			if(!basic_mc_icon_uil.parent)basic["mc_icon"].addChild(basic_mc_icon_uil);
//			basic_mc_icon_uil.source=bag.iconBig
			ImageUtils.replaceImage(basic["mc_icon"],basic["mc_icon"]["uil"],bag.iconBig);
			
			basic["mc_icon"].gotoAndStop(bag.toolColor);
			basic["mc_lock"].visible=!bag.isTrade;
			if (Data.myKing.level >= bag.level)
			{
				basic["txt_dengJi"].htmlText=bag.level + Lang.getLabel("pub_ji");
			}
			else
			{
				basic["txt_dengJi"].htmlText="<font color='#ff0000'>" + bag.level + Lang.getLabel("pub_ji") + "</font>";
			}
			var isMetier:Boolean=(Data.myKing.metier == bag.metier || bag.metier == 0 || bag.metier == 7) ? true : false;
			var isSex:Boolean=Data.myKing.sex == bag.sex || bag.sex == 0 ? true : false;
			var zhiYe:String=(isMetier ? bag.equip_jobName : "<font color='#ff0000'>" + bag.equip_jobName + "</font>");
			zhiYe+=bag.sex == 0 ? "" : " (" + (isSex ? Metier.getSexName(bag.sex) : "<font color='#ff0000'>" + Metier.getSexName(bag.sex) + "</font>") + ")";
			basic["txt_zhiYe"].htmlText=zhiYe;
			//basic["txt_bangDing"].text=bag.isTrade ? Lang.getLabel("pub_wei_bang_ding") : Lang.getLabel("pub_bang_ding");
			//强化钻石
			var child:MovieClip=null;
			//模板最大值
			var strong_max:int=bag.equip_strongLevelMax;
			//当前可用最大值
			var used_max:int=strong_max - bag.strongFailed;
			if (used_max < bag.equip_strongLevel)
			{
				used_max=bag.equip_strongLevel;
			}
			for (i=1; i <= QH.MAX_STRONG_LEVEL; i++)
			{
				child=basic["zuan" + (i)];
				if (child == null)
					continue;
				if (i <= used_max)
				{
					if (i <= bag.equip_strongLevel)
					{
						child.gotoAndStop(2);
						child["mc_shan"].gotoAndPlay(1);
					}
					else
					{
						child.gotoAndStop(1);
					}
					child.visible=true;
				}
				else
				{
					child.visible=false;
				}
			}
//			if (strong_max == 0)
//			{
//				basic["mc_star_bg"].visible=false;
//				att.y=108;
//			}
//			else
//			{
//				basic["mc_star_bg"].visible=true;
//				att.y=138;
//			}
			//2.属性信息
			att["mc_background"].height=0;
			att["txt_att1"].height=0;
			var str:String="";
			var map:HashMap=null;
			var mapNext:HashMap=null;
			//基础属性
			map=getAtt(bag.equip_att1, false);
			str+=showEquipStrong(map, null, "FFF5D2", TIP_SPACE);
			//str+="\n";
			//附加属性
			if (bag.arrItemattrs.length > 0)
			{
				map=getAtt(bag.arrItemattrs, false);
				str+=showEquipStrong(map, null, "f8cc00", TIP_SPACE);
				//str+="<br/>";
			}
			//2014-01-02 强化下一等级
			map=getAtt(getStrongAtt(bag.strongId, bag.equip_strongLevel), false);
			if (bag.equip_strongLevel < bag.equip_strongLevelMax)
			{
				mapNext=getAtt(getStrongAtt(bag.strongId, bag.equip_strongLevel + 1), false);
				if (bag.equip_strongLevel == 0)
					map=null;
				str+=showEquipStrong(map, mapNext, "f76e00", TIP_SPACE);
			}
			else
			{
				str+=showEquipStrong(map, null, "f76e00", TIP_SPACE,true);
			}
			att["txt_att1"].htmlText=str;
			att["txt_att1"].height=att["txt_att1"].textHeight + 12;
			//赋值3便，才取到att真正高度，目前原因不祥，没有完美解决方案
			att["mc_background"].height=att.height;
			att["mc_background"].height=att.height;
			//3 宝石属性
			att1.y=att.y + att.height;
			att1.scaleY=0;
			if (bag.equip_hole > 0 && false)
			{
				att1.scaleY=1;
				var storeData:Vector.<StructGemInfo2>=null;
				var equip_pos:int=0;
				if (bag.pos >= BeiBaoSet.ZHUANGBEI_INDEX && bag.pos <= BeiBaoSet.ZHUANGBEI_END_INDEX)
				{
					equip_pos=Data.beiBao.getEquipPos(bag.pos);
					storeData=Data.beiBao.getStoneByEquipPos(equip_pos);
				}
				else if (bag.equip_source == 6)
				{
					equip_pos=bag.pos;
					storeData=JiaoSeLook.instance().getStoneByEquipPos(equip_pos);
				}
				else
				{
					equip_pos=bag.equip_type;
				}
				var gem:Pub_GemResModel=XmlManager.localres.pubGemXml.getResPath(equip_pos) as Pub_GemResModel;
				var stoneHeight:int=att1["item0"].height + 3;
				for (var i:int=0; i < 3; i++)
				{
					if (att1["item" + i] == null)
						continue;
					att1["item" + i]["uil"].unload();
					ImageUtils.cleanImage(att1["item" + i]);
					att1["item" + i]["txt_name"].htmlText="";
					if (i < bag.equip_hole)
					{
						CtrlFactory.getUIShow().setColor(att1["item" + i], 1);
						att1["item" + i].visible=true;
						att1["item" + i].y=i * stoneHeight + 8;
						if (gem != null)
						{
							att1["item" + i]["txt_name"].htmlText=Lang.getLabel("1023" + gem["gem_sort" + (i + 1)] + "_baoshi");
						}
					}
					else
					{
//						CtrlFactory.getUIShow().setColor(att1["item" + i]);
//						att1["item" + i]["txt_name"].htmlText=Lang.getLabel("10235_resctrl");
						att1["item" + i].visible=false;
						att1["item" + i].y=0;
					}
				}
				att1["mc_background"].height=bag.equip_hole * stoneHeight + 10;
				if (storeData != null && storeData.length > 0)
				{
					for (i=0; i < storeData.length; i++)
					{
						if (att1["item" + i] == null)
							continue;
						if (storeData[i].toolId > 0)
						{
							var m_bag:StructBagCell2=new StructBagCell2();
							m_bag.itemid=storeData[i].toolId;
							Data.beiBao.fillCahceData(m_bag)
//							att1["item" + i]["uil"].source=m_bag.icon;
							ImageUtils.replaceImage(att1["item" + i],att1["item" + i]["uil"],m_bag.icon);
							att1["item" + i]["txt_name"].htmlText=m_bag.itemname + " " + m_bag.desc;
						}
					}
				}
			}
			//4 套装属性
			att2.y=att1.y + att1.height;
			var m_model:Vector.<Pub_Equip_SuitResModel>=XmlManager.localres.getEquipSuitXml.getResPath2(bag.suit_id) as Vector.<Pub_Equip_SuitResModel>;
			if (m_model.length > 0)
			{
				att2.scaleY=1;
				var m_suitNum:int=0;
				var m_roleEquip:Array=Data.beiBao.getRoleEquipList();
				if (bag.equip_source == 6)
				{
					m_roleEquip=JiaoSeLook.instance().getPlayerEquip();
				}
				else
				{
				}
				var m_color:Array=[];
				str="";
				for (i=0; i < m_roleEquip.length; i++)
				{
					var m_d:StructBagCell2=m_roleEquip[i] as StructBagCell2;
					if (m_d != null && m_d.suit_id == bag.suit_id)
					{
						m_color[m_d.pos - BeiBaoSet.ZHUANGBEI_INDEX + 1]=1;
						if (bag.equip_source == 6)
						{
							m_color[m_d.pos]=1;
						}
						else
						{
						}
						m_suitNum++;
					}
				}
				var m_dic:Dictionary=new Dictionary();
				for (i=0; i < m_model.length; i++)
				{
					var m_vector:Vector.<StructItemAttr2>=new Vector.<StructItemAttr2>();
					for (var n:int=1; n < 11; n++)
					{
						if (m_model[i]["func" + n] > 0)
						{
							var m_funcAtt:StructItemAttr2=new StructItemAttr2()
							m_funcAtt.attrIndex=m_model[i]["func" + n];
							m_funcAtt.attrValue=m_model[i]["value" + n];
							m_vector.push(m_funcAtt);
						}
					}
					m_dic[m_model[i].suit_num]=getAtt(m_vector, false);
				}
				str="<font color='#fcc738'>套装:" + m_model[0].suit_name + "(" + m_suitNum + "/" + m_model[0].suit_max_num + ")</font><br>";
				str+="<font color='#928367'>";
				if (bag.suit_id == 10000)
				{
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_WEAPON] == 1 ? " color='#8AFD5C'" : "") + ">武器</font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_CLOTHES] == 1 ? " color='#8AFD5C'" : "") + "> 衣服</font><br>";
				}
				else
				{
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_HEAD] == 1 ? " color='#8AFD5C'" : "") + ">头盔</font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_NECK] == 1 ? " color='#8AFD5C'" : "") + "> 项链</font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_BELT] == 1 ? " color='#8AFD5C'" : "") + "> 腰带</font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_BOOT] == 1 ? " color='#8AFD5C'" : "") + "> 靴子</font><br>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_BRACELET] == 1 ? " color='#8AFD5C'" : "") + ">手镯</font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_DUMMY_1] == 1 ? " color='#8AFD5C'" : "") + "> 手镯 </font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_RING] == 1 ? " color='#8AFD5C'" : "") + ">戒指 </font>";
					str+="<font" + (m_color[JiaoSeSet.EQUIPTYPE_DUMMY_2] == 1 ? " color='#8AFD5C'" : "") + ">戒指</font><br>";
				}
				str+="</font>";
				var array_str:Array=[];
				for (var v:String in m_dic)
				{
					array_str[int(v)]="";
					for each (var a:String in m_dic[v].keys())
					{
						if (m_suitNum < int(v))
						{
							array_str[int(v)]+="<font color='#928367'>(" + v + ")</font>" + getAttShow(m_dic[v].get(a), true, false, "928367") + "<br>";
						}
						else
						{
							array_str[int(v)]+="<font color='#8AFD5C'>(" + v + ")</font>" + getAttShow(m_dic[v].get(a), true, false, "8AFD5C") + "<br>";
						}
					}
						//					m_num=m_num < int(v) ? int(v) : m_num;
				}
				for each (var m_str:String in array_str)
				{
					if (m_str != "")
					{
						str+=m_str;
					}
				}
				att2["txt_att1"].htmlText=str;
				att2["txt_att1"].height=att2["txt_att1"].textHeight + 5;
				att2["mc_background"].height=att2["txt_att1"].height + att2["txt_att1"].y;
			}
			else
			{
				att2.scaleY=0;
			}
			//捐献
			if (bag.contribute > 0)
			{
				att3["txt_juan_xian"].htmlText=Lang.getLabel("10026_resctrl", [bag.contribute, bag.need_contribute]);
				att3.scaleY=1;
			}
			else
			{
				att3.scaleY=0;
			}
			att3.y=att2.y + att2.height;
			//5.描述信息
			//desc["txt_title"].htmlText=Lang.getLabel("10132_resctrl");
			desc["txt_desc"].htmlText=bag.desc+ Data.beiBao.getExpiredDate(bag.exist_time);
			showPrice(desc["txt_price"], bag);
			if (bag.pos > 0)
			{
				if (bag.pos >= BeiBaoSet.BEIBAO_INDEX && bag.pos <= BeiBaoSet.BEIBAO_END_INDEX)
				{
					//包裹中 
					if (bag.sort == 13 || bag.sort == 21 || bag.sort == 22)
					{
						//双击即可穿上
						desc["txt_wear"].text=Lang.getLabel("10018_bao_guo");
					}
					else if (bag.isused == 1)
					{
						//双击即可使用
						desc["txt_wear"].text=Lang.getLabel("10216_bao_guo");
					}
					else
					{
						desc["txt_wear"].text="";
					}
				}
				else
				{
					//包裹外 双击可卸下
					if (bag.sort == 13 || bag.sort == 21 || bag.sort == 22 || bag.sort == 27)
					{
						desc["txt_wear"].text=Lang.getLabel("10019_bao_guo");
					}
					else
					{
						desc["txt_wear"].text="";
					}
				}
			}
			else if (bag.equip_type == 1)
			{
				desc["txt_wear"].text=Lang.getLabel("10019_bao_guo");
			}
			else
			{
				desc["txt_wear"].text="";
			}
			desc.y=att3.y + att3.height;
			//2013-10-14 策划说悬浮可以超过屏幕75像素不换行
			if (mc_zhuangBei.height > PubData.mainUI.stage.stageHeight + 75)
			{
				desc.x=basic.width;
				desc.y=att.height;
			}
			else
			{
				desc.x=0;
			}
			return mc_zhuangBei;
		}

		/**
		 *	获得装备售价【基础价格+强化价格/2】
		 */
		public function getEquipPrice(bag:StructBagCell2, metier:int=0):int
		{
			if (bag.equip_strongLevel == 0)
				return bag.sellprice;
			var xml:Pub_Equip_Strong_2ResModel=XmlManager.localres.getEquipSrongXml.getResPath2(bag.strongId, bag.equip_strongLevel) as Pub_Equip_Strong_2ResModel;
			if (xml == null)
				return 0;
			return bag.sellprice + xml.cost_coin1 / 2;
		}

		/**
		 * 获得炼丹配方材料
		 * @param v 配方id
		 */
		public function getDanFangConfig(v:int):Array
		{
			var crm:Pub_ComposeResModel=XmlManager.localres.getPubComposeXml.getResPath(v) as Pub_ComposeResModel;
			if (crm == null)
				return new Array();
			var ret:Array=[];
			var bag:StructBagCell2=new StructBagCell2();
			if (crm.stuff_id1 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=crm.stuff_id1;
				bag.need_num=crm.stuff_num1;
				Data.beiBao.fillCahceData(bag);
				ret.push(bag);
			}
			if (crm.stuff_id2 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=crm.stuff_id2;
				bag.need_num=crm.stuff_num2;
				Data.beiBao.fillCahceData(bag);
				ret.push(bag);
			}
			if (crm.stuff_id3 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=crm.stuff_id3;
				bag.need_num=crm.stuff_num3;
				Data.beiBao.fillCahceData(bag);
				ret.push(bag);
			}
			if (crm.stuff_id4 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=crm.stuff_id4;
				bag.need_num=crm.stuff_num4;
				Data.beiBao.fillCahceData(bag);
				ret.push(bag);
			}
			if (crm.need_value1 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=1;
				bag.itemname=Lang.getLabel("pub_suipian" + bag.itemid);
				bag.need_num=crm.need_value1;
				ret.push(bag);
			}
			if (crm.need_value2 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=2;
				bag.itemname=Lang.getLabel("pub_suipian" + bag.itemid);
				bag.need_num=crm.need_value2;
				ret.push(bag);
			}
			if (crm.need_value3 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=3;
				bag.itemname=Lang.getLabel("pub_suipian" + bag.itemid);
				bag.need_num=crm.need_value3;
				ret.push(bag);
			}
			if (crm.need_value4 > 0)
			{
				bag=new StructBagCell2();
				bag.itemid=4;
				bag.itemname=Lang.getLabel("pub_suipian" + bag.itemid);
				bag.need_num=crm.need_value4;
				ret.push(bag);
			}
			if (ret.length > 0)
			{
				//合成的其他数据放在一个上
				bag=ret[0];
				bag.need_coin3=crm.coin3;
				bag.need_coin1=crm.coin1;
				bag.odd=crm.odd;
				bag.resultId=crm.tool_id;
			}
			return ret;
		}

		/**
		 * 悬浮专用 fux
		 */
		public function getSkillXiaoHaoByXuanFu(psdr:Pub_Skill_DataResModel):String
		{
			var ret:String="";
			if (psdr == null)
				return ret;
			if (0 == psdr.cc1 && 0 == psdr.cc2 && 0 == psdr.cc3)
			{
				return "0";
			}
			ret+=getXiaoHaoTypeByXuanFu(psdr.cc1, psdr.cc1_para1, psdr.cc1_para2);
			ret+=getXiaoHaoTypeByXuanFu(psdr.cc2, psdr.cc2_para1, psdr.cc2_para2);
			ret+=getXiaoHaoTypeByXuanFu(psdr.cc3, psdr.cc3_para1, psdr.cc3_para2);
			return ret;
		}

		private function getXiaoHaoTypeByXuanFu(v:int, v1:int=0, v2:int=0):String
		{
			var ret:String="";
			switch (v)
			{
				case 0:
					ret="";
					break;
				case 1:
					ret=v1 + Lang.getLabel("pub_ling_li");
					break;
				case 2:
					ret=v1 + "%" + Lang.getLabel("pub_ling_li");
					break;
				case 3:
					ret=v1 + Lang.getLabel("pub_sheng_ming");
					break;
				case 4:
					ret=v1 + "%" + Lang.getLabel("pub_sheng_ming");
					break;
			}
			return ret + " ";
		}

		/**
		 *	技能消耗【可能同时消耗多种，最多三种】
		 * 	@param psdr  本地技能数据
		 */
		public function getSkillXiaoHao(psdr:Pub_Skill_DataResModel):String
		{
			var ret:String="";
			if (psdr == null)
				return ret;
			if (0 == psdr.cc1 && 0 == psdr.cc2 && 0 == psdr.cc3)
			{
				return "0";
			}
			ret+=getXiaoHaoType(psdr.cc1, psdr.cc1_para1, psdr.cc1_para2);
			ret+=getXiaoHaoType(psdr.cc2, psdr.cc2_para1, psdr.cc2_para2);
			ret+=getXiaoHaoType(psdr.cc3, psdr.cc3_para1, psdr.cc3_para2);
			return ret;
		}

		private function getXiaoHaoType(v:int, v1:int=0, v2:int=0):String
		{
			var ret:String="";
			switch (v)
			{
				case 0:
					ret="0";
					break;
				case 1:
					ret=v1 + Lang.getLabel("pub_ling_li");
					break;
				case 2:
					ret=v1 + "%" + Lang.getLabel("pub_ling_li");
					break;
				case 3:
					ret=v1 + Lang.getLabel("pub_sheng_ming");
					break;
				case 4:
					ret=v1 + "%" + Lang.getLabel("pub_sheng_ming");
					break;
			}
			return ret + " ";
		}

		/**
		 *  得到强化属性名字
		 *  @param lv 装备强化等级
		 */
		public function getStrongName(lv:int):String
		{
			var ret:String="";
			if (mapStrongName == null)
			{
				mapStrongName=XmlManager.localres.getEquipSrongXml.getResPath3() as HashMap;
			}
			if (mapStrongName != null)
			{
				ret=mapStrongName.get(lv);
			}
			if (ret == null)
				ret="";
			return ret;
		}

		/**
		 *  得到强化属性
		 *  2013－12－23
		 * 	@param strongId    装备强化ID
		 *  @param strongLevel 装备强化等级
		 */
		public function getStrongAtt(strongId:int, strongLevel:int):Vector.<StructItemAttr2>
		{
			var ret:Vector.<StructItemAttr2>=new Vector.<StructItemAttr2>();
			var att:StructItemAttr2=null;
			var strongXml:Pub_Equip_Strong_2ResModel=XmlManager.localres.getEquipSrongXml.getResPath2(strongId, strongLevel) as Pub_Equip_Strong_2ResModel;
			if (strongXml == null)
				return ret;
			for (var i:int=1; i <= 10; i++)
			{
				if (strongXml["func" + i] != null && strongXml["func" + i] > 0)
				{
					att=new StructItemAttr2();
					att.attrIndex=strongXml["func" + i];
					att.attrValue=strongXml["value" + i];
					ret.push(att);
				}
			}
			return ret;
		}

		/**
		 *	 整合属性【区间】
		 * 	 2013-12-23
		 *   @param vec 属性集合
		 *   @param map
		 */
		public function getAtt(vec:Vector.<StructItemAttr2>, isCheckMetier:Boolean=true, metier:int=0):HashMap
		{
			if (vec == null || vec.length == 0)
				return null;
			var ret:HashMap=new HashMap();
			var attModel:AttModel=null;
			var attId:int=0;
			for each (var item:StructItemAttr2 in vec)
			{
				attId=Att.getAttId(item.attrIndex);
				//检查职业
				if (isCheckMetier)
				{
					if (metier == 0)
						metier=Data.myKing.metier;
					if (Att.isSameAttAndMetier(attId, metier) == false)
					{
						continue;
					}
				}
				if (ret.containsKey(attId))
				{
					attModel=ret.get(attId);
				}
				else
				{
					attModel=new AttModel();
					attModel.attId=attId;
					ret.put(attId, attModel);
				}
				if (Att.getAttLimit(item.attrIndex) == 0 || Att.getAttLimit(item.attrIndex) == 1)
					attModel.minAtt=item;
				else
					attModel.maxAtt=item;
			}
			return ret;
		}

		/**
		 *	 得到装备基本属性总值【强化属性】
		 *   2013-12-23
		 *   @param map       基础属性
		 *   @param mapStrong 强化属性
		 *   @param space     间隔
		 */
		public function showEquipStrong(map:HashMap, mapNext:HashMap, fontColor:String="fed293", space:String="",isMaxLevel:Boolean=false):String
		{
			var ret:String="";
			var next:AttModel=null;
			var minValue:String="";
			if (map != null)
			{
				for each (var attModel:AttModel in map.values())
				{
					if (attModel.minAtt == null)
						continue;
					if (attModel.minAtt == null)
						continue;
					minValue=getAttShow(attModel, true, false, fontColor, space);
					if (minValue == "")
						continue;
					ret+=minValue;
					if (mapNext != null && mapNext.containsKey(attModel.attId))
					{
						next=mapNext.get(attModel.attId) as AttModel;
						ret+=getAttShow(next, false, true, fontColor, space);
					}
					//2014-11-06 顶级强化
					if(isMaxLevel){
						ret+="  <font color='#ff9600'>顶级强化</font>";
					}
					ret+="<br/>";
				}
			}
			else
			{
			}
			//对齐处理,比较复杂 强化下一级
			if (map != null && mapNext != null && mapNext.size() > 1)
			{
				var arr:Array=ret.split("<br/>");
				var maxLen:int=0;
				for (var k:int=0; k < arr.length - 1; k++)
				{
					if (arr[k].split("</font>")[1].length > maxLen)
						maxLen=arr[k].split("</font>")[1].length;
				}
				for (k=0; k < arr.length - 1; k++)
				{
					if (arr[k].split("</font>")[1].length < maxLen)
					{
						arr[k]=arr[k].toString().replace(Lang.getLabel("10128_resctrl"), addSpace(maxLen - arr[k].split("</font>")[1].length) + Lang.getLabel("10128_resctrl"));
					}
				}
				ret=arr.join("<br/>");
			}
			
			//对齐处理,比较复杂 强化下一级
			if (map != null && isMaxLevel)
			{
				var arr:Array=ret.split("<br/>");
				var maxLen:int=0;
				for (var k:int=0; k < arr.length - 1; k++)
				{
					if (arr[k].split("</font>")[1].length > maxLen)
						maxLen=arr[k].split("</font>")[1].length;
				}
				for (k=0; k < arr.length - 1; k++)
				{
					if (arr[k].split("</font>")[1].length < maxLen)
					{
						arr[k]=arr[k].toString().replace("顶级强化", addSpace(maxLen - arr[k].split("</font>")[1].length) + "顶级强化");
					}
				}
				ret=arr.join("<br/>");
			}
			return ret;
		}

		private function getAttShow(attModel:AttModel, isShowName:Boolean=true, isShowNext:Boolean=true, fontColor:String="fed293", space:String=""):String
		{
			var ret:String="";
			var minValue:String="";
			if (attModel != null)
			{
				minValue=Att.getAttValuePercent(attModel.minAtt.attrIndex, attModel.minAtt.attrValue);
				//必须得有最小值
				if (minValue == "")
					return "";
				if (isShowName)
				{
					var m_att_name:String=Att.getAttNameByID(attModel.attId);
					while (m_att_name.length < 4)
					{
						m_att_name+="　";
					}
					ret+=space + "<font color='#" + fontColor + "'>" + m_att_name + "：</font> ";
				}
				if (isShowNext)
				{
					ret+="   <font color='#" + fontColor + "'>" + Lang.getLabel("10128_resctrl") + "：</font> ";
				}
				ret+=isShowNext ? "<font color='#00ff00'>" : "";
				if (attModel.maxAtt == null)
					ret+="+" + Att.getAttValuePercent(attModel.minAtt.attrIndex, attModel.minAtt.attrValue);
				else
					ret+=Att.getAttValuePercent(attModel.minAtt.attrIndex, attModel.minAtt.attrValue) + "-" + Att.getAttValuePercent(attModel.maxAtt.attrIndex, attModel.maxAtt.attrValue);
				ret+=isShowNext ? "</font>" : "";
			}
			return ret;
		}

		private function addSpace(count:int):String
		{
			var ret:String="";
			for (var p:int=1; p <= count; p++)
			{
				ret+=" ";
			}
			return ret;
		}

		/**
		 *	附加属性条数
		 */
		public function getAttCount(bag:StructBagCell2):int
		{
			var ret:int=0;
			if (bag != null)
			{
				ret=bag.arrItemattrs.length;
			}
			return ret;
		}

		/**
		 * 重铸属性全部显示出来，未开放的灰色显示
		 * 2012-08-09
		 * @param itemIndex  第几条
		 * @param equipLevel 装备等级
		 */
		public function isGray(itemIndex:int, bag:StructBagCell2):Boolean
		{
			var count:int=getAttCount(bag);
			if (itemIndex <= count)
				return false;
			else
				return true;
		}

		/**
		 *	强化连续完美个数
		 *  @param strong_perfect 完美信息
		 *  @param strong_level   强化等级
		 */
		public function getWanMeiCount(strong_perfect:int, strong_level:int):int
		{
			var ret:int=0;
			for (var j:int=1; j <= strong_level; j++)
			{
				if (BitUtil.getBitByPos(strong_perfect, j) == 1)
				{
					ret++;
				}
				else
				{
					break;
				}
			}
			return ret;
		}

		/**
		 *	价格显示【是否出售】
		 */
		private function showPrice(txt:TextField, bag:StructBagCell2):void
		{
			if (txt == null || bag == null)
				return;
			if (bag.isSale)
			{
//				if (bag.sort == 13)
//					txt.htmlText=Lang.getLabel("10067_bao_guo") + " " + (bag.equip_type == 2 ? bag.buyprice1 : getEquipPrice(bag)) + " " + Lang.getLabel("pub_yin_liang");
//				else if (bag.sort == 12)
//					txt.htmlText=Lang.getLabel("10067_bao_guo") + " " + (bag.equip_type == 2 ? bag.buyprice1 : bag.sellprice) + " " + Lang.getLabel("pub_wu_hun_dian");
//				else
//					txt.htmlText=Lang.getLabel("10067_bao_guo") + " " + (bag.pos == 0 ? bag.buyprice1 : bag.sellprice) + " " + Lang.getLabel("pub_yin_liang");
				//2014-01-17 marry说游戏中可出售道具买卖价格一样
				txt.htmlText=Lang.getLabel("10067_bao_guo") + " " + bag.sellprice + " " + Lang.getLabel("pub_yin_liang");
			}
			else
			{
				txt.htmlText=Lang.getLabel("10068_bao_guo");
			}
			if (bag.booth_price > 0)
			{
				txt.htmlText=Lang.getLabel("10171_resctrl") + " " + bag.booth_price + " " + Lang.getLabel("pub_yuan_bao");
			}
		}

		/**
		 *	字体色
		 */
		public function getFontByColor(font:String, num:int=0):String
		{
			if (num > 7)
				num=0;
			return "<font color='#" + ResCtrl.instance().arrColor[num] + "'>" + font + "</font>";
		}
		public var arrColorMonster:Array=["", KingNameColor.A11_MONSTER, KingNameColor.A12_MONSTER, KingNameColor.A13_MONSTER, KingNameColor.A14_MONSTER, KingNameColor.A15_MONSTER];

		/**
		 *	字体色 怪物头顶  非标准色
		 *  2014-02-19
		 */
		public function getFontByColorMonster(font:String, num:int=0):String
		{
			if (num > 7)
				num=0;
			return "<font color='" + ResCtrl.instance().arrColorMonster[num] + "'>" + font + "</font>";
		}

		/**
		 *	获得重铸次数
		 */
		public function getFreeTimes():int
		{
			//			var limit:StructLimitInfo2=Data.huoDong.getLimitById(LIMIT_ID);
			//			var freeTimes:int=limit==null?0:(limit.maxnum-limit.curnum);
			//			return freeTimes;
			//2012-11-09 策划说取消免费重铸次数
			return 0;
		}
		/**
		 * 装备悬浮限制显示 穿
		 */
		public static const EquipLimit_Equip:int=0;
		/**
		 * 装备悬浮限制显示 脱
		 */
		public static const EquipLimit_Unequip:int=1;
		/**
		 * 装备悬浮限制显示 强化
		 */
		public static const EquipLimit_Strong:int=2;
		/**
		 * 装备悬浮限制显示 鉴定
		 */
		public static const EquipLimit_Indentify:int=3;
		/**
		 * 装备悬浮限制显示 重铸
		 */
		public static const EquipLimit_Refound:int=4;
		/**
		 * 装备悬浮限制显示 镶嵌
		 */
		public static const EquipLimit_Inlay:int=5;
		/**
		 * 装备悬浮限制显示 吞噬
		 */
		public static const EquipLimit_Swallow:int=6;
		/**
		 * 装备悬浮限制显示 被吞噬
		 */
		public static const EquipLimit_Beswallow:int=7;
		/**
		 * 装备悬浮限制显示 传承
		 */
		public static const EquipLimit_Inherit:int=8;
		/**
		 * 装备悬浮限制显示 神武
		 */
		public static const EquipLimit_ColorUp:int=9;
		/**
		 * 装备悬浮限制显示 觉醒
		 */
		public static const EquipLimit_Awake:int=10;
		/**
		 * 装备悬浮限制显示 升级
		 */
		public static const EquipLimit_LevelUp:int=11;
		/**
		 * 装备悬浮限制显示 分解
		 */
		public static const EquipLimit_Resolve:int=12;
		/**
		 * 装备悬浮限制显示 转移
		 */
		public static const EquipLimit_Move:int=13;

		/**
		 * 根据道具 equip_limit
		 * 做功能限制
		 * 0.可以 1.不可以
		 * 2013-07-29 andy
		 */
		public function getEquipLimit(limit:int, limitType:int=0):Boolean
		{
			var ret:Boolean=true;
			if (BitUtil.getBitByPos(limit, limitType + 1) == 1)
				ret=false;
			return ret;
		}
	}
}
