package scene.manager
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.display.MapLoading;
	import com.bellaxu.map.MapBlockContainer;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.mgr.TimeMgr;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.struct.Hash;
	import com.bellaxu.util.MathUtil;
	import com.bellaxu.util.StageUtil;
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	
	import scene.action.Action;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.human.GameHuman;
	import scene.human.GameMonster;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.load.GameNewLoadMain;
	import scene.skill2.SkillTrackReal;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.Image;
	import ui.frame.ImageUtils;
	import ui.view.UIMessage;
	
	import world.FileManager;
	import world.IWorld;
	import world.WorldEvent;
	import world.WorldPoint;
	import world.WorldState;
	import world.graph.WorldSprite;
	import world.type.WorldType;

	/**
	 *
	 */
	public class SceneManager
	{
		public var m_kingList:Array;

		public function SceneManager()
		{
			m_kingList=[];
		}

		public function addKing(king:King):void
		{
			if (m_kingList.indexOf(king) != -1)
				return;
			m_kingList.push(king);
		}

		public function removeKing(king:King):void
		{
			var i:int=m_kingList.indexOf(king)
			if (i != -1)
				m_kingList.splice(i, 1);
		}

		public function hasAppeared(objId:int):Boolean
		{
			var k:IGameKing=GetKing_Core(objId);
			return k != null && k.hp > 0;
		}

		private var m_lastUpdateTime:int;
		private var m_updateIntervalTime:int=500;

		public function update():void
		{
			TimeMgr.update();
			var king:King;
			for (var i:int=m_kingList.length - 1; i >= 0; --i)
			{
				king=m_kingList[i];
				if (king == Data.myKing.king)
					continue;
				king.update();
			}
			king=Data.myKing.king as King;
			if (king)
			{
				king.update();
			}
			//攻击延迟死亡
			if (TimeMgr.cacheTime - m_lastUpdateTime >= m_updateIntervalTime)
			{
				SkillTrackReal.instance.update();
				m_lastUpdateTime=TimeMgr.cacheTime;
			}
		}

		public static const USE_ALCHEMY:int=1;

		//0- 正常
		//1-隐藏
		public static const delKing_Core_Mode:int=1; //0;

		/**
		 * 持续锁定时间，以应对人特别多的情况
		 * 比如某个任务接不了，大家都挤在这里
		 * 3秒
		 * 9秒太长
		 * 现改为6秒，即60/10
		 */
		public static const slowFrameRateLockMaxCount:int=30 * 6; //

		public static var MapInLoading:Boolean=false;

		/**
		 *
		 */
		private static var _instance:SceneManager;

		public static function get instance():SceneManager
		{
			if (!_instance)
			{
				_instance=new SceneManager();
			}

			return _instance;
		}



		public const PERF_NUM:int=20;
		public var currentMapHeight:int=-1;

		/**
		 * 传送点列表
		 */
		public var currentMapTransList:Array;


		public var currentMapWidth:int=-1;

		public var findTime:int;

		public var indexUI:Sprite;
		public var indexUI_GameMap:Sprite

		/**
		 * GameMap子级
		 */
		public var indexUI_GameMap_Body:Sprite;

		/**
		 *
		 */
		public var indexUI_GameMap_Body2:Sprite;
		/**
		 * 上次点击的
		 */
		public var indexUI_GameMap_LastClickTargetName:String;

		private var _currentMapId:int=-1;

		private var _oldMapId:int=-1;

		private var _oldMapId2:int=-1;

		private var _EDP:EventDispatcher=new EventDispatcher();

		public function get EDP():EventDispatcher
		{
			return _EDP;
		}

		public static function DispatchEvents(EventString:String, EventData:*=null):void
		{
			SceneManager.instance.EDP.dispatchEvent(new WorldEvent(EventString, EventData));
		}


		public static function AddEventListener(EventString:String, RecvFunc:Function):void
		{
			SceneManager.instance.EDP.removeEventListener(EventString, RecvFunc);
			SceneManager.instance.EDP.addEventListener(EventString, RecvFunc);

		}

		public static function RemoveEventListener(EventString:String, RecvFunc:Function):void
		{
			SceneManager.instance.EDP.removeEventListener(EventString, RecvFunc);

		}

		/**
		 * 非生物
		 */
		public function AddItem_Core(k:IWorld):void
		{
			if (null != k)
			{
				LayerDef.bodyLayer.addChild(k as DisplayObject);

				if (LayerDef.bodyLayer.numChildren < PERF_NUM)
				{
					Depth_Core(LayerDef.bodyLayer);
				}

			}

		}

		/**
		 * 增加生物
		 */
		public function AddKing_Core(k:IGameKing):void
		{
			// 测试 by  saiman
			//			return 
			//			vAddGK.push(k);
			//			if (!delayAdd.running)
			//				delayAdd.start();
			//		}
			//
			//		/**
			//		 * 延时一下，给渲染减负
			//		 * */
			//		private function AddKing_Cored(e:TimerEvent):void
			//		{
			//			if (vAddGK.length == 0)
			//			{
			//				delayAdd.reset();
			//				return;
			//			}
			//			var k:IGameKing=vAddGK.shift()
			if (null == k || k.name == '')
			{
				return;
			}
			//这里只用判断bottom
			if (DepthDef.BOTTOM == k.depthPri)
			{
				LayerDef.bodyLayer.addChildAt(k as DisplayObject, 0);

			}
			else
			{
				LayerDef.bodyLayer.addChild(k as DisplayObject);

			}
			addKing(k as King);
			if (Data.myKing.attackLockObjID != 0 && k.objid == Data.myKing.attackLockObjID)
			{
				Action.instance.fight.focusKing(k);
			}

			//需判断bottom,normal,top
			//优化cpu性能
			if (LayerDef.bodyLayer.numChildren < PERF_NUM)
			{
				Depth_Core(LayerDef.bodyLayer);
			}


		}

		/**
		 * 天空物件
		 */
		public function AddWeater_Core(k:IWorld):void
		{
			if (null != k)
			{
				MapData.MAP_WEATHER.addChild(k as DisplayObject);

				if (LayerDef.bodyLayer.numChildren < PERF_NUM)
				{
					Depth_Core(MapData.MAP_WEATHER);
				}
			}

		}

		private function depthSortCallback2(spr:WorldSprite, index:int, arr:Array):void
		{
			spr.lastI+=list_len1;
		}

		private function depthSortCallback3(spr:WorldSprite, index:int, arr:Array):void
		{
			spr.lastI+=list_len2;
		}

		private var list_len1:int;
		private var list_len2:int;

		private var list1:Array; //底层，包括传送阵
		private var list2:Array; //中间层，包括怪、人、npc
		private var list3:Array; //顶层，包括技能

		/**
		 *
		 * getChildAt() 方法比 getChildByName() 方法快。
		 * getChildAt() 方法从缓存数组中访问子项，而 getChildByName() 方法则必须遍历链接的列表来访问子项。
		 *
		 */
		public function Depth_Core(containerSp:Sprite):void
		{
			list1=[];
			list2=[];
			list3=[];
			var i:int;
			var child:WorldSprite;
			while (i < containerSp.numChildren)
			{
				child=containerSp.getChildAt(i++) as WorldSprite;
				if (child)
				{
					switch (child.depthPri)
					{
						case DepthDef.BOTTOM:
							child.lastI=list1.length;
							list1.push(child);
							break;
						case DepthDef.NORMAL:
							child.lastI=list2.length;
							list2.push(child);
							break;
						case DepthDef.TOP:
							child.lastI=list3.length;
							list3.push(child);
							break;
					}
				}
			}
			list_len1=list1.length;
			list_len2=list1.length + list2.length;
			list2.sortOn("y", Array.NUMERIC);
			list2.forEach(depthSortCallback2);
			list3.forEach(depthSortCallback3);
			list1=list1.concat(list2).concat(list3);
			i=0;
			var nowTime:int=getTimer();
			var child2:DisplayObject;
			while (i < list1.length)
			{
				child=list1[i];
				if (child.lastI != i)
				{
					child2=containerSp.getChildAt(i);
					if (MathUtil.abs(child.y - child2.y) >0)
						containerSp.setChildIndex(child, i);
				}
				i++;
			}
		}

		public function get Depth_Child_List():Array
		{
			var containerSp:Sprite=LayerDef.bodyLayer;

			//ground最底层,普通,sky最上层
			var childList0:Array=[];

			//
			var len:int=containerSp.numChildren;

			var d:DisplayObject;
			var w:IWorld;
			var k:IGameKing;

			//
			for (var i:int=0; i < len; i++)
			{
				d=containerSp.getChildAt(i);

				w=d as IWorld;

				childList0.push(d);

			}

			return childList0;
		}


		public function GetItem_Core(objid:uint):IWorld
		{
			var d:DisplayObject;

			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());

			if (null == d)
			{
				return null;
			}

			return d as IWorld;
		}


		/**
		 * 获取屏幕生物
		 */
		public function GetKing_Core(objid:uint):IGameKing
		{
			var d:DisplayObject;

			//var tStart:int = getTimer();

			if (null == LayerDef.bodyLayer)
			{
				return null;
			}

			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());

			if (null == d)
			{
				return null;
			}

			return d as IGameKing;
		}

		public function GetObj_Core(objid:uint):IWorld
		{
			var d:DisplayObject;

			d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());

			if (null == d)
			{
				return null;
			}

			return d as IWorld;
		}

		/**
		 * 当前地图Id
		 */
		public function get currentMapId():int
		{
			return _currentMapId;
		}

		/**
		 * 当前地图名称
		 */
		public function get currentMapName():String
		{
			//项目转换	var map:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, _currentMapId.toString());
			var map:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(_currentMapId) as Pub_MapResModel;
			if (null == map)
			{
				return "";
			}

			return map.map_title;
		}

		//		private var hmDelGK:HashMap=new HashMap();
		//		private var delayDel:Timer=new Timer(50, 100);

		/**
		 *延时删除，减少CPU压力
		 * */
		public function delKing_Core(k:IGameKing, objid:uint):void
		{
			//移除前还原鼠标指针
			//removeChild时发出鼠标事件out

			var d:DisplayObject=k as DisplayObject;

			if (null == d)
			{
				return;
			}

			removeKing(k as King);

			if (0 == delKing_Core_Mode)
				delObj_Core(objid, k as DisplayObject);
			else if (1 == delKing_Core_Mode)
			{
				//删除怪和人按隐藏来
				//WorldFactory.KING_REMOVED_FROM_STAGE2(k as King, LayerDef.bodyLayer2);
				delObj_Core(objid, k as DisplayObject);
			}


			//
			//k.SendPlayerRemoveScene();
			setTimeout(function():void
			{
				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.RemoveThis, objid));
			}, 200);
		}

		/**
		 * 切换地图后使用该命令
		 */
		public function delObjAll_Core():void
		{
			var k:DisplayObject
			if (0 == delKing_Core_Mode)
			{
				while (LayerDef.bodyLayer.numChildren > 0)
				{
					k = LayerDef.bodyLayer.removeChildAt(0);
					if (null == k)
					{
						continue;
					}
					
//					if (k as IGameKing)
//					{
//						(k as King).dispose();
//					}
				}
			}
			//---------------------------------------------------------------------------------------
			
			if (1 == delKing_Core_Mode)
			{
				while (LayerDef.bodyLayer.numChildren > 0)
				{
					k=LayerDef.bodyLayer.removeChildAt(0);

					if (null == k)
					{
						continue;
					}

					if (k as IGameKing)
					{
						Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.RemoveThis, (k as IGameKing).objid));
					}

				}
			}
		}

		/**
		 *
		 */
		public function delObj_Core(objid:int, d:DisplayObject=null):void
		{
			//
			//if (WorldState.ground == GameIni.currentState)
			//{
			//UI_index.instance.focusManager.deactivate();
			//}				

			//var d:DisplayObject;

			//性能优化,优先使用传进来的d
			if (null == d)
			{
				d=LayerDef.bodyLayer.getChildByName(WorldType.WORLD + objid.toString());
			}

			if (null == d)
			{
				return;
			}

			//移除前还原鼠标指针
			//removeChild时发出鼠标事件out

			//优化cpu性能
			if (LayerDef.bodyLayer.numChildren < PERF_NUM)
			{
				var po:WorldPoint=getIndexUI_GameMap_MouseGridPoint();

				if (d.hitTestPoint(po.x, po.y))
				{
					d.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				}
			}

			//
			if (null != d.parent)
			{
				var tar:WorldSprite=d as WorldSprite

				LayerDef.bodyLayer.removeChild(d);
				if (tar)
				{
					tar.dispose();
				}
			}
		}

		/**
		 * 获取指定范围内的怪物数量
		 */
		public function getMonsterCountAroundKing(k:King, withoutCenter:Boolean=true):int
		{
			var kingX:int=MapCl.gridXToMap(k.mapx);
			var kingY:int=MapCl.gridYToMap(k.mapy);
			var rectX:int=k.mapx - 1;
			var rectY:int=k.mapy - 1; //宽高比例2:1
			var rectW:int=3;
			var rectH:int=3;

			var rect:Rectangle=new Rectangle(rectX, rectY, rectW, rectH);
			var container:Sprite=LayerDef.bodyLayer;
			var len:int=container.numChildren;
			var index:int=0;
			var target:IGameKing;
			var count:int=0;
			while (index < len)
			{
				target=container.getChildAt(index) as IGameKing;
				if (!(target is GameMonster) || target.isMe || target.isMeMon || target.isMePet || target.isMeTeam || target.isSameCampId || target.hp == 0)
				{
					index++;
					continue;
				}
				if (rect.contains(target.mapx, target.mapy))
				{
					if (withoutCenter)
					{
						if (!MapCl.isKingInSameGrid(target, Data.myKing.king))
						{
							count++;
						}
					}
					else
					{
						count++;
					}
					if (count > 1)
					{
						break;
					}
				}
				index++;
			}
			return count;
		}

		/**
		 * 获取九宫格内的怪物数量
		 */
		public function getMonsterCountAroundKingInGrid9(k:King):int
		{
			var grids:Array=MapCl.getGridsAround(k.mapx, k.mapy);
			var index:int=0;
			var target:IGameKing;
			var container:Sprite=LayerDef.bodyLayer;
			var len:int=container.numChildren;
			var pos:Array;
			var count:int=0;
			while (index < len)
			{
				target=container.getChildAt(index) as IGameKing;
				if (!(target is GameMonster) || target.isMe || target.isMeMon || target.isMePet || target.isMeTeam || target.isSameCampId)
				{
					index++;
					continue;
				}
				var gridLen:int=grids.length;
				var gridIndex:int=0;
				while (gridIndex < gridLen)
				{
					pos=grids[gridIndex];
					if (target.mapx == pos[0] && target.mapy == pos[1])
					{
						grids.splice(gridIndex, 1);
						count++;
						break;
					}
					gridIndex++;
				}
				if (count > 2)
				{ //这里暂时只检索到3个，提高效率
					trace("周围怪物数量-------", count);
					break;
				}
				index++;
			}
			return count;
		}

		public function getIndexUI_GameMap_LastClickTargetName():String
		{
			return indexUI_GameMap_LastClickTargetName;
		}


		/**
		 *
		 */
		public function getIndexUI_GameMap_MousePoint():WorldPoint
		{
			return WorldPoint.getInstance().getItem(StageUtil.mouseX, StageUtil.mouseY, StageUtil.mouseX, StageUtil.mouseY);
		}

		private var m_nCommonPoint:Point=new Point();

		/**
		 *
		 */
		public function getIndexUI_GameMap_MouseGridPoint():WorldPoint
		{
			var p:WorldPoint=null;
			p=WorldPoint.getInstance().getItem(StageUtil.mouseX, StageUtil.mouseY, LayerDef.mapLayer.mouseX, LayerDef.mapLayer.mouseY);

			m_nCommonPoint.x=p.mapx;
			m_nCommonPoint.y=p.mapy;
			MapCl.mapToGrid(m_nCommonPoint);
			p.mapx=m_nCommonPoint.x;
			p.mapy=m_nCommonPoint.y;
			return p;
		}

		/**
		 *
		 */
		public function get isAtNoYin():Boolean
		{
			//项目转换		var map_m:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, this.currentMapId.toString());
			var map_m:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(this.currentMapId) as Pub_MapResModel;

			if (null == map_m)
			{
				return true;
			}

			return map_m.is_yin == 0 ? false : true;

		}

		/**
		 * 判断玩家当前是否在大海战地图
		 * @return
		 *
		 */
		public function isAtSeaWar():Boolean
		{
			if (20200031 == _currentMapId)
			{
				return true;
			}
			return false;
		}

		/**
		 * 判断玩家当前是否在大航海地图
		 * @return
		 *
		 */
		public function isAtDaHangHai():Boolean
		{
			if (20200031 == _currentMapId)
			{
				return true;
			}
			return false;
		}

		/**
		 * 判断玩家当前是否在躲猫猫地图
		 * @return
		 *
		 */
		public function isAtGhost():Boolean
		{
			if (20210008 == _currentMapId)
			{
				return true;
			}
			return false;
		}

		/**
		 *
		 */
		public function isAtJueZhan():Boolean
		{
			if (20210088 == _currentMapId)
			{
				return true;
			}
			return false;
		}


		/**
		 * 判断玩家当前是否在五子连珠地图
		 * @return
		 *
		 */
		public function isAtWuZiLianZhu():Boolean
		{
			if (20210002 == _currentMapId)
			{
				return true;
			}
			return false;
		}

		/**
		 * 判断玩家是否在皇城至尊地图
		 * 古皇城：20100004
		 皇宫：20100009
		 *
		 * @return
		 *
		 */
		public function isHuangChengZhiZhun():Boolean
		{
			if (20100004 == _currentMapId || 20100009 == _currentMapId)
			{
				return true;
			}
			return false;
		}



		/**
		 * 在跳转地图成功后调用此方法
		 *
		 * 超过90分钟自动刷新网页
		 改为60
		 QQ版本不需要此功能

		 PacketSCMapSend

		 **/
		public function isAutoRefreshPage(runCount:int):Boolean
		{
			if (GameData.autoRefresh)
			{
				//
				var map_list:Array=Lang.getLabelArr("auto_refresh_page_mapid");

				//
				if (null == map_list || 0 == map_list.length)
				{
					map_list=["20100005,20100003,20100004,20200011", "20100001"];
				}

				//跳地图前不在 
				if (map_list[0].indexOf(oldMapId.toString()) == -1 &&
					//跳地图后在 	
					map_list[1].indexOf(currentMapId.toString()) >= 0)
				{
					//			
					if (runCount >= (60 * 60))
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 上个地图Id
		 */
		public function get oldMapId():int
		{
			return _oldMapId;
		}

		/**
		 * 上上个地图Id
		 */
		public function get oldMapId2():int
		{
			return _oldMapId2;
		}

		public function setCurrentMapId(value:int, tag:int):void
		{
			//地图id一样，不用重复设
			if (-1 != _currentMapId && _currentMapId == value)
			{
				return;
			}

			_oldMapId2=_oldMapId;
			_oldMapId=_currentMapId;
			_currentMapId=value;

			//地图id不可为0，服务器发生错误
			if (0 == value)
				DataKey.instance.socket.DispatEventSocketMsg(Lang.getServerMsg(tag).msg);
		}

		public function findpath(startKing:IGameKing, findKing:Object, path:Array):int
		{
			if (null == startKing)
				throw new Error("startKing is null")
			if (findKing == null)
				throw new Error("findKing is null");
			//start
			var startPoint:WorldPoint=WorldPoint.getInstance().getItem(startKing.x, startKing.y, startKing.mapx, startKing.mapy);
			var findPoint:WorldPoint
			if (findKing as IGameKing)
			{
				var fk:IGameKing=findKing as IGameKing;
				findPoint=WorldPoint.getInstance().getItem(fk.x, fk.y, fk.mapx, fk.mapy);
			}
			else if (findKing as WorldPoint)
			{
				var fp:WorldPoint=findKing as WorldPoint;
				findPoint=WorldPoint.getInstance().getItem(fp.x, fp.y, fp.mapx, fp.mapy);
			}
			else
			{
				throw new Error("findKing is other value");
			}
			//find now				
			var mapId:int=SceneManager.instance.currentMapId;
			var path:Array=[];
			var result:int=AlchemyManager.instance.getPath(startPoint.mapx, startPoint.mapy, findPoint.mapx, findPoint.mapy, path);
			//find result
			if (-1 == result)
				return -1;
			return 0;
		}

		/**
		 * 显示地图提示
		 */
		public function showMapTip():void
		{
//项目转换  当前项目没有这两个属性		var m:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, MapData.MAPID.toString());
//			if (m.map_tip_flag==2)
//			{
//				playPic(m.map_tip);
//			}
		}

		private function setVisibleByZone(value:Boolean):void
		{
			if (!value)
			{
				if (null != UIMessage.zoneMC.parent)
				{
					(UIMessage.zoneMC.parent as DisplayObjectContainer).removeChild(UIMessage.zoneMC);
				}
				return;
			}

			if (value)
			{
				if (null == UIMessage.zoneMC.parent)
				{
					LayerDef.tipLayer.addChild(UIMessage.zoneMC);
				}
				return;
			}
		}

		private function playPic(content:String):void
		{
			setVisibleByZone(true);
			UIMessage.zoneMC.y=int(this.m_cameraHeight * 3 / 7) - UIMessage.zoneMC.height * 0.5;
			UIMessage.zoneMC.alpha=0;
			TweenLite.killTweensOf(UIMessage.zoneMC);
//			UIMessage.zoneMC.source=FileManager.instance.getQuYuIconById(int(content));
			ImageUtils.replaceImage(UI_index.indexMC["message"], UIMessage.zoneMC.source, FileManager.instance.getQuYuIconById(int(content)));
			TweenLite.to(UIMessage.zoneMC, 1, {alpha: 1, delay: 1, onComplete: showComplete});
		}

		private function showComplete():void
		{
			TweenLite.to(UIMessage.zoneMC, 1, {alpha: 0, delay: 2, onComplete: clearComplete});
		}

		private function clearComplete():void
		{
			UIMessage.zoneMC.unload();
			setVisibleByZone(false);
		}

		public function buildMap():void
		{
			if (GameNewLoadMain.FirstInGame)
				GameNewLoadMain.getInstance().ChangeAndSetMapData(Data.myKing.mapid);
		}

		public function onLoadedMap():void
		{
			MapBlockContainer.getInstance().init();
			MapInLoading=false;
			reloadTile(true);
			MapLoading.getInstance().hide();
			//进场景后延时8秒播放音乐， 避免影响主加载
			if (_firstBuildMap)
			{
				_firstBuildMap=false;
				TimerMgr.getInstance().add(8000, playMusic, 1);
			}
			else
			{
				playMusic();
			}
		}

		private var _firstBuildMap:Boolean=true;

		public function playMusic():void
		{
			MusicMgr.playMusic(MusicDef.getMusicPath(MapData.getThisMapMusicUrl));
		}

		public function reloadTile(drawNow:Boolean=false):void
		{
			if (MapInLoading)
				return;
			//项目转换修改
//			if(GameData.state != StateDef.IN_SCENE)
//				return;
			if (GameIni.currentState != WorldState.ground)
			{
				return;
			}
			if (null == Data.myKing.king)
			{
				return;
			}
			if (DataKey.instance.sleep)
			{
				return;
			}

			var absX:int;
			var absY:int;
			absX=-LayerDef.mapLayer.x;
			absY=-LayerDef.mapLayer.y;
			var mapx:int=Data.myKing.king.x;
			var mapy:int=Data.myKing.king.y;
//			mapx = MapCl.gridXToMap(mapx);
//			mapy = MapCl.gridYToMap(mapy);
			absX=mapx - m_halfWidth;
			absY=mapy - m_halfHeight
			MapBlockContainer.getInstance().reloadTile(absX, absY, 1, drawNow);
		}

		public function resize():void
		{
			resetCamera(StageUtil.stageWidth, StageUtil.stageHeight);
			if (MapBlockContainer.hasInstance())
				this.reloadTile();
		}

		private var m_cameraWidth:int;
		private var m_cameraHeight:int;
		private var m_halfWidth:int;
		private var m_halfHeight:int;

		public function resetCamera(stageW:int, stageH:int):void
		{
			this.m_cameraWidth=stageW;
			this.m_cameraHeight=stageH;
			this.m_halfWidth=this.m_cameraWidth >> 1;
			this.m_halfHeight=this.m_cameraHeight >> 1;
		}

		public function getCameraRect(playerX:int, playerY:int):Vector.<Point>
		{
			var left:int=playerX - this.m_halfWidth;
			var right:int=playerX + this.m_halfWidth;
			if (playerX <= this.m_halfWidth)
			{
				left=0;
				right=this.m_cameraWidth;
			}
			else
			{
				var sceneWidth:int=MapData.MAP_RES_WIDTH;
				var sceneHeight:int=MapData.MAP_RES_HEIGHT;
				if (right >= MapData.MAP_RES_WIDTH)
				{
					left=sceneWidth - this.m_cameraWidth;
					right=sceneWidth;
				}
			}
			var top:int=playerY - this.m_halfHeight;
			var bottom:int=playerY + this.m_halfHeight;
			if (playerY <= this.m_halfHeight)
			{
				top=0;
				bottom=this.m_cameraHeight;
			}
			else
			{
				if (bottom >= sceneHeight)
				{
					top=sceneHeight - this.m_cameraHeight;
					bottom=sceneHeight;
				}
			}
			return MapCl.getHelixGroup(MapCl.mapXToTile(playerX), MapCl.mapYToTile(playerY), MapCl.mapXToTile(left), MapCl.mapXToTile(right) + 1, MapCl.mapYToTile(top), MapCl.mapYToTile(bottom) + 1);
		}

		//--------  策划提供需要自动挂机地图   由策划提供-------------------------------------------------------
		/**
		 * 是否需要显示美女自动挂机引导
		 * @return
		 *
		 */
		public function isNeedShowGuideGirl():Boolean
		{
			if ((_currentMapId >= 20210002 && _currentMapId <= 20210003) || (_currentMapId >= 20210005 && _currentMapId <= 20210008) || (_currentMapId >= 20210064 && _currentMapId <= 20210073) || (_currentMapId == 20220017))
			{
				return false;
			}

			return true;
		}

		public function isJingCheng():Boolean
		{
			if (_currentMapId == 20100006)
				return true;
			return false
		}
		private var arrCopy:Array=[20220137];

		/**
		 * 判断玩家当前是否在副本地图=0
		 */
		public function isAtGameTranscript():Boolean
		{
			if ((_currentMapId >= 20220018 && _currentMapId <= 20220029) || arrCopy.indexOf(_currentMapId) >= 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 进入副本显示挂机箭头
		 */
		public function showGuaJiRow():Boolean
		{
			if (_currentMapId ==20220018 || _currentMapId == 20210004 || _currentMapId ==20210010 || 
				_currentMapId ==20220137 ||  _currentMapId ==20220019 ||  _currentMapId ==20220020 || 
				_currentMapId ==20220022 ||  _currentMapId ==20220024 ||  _currentMapId ==20220025 || 
				_currentMapId ==20220026 ||  _currentMapId ==20220027
			)
			{
				return true;
			}
			return false;
		}

		public function getKingInMapGridForMouseClick():IGameKing
		{
			var wp:WorldPoint=getIndexUI_GameMap_MouseGridPoint();

			var index:int=0;
			var igk:IGameKing;
			var result:IGameKing;
			while (index < LayerDef.bodyLayer.numChildren)
			{
				igk=LayerDef.bodyLayer.getChildAt(index) as IGameKing;
				if (igk && igk.mapx == wp.mapx && igk.mapy == wp.mapy)
				{
					if (igk.isMe == false)
					{
						result=igk;
						break;
					}
				}
				index++;
			}
			return result;
		}

		//场景对象显示数量优化 rect:实际地图指定坐标范围
		public function checkPlayerShow(rect:Rectangle):void
		{
			var totalLimit:int=200; //当前显示目标上限数量
			var gridCountLimit:int=2; //每个格子目标显示数量
			var total:int=m_kingList.length; //当前区域目标总量
			if (total < totalLimit)
				return;
			var key:String;
			var countInGrids:Hash=new Hash();
			var playerInGrids:Hash=new Hash();
			var players:Vector.<uint>;
			var count:int;
			for each (var k:King in m_kingList)
			{
				if (k is GameHuman && rect.contains(k.x, k.y)) //在有效区域内
				{
					key=k.mapx + "_" + k.mapy;
					players=playerInGrids.take(key) as Vector.<uint>;
					if (players == null)
					{
						players=new Vector.<uint>();
						playerInGrids.put(key, players);
					}
					//此处如果需设置优先级，则为king添加一个排序索引
					players.push(k.objid);
					if (countInGrids.has(key))
					{
						count=int(countInGrids.take(key));
						count++;
						countInGrids.put(key, count);
					}
				}
			}
			var currentCount:int=0;
			var currentObjId:int;
			for (key in countInGrids)
			{
				currentCount=int(countInGrids.take(key));
				if (currentCount > gridCountLimit)
				{
					players=playerInGrids.take(key) as Vector.<uint>;
					while (currentCount > gridCountLimit)
					{
						currentObjId=players.shift();
						//对指定目标进行处理
						k=GetKing_Core(currentObjId) as King;
						if (k != null)
						{
							setKingBodyVisible(k);
						}
						currentCount--;
					}
				}
			}
		}

		/**
		 * 设置目标显示状态
		 */
		private function setKingBodyVisible(k:King):void
		{
			//TODO 根据具体需求来隐藏
		}
	}
}

