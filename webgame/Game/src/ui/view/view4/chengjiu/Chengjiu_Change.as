package ui.view.view4.chengjiu
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.managers.Lang;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.chengjiu.ChengjiuModel;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.view.view7.UI_Exclamation;
	
	import world.FileManager;
	
	public class Chengjiu_Change extends Sprite
	{
		private var arChangePanel:MovieClip;
		private static var _instance:Chengjiu_Change;
		
		public function Chengjiu_Change()
		{
			if (arChangePanel == null)
			{
//				arChangePanel=GamelibS.getswflink("game_index", "chengjiu_tishi") as MovieClip;
			}
		}
		
		public static function getInstance():Chengjiu_Change
		{
			if (_instance == null)
				_instance=new Chengjiu_Change();
			return _instance;
		}
		private var parm:Pub_AchievementResModel=null;
		public function chengjiuChangData(change:Pub_AchievementResModel):void
		{
			if(change== null)return;
			if (arChangePanel == null)
			{
				arChangePanel=GamelibS.getswflink("game_index", "chengjiu_tishi") as MovieClip;
				if(arChangePanel!=null){
					arChangePanel["item1"]["uil"].source=FileManager.instance.getIconXById(11800352);
					arChangePanel["item2"]["uil"].source=FileManager.instance.getIconXById(11800220);
					arChangePanel["item3"]["uil"].source=FileManager.instance.getIconXById(11800200);
				}
			}
			if (arChangePanel != null && arChangePanel.parent == null )
			{
				parm=change;
				arChangePanel.x=(GameIni.MAP_SIZE_W - 300) / 2;
				arChangePanel.y=GameIni.MAP_SIZE_H - 350;
				arChangePanel["mingcheng"].text=parm.target_desc;
				
				arChangePanel["item1"]["txt_num"].text=VipGift.getInstance().getWan(parm.achievement_value);
				arChangePanel["item2"]["txt_num"].text=VipGift.getInstance().getWan(parm.prize_coin2);
				arChangePanel["item3"]["txt_num"].text=VipGift.getInstance().getWan(parm.prize_coin1);
;
				//				arChangePanel["point"].text=parm.achievement_value;
//				arChangePanel["icon"].source=FileManager.instance.getChengJiuIconById(parm.achievement_icon);
				ImageUtils.replaceImage(arChangePanel,arChangePanel["icon"],FileManager.instance.getChengJiuIconById(parm.achievement_icon));
				//UI_index.indexMC.addChild(arChangePanel);
				UI_Exclamation.instance.mc.addChild(arChangePanel);
				
				arChangePanel.gotoAndPlay(1);
				arChangePanel.addFrameScript(arChangePanel.endframe, deleteWin);
				
				arChangePanel.mouseEnabled=true;
				//arChangePanel.mouseChildren=false;
				//				arChangePanel.arType=parm.sort;
				arChangePanel.addEventListener(MouseEvent.CLICK, clickAr);
				
				arChangePanel.addEventListener(MouseEvent.CLICK,mcHandler);
				
				GameMusic.playWave(WaveURL.ui_get_cheng_jiu);
			}
		}
		
		private function mcHandler(e:MouseEvent):void{
			var target:Object=e.target;
			switch(target.name){
				case "btnOk":
//					if(parm!=null)
//						ChengjiuModel.getInstance().getReward(parm.ar_id);
					onComplete1();
					
					break;
				default:
					break;
			}
		}
		
		private static function clickAr(e:MouseEvent):void
		{
			try
			{
				//					ChengJiu2.instance.open(true);
				//					ChengJiu2.instance.bg.outDownHander(ChengJiu2.instance.mc["groupBtn" + (int(arChangePanel.arType) - 1)], false);
			}
			catch (e:Error)
			{
				trace("ChengJiu2 严重错误!!!!!");
			}
		}
		
		private function deleteWin():void
		{
			if (arChangePanel.parent != null)
			{
				TweenLite.to(arChangePanel, 10, {alpha: 1, delay: 0, onComplete: onComplete1});
			}
		}
		
		private function onComplete1():void
		{
			TweenLite.killTweensOf(arChangePanel, true);
			arChangePanel.alpha=1;
			arChangePanel.removeEventListener(MouseEvent.CLICK, clickAr);
			if (arChangePanel.parent != null)
				arChangePanel.parent.removeChild(arChangePanel);
			//				playArCompelete();
		}
	}
}