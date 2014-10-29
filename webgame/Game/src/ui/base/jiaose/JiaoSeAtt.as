package ui.base.jiaose
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.managers.Lang;
	import common.utils.bit.BitUtil;
	
	import flash.display.Sprite;
	
	import netc.Data;


	/**
	 * 角色详细信息	
	 * andy 
	 * 2011-09-20
	 * 2013-03-28
	 */
	public final class JiaoSeAtt 
	{
		private var mc:Sprite;
		private var mc_basicAtt:Sprite;
		private var mc_otherAtt:Sprite;
		private static var _instance:JiaoSeAtt;
		public static function getInstance():JiaoSeAtt{
			if(_instance==null){
				_instance=new JiaoSeAtt();
			}
			return _instance;
		}
		
		public function setMc(v:Sprite):void{
			mc=v;
			mc_basicAtt=mc;//mc["mc_basicAtt"];
			mc_otherAtt=mc//;mc["mc_otherAtt"];
			

			Lang.addTip(mc["txt_PK"],"jiaose_pk");
			
			//Lang.addTip(mc["txt_shengMing"],"jiaose_shengming");
			//Lang.addTip(mc["txt_lingLi"],"jiaose_lingli");
			//Lang.addTip(mc["txt_jingYan"],"jiaose_jingyan");
			var tipWidth:int=120;
			Lang.addTip(mc_basicAtt["txt_gongJiWai"],"jiaose_gongji");
			Lang.addTip(mc_basicAtt["txt_gongJiNei"],"jiaose_gongji1");
			Lang.addTip(mc_basicAtt["txt_gongJiDao"],"jiaose_gongji2");
			Lang.addTip(mc_basicAtt["txt_fangYuWai"],"jiaose_fangyuwai");
			Lang.addTip(mc_basicAtt["txt_fangYuNei"],"jiaose_fangyunei");

			Lang.addTip(mc_basicAtt["txt_mingZhong"],"jiaose_mingzhong",tipWidth);
			Lang.addTip(mc_basicAtt["txt_shanBi"],"jiaose_shanbi",tipWidth);
			Lang.addTip(mc_basicAtt["txt_zuZhou"],"jiaose_zuzhou",tipWidth);
			Lang.addTip(mc_basicAtt["txt_xingYun"],"jiaose_xingyun",tipWidth);
			Lang.addTip(mc_basicAtt["txt_baoJi"],"jiaose_baoji",tipWidth);
			Lang.addTip(mc_basicAtt["txt_baoJiRate"],"jiaose_baojirate",tipWidth);

			refresh();
		}

		
		public function refresh():void{
			
			mc["txt_zhiYe"].text=XmlRes.GetJobNameById(Data.myKing.metier);;
			mc["txt_dengJi"].text=Data.myKing.level+ Lang.getLabel("pub_ji");;
			mc["txt_PK"].text=Data.myKing.pkvalue;
			
			
			mc["txt_shengMing"].text=Data.myKing.hp+"/"+Data.myKing.maxhp;
			mc["txt_lingLi"].text=Data.myKing.mp+"/"+Data.myKing.maxmp;
			var nextExp:Number=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level)["king"];
			mc["txt_jingYan"].text=int(Data.myKing.exp/nextExp*100)+"%";
			
			mc["mc_progress_hp"]["mc_zhe_zhao"].scaleX=Data.myKing.hp/Data.myKing.maxhp;
			mc["mc_progress_mp"]["mc_zhe_zhao"].scaleX=Data.myKing.mp/Data.myKing.maxmp;
			mc["mc_progress_exp"]["mc_zhe_zhao"].scaleX=Data.myKing.exp/nextExp;
			mc["txt_zhanDouLi"].htmlText=Data.myKing.FightValue;
			
			mc_basicAtt["txt_gongJiWai"].text=Data.myKing.Atk+"-"+Data.myKing.AtkMax;
			mc_basicAtt["txt_gongJiNei"].text=Data.myKing.MAtk+"-"+Data.myKing.MAtkMax;
			mc_basicAtt["txt_gongJiDao"].text=Data.myKing.sAtk+"-"+Data.myKing.sAtkMax;

			mc_basicAtt["txt_fangYuWai"].text=Data.myKing.Def+"-"+Data.myKing.DefMax;
			mc_basicAtt["txt_fangYuNei"].text=Data.myKing.MDef+"-"+Data.myKing.MDefMax;
			
			mc_basicAtt["txt_mingZhong"].text=Data.myKing.Hit;
			mc_basicAtt["txt_shanBi"].text=Data.myKing.Miss;
			mc_basicAtt["txt_baoJi"].text=Data.myKing.Cri;
			mc_basicAtt["txt_zuZhou"].text=Data.myKing.curse;
			mc_basicAtt["txt_xingYun"].text=Data.myKing.lucky;
			
			//2013-09-12 最大350
			mc_basicAtt["txt_baoJiRate"].text=Data.myKing.CHAtk;
		}	
		
		
		
	}
}