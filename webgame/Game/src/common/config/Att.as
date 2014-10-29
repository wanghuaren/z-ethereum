package common.config
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Tool_AttrResModel;

	public class Att
	{
		/**
		 *	属性定义
		 *  2013-03-28 andy 
		 */
		public function Att()
		{
		}
		/**
		 *	获得属性名字【短】区间属性ID
		 *  如： 生命 
		 */
		public static function getAttName(attId:int):String{
			var ret:String="";
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath2(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				ret=tool_attr.attr_name;
			}
			return ret;
		}
		/**
		 *	获得属性名字【短】属性ID
		 *  如： 生命 
		 */
		public static function getAttNameByID(attId:int):String{
			var ret:String="";
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				ret=tool_attr.attr_name;
			}
			return ret;
		}
		
		/**
		 *	获得属性名字描述
		 *  如：增加100生命 
		 */
		public static function getAttNameDesc(attId:int,attValue:Number=0):String{
			var ret:String="";
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath2(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				ret=tool_attr.attr_name.replace("#param",getAttValue(attId,attValue));
			}
			return ret;
		}
		
		/**
		 * 获得属性值
		 * 如：(+ 10)
		 * return int
		 */
		public static function getAttValue(attId:int,attValue:int):Number{
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath2(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				if(tool_attr.attr_sort==2){
					return Number((attValue/100).toFixed(1));
				}
			}
			return attValue;
		}
		/**
		 * 获得属性值
		 * 如：(+ 10%)
		 * return string
		 */
		public static function getAttValuePercent(attId:int,attValue:int):String{
			var ret:String="";
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath2(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				ret=getAttValue(attId,attValue)+(tool_attr.attr_sort==0?"":"%");
			}
			return ret;
		}
		
		/**
		 *	职业和属性是否相符
		 *  如：攻击属性：物理－外功 魔法－内功
		 *  2013-09-13  
		 */
		public static function isSameAttAndMetier(attId:int,metier:int=0):Boolean{
			var ret:Boolean=true;
			if(getJobType(metier)==WU_LI){
				//物理职业不相符的属性
				if(attId==HURT_NEI_GONG||attId==HURT_CHUAN_TOU)
					ret=false;
				
			}else{
				//魔法职业不相符的属性
				if(attId==HURT_WAI_GONG||attId==HURT_PO_JIA)
					ret=false;
			}
			return ret;
		}
		/**
		 *	获得职业类型 【1.物理2. 魔法】
		 *  2013-03-28 andy 
		 */
		public static const WU_LI:int=1;
		public static const MO_FA:int=2;
		public static function getJobType(job:int):int{
			return (job==2||job==3||job==5||job==6)?WU_LI:MO_FA;
		}
		/**
		 *	获得属性是上限还是下限 0.没有上下限 1.上限 2.下限
		 *  2013-12-23 andy
		 */
		public static function getAttLimit(attId:int):int{
			var ret:int=0;
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath2(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				if(tool_attr.min_attr==tool_attr.max_attr)ret=0;
				else if(tool_attr.min_attr==attId)ret=1;
				else if(tool_attr.max_attr==attId)ret=2;
				else{};
			}
			return ret;
		}
		
		/**
		 *	获得显示属性ID
		 *  2013-12-23 andy
		 */
		public static function getAttId(attId:int):int{
			var ret:int=0;
			var tool_attr:Pub_Tool_AttrResModel=XmlManager.localres.getToolAttrXml.getResPath2(attId) as Pub_Tool_AttrResModel;
			if(tool_attr!=null){
				ret=tool_attr.id;
			}
			return ret;
		}
		
		
		
		
		
		
		/**
		 *	生命 
		 */
		public static var SHENG_MING:int=1;
		
		
		/**
		 *	内力 
		 */
		public static var NEI_LI:int=2;
		/**
		 *	内功攻击 
		 */
		public static var HURT_NEI_GONG:int=5;
		/**
		 *	外功攻击 
		 */
		public static var HURT_WAI_GONG:int=3;
		/**
		 *	外功防御 
		 */
		public static var DEF_WAI_GONG:int=4;
		/**
		 *	内功防御 
		 */
		public static var DEF_NEI_GONG:int=6;
		/**
		 *	暴击 
		 */
		public static var BAO_JI:int=41;
		/**
		 *	暴击倍数 
		 */
		public static var BAO_JI_RATE:int=13;
		/**
		 *	闪避
		 */
		public static var SHAN_BI:int=40;
		/**
		 *	命中
		 */
		public static var MING_ZHONG:int=39;
		/**
		 *	诅咒
		 */
		public static var ZU_ZHOU:int=36;
		/**
		 *	幸运
		 */
		public static var XING_YUN:int=35;
		/**
		 *	防爆
		 */
		public static var FANG_BAO:int=42;
		/**
		 *	移动速度
		 */
		public static var YI_DONG_SPEED:int=43;
		/**
		 *	攻击速度
		 */
		public static var GONG_JI_SPEED:int=44;
		/**
		 *	减速抗性 
		 */
		public static var DEF_JIAN_SU:int=45;
		/**
		 *	定身抗性 
		 */
		public static var DEF_DING_SHEN:int=46;
		/**
		 *	眩晕抗性 
		 */
		public static var DEF_XUAN_YUN:int=47;
		/**
		 *	沉默抗性 
		 */
		public static var DEF_CHEN_MO:int=48;
		/**
		 *	混乱抗性 
		 */
		public static var DEF_HUN_LUAN:int=49;
		/**
		 *	坐骑移动速度
		 */
		public static var ZUOQI_SPEED:int=92;
		
		/****** 废弃 ******************************/
		/**
		 *	体质 
		 */
		public static var TI_ZHI:int=0;
		/**
		 *	法术 
		 */
		public static var FA_SHU:int=0;
		/**
		 *	力量 
		 */
		public static var LI_LIANG:int=0;
		/**
		 *	智慧 
		 */
		public static var ZHI_HUI:int=0;
		/**
		 *	敏捷 
		 */
		public static var MIN_JIE:int=0;
		
		/**
		 *	内功穿透 
		 */
		public static var HURT_CHUAN_TOU:int=0;
		/**
		 *	外功破甲 
		 */
		public static var HURT_PO_JIA:int=0;
		
		/**
		 *	格挡 
		 */
		public static var GE_DANG:int=0;
		/**
		 *	任性 
		 */
		public static var REN_XING:int=0;
		/**
		 *	破格 
		 */
		public static var PO_GE:int=0;
		
		/**
		 *	雷电伤害 
		 */
		public static var HURT_LEI_DIAN:int=0;
		/**
		 *	雷电抗性 
		 */
		public static var DEF_LEI_DIAN:int=0;
		/**
		 *	火焰伤害 
		 */
		public static var HURT_HUO_YAN:int=0;
		/**
		 *	火焰抗性
		 */
		public static var DEF_HUO_YAN:int=0;
		/**
		 *	冰冻伤害 
		 */
		public static var HURT_BING_DONG:int=0;
		/**
		 *	冰冻抗性 
		 */
		public static var DEF_BING_DONG:int=0;
		
		
		//					左侧，基础属性、进阶属性中，需要根据角色职业显示 外功攻击或内功攻击
		//					外功攻击：
		//					3神剑山庄
		//					5唐门
		//					6明教
		//					2天波府
		//					
		//					内功攻击：
		//					
		//					1逍遥派
		//					4慈航静斋 
		
		public static function isHurtWaiGong(metier:int):Boolean
		{
			
			if(3 == metier ||
			   5 == metier ||
			   6 == metier ||
			   2 == metier)
			{
				return true;
			}
			
			return false;
		
		}		
		
		public static function isHurtNeiGong(metier:int):Boolean
		{
			if(1 == metier ||
			   4 == metier)
			{
				return true;
			}
			
			return false;
		}
		
		
		
	}
}