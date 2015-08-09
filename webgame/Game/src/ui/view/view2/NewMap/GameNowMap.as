package ui.view.view2.NewMap
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import display.components.CheckBoxStyle1;
	import display.components.ScrollContent;
	import display.components2.UILd;
	
	import engine.event.DispatchEvent;
	import engine.utils.SystemGC;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import netc.Data;
	import netc.packets2.PacketSCMapSend2;
	import netc.packets2.PacketSCTeamMemberDesc2;
	import netc.packets2.StructTeamMember2;
	
	import nets.packets.StructTeamMember;
	
	import scene.action.PathAction;
	import scene.action.hangup.GamePlugIns;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.gprs.GameSceneGprs;
	import scene.king.FightSource;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.libclass.GameTinyNpc;
	import scene.libclass.SmBody;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.base.renwu.MissionMain;
	import ui.base.renwu.renwuEvent;
	import ui.base.zudui.DuiWu;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.WorldPoint;
	import world.type.BeingType;

	/**
	 *	地图【当前地图和世界地图】
	 *  andy 2011-01-13
	 */
	public class GameNowMap extends UIWindow
	{
		private var mc_content:Sprite=null;
		//当前地图图片
		//private var map:JPGLoader;
		private var map:UILd;
		//gprs
		private var mc_gprs:Sprite;
		//npc【左边】
		private var mc_npc:Sprite;
		//队员【左边】
		private var mc_team:Sprite;
		//传点【左边】
		private var mc_chuandian:Sprite;
		private var xianrenzhiluBtn:SimpleButton;
		private var mc_monster:Sprite;
		//玩家
		private var mc_player:Sprite;
		//小地图和大地图的缩放比例
		private var beiW:Number=0;
		private var beiH:Number=0;
		//当前地图id
		private var curMapId:int=0;
		//寻路id
		private var seekId:int=0;
		//世界地图悬浮
		private var mc_word_float:MovieClip;
		private static var gprsPath:Array=[];
		//
		private var arrCheck:Array=[0, 1, 1, 0, 1, 1, 1, 1];
		//控制地图右边先人指路面板显示
		private var mrpBool:Boolean=true;
		private static var _instance:GameNowMap;

		public static function instance():GameNowMap
		{
			if (_instance == null)
				_instance=new GameNowMap();
			return _instance;
		}

		public function GameNowMap(d:Object=null)
		{
			blmBtn=2;
			super(getLink("win_di_tu"), d);
		}

		override protected function init():void
		{
			if (m_initW < 0)
			{
				m_initW=mc.width;
				m_initH=mc.height;
			}
			addEvent();
			mcHandler({name: "cbtn1"});
			replace();
		}

		public function addEvent(p:PacketSCMapSend2=null):void
		{
			super.sysAddEvent(renwuEvent.instance, renwuEvent.TASKCHANGE, taskChange);
			super.sysAddEvent(renwuEvent.instance, renwuEvent.DuiWuAdd, AddTeam);
			super.sysAddEvent(renwuEvent.instance, renwuEvent.changeDuiWuLEVEL, ShowKingTeam);
			super.sysAddEvent(renwuEvent.instance, renwuEvent.DuiWuDelete, RemoveThisTeam);
			super.sysAddEvent(renwuEvent.instance, renwuEvent.DuiWuDeleteAll, RemoveAllTeam);
			super.sysAddEvent(Body.instance.sceneEvent, HumanEvent.AddShowToMap, AddShowToMap);
			super.sysAddEvent(Body.instance.sceneEvent, HumanEvent.RemoveThis, RemoveThisHuman);
			super.sysAddEvent(MapData.MAP_BODY, HumanEvent.RemoveAll, RemoveAllHuman);
			super.sysAddEvent(Body.instance.sceneEvent, HumanEvent.Arrived, Arrived);
			if (MapData.MAP_RES_WIDTH < Data.myKing.king.mapx || MapData.MAP_RES_HEIGHT < Data.myKing.king.mapy)
			{
				if (p != null)
				{
					Data.myKing.king.x=p.mapx;
					Data.myKing.king.y=p.mapy;
				}
				if (Data.myKing.king.hp > 0)
				{
					GamePlugIns.getInstance().start();
				}
			}
		}

		// 面板双击事件
		override protected function mcDoubleClickHandler(target:Object):void
		{
			var name:String=target.name;
			if (name.indexOf("item") >= 0)
			{
				mcHandler(target);
				mcHandler({name: "btnMove"});
			}
		}

		// 鼠标点击事件
		override public function mcHandler(target:Object):void
		{
			GamePlugIns.getInstance().needClickStop(target);
///item_now_map_npc (@1e4c5701)
			///item_now_map_npc (@1e4c5681)
			super.mcHandler(target);
			var name:String=target.name;
			//是否显示【右上】
			if (name.indexOf("check") == 0)
			{
				(target as CheckBoxStyle1).selected=!(target as CheckBoxStyle1).selected;
				var sort:int=int(name.replace("check", ""));
				arrCheck[sort]=(target as CheckBoxStyle1).selected ? 1 : 0;
				hideNpcListMap(sort, (target as CheckBoxStyle1).selected);
				return;
			}
			//当前地图上按钮【左边】
			if (name.indexOf("GameTinyNpc_") == 0)
			{
				seekId=int(name.replace("GameTinyNpc_", ""));
				seek();
				return;
			}
			//右边 npc列表  
			if (name.indexOf("item_npc") == 0)
			{
				seekId=int(name.replace("item_npc", ""));
				seek();
				return;
			}
			//当前地图菜单【右下】
//			if(name.indexOf("dbtn")==0){
//				sort=int(name.replace("dbtn",""));
//				mc_content["mc_title"].gotoAndStop(sort==3?2:1);
//				showNpcList(sort);
//				for(i=1;i<=3;i++){
//					(mc_content["dbtn"+i] as TabBtn).toggle= false;
//				}
//				(mc_content["dbtn"+sort] as TabBtn).toggle=true;
//				if(sort==1&&target!=null&&!target.hasOwnProperty("toggle"))
//					mc_content["dbtn1"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//				return;
//			}
			//当前地图按钮【右下】
//			if(target["parent"]["name"].indexOf("item_npc")==0){
			if (name.indexOf("btnFly") == 0)
			{
//				itemSelected(target);
				seekId=(target.parent.data as Pub_SeekResModel).seek_id;
				chuan();
				return;
			}
			switch (target.name)
			{
				case "cbtn1":
					type=1;
					(mc as MovieClip).gotoAndStop(1);
					mc_content=mc["mc_now"];
					now_map();
					break;
				case "cbtn2":
					type=2;
					(mc as MovieClip).gotoAndStop(2);
					mc_content=mc["mc_word"];
					word_map();
					break;
				case "btnMove":
					seek();
					break;
//				case "btnFly":
//					if(name.indexOf("GameTinyNpc_")==0){
//						seekId=int(name.replace("GameTinyNpc_",""));
//					}
//					break;
				case "xianrenzhiluBtn":
					mrpBool=!mrpBool
					mc_content["map_rightPanel"].visible=mrpBool;
					break;
			}
		}

		/***********世界地图************/
		/**
		 *	世界地图
		 */
		private function word_map():void
		{
			mc_word_float=mc_content["mc_float_info"] as MovieClip;
			mc_word_float.mouseEnabled=false;
			mc_word_float.mouseChildren=false;
			mc_word_float.visible=false;
			var child:DisplayObject=null;
			var len:int=mc_content.numChildren;
			for (var i:int=0; i < len; i++)
			{
				child=mc_content.getChildAt(i);
				if (child is SimpleButton)
				{
					(child as SimpleButton).useHandCursor=false;
					child.addEventListener(MouseEvent.ROLL_OVER, overWordMap);
					child.addEventListener(MouseEvent.ROLL_OUT, outWordMap);
				}
			}
		}

		private function overWordMap(me:MouseEvent):void
		{
			var target:SimpleButton=me.target as SimpleButton;
			var mapId:int=int(target.name.replace("btn_word", ""));
			//mapId=WORLD_MAP_IDS[mapId];
			var map:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(mapId) as Pub_MapResModel;
			if (map == null)
				return;
//			if(mapId==20100001||mapId==20100002||mapId==20100005){
//				(mc_content["btn_word20100005"] as SimpleButton).upState=(mc_content["btn_word20100005"] as SimpleButton).overState;
//			}
			target.addEventListener(MouseEvent.MOUSE_MOVE, moveWordMap);
			mc_content["mc_float_info"]["txt_map_name"].htmlText=map.map_title;
			mc_content["mc_float_info"]["txt_level1"].htmlText=map.min_level;
			mc_content["mc_float_info"]["txt_level2"].htmlText=map.monster_level;
			mc_content["mc_float_info"]["txt_level3"].htmlText=map.pk_mode;
			mc_content["mc_float_info"]["txt_desc"].htmlText=map.map_desc;
			mc_content["mc_float_info"].visible=true;
		}

		private function outWordMap(me:MouseEvent):void
		{
			me.target.removeEventListener(MouseEvent.MOUSE_MOVE, moveWordMap);
			mc_content["mc_float_info"].visible=false;
			var mapId:int=int(me.target.name.replace("btn_word", ""));
//			if(mapId==20100001||mapId==20100002||mapId==20100005){
//				(mc_content["btn_word20100005"] as SimpleButton).upState=(mc_content["btn_word20100005"] as SimpleButton).downState;
//			}
		}

		private function moveWordMap(me:MouseEvent):void
		{
			if (me.target.parent == null)
				return;
			var xx:int=me.target.parent.mouseX + 5;
			var yy:int=me.target.parent.mouseY + 5;
			if (xx + mc_content["mc_float_info"].width > mc_content.width)
				xx=xx - mc_content["mc_float_info"].width;
			if (yy + mc_content["mc_float_info"].height > mc_content.height)
				yy=yy - mc_content["mc_float_info"].height;
			mc_content["mc_float_info"].x=xx;
			mc_content["mc_float_info"].y=yy;
		}

		/***********当前地图************/
		/**
		 *	当前地图
		 */
		private function now_map():void
		{
			map=mc_content["uil"];
			mc_gprs=mc_content["mc_gprs"];
			mc_npc=mc_content["mc_npc"];
			mc_team=mc_content["mc_team"];
			mc_player=mc_content["mc_player"];
			mc_monster=mc_content["mc_monster"];
			mc_gprs.x=mc_npc.x=mc_team.x=mc_player.x=map.x;
			mc_gprs.y=mc_npc.y=mc_team.y=mc_player.y=map.y;
			xianrenzhiluBtn=mc_content["xianrenzhiluBtn"];
			mc_chuandian=mc_content["mc_chuandian"];
			mc_gprs.mouseEnabled=false;
			mc_npc.mouseEnabled=false;
			map.addEventListener(MouseEvent.MOUSE_DOWN, downNowHandle);
			map.addEventListener(MouseEvent.MOUSE_MOVE, moveNowHandle);
			mc_content.addEventListener(MouseEvent.MOUSE_OVER, downNowHandle);
			mc_content.addEventListener(MouseEvent.MOUSE_OUT, downNowHandle);
			mc_content["check1"].selected=arrCheck[1];
			mc_content["check2"].selected=arrCheck[2];
			mc_content["check3"].selected=arrCheck[3];
//			mc_content["check4"].selected=arrCheck[4];
			mc_content["check6"].selected=arrCheck[6];
			mc_content["check7"].selected=arrCheck[7];
			GameClock.instance.addEventListener(WorldEvent.CLOCK__, onEnterFrame);
			showNpcList(1);
//			showNpcList(2);
			showNpcList(3);
//			showNpcList(4);
			showNowMap();
		}

		private function onEnterFrame(e:Event):void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__, onEnterFrame);
			mc_content["check1"].selected=arrCheck[1];
			mc_content["check2"].selected=arrCheck[2];
			mc_content["check3"].selected=arrCheck[3];
//			mc_content["check4"].selected=arrCheck[4];
			mc_content["check6"].selected=arrCheck[6];
			mc_content["check7"].selected=arrCheck[7];
		}

		/**
		 *	点击当前地图
		 */
		private function downNowHandle(me:MouseEvent):void
		{
			var target:Object=me.target;
			me.currentTarget
			var name:String=target.name;
			switch (me.type)
			{
				case MouseEvent.MOUSE_DOWN:
					var po:WorldPoint=WorldPoint.getInstance().getItemGrid(map.mouseX * beiW, map.mouseY * beiH, map.mouseX * beiW, map.mouseY * beiH);
					PathAction.FindPathToMap(po);
					Body.instance.sceneKing.DelMeFightInfo(FightSource.ClickGround, 0);
					if (null != Data.myKing.king)
					{
						Data.myKing.king.getSkin().getHeadName().setAutoPath=true;
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if (name.indexOf("GameTinyNpc_") == 0)
					{
						mc_npc.setChildIndex(target as DisplayObject, mc_npc.numChildren - 1);
						(target as GameTinyNpc).showName(true);
					}
					if (name.indexOf("map_uid_team") == 0)
					{
						mc_team.setChildIndex(target as DisplayObject, mc_team.numChildren - 1);
						(target as SmBody).showName(true);
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if (name.indexOf("GameTinyNpc_") == 0)
					{
						(target as GameTinyNpc).showName(false);
					}
					if (name.indexOf("map_uid_team") == 0)
					{
						(target as SmBody).showName(false);
					}
					break;
			}
		}

		/**
		 *	当前地图鼠标移上，地图更新坐标显示值
		 */
		private function moveNowHandle(me:MouseEvent):void
		{
			mc_content["txt_pos"].text=Math.round(map.mouseX * beiW / MapData.TW) + "," + Math.round(map.mouseY * beiH / MapData.TH);
		}

		/**
		 *	地图有变化
		 */
		private function showNowMap():void
		{
			if (type == 1)
			{
				beiW=MapData.MAPW / 600;
				beiH=MapData.MAPH / 361;
				mc["mc_now"]["txt_pos"].text="0,0";
				mc["mc_now"]["txt_mapName"].text=SceneManager.instance.currentMapName;
				if (curMapId != SceneManager.instance.currentMapId)
				{
					curMapId=SceneManager.instance.currentMapId;
				}
				var res_id:String=XmlManager.localres.getPubMapXml.getResPath(curMapId)["small_res_id"];
				var s:String=FileManager.instance.getSmallMapById(res_id);
				if (null == map.source || map.source.toString() != s)
				{
					map.unload();
					map.source=s;
				}
				//map.setCompleteFunc=CompleteFunc;
				CompleteFunc();
			}
		}

		private function CompleteFunc():void
		{
			ShowKing(SceneManager.instance.GetKing_Core(PubData.roleID));
			for each (var team:StructTeamMember2 in DuiWu.stmVec)
			{
				if (team.roleid != Data.myKing.roleID)
				{
					this.ShowKingTeam(new DispatchEvent("", team.memberDesc));
				}
			}
			showNpcListMap();
			if (Data.myKing.king != null)
			{
				var zt:String=Data.myKing.king.roleZT;
				if (KingActionEnum.DJ == zt || KingActionEnum.ZOJ_DJ == zt || KingActionEnum.Dead == zt || KingActionEnum.ZOJ_Dead == zt)
				{
					gprsPath=[];
				}
				MapDrawPathLine(gprsPath);
				mcHandler({name: "dbtn1"});
			}
		}

		/**
		 *	移除地图上动态加载的所有玩家，怪物
		 */
		private function RemoveAllHuman(e:DispatchEvent=null):void
		{
			if (type == 1)
			{
				if (mc_chuandian != null)
				{
					while (mc_chuandian.numChildren > 0)
						mc_chuandian.removeChildAt(0);
				}
				if (mc_player != null)
				{
					while (mc_player.numChildren > 0)
						mc_player.removeChildAt(0);
				}
				if (mc_monster != null)
				{
					while (mc_monster.numChildren > 0)
						mc_monster.removeChildAt(0);
				}
				if (mc_gprs != null)
				{
					while (mc_gprs.numChildren > 0)
						mc_gprs.removeChildAt(0);
				}
				if (mc_npc != null)
				{
					while (mc_npc.numChildren > 0)
						mc_npc.removeChildAt(0);
				}
				if (mc_team != null)
				{
					while (mc_team.numChildren > 0)
						mc_team.removeChildAt(0);
				}
				if (map != null)
					map.unload();
					//Loadres.clean()
			}
		}

		/**
		 *	动态移除玩家和怪物【单个】
		 */
		private function RemoveThisHuman(e:DispatchEvent):void
		{
			if (type == 1)
			{
				var uid:String=e.getInfo;
				var PL:SmBody=mc_player.getChildByName("map_uid_" + uid) as SmBody;
				if (null == PL)
				{
					PL=mc_monster.getChildByName("map_uid_" + uid) as SmBody;
				}
				if (null != PL)
				{
					if (null != PL.parent)
					{
						PL.parent.removeChild(PL);
					}
				}
			}
		}

		/**
		 *	动态加载玩家和怪物【单个】
		 */
		private function AddShowToMap(e:DispatchEvent):void
		{
			this.ShowKing(SceneManager.instance.GetKing_Core(e.getInfo));
		}

		private function ShowKing(GameKing:IGameKing):void
		{
			if (GameKing != null && type == 1)
			{
				var king:King=King(GameKing);
				//队员过滤掉
				if (this.checkIsTeam(king.roleID))
					return;
				//小鸡不显示
				if (king.beingType == BeingType.MON || king.beingType == BeingType.NPC)
				{
					if (king.getKingType == 4 || king.getKingType == 6 || king.getKingType == 1 || king.getKingType == 2)
						return;
				}
				//伙伴不显示
				if (king.beingType == BeingType.PET)
					return;
				var uid:int=king.roleID;
				var PL:SmBody=mc_player.getChildByName("map_uid_" + uid.toString()) as SmBody;
				if (PL == null)
				{
					PL=mc_monster.getChildByName("map_uid_" + uid.toString()) as SmBody;
				}
				if (PL == null)
				{
					PL=ItemManager.instance().getSmBody();
					if (PL == null)
						return;
					PL.name="map_uid_" + uid.toString();
					PL.setObjid(uid);
					if (king.isMe)
					{
						PL.gotoAndStop(1);
					}
					else
					{
						if (king.beingType == BeingType.HUMAN)
						{
							PL.gotoAndStop(2);
								//PL.setRoleName(king.getKingName);
						}
						else if (king.beingType == BeingType.MON)
						{
							PL.gotoAndStop(3);
						}
						else
						{
							PL.gotoAndStop(4);
						}
					}
					if (king.beingType == BeingType.MON)
					{
						mc_monster.addChild(PL);
					}
					else
					{
						mc_player.addChild(PL);
					}
				}
				PL.x=king.mapx*MapData.TW / beiW;
				PL.y=king.mapy*MapData.TH / beiH;
				if (king.isMe)
				{
					PL.rotation=GameKing.roleAngle;
					PL.alpha=1.0;
				}
				else if (SceneManager.instance.isAtGhost())
				{
					PL.alpha=0.0;
				}
				else
				{
					PL.alpha=1.0;
				}
			}
		}

		/**
		 *	队伍解散
		 */
		private function RemoveAllTeam(e:Event=null):void
		{
			if (type == 1)
			{
				while (mc_team.numChildren)
					mc_team.removeChildAt(0);
			}
		}

		/**
		 *	移除一个队员【单个】
		 */
		private function RemoveThisTeam(e:DispatchEvent):void
		{
			if (type == 1)
			{
				var uid:String=e.getInfo;
				var PL:SmBody=mc_team.getChildByName("map_uid_team" + uid) as SmBody;
				if (null != PL)
				{
					if (null != PL.parent)
					{
						PL.parent.removeChild(PL);
					}
				}
			}
		}

		/**
		 *	动态加载队员【单个】
		 */
		private function AddTeam(e:DispatchEvent):void
		{
			//移除视野内玩家【必须的，否则会出现两个点】
			RemoveThisHuman(e);
		}

		/**
		 *	队员显示
		 */
		private function ShowKingTeam(e:DispatchEvent=null):void
		{
			if (type == 1)
			{
				var team:PacketSCTeamMemberDesc2=e.getInfo as PacketSCTeamMemberDesc2;
				//如果队友和自己不在同一张地图，侧从地图上删除 ,如果队友跟自己都在躲猫猫地图中，也从地图上删除
				if (team.mapid != this.curMapId || team.mapid == 20210008)
				{
					RemoveThisTeam(new DispatchEvent("", team.roleid + ""));
					return;
				}
				if (team.roleid != Data.myKing.roleID)
				{
					var PL:SmBody=mc_team.getChildByName("map_uid_team" + team.roleid) as SmBody;
					if (PL == null)
					{
						PL=ItemManager.instance().getSmBody();
						if (PL == null)
							return;
						PL.setRoleName(team.roleid, team.name + " " + XmlRes.GetJobNameById(team.metier));
						PL.name="map_uid_team" + team.roleid;
						PL.gotoAndStop(7);
						mc_team.addChild(PL);
					}
					PL.x=team.mapx*MapData.TW / beiW;
					PL.y=team.mapy*MapData.TH / beiH;
					PL.visible=arrCheck[6];
				}
			}
		}

		/**
		 * 设置导航位置
		 */
		public static function SetKingPos(GameKing:IGameKing):void
		{
			if (_instance != null && _instance.type == 1 && _instance.isOpen)
			{
				_instance.ShowKing(GameKing);
			}
		}

		/**
		 * 设置导航线
		 */
		public static function MapDrawPathLine(path:Array):void
		{
			if (null == path)
			{
				return;
			}
			//2013-12-09 躲猫猫不能寻路
			if (Data.myKing.king.isGhost)
			{
				path=[];
			}
			gprsPath=path;
			if (_instance != null && _instance.type == 1)
			{
				CtrlFactory.getUIShow().DrawPathLine(_instance.map, _instance.mc_gprs, path, _instance.beiW, _instance.beiH, 2, 9, 0x00FF00);
			}
		}

		/**
		 * 切换地图提前加载地图
		 */
		public function changeMap():void
		{
			if (_instance != null && _instance.mc != null)
			{
				MapDrawPathLine([]);
				RemoveAllHuman();
//				Loadres.clean();
				SystemGC.gc();
			}
		}

		/**
		 *	自动寻路到达，清除导航线
		 */
		private function Arrived(e:DispatchEvent):void
		{
			SetKingPos(Data.myKing.king);
			MapDrawPathLine([]);
		}
		private var iList:int=0;

		/**
		 *	当前地图npc列表【右下】
		 */
		private function showNpcList(sort:int):void
		{
			var arrNpc:Array=GameSceneGprs.getSeekBySort(sort);
			if (sort == 1)
			{
				var arrNpc2:Array=GameSceneGprs.getSeekBySort(2);
				for (var tk:int=0; tk < arrNpc2.length; tk++)
				{
					arrNpc.push(arrNpc2[tk]);
				}
			}
			if (arrNpc != null && type == 1)
			{
				var sp:ScrollContent=mc_content["map_rightPanel"]["sp" + sort];
				var spContent:Sprite=mc_content["map_rightPanel"]["spContent" + sort];
				while (spContent.numChildren > 0)
					spContent.removeChildAt(0);
				//var c:Class=getClass("item_now_map_npc");
				var sprite:*=null;
//				i=0;
				var t:int=0;
				for each (var item:Pub_SeekResModel in arrNpc)
				{
					t++;
					var ts:int=int(String(sort) + String(t));
					sprite=ItemManager.instance().getitem_now_map_npc(ts);
					sprite.name="item_npc" + item.seek_id;
					sprite["txt1"].text=item.seek_name;
					if (item.sort == 3)
					{
						sprite["txt2"].text=item.seek_level == 0 ? "" : item.seek_level.toString();
					}
					else
					{
						sprite["txt2"].text=item.seek_title;
					}
					itemEvent(sprite, item);
					sprite.buttonMode=false;
					sprite.mouseChildren=true;
					sprite.mouseEnabled=true
					sprite["btnFly"].mouseEnabled=true;
					spContent.addChild(sprite);
				}
				CtrlFactory.getUIShow().showList2(spContent);
				sp.source=spContent;
				sp.position=0;
			}
		}

		/**
		 *	任务有变化
		 */
		private function taskChange(e:DispatchEvent=null):void
		{
			if (type == 1)
			{
				showNpcListMap();
			}
		}

		override protected function windowClose():void
		{
			// 面板关闭事件
			super.windowClose();
			RemoveAllHuman();
			if (map != null)
			{
				map.removeEventListener(MouseEvent.MOUSE_DOWN, downNowHandle);
				map.removeEventListener(MouseEvent.MOUSE_MOVE, moveNowHandle);
			}
		}

		/************通信**********/
		private function chuan():void
		{
			if (seekId == 0)
				return;
			GameAutoPath.chuan(seekId);
			seekId=0;
		}

		/**
		 *	寻路
		 */
		private function seek():void
		{
			if (seekId == 0)
				return;
			GameAutoPath.seek(seekId);
			seekId=0;
		}

		/************内部方法**********/
		/**
		 *	显示当前地图所有npc【左边】
		 */
		private function showNpcListMap():void
		{
			var item:Pub_SeekResModel=null;
			var item1:Pub_Map_SeekResModel=null;
			var npcRes:Pub_NpcResModel=null;
			var child:GameTinyNpc=null;
			while (mc_npc.numChildren > 0)
				mc_npc.removeChildAt(0);
			var arrSeek:Vector.<Pub_SeekResModel>=GameSceneGprs.arrSeek;
			for each (item in GameSceneGprs.arrSeek)
			{
				if (item.is_show == 0 || item.icon_x == 0 || item.icon_y == 0)
					continue;
				child=ItemManager.instance().getNpcItem(item.seek_id);
				child.npcId=item.seek_id;
				child.sort=item.sort;
				child.hasTask=false;
				child.showName(false);
				//先检测有没有任务
				npcTaskStatus(child);
				if (child.hasTask == false)
				{
					npcRes=XmlManager.localres.getNpcXml.getResPath(item.seek_id) as Pub_NpcResModel;
					//功能npc有图表
					if (item.sort == 1)
					{
						if (npcRes != null)
						{
							child.setIcon(npcRes.func_icon);
						}
					}
					//剧情npc
					if (item.sort == 2)
					{
						child.setIcon(0);
					}
					//传送点图标写死
					if (item.sort == 4)
					{
						child.setIcon(1111);
					}
					//怪物
					if (item.sort == 3)
					{
						if (npcRes != null)
							child.setIcon(npcRes.res_id);
					}
				}
				child.x=item.icon_x / beiW;
				child.y=item.icon_y / beiH;
				if (item.sort == 1 || item.sort == 2)
				{
					child.showNpcIcon();
					child.setName(item.seek_title + " " + item.seek_name);
				}
				else
				{
					child.showNpcIcon(false);
					child.setName(item.seek_level == 0 ? item.seek_name : item.seek_name + " " + item.seek_level + Lang.getLabel("pub_ji"));
				}
				child.visible=arrCheck[item.sort];
				if (child.hasTask)
					child.visible=arrCheck[5];
				mc_npc.addChild(child);
			}
		}

		/**
		 *	隐藏(或显示)当前地图npc【左边】
		 */
		private function hideNpcListMap(sort:int, isShow:Boolean):void
		{
			var len:int=mc_npc.numChildren;
			var child:GameTinyNpc=null;
			var smBody:SmBody;
			//1功能 5任务 3 怪物  //2 传点
			if (sort == 1 || sort == 2 || sort == 3)
			{
				//功能npc
				for (i=0; i < len; i++)
				{
					child=mc_npc.getChildAt(i) as GameTinyNpc;
					if (child != null && child.sort == sort && child.hasTask == false)
					{
						child.visible=isShow;
					}
				}
					//return;
			}
			//传点
			if (sort == 5)
			{
				this.mc_chuandian.visible=isShow;
				return;
			}
			//怪物
			if (sort == 3)
			{
				mc_monster.visible=isShow;
				return;
			}
			//任务
//			if(sort==5){
//				return;
//			}
			//队员
			if (sort == 6)
			{
				mc_team.visible=isShow;
				return;
			}
			if (sort == 7)
			{
				//mc_player.visible=isShow;
				var len:int=mc_player.numChildren;
				var myRoleId:uint=Data.myKing.king.objid;
				for (i=0; i < len; i++)
				{
					var sm:SmBody=mc_player.getChildAt(i) as SmBody;
					if (sm.objid != myRoleId)
					{
						sm.visible=isShow;
					}
				}
				return;
			}
		}

		/**
		 *	检测npc是否有任务
		 */
		private function npcTaskStatus(npcChild:GameTinyNpc):void
		{
			if (MissionMain.taskList != null && MissionMain.taskList.length != 0)
			{
				var len:int=MissionMain.taskList.length;
				for (var i:int=0; i < len; i++)
				{
					if (MissionMain.taskList[i].submitNpc == npcChild.npcId)
					{
						if (MissionMain.taskList[i].status == 3)
						{
							//可交
							npcChild.setIcon(1007);
							npcChild.hasTask=true;
						}
						else if (MissionMain.taskList[i].status == 2)
						{
							//进行中
							npcChild.setIcon(0);
							npcChild.hasTask=true;
						}
					}
				}
			}
			if (MissionMain.nextList != null && MissionMain.nextList.length != 0)
			{
				var len2:int=MissionMain.nextList.length;
				for (var j:int=0; j < len2; j++)
				{
					if (MissionMain.nextList[j].sendNpc == npcChild.npcId && MissionMain.nextList[j].status == 1)
					{
						//可接
						npcChild.setIcon(1005);
						npcChild.hasTask=true;
					}
				}
			}
		}

		/**
		 *	检测是不是队员
		 */
		private function checkIsTeam(roleId:int):Boolean
		{
			var isTeam:Boolean=false;
			for each (var team:StructTeamMember in DuiWu.stmVec)
			{
				if (team.roleid == roleId && Data.myKing.roleID != roleId)
				{
					isTeam=true;
					break;
				}
			}
			return isTeam;
		}

		override public function getID():int
		{
			return 1028;
		}
		//窗口第一次初始化的宽度和高度
		private var m_initW:int=-1;
		private var m_initH:int=-1;
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标

		private function replace():void
		{
			if (null == m_gPoint)
			{
				m_gPoint=new Point();
			}
			if (null == m_lPoint)
			{
				m_lPoint=new Point();
			}
			if (null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x=(mc.stage.stageWidth - m_initW) >> 1;
				m_gPoint.y=(mc.stage.stageHeight - m_initH) >> 1;
				m_lPoint=this.parent.globalToLocal(m_gPoint);
				mc.x=0;
				mc.y=0;
				this.x=m_lPoint.x;
				this.y=m_lPoint.y;
			}
		}

		override public function get height():Number
		{
			return 485;
		}
	}
}
