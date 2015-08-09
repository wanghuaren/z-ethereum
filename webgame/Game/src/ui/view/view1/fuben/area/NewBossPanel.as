package ui.view.view1.fuben.area
{
	import com.bellaxu.map.MapLoader;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import nets.packets.PacketSCBossSelfDamage;
	
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.king.IGameKing;
	import scene.load.ReadMapData;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;
	
	import world.FileManager;
	import world.WorldEvent;
	
	public class NewBossPanel
	{
		private var time:int;
		private var mc:MovieClip;
		//鼓舞次数
		private var rmbbuff:int;
		private var coinbuff:int;
		public static var boss_name:String;
		public var isShow :Boolean = false;
		
		
		private static var _instance : NewBossPanel = null;
		
		
		public static function get instance() : NewBossPanel {
			if (null == _instance)
			{
				_instance=new NewBossPanel();
				_instance.mc = UI_index.indexMC["bossHp"];
			}
			return _instance;
		}
		
		public function NewBossPanel()
		{
		GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
		}

		private var curMon:IGameKing;
		private function _onClockSecond(e:WorldEvent):void
		{
			if(guai != null){
				setHpBar(guai);
			}
		}
		public function bloodBarFull():void
		{
			if(mc["hp"]==null)return;
			mc["hp"]["zhedang"].scaleX = 1;
		}
		private var guai:IGameKing
		public function clickGuai(_guai:IGameKing,_isShow:Boolean):void{
			if(mc==null){
				return;
			}
			if((_isShow==false&&mc!=null)||_guai==null){
				mc.visible =isShow=_isShow;
				//mc.x=mc.stage.stageWidth / 2 - UI_index.indexMC["bossHp"].width / 2;
				bloodBarFull();
				guai = null;
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				return;
			}
			if(_guai.hp<=0){
				mc.visible = false;
				guai = null;
				bloodBarFull();
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				return;
			}
//			if(	!ReadMapData.mapShowHead){//有的地图不显示该血条
			if(	!MapLoader.mapShowHead){//有的地图不显示该血条
				mc.visible  = false;
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				return;
			}
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
			guai = _guai;
			if(mc.currentFrame!=7)
				mc.gotoAndStop(7);			
			mc.visible =isShow=_isShow;
	
			
			curMon = _guai;
			var hpscale:Number = Number( _guai.hp/_guai.maxHp);
			mc["hp_txt"].htmlText =_guai.hp+"/"+_guai.maxHp;
			setHpBar(_guai);
			mc["hp"]["zhedang"].scaleX = hpscale;
			mc["level"].htmlText = _guai.level;
			mc["king_name"].htmlText = _guai.getKingName;
			
			var boss:Pub_NpcResModel = XmlManager.localres.getNpcXml.getResPath(_guai.dbID) as Pub_NpcResModel;
//			mc["uil"].source = FileManager.instance.getHeadIconXById(boss.res_id);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconXById(boss.res_id));
		}
			private var mapBoss:Array ;
			
		public function isShowPanel(_guai:IGameKing=null,_isShow:Boolean=false):void{
			if(mc==null){
				return;
			}
			if((_isShow==false&&mc!=null)||_guai==null){
				
				mc.visible =isShow=_isShow;
				bloodBarFull();
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				guai = null;
				return;
			}
			UI_index.indexMC["bossHp"].x=(UI_index.indexMC.stage.stageWidth- UI_index.indexMC["bossHp"].width) / 2;
			if(_guai.hp<=0){
				mc.visible = false;
				bloodBarFull();
				guai = null;
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				return;
			}
//			if(	!ReadMapData.mapShowHead){//有的地图不显示该血条
			if(	!MapLoader.mapShowHead){//有的地图不显示该血条
				guai = null;
				mc.visible  = false;
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				return;
			}
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
			guai = _guai;
			mc.visible =isShow=_isShow;
			if(mc.currentFrame!=7)
			mc.gotoAndStop(7);		
			
			mc["hp_txt"].htmlText = _guai.hp+"/"+_guai.maxHp
			setHpBar(_guai);
			mc["level"].htmlText = _guai.level;
			mc["king_name"].htmlText = _guai.getKingName;
			
			var boss:Pub_NpcResModel = XmlManager.localres.getNpcXml.getResPath(_guai.dbID) as Pub_NpcResModel;
//			mc["uil"].source = FileManager.instance.getHeadIconXById(boss.res_id);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconXById(boss.res_id));
		}

		public function setHpBar(_enemyKing:IGameKing):void
		{
			if(_enemyKing.objid!=guai.objid){
				_enemyKing = guai;
			}
			if(null != mc["hp"])
			{
				CtrlFactory.getUIShow().fillBar([mc["hp"]["zhedang"]],
					[_enemyKing.hp,_enemyKing.maxHp]);
			}
			
			if(null != mc["hp_txt"])
			{
				mc["hp_txt"].htmlText = _enemyKing.hp+"/"+_enemyKing.maxHp;
			}
			
			
		}

		private function clcikHander(e:MouseEvent):void
		{
			var cost:int;
			//			
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