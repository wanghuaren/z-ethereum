package scene.body 
{
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.GameMgr;
	import com.bellaxu.mgr.TargetMgr;
	import com.bellaxu.res.ResTool;
	
	import common.utils.CtrlFactory;
	
	import engine.load.Loadres;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCFly2;
	
	import scene.display.NowLoading;
	import scene.event.MapDataEvent;
	import scene.load.GameNewLoadMain;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffectManager;
	import scene.utils.MapData;
	
	import ui.frame.UISource;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.view.view1.xiaoGongNeng.Welcome;
	import ui.view.view7.UI_Mrt;
	import ui.base.login.NewRole_new;
	
	import world.FileManager;
	import world.WorldEvent;

	public class Body extends EventDispatcher 
	{
		private static var _instance:Body;
		
		/**
		 * 本地事件通迅
		 */
		private var _sceneEvent:EventBody;
		
		public function get sceneEvent():EventBody
		{
			return _sceneEvent;
		}
		
		private var _sceneKing:KingBody;
		
		public function get sceneKing():KingBody
		{
			return _sceneKing;
		}
		
		public var _sceneTrans:TransBody;
		
		private var _sceneRes:ResBody;
		
		public function get sceneRes():ResBody
		{
			return _sceneRes;
		}

		public static function get instance():Body
		{
			if(!_instance)
				_instance = new Body();
			return _instance;
		}
		
		/**
		 * 负责显示出来
		 */ 
		public function Body() 
		{
			if(!_sceneKing)
				_sceneKing = new KingBody();
			if(!_sceneTrans)
				_sceneTrans = new TransBody();
			if(!_sceneRes)
				_sceneRes = new ResBody();
			if(!_sceneEvent)
				_sceneEvent = new EventBody();
			SceneManager.AddEventListener(WorldEvent.MapDataComplete, MapDataComplete);
		}

		private function MapDataComplete(we : WorldEvent) : void
		{
			//从地图里出来的需刷一下数据			
			UI_index.instance.FuBenInit();
			CtrlFactory.getUIShow().SetIndexEnabled(false);
			//提前加载其它			
			SkillEffectManager.instance.preLoadOther(Data.myKing.level, Data.myKing.sex, SceneManager.instance.currentMapId);
			
			LoadFunc2();
			loadUI2();
		}
		
		private function LoadFunc2():void
		{
			if(!GameNewLoadMain.FirstInGame)
				GameNewLoadMain.CPlayerMapChangeCore2();
			
			DataKey.instance.sleep = false;
			//项目转换
			NowLoading.getInstance().hide();
			setTimeout(function():void{
				
				if(!GameNewLoadMain.FirstInGame)
				{
					//GameNewLoadMain.CPlayerMapChangeCore2();
					GameNewLoadMain.MosaicMapCompleteX();
				}
				
				UI_index.instance.StoryJumpMap(false);
				
				CtrlFactory.getUIShow().SetIndexEnabled(true);
				
				var s_p:PacketSCFly2 = new PacketSCFly2();
				s_p.flag = 0;
				DataKey.instance.receive(s_p);
				
				if (UI_index.indexMC_mrt["smallmap"]["btnHidePlayer"].currentFrame == 2)
					UI_Mrt.instance.mcHandler({name:"btnHidePlayer"});
				
				if (NewRole_new.loginTimes == 1)
				{
					NewRole_new.loginTimes++;
					Welcome.instance().open(true,false);
				}
				MapData.DispatchEvents(MapDataEvent.MapShowComplete, null);
			},350);
			//这句会切换地图后开始任务自动寻路
			//	GameNet.sendObj("SNpcGetStatus", "CNpcStatus", {});
			//	GameNet.sendObj("SNpcGetList", "CNpcGetList", {map_id:MapData.MAPID});
		}

		private function _SelectQualityWindowCallback():void
		{
			if (NewRole_new.loginTimes == 1)
			{
				NewRole_new.loginTimes++;
				//				var huanying:DisplayObject=GamelibS.getswflink("game_index", "girl_welcome");
				//				var do_huanying:DisplayObject=(new GameAlert).ShowMsg(huanying, 3, null, function(type:int):void
				//				{
				//					var vo:PacketCSAutoSeek=new PacketCSAutoSeek();
				//					vo.seekid=30100001;
				//					DataKey.instance.send(vo);
				//				}, 1, 0);
				//				do_huanying.x+=200;
				//				do_huanying.y+=100;
				Welcome.instance().open(true, false);
			}
		}
		private var _ldUi:Loadres;

		public function get ldUI():Loadres
		{
			if (null == _ldUi)
			{
				_ldUi=Loadres.getInstance().getItem;
			}
			return _ldUi;
		}
		public function sortLoadUI(swfName2:String):Loadres
		{
			if ("" == swfName2 || null == swfName2)
			{
				return null;
			}
			//info2自动加载，会调顺序
			if (ldUI.sort(swfName2))
			{
				return ldUI;
			}
			//info3手动触发加载
			var sUrl2:String=FileManager.instance.getUI(swfName2);
			var sArr2:Array=[sUrl2];
			var ld:Loadres=Loadres.getInstance().getItem;
			ld.loading_remain3();
			ld.load(sArr2);
			//			var info3:Array = Loadres.info3;
			//			
			//			for(var i:int=0;i<info3.length;i++)
			//			{
			//				var sUrl:String = info3[i];
			//				var swfName:String = Loadres.getFileName(sUrl);
			//					
			//				if(swfName == swfName2)
			//				{
			//					var sUrl2:String = info3[i];
			//					var sArr2:Array = [sUrl2];
			//						
			//					info3.splice(i,1);
			//						
			//					var ld:Loadres = Loadres.getInstance().getItem;
			//						
			//					ld.loading_remain3();
			//					ld.load(sArr2);
			//						
			//					return ld;
			//				}				
			//			}
			return ld;
		}
		
		
		private function loadUI2():void
		{
			ldUI.loading_remain2();
			//
			//ldUI.sort("game_index1");
			//ldUI.sort("si_liao");
			//ldUI.sort("gm_lianxi");
			//ldUI.sort("jue_se");
			//ldUI.sort("ji_neng");
		}
	}
}
