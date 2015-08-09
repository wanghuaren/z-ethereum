package ui.view.view1.fuben.area
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructRank_List2;
	
	import nets.packets.PacketCSServerCoinBuff;
	import nets.packets.PacketCSServerRmbBuff;
	import nets.packets.PacketSCBossInfoUpdate;
	import nets.packets.PacketSCBossSelfDamage;
	import nets.packets.PacketSCServerCoinBuff;
	import nets.packets.PacketSCServerRmbBuff;
	
	import scene.manager.SceneManager;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view6.GameAlert;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;
	import world.WorldEvent;

	public class BossPanel
	{
		private var time:int;
		private var mc:MovieClip;
		//鼓舞次数
		private var rmbbuff:int;
		private var coinbuff:int;
		public static var boss_name:String;
		
		private static var _instance : BossPanel = null;
		
		public static function get instance() : BossPanel {
			if (null == _instance)
			{
				_instance=new BossPanel();
				_instance.mc = UI_index.indexMC["mc_fu_ben"];
			}
			return _instance;
		}
		
		public function BossPanel()
		{
			
		}
		
		public function init():void{
			DataKey.instance.register(PacketSCBossInfoUpdate.id,SCBossInfoUpdate);
			DataKey.instance.register(PacketSCServerRmbBuff.id,SCRmbBuff);
			DataKey.instance.register(PacketSCServerCoinBuff.id,SCRmbBuff);
			
			DataKey.instance.register(PacketSCBossSelfDamage.id,SCBossSelfDamage);
					
			
			mc.gotoAndStop(3);			
			
			//显示玩家
			//隐藏玩家
			var isShowPlayer:Boolean = SysConfig.getSettingValue(2);
			
			//mc["btnYinCangWanJia"].label =  isShowPlayer == true?"显示玩家":"隐藏玩家";
			
			mc["btnYinCangWanJia"].label =  isShowPlayer == true?Lang.getLabel("50011_PanelJiangLi"):Lang.getLabel("50012_PanelJiangLi");
			
			this.setSmallMapVisible(false);				
			
			
			Lang.addTip(mc["yuanbao"], "yuanbaoguli");
			Lang.addTip(mc["yinliang"], "jinbiguli");
			
			mc.addEventListener(MouseEvent.CLICK,clcikHander);
		}
		
		public function setSmallMapVisible(value:Boolean):void
		{
			UI_index.indexMC_mrt["missionMain"].visible = value;
			//UI_index.indexMC_mrt["mc_up_target"].visible = value;
			
			if(value)
			{
				if(null == UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(UI_index.indexMC_mrt_buttonArr!=null&&null == UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt.addChild(UI_index.indexMC_mrt_buttonArr);
				}			
				
				return;
			}
			
			if(!value)
			{
				if(null != UI_index.indexMC_mrt_smallmap.parent)
				{
					UI_index.indexMC_mrt_smallmap.parent.removeChild(UI_index.indexMC_mrt_smallmap);
				}
				
				if(UI_index.indexMC_mrt_buttonArr!=null&&null != UI_index.indexMC_mrt_buttonArr.parent)
				{
					UI_index.indexMC_mrt_buttonArr.parent.removeChild(UI_index.indexMC_mrt_buttonArr);
				}				
				
			}
			
		}
		
		private function SCBossInfoUpdate(p:IPacket) : void {
			var value:PacketSCBossInfoUpdate = p as PacketSCBossInfoUpdate;
			
			var boss:Pub_NpcResModel = XmlManager.localres.getNpcXml.getResPath(value.bossres) as Pub_NpcResModel;
			mc["king_name"].text = boss_name = boss.npc_name;
//			mc["uil"].source = FileManager.instance.getHeadIconXById(boss.res_id);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconXById(boss.res_id));
			if(time==0){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
				time = int(value.lefttime/1000);
				
			}
			
			
			
			mc["renshu"].text = value.gameman;
			CtrlFactory.getUIShow().fillBar([mc["hp"]["zhedang"]],
				[value.curhp,value.maxhp]);
			
			var list:Vector.<StructRank_List2> = value.arrItemrank_list;
			var str1:String="";
			var str2:String="";
			var color:String;
			
			//排行榜前三名颜色
			//private const arrColor:Array=["","#ff9b0f","#f64afd","#09a3d7"];
			
			for(var i:int=0;i<value.arrItemrank_list.length;i++)
			{
				
				switch(i)
				{
					case 0:
						//color = "f9870c";
						color = "ff9b0f";
						break;
					case 1:
						color = "f64afd";
						break;
					case 2:
						color = "09a3d7";
						break;
					default:
						color = "969393";
						break;
				}
				
				//前三名加粗
				if(i < 3)
				{
					str1 += "<b><font color='#"+color+"'>"+list[i].rank_no+"."+list[i].name+"</font></b>\n";
					str2 += "<b><font color='#"+color+"'>"+Lang.getLabel("shanghai")+list[i].damage+"("+
						//int(list[i].per/100)+"."+int(list[i].per%100)+
						(list[i].per/100)+
						"%)</font></b>\n";
				
				}else
				{
					str1 += "<font color='#"+color+"'>"+list[i].rank_no+"."+list[i].name+"</font>\n";
					str2 += "<font color='#"+color+"'>"+Lang.getLabel("shanghai")+list[i].damage+"("+
						//int(list[i].per/100)+"."+int(list[i].per%100)+
						(list[i].per/100)+
						"%)</font>\n";
				}
			}
			
			mc["txt_boss_list1"].htmlText = str1;
			mc["txt_boss_list2"].htmlText = str2;
			
			
			
		}
		
		private function TimerCLOCK(e:WorldEvent) : void {
			time--;
			mc["txt_sheng_shi"].text = getskillcolltime(time);
		}
		
		private function getskillcolltime(value:int):String{
			return int(value/60)+Lang.getLabel("pub_fen")+int(value%60)+Lang.getLabel("pub_miao");
		}
		
		public function leave():void
		{
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,TimerCLOCK);
			
			if(null != mc)
			{
				mc.gotoAndStop(1);
			}
			time = 0;
			
			//
			if(true == BossJiangLi.hasAndGetInstance()[0])
			{
				if(BossJiangLi.hasAndGetInstance()[1].isOpen)
				{
					BossJiangLi.hasAndGetInstance()[1].winClose();
				}			
			}
			
			//
			this.setSmallMapVisible(true);
			
		}
		
				
		private function clcikHander(e:MouseEvent):void
		{
			var cost:int;
			
			switch(e.target.name){
				case "yuanbao":
					
					//vip 0级才可使用
					if(Data.myKing.Vip >= 0)
					{
						cost = 10+2*rmbbuff;
						
						
							
						//根据地图 ID 判断是否为 跨服 Boss 战
						if(20200032 == SceneManager.instance.currentMapId)
						{
							GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("20074_FuBen",[cost.toString()]),GameAlertNotTiShi.GUWU,null,function():void{
								var vo:PacketCSServerRmbBuff=new PacketCSServerRmbBuff();
								DataKey.instance.send(vo);
							});
						}
					}else
					{
						//Vip等级低于3级时，点击元宝鼓舞，银两鼓舞会在提示信息4处显示：
						//VIP3级以上可享受此功能。
						Lang.showMsg({type:4,msg:Lang.getLabel("20078_vip3")});
						
					
					}
					
					break;
				case "yinliang":
					
					//vip 3级才可使用
					if(Data.myKing.Vip >= 0)
					{
						cost = 10000+5000*coinbuff;
						
						
						
						//根据地图 ID 判断是否为 跨服 Boss 战
						if(20200032 == SceneManager.instance.currentMapId)
						{
							(new GameAlert).ShowMsg(Lang.getLabel("20075_FuBen",[cost.toString()]),4,null,function():void{
								var vo2:PacketCSServerCoinBuff=new PacketCSServerCoinBuff();
								DataKey.instance.send(vo2);
							});
						}
					}else
					{
						//Vip等级低于3级时，点击元宝鼓舞，银两鼓舞会在提示信息4处显示：
						//VIP3级以上可享受此功能。
						Lang.showMsg({type:4,msg:Lang.getLabel("20078_vip3")});
					}
					
					break;
			}
		}
		
		private function SCRmbBuff(p:IPacket) : void {
			Lang.showResult(p);
		}
		
		
		
		private function SCBossSelfDamage(p:PacketSCBossSelfDamage) : void {
			//mc["txt_boss_hurt"].text = Lang.getLabel("20073_FuBen")+p.damage+"("+int(p.per/100)+"."+int(p.per%100)+"%)";
			
			mc["txt_boss_hurt"].text = Lang.getLabel("20073_FuBen")+p.damage+				
				"("+
				(p.per/100).toString() + 
				"%)";
			
			rmbbuff = p.rmbbuff;
			coinbuff = p.coinbuff;
			if(rmbbuff+coinbuff>=10){
				StringUtils.setUnEnable(mc["yuanbao"]);
				StringUtils.setUnEnable(mc["yinliang"]);
			}else{
				StringUtils.setEnable(mc["yuanbao"]);
				StringUtils.setEnable(mc["yinliang"]);
			}
		}
	}
}