package ui.base.jiaose
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.config.xmlres.server.Pub_PetResModel;
	import common.config.xmlres.server.Pub_Pet_SealResModel;
	import common.managers.Lang;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	import netc.packets2.PacketSCPetData2;
	import netc.packets2.PacketWCPlayerLookInfo2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;


	/**
	 * 角色查看详细信息
	 * andy 2011－09－20
	 * andy 2013－10－08
	 * andy 2013-12-23 【废弃】
	 */
	public class JiaoSeLookAtt
	{
		private var mc:Sprite;
		private var mc_basicAtt:Sprite;
		private var mc_otherAtt:Sprite;
		
		
		private static var _instance:JiaoSeLookAtt;
		public static function getInstance():JiaoSeLookAtt{
			if(_instance==null){
				_instance=new JiaoSeLookAtt();
			}
			return _instance;
		}
		public function JiaoSeLookAtt()
		{

		}

		public function refresh(type:int,data:PacketWCPlayerLookInfo2,m:MovieClip):void{
			if(data==null)return;
			
			if(type==1){
				mc=m["mc_att"];
				mc_basicAtt=mc//mc["mc_basicAtt"];
				mc_otherAtt=mc//mc["mc_otherAtt"];
				
				Lang.addTip(mc["txt_PK"],"jiaose_minjie");
				
				Lang.addTip(mc["txt_shengMing"],"jiaose_shengming");
				Lang.addTip(mc["txt_lingLi"],"jiaose_lingli");
				Lang.addTip(mc["txt_jingYan"],"jiaose_jingyan");
				
				Lang.addTip(mc_basicAtt["txt_gongJi"],"jiaose_gongji");
				Lang.addTip(mc_basicAtt["txt_fangYuWai"],"jiaose_fangyuwai");
				Lang.addTip(mc_basicAtt["txt_fangYuNei"],"jiaose_fangyunei");
				
				Lang.addTip(mc_basicAtt["txt_mingZhong"],"jiaose_mingzhong");
				Lang.addTip(mc_basicAtt["txt_shanBi"],"jiaose_shanbi");
				Lang.addTip(mc_basicAtt["txt_baoJi"],"jiaose_baoji");
				Lang.addTip(mc_basicAtt["txt_baoJiRate"],"jiaose_baojirate");

				
				
				//2013-03-28 根据职业显示属性名字
				//1.法术-力量  2.内功攻击-外功防御 3.内功穿透-外功破甲
				if(Att.getJobType(data.metier)==Att.WU_LI){
					var temp:String=Att.getAttName(Att.LI_LIANG);
					mc["txt_metierAttName1"].text=temp.substr(0,1)+temp.substr(1,1)+"：";
					mc_basicAtt["txt_metierAttName2"].text=Att.getAttName(Att.HURT_WAI_GONG);
					mc_basicAtt["txt_metierAttName3"].text=Att.getAttName(Att.HURT_PO_JIA);
					
					Lang.addTip(mc["txt_faShu"],"jiaose_liliang");
				}
				if(Att.getJobType(data.metier)==Att.MO_FA){
					var temp1:String=Att.getAttName(Att.FA_SHU);
					mc["txt_metierAttName1"].text=temp1.substr(0,1)+temp1.substr(1,1)+"：";
					mc_basicAtt["txt_metierAttName2"].text=Att.getAttName(Att.HURT_NEI_GONG);
					mc_basicAtt["txt_metierAttName3"].text=Att.getAttName(Att.HURT_CHUAN_TOU);
					
					Lang.addTip(mc["txt_faShu"],"jiaose_fashu");
				}

				mc["txt_shengMing"].text=data.shengming+"/"+data.shengmingMax;
				mc["txt_lingLi"].text=data.lingli+"/"+data.lingliMax;
			
				mc["mc_progress_hp"]["mc_zhe_zhao"].scaleX=data.shengming/data.shengmingMax;
				mc["mc_progress_mp"]["mc_zhe_zhao"].scaleX=data.lingli/data.shengmingMax;
				
				//根据职业获得相应属性值
				if(Att.getJobType(data.metier)==Att.WU_LI){
//					mc["txt_faShu"].text=data.liLiang;
//					mc_basicAtt["txt_gongJi"].text=data.gongjiWai;
//					mc_basicAtt["txt_chuanTou"].text=data.pojiaWai;
				}
				if(Att.getJobType(data.metier)==Att.MO_FA){
//					mc["txt_faShu"].text=data.faShu;
//					mc_basicAtt["txt_gongJi"].text=data.gongjiNei;
//					mc_basicAtt["txt_chuanTou"].text=data.pojiaNei;
				}
				mc_basicAtt["txt_fangYuWai"].text=data.fangyuWai+"-"+data.fangyuWaiMax;
				mc_basicAtt["txt_fangYuNei"].text=data.fangyuNei+"-"+data.fangyuNeiMax;
				
				mc_basicAtt["txt_mingZhong"].text=data.mingzhong;
				mc_basicAtt["txt_shanBi"].text=data.shanbi;
				mc_basicAtt["txt_baoJi"].text=data.baoji;
				
				//2013-09-12 最大350
				mc_basicAtt["txt_baoJiRate"].text=data.baojiRate;
		
			}
				
		}



	}
}






