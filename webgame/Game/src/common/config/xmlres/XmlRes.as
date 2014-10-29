package common.config.xmlres
{
	import common.managers.Lang;
	import common.utils.res.ResCtrl;

	/**
	 *	游戏中一些固定的信息
	 *  2011－12－29 
	 */
	public final class XmlRes
	{
		/** 
		 *活动标识,1表示门派秘宝,2表示PK赛,3表示金戈铁马,4表示门派建设
		 */
		public static function GetActNameByActId(actId:int):String
		{
			var act_name:String = "";
			switch(actId)
			{
				case 1:
					act_name = Lang.getLabel("pub_huo_dong1");
					break;
				case 2:
					//act_name = "PK赛";
					act_name = Lang.getLabel("pub_huo_dong2");
					
					break;
				case 3:
					act_name = Lang.getLabel("pub_huo_dong3");
					break;
				case 4:
					act_name = Lang.getLabel("pub_huo_dong4");
					break;
			
			}
			
			return act_name;
		
		}
		
		/**
		 *	获得角色名字 
		 */
		public static function GetJobNameById(job:int):String
		{
			var ret:String=Lang.getLabel("pub_job"+job);
			return ret;
		}
		/**
		 *	获得货币名字 2014-01-01
		 */
		public static function GetMoneyNameById(type:int):String
		{
			var ret:String="";
			switch(type){
				case 1:ret=Lang.getLabel("pub_yuan_bao");break;
				case 2:ret=Lang.getLabel("pub_li_jin");break;
				case 3:ret=Lang.getLabel("pub_yin_liang");break;
				default: ret="";
			}
			return ret;
		}
		
		public static function GetGuildDutyName(duty:int):String
		{
			var rs:String="";
			switch(duty)
			{
				case 1:rs=Lang.getLabel("pub_shen_qing_jz");break;
				case 2:rs=Lang.getLabel("pub_zu_yuan");break;
				case 3:rs=Lang.getLabel("pub_fu_zu_zhang");break;
				case 4:rs=Lang.getLabel("pub_zu_zhang");break;
				default: rs="";
			}
			
			return rs;
		
		}
		
		/**
		 * 根据装备编号获得装备位置
		 */
		public static function GetEquipPos(id:int):int{
			return int(id.toString().substr(3,2));
		}
		/**
		 * 根据装备编号获得装备颜色
		 */
		public static function GetEquipColor(id:int):int{
			return int(id.toString().substr(5,1));
		}
		
		/**
		 * 根据装备编号获得装备颜色【16进制】
		 */
		public static function GetEquipColor16(color:int):String{
			if(color<1||color>5)color=1;
			return ResCtrl.instance().arrColor[color];
		}

		public static function GetEquipTypeName(type:int,isDesc:String=""):String
		{
			return Lang.getLabel("pub_equip_name"+type+isDesc);
		}
		/**
		 *	获得装备位置名字【宠物】
		 *  2013-08-09 
		 * 04	兽甲	
			07	战靴	
			01	魂武	
			08	兽环	
			09	项圈	
			10	铃铛
		 */
		public static function GetEquipTypeNamePet(pos:int,isDesc:String=""):String
		{
			var ret:String="";
			switch(pos){
				case 1:ret=Lang.getLabel("pub_hun_wu"+isDesc);break;
				case 4:ret=Lang.getLabel("pub_shou_jia"+isDesc);break;
				case 7:ret=Lang.getLabel("pub_zhan_xue"+isDesc);break;
				case 8:ret=Lang.getLabel("pub_xiang_quan"+isDesc);break;
				case 9:ret=Lang.getLabel("pub_shou_huan"+isDesc);break;
				case 10:ret=Lang.getLabel("pub_ling_dang"+isDesc);break;
				default: ret="";
			}
			return ret;
		}
		
		
		/**
		 *	把阿拉伯数字换成中文 
		 */
		public static function getChinaNumber(num:int=1):String{
			var ret:String="";
			switch(num){
				case 1:ret=Lang.getLabel("pub_yi_1");break;
				case 2:ret=Lang.getLabel("pub_er_2");break;
				case 3:ret=Lang.getLabel("pub_san_3");break;
				case 4:ret=Lang.getLabel("pub_si_4");break;
				case 5:ret=Lang.getLabel("pub_wu_5");break;
				case 6:ret=Lang.getLabel("pub_liu_6");break;
				case 7:ret=Lang.getLabel("pub_qi_7");break;
				case 8:ret=Lang.getLabel("pub_ba_8");break;
				case 9:ret=Lang.getLabel("pub_jiu_9");break;
				case 10:ret=Lang.getLabel("pub_shi_10");break;
				case 11:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_yi_1");break;
				case 12:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_er_2");break;
				case 13:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_san_3");break;
				case 14:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_si_4");break;
				case 15:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_wu_5");break;
				case 16:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_liu_6");break;
				case 17:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_qi_7");break;
				case 18:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_ba_8");break;
				case 19:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_jiu_9");break;
				case 20:ret=Lang.getLabel("pub_shi_10")+Lang.getLabel("pub_shi_10");break;
				default: ret="";
			}
			return ret;
		}
		/**
		 *	获得阵营
		 */
		public static function getZhenYing(num:int=1,haveColor:Boolean=false):String{
			var ret:String="";
			if(haveColor){
				switch(num){
					case 1:ret="";break;
					case 2:ret="<b><font color='#00d8ff'>["+Lang.getLabel("pub_tai_yi")+"]</font></b>";break;
					case 3:ret="<b><font color='#ff9000'>["+Lang.getLabel("pub_tong_tian")+"]</b></font>";break;
					default: ret="";
				}
			}else{
				switch(num){
					case 1:ret=Lang.getLabel("pub_wu");break;
					case 2:ret=Lang.getLabel("pub_tai_yi");break;
					case 3:ret=Lang.getLabel("pub_tong_tian");break;
					default: ret=Lang.getLabel("pub_wu");
				}
			}
			return ret;
		}
		/**
		 *	
		 */
		public static function getEquipColorFont(num:int=1):String{
			var ret:String="";
			switch(num){
				case 1:ret=Lang.getLabel("pub_fan_pin");break;
				case 2:ret=Lang.getLabel("pub_ling_pin");break;
				case 3:ret=Lang.getLabel("pub_tian_pin");break;
				case 4:ret=Lang.getLabel("pub_xian_pin");break;
				case 5:
				case 6:
				case 7:	
					ret=Lang.getLabel("pub_shen_pin");
					break;
				default: ret=Lang.getLabel("pub_wu");
			}
			return ret;
		}
		/**
		 *	装备品质
		 */
		public static function getEquipQCFont(num:int=1):String{
			var ret:String="";
			switch(num){
				case 1:ret=Lang.getLabel("pub_liang_hao");break;
				case 2:ret=Lang.getLabel("pub_you_xiu");break;
				case 3:ret=Lang.getLabel("pub_zhuo_yue");break;
				case 4:ret=Lang.getLabel("pub_wan_mei");break;
				case 5:ret=Lang.getLabel("pub_ji_zhi");break;
				default: ret=Lang.getLabel("pub_wu");
			}
			return ret;
		}

	}
}