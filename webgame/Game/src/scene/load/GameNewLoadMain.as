package scene.load
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.StateDef;
	import com.bellaxu.display.FubenTips;
	import com.bellaxu.display.MapLoading;
	import com.bellaxu.map.MapBlockContainer;
	import com.bellaxu.map.MapLoader;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.res.MapResLoader;
	import com.bellaxu.res.ResLoader;
	import com.bellaxu.res.ResMcMgr;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.StageUtil;
	
	import common.utils.AsToJs;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import model.fuben.FuBenModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCMapSend2;
	
	import nets.packets.PacketSCMapSend;
	
	import scene.action.Action;
	import scene.action.hangup.GamePlugIns;
	import scene.body.Body;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.WaftNumManager;
	import scene.utils.MapData;
	import scene.utils.PowerManage;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.UISource;
	import ui.frame.UIWindow;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view2.other.ControlButton;
	
	import world.WorldEvent;

	public class GameNewLoadMain extends EventDispatcher
	{
		public static var FirstInGame:Boolean=true;
		public static var lastMapId:int=0;
		//单例－andy
		private static var instance:GameNewLoadMain=null;

		public static function getInstance():GameNewLoadMain
		{
			if (!instance)
				instance=new GameNewLoadMain();
			return instance;
		}

		public function GameNewLoadMain():void
		{

		}

		public function InitFunc():void
		{
			DataKey.instance.register(PacketSCMapSend.id, CPlayerMapChange);
		}

		//------------------------CPlayerMapChange		
		private static var mapSendP:PacketSCMapSend2=null;

		private function CPlayerMapChange(p:PacketSCMapSend2):void
		{
			mapSendP=p;

			FirstInGame=false;

//			if (null != Data.myKing.king)
//			{
//				(Data.myKing.king as King).setKingPosXY(p.mapx,p.mapy);
////				var k_x:int = Data.myKing.king.x;
////				var k_y:int = Data.myKing.king.y;
//				
////				Data.myKing.king.setKingMoveStop(true);
////				
////				MyWay.way = null;
//				(Data.myKing.king as King).idle();
//			}
			ChangeAndSetMapData(p.mapid);
		}

		public static function CPlayerMapChangeCore2():void
		{
			switch (Data.myKing.mapid)
			{
				case 20220032:
					FubenTips.show(360, "有一种感情叫兄弟", "有一处圣地叫沙城", "还记得那热血激情吗");
					break;
				case 20220040:
					SysConfig.getInstance().setMonsterBoolBar(true);
					break;
			}
		}

		private function CPlayerMapChangeCore(p:PacketSCMapSend2):void
		{
			GameData.state == StateDef.LOADING;
			MapLoading.getInstance().show();
			//QQ版本不需要此功能
			if (SceneManager.instance.isAutoRefreshPage(DataKey.instance.runCount))
				AsToJs.callJS("refreshpage");
			//fux_map
			SceneManager.instance.setCurrentMapId(p.mapid, 0);
			//	
			if (Data.myKing.mapid == 20220040 && p.mapid != 20220040)
			{
				SysConfig.getInstance().setMonsterBoolBar(false);
			}
			Data.myKing.mapid=p.mapid;
			MapData.MapChangeSeekId=p.seekid;

			//停止挂机
			if (GamePlugIns.getInstance().running)
			{
				GamePlugIns.getInstance().stop();
			}
			//清理掉物数据
			GamePlugIns.getInstance().clearPlist();

			//
			PowerManage.StopAndDelAllRunFunc();

			//
			if (Data.myKing.king != null)
			{
				(Data.myKing.king as King).idle();
			}

			var depth_Child_List:Array=SceneManager.instance.Depth_Child_List;
			var jLen:int=depth_Child_List.length;
			for (var j:int=0; j < jLen; j++)
			{
				if (depth_Child_List[j] as IGameKing)
				{
					(depth_Child_List[j] as King).idle();
				}
			}

			Action.instance.fight.DelAll();
			Action.instance.fight.HideHeadMenu();
			Action.instance.fight.HideNpcStatus();

			WaftNumManager.instance.DelAll();
			UIWindow.removeWin(UISource.MapChange);



			UI_index.indexMC_mrt_smallmap["MapNameText"].text=SceneManager.instance.currentMapName;

			ControlButton.getInstance().check();

			//关闭 活动倒计时 窗口
			FuBenModel.getInstance().closeHuoDongCountDownWindow();



			if (null != Data.myKing.king)
			{
				(Data.myKing.king as King).setKingPosXY(p.mapx, p.mapy);
				//				var k_x:int = Data.myKing.king.x;
				//				var k_y:int = Data.myKing.king.y;

				//				Data.myKing.king.setKingMoveStop(true);
				//				
				//				MyWay.way = null;
				(Data.myKing.king as King).idle();
			}
			MapBlockContainer.getInstance().clear();
			ResTool.clearWhenChangeMap();
			Body.instance.sceneKing.DelAll();
			ResMcMgr.timeGc();
			//2012-07-23 andy 切换地图停止播放声音
			MusicMgr.changeMap();
		}

		public function ChangeAndSetMapData(map_id:int):void
		{
			if (lastMapId == map_id) //同一张地图不在重复地图资源配置加载
				return;
			lastMapId=map_id;
			SceneManager.MapInLoading=true;
			MapLoader.ReadData(ReadDataRecv, map_id);
		}

		private function ReadDataRecv():void
		{
			if (!FirstInGame)
			{
				CPlayerMapChangeCore(mapSendP);
				dispatchMosaicMapCompleteEvent();

			}
			else if (FirstInGame)
			{
				MosaicMapCompleteX();
			}
		}

		private static var isCheck:Boolean;

		private static function enterFrameFunc(e:Event):void
		{
			if (isCheck && Data.myKing.king && FirstInGame)
			{
				isCheck=false;
				StageUtil.removeEventListener(Event.ENTER_FRAME, enterFrameFunc);
				Data.myKing.king.CenterAndShowMap();
				Data.myKing.king.CenterAndShowMap2();
				instance.dispatchMosaicMapCompleteEvent();
			}
		}

		public static function MosaicMapCompleteX():void
		{
			if (FirstInGame)
			{
				StageUtil.addEventListener(Event.ENTER_FRAME, enterFrameFunc)
				isCheck=true;
			}
		}

		private function dispatchMosaicMapCompleteEvent():void
		{
			SceneManager.DispatchEvents(WorldEvent.MapDataComplete, SceneManager.instance.currentMapId);
		}
	}
}
