package ui.view.view2.other
{
	import com.bellaxu.def.AttrDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.model.lib.ext.IS;
	
	import common.managers.Lang;

	/**
	 * 大图标开启条件，常量
	 */ 
	public class CBParam
	{
		
		 
		public static function get ArrHongHuangLianYu_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrHongHuangLianYu_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 50;
			}
			
			return parseInt(s);
			
		}		
		
		public static function get ArrExpX2_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrExpX2_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 40;
			}
			
			return parseInt(s);
			
		}
		
		public static function get ArrMonsterAttackCity1_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrMonsterAttackCity1_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 40;
			}
			
			return parseInt(s);
			
		}
		
		
		public static function get ArrBaZhuShengJian_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrBaZhuShengJian_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 40;
			}
			
			return parseInt(s);
			
		}
		
		
		public static function get ArrKaiFu_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrKaiFu_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 1;
			}
			
			return parseInt(s);
			
		}

		
		public static function get ArrWuLinBaoDian_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrWuLinBaoDian_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 40;
			}
			
			return parseInt(s);
			
		}
		
		public static function get ArrJueZhanZhanChang_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrJueZhanZhanChang_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 40;
			}
			
			return parseInt(s);
		
		}
		
		public static function get ArrQuanGuoYaYun_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrQuanGuoYaYun_On_Lvl");
			
			if(null == s || "" == s)
			{
				return 50;
			}
			
			return parseInt(s);
			
		}
		
		
		
		public static function get ArrMoBaiChengZhu_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrMoBaiChengZhu_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrBaoWeiHuangCheng_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrBaoWeiHuangCheng_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrXiaoFeiFanLi_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrXiaoFeiFanLi_On_Lvl");
			
			if(null == s||s=="")
			{
				return 20;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrDiGongBoss_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrDiGongBoss_On_Lvl");
			
			if(null == s||s=="")
			{
				return 30;
			}
			
			return parseInt(s);
		}
		public static function get ArrYaoQing_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrYaoQing_On_Lvl");
			
			if(null == s||s=="")
			{
				return 20;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrXunBao_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrXunBao_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		public static function get BtnZuoQi():int
		{
			//var s:String = Lang.getLabel("ArrXunBao_On_Lvl");
			
			
				return 35;
			
		}
		public static function get ArrHeFu_On_Dayl():int
		{
			var s:String = Lang.getLabel("ArrHeFu_On_Day");
			
			if(null == s||s=="")
			{
				//默认就不要出现了
				return 6;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrYaSongJunXu_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrYaSongJunXu_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrKaiFuLiBaoOn_Lvl():int
		{
			var s:String = Lang.getLabel("ArrKaiFuLiBaoOn_Lvl");
			
			if(null == s||s=="")
			{
				return 25;
			}
			
			return parseInt(s);
		}
		
		public static function get Huo():int
		{
			var s:String = Lang.getLabel("Huo_On_Lvl");
			
			if(null == s||s=="")
			{
				return 25;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrHuoYue_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrHuoYue_On_Lvl");
			
			if(null == s||s=="")
			{
				return 1;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrMoTian_On_Lvl():int
		{
//项目转换			var m:Pub_Demon_WorldResModel = Lib.getVec(LibDef.PUB_DEMON_WORLD, [AttrDef.step, IS, 1], [AttrDef.floor, IS, 1])[0];
//			return m.king_lvl;
			var s:String = Lang.getLabel("ArrMoTian_On_Lvl");
			
			if(null == s||s=="")
			{
				return 30;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 魔天成界开启条件 - 等级
		 */ 
		public static function get ArrDoJie_On_Lvl():int
		{
//项目转换		var m:Pub_Demon_WorldResModel = Lib.getVec(LibDef.PUB_DEMON_WORLD, [AttrDef.step, IS, 1], [AttrDef.floor, IS, 1])[0];
//			return m.king_lvl;
			var s:String = Lang.getLabel("ArrMoTian_On_Lvl");
			
			if(null == s||s=="")
			{
				return 30;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 龙图霸业开启条件 - 等级
		 */ 
		public static function get ArrLongTuDaYe_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrLongTuDaYe_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 七日登录
		 */ 
		public static function get ArrQiRiDengLu_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrQiRiDengLu_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		/**
		 * 怪物攻城
		 */ 
		public static function get ArrMonsterAttackCity_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrMonsterAttackCity_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		
		
		/**
		 * boss
		 */ 
		public static function get ArrBoss_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrBoss_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 新pk之王
		 * 
		 */ 
		public static function get ArrPKKing_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrPKKing_On_Lvl");
			
			if(null == s||s=="")
			{
				return 50;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 仙道大会
		 */ 
		public static function get ArrXianDaoHui_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrXianDaoHui_On_Lvl");
			
			if(null == s||s=="")
			{
				return 30;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 通天塔
		 */ 
		public static function get ArrTongTianTa_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrTongTianTa_On_Lvl");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 家族大乱斗
		 */ 
		public static function get ArrJiaZuDaLuanDou_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrJiaZuDaLuanDou_On_Lvl");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 皇城争霸
		 */ 
		public static function get ArrHuangCheng_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrHuangCheng_On_Lvl");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 首日礼包、次日礼包、三日礼包
		 */
		public static function get ArrLoginDayGift_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrLoginDayGift_On_Lvl");
			
			if(null == s||s=="")
			{
				return 28;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 
		 */ 
		public static function get ArrJinMa_On_Lvl():int		
		{
			var s:String = Lang.getLabel("ArrJinMa_On_Lvl");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 
		 */ 
		public static function get ArrSeaWar_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrSeaWar_On_Lvl");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 跨服Boss战 等级定义  
		 */		
		public static function get ArrKuaFu_Boss_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrKuaFu_Boss_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 新手目标 等级定义 
		 */		
		public static function get ArrXinShou_Mubiao_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrXinShou_Mubiao_On_Lvl");
			
			if(null == s||s=="")
			{
				return 10;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 
		 */ 
		public static function get ArrChongZhiGift1_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrChongZhiGift1_On_Lvl");
			
			if(null == s||s=="")
			{
				return 15;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrChongZhiGift2_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrChongZhiGift2_On_Lvl");
			
			if(null == s||s=="")
			{
				return 15;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrChongZhiGift3_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrChongZhiGift3_On_Lvl");
			
			if(null == s||s=="")
			{
				return 15;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrWuXingLianZhu_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrWuXingLianZhu_On_Lvl");
			
			if(null == s||s=="")
			{
				return 30;
			}
			
			return parseInt(s);
		}		
		
		public static function get ArrBaoZouDaTi_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrBaoZouDaTi_On_Lvl");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrLingDiZhengDuo_On_Lv1():int{
			var s:String = Lang.getLabel("ArrLingDiZhengDuo_On_Lv1");
			
			if(null == s||s=="")
			{
				return 40;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrBangPaiMiGong_On_Lv1():int{
			var s:String = Lang.getLabel("ArrBangPaiMiGong_On_Lv1");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrHuaShanLunJian_On_Lv1():int{
			var s:String = Lang.getLabel("ArrHuaShanLunJian_On_Lv1");
			
			if(null == s||s=="")
			{
				return 35;
			}
			
			return parseInt(s);
		}
		
		public static function get ArrBangPaiZhan_On_Lv1():int{
			var s:String = Lang.getLabel("ArrBangPaiZhan_On_Lv1");
			
			if(null == s||s=="")
			{
				return 45;
			}
			
			return parseInt(s);
			return 45;
		}
		
		public static function get ArrDouZhanShen_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrDouZhanShen_On_Lvl");
			
			if(null == s||s=="")
			{
				return 65;
			}
			
			return parseInt(s);
		}
		
		
		public static function get ArrShenLongTuTeng_On_Lv1():int{
			var s:String = Lang.getLabel("ArrShenLongTuTeng_On_Lv1");
			
			if(null == s||s=="")
			{
				return 150;
			}
			
			return parseInt(s);
		}
		
		/**
		 * 皇城任务 
		 * @return 
		 * 
		 */
		public static function get ArrXuanShang_On_Lv1():int{
			var s:String = Lang.getLabel("ArrXuanShang_On_Lv1");
			
			if(null == s||s=="")
			{
				return 30;
			}
			
			return parseInt(s);
		}

		/**
		 * 珍宝阁开启条件 - 等级
		 */ 
		public static function get ArrZhenBaoGe_On_Lvl():int
		{
			var s:String = Lang.getLabel("ArrZhenBaoGe_On_Lvl");
			
			if(null == s||s=="")
			{
				return 15;
			}
			
			return parseInt(s);
		}
				
		
		/**
		 *个人排位赛 
		 * @return 
		 * 
		 */
		public static  function get ArrGRPW_On_Lvl():int
		{
			var s:String = Lang.getLabel("arrGeRenPaiWei");
			
			if(null == s||s=="")
			{
				return 60;
			}
			return parseInt(s);
		}
		
		
		/**
		 * 领取神兽图标 消失之条件7天后
		 */ 
		//public static const ArrLingShou_Off_KaiFuDay:int = 7;
		
		
		/**
		 * 活动组
		*/
		//public static const BOSS_ACTION_GROUP:int = 20010;
		//public static const JinMa_ACTION_GROUP:int = 10046;
		public static const PKKing_ACTION_GROUP:int = 20012;
		public static const SPA_ACTION_GROUP:int = 20031;
		public static const XianDaoHui_ACTION_GROUP:int = 20046;
		public static const TongTianTa_ACTION_GROUP:int = 20047;
		
		public static const SeaWar_ACTION_GROUP:int = 20049;
		public static const KuaFu_BOSS_ACTION_GROUP:int = 20050;		
		
		public static const WuXingLianZhu_ACTION_GROUP:int = 20001;
				
		public static const DuoMaoMao_ACTION_GROUP:int = 20002;
	
		public static const BaoZouDaTi_ACTION_GROUP:int = 20003;
		
		public static const LingDiZhengDuo_ACTION_GROUP:int = 20008;
		
		public static const BangPaiZhan_ACTION_GROUP:int = 80005;
		public static const BangPaiMiGong_ACTION_GROUP:int = 80004;
				
		public static const Boss_ACTION_GROUP:int = 80003;
		public static const YaoSai_ACTION_GROUP:int = 20027;
		public static const HuangChengZhiZun_ACTION_GROUP:int = 20025;
		public static const TianMenZhen_ACTION_GROUP:int = 40002;
		public static const ShenLongTuTeng_ACTION_GROUP:int = 20041;
		
		public static const YaSongJunXu_ACTION_GROUP:int = 20015;
		
		public static const DiGong_ACTION_GROUP:int = 20017;
		public static const GeRenPaiWei_ACTION_GROUP:int = 20058;//个人排位赛
		
		//怪物攻城 20010
		public static const MonsterAttackCity_ACTION_GROUP:int = 20010;
		
		public static const DuiDuiPeng_ACTION_GROUP:int = 40001;
		
		//保卫皇城 20011
		public static const BaoWeiHuangCheng_ACTION_GROUP:int = 20011;
		
		//膜拜城主 20031
		public static const MoBaiChengZhu_ACTION_GROUP:int = 20031;
		
		//决战战场10046
		public static const JueZhanZhanChang_ACTION_GROUP:int =10046;
		//全国押运10046
		public static const QuanGuoYaYun_ACTION_GROUP:int =20032;
			
		//王者之剑 20034	
		public static const BaZhuShengJian_ACTION_GROUP:int =20034;
		//双倍经验 20036	
		public static const DOBOULE_EXP_ACTION_GROUP:int =20036;
				
		//
		public static const MonsterAttackCity1_ACTION_GROUP:int =20028;
	
		public static const HongHuangLianYu_ACTION_GROUP:int = 20029;
	
	}
	
	
	
	
	
	
	
	
}