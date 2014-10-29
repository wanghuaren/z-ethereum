package ui.view.view3.drop
{
	import com.bellaxu.debug.Debug;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.MathUtil;
	import com.bellaxu.util.PathUtil;
	import com.greensock.TweenMax;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	import engine.load.Gamelib;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.PacketSCDropEnterGrid2;
	import netc.packets2.StructDropList2;
	
	import nets.packets.PacketCSPick;
	import nets.packets.PacketSCDropEnterGrid;
	import nets.packets.PacketSCDropItemLeaveGrid;
	import nets.packets.PacketSCObjLeaveGrid;
	import nets.packets.PacketSCPick;
	
	import scene.action.PathAction;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.utils.MapCl;
	
	import ui.base.beibao.BeiBao;
	import ui.base.mainStage.UI_index;
	import ui.view.view1.shezhi.SysConfig;
	import ui.view.view7.UI_Exclamation;
	
	import world.WorldPoint;
	import world.cache.res.ResItem;
	import world.cache.res.ResItemPool;

	/**
	 * @author  WangHuaRen
	 * @version 2012-1-7-上午10:09:08
	 **/
	public final class ResDrop
	{
		private static var _instance:ResDrop=null;
		private var dropDic:Dictionary=null;
		private var sendPackage:PacketCSPick=null;
		private var dropEffect:Dictionary=new Dictionary();

		public static function get instance():ResDrop
		{
			if (!_instance)
				_instance=new ResDrop();
			return _instance;
		}

		public function ResDrop()
		{
			dropDic=new Dictionary();
			sendPackage=new PacketCSPick();
			//掉落资源出现
			DataKey.instance.register(PacketSCDropEnterGrid.id, CPacketSCDropEnterGrid);
			//掉落资源消失-------这此处是掉落资源消失,这个协议是通用的,其它类型物品消失也用这个协议
			DataKey.instance.register(PacketSCObjLeaveGrid.id, CPacketSCObjLeaveGrid);
			//掉落资源项消失
			DataKey.instance.register(PacketSCDropItemLeaveGrid.id, CPacketSCDropItemLeaveGrid);
			//拾取掉落资源后的返回
			DataKey.instance.register(PacketSCPick.id, CPacketSCPick);
			//接收战斗掉落指令
//			Body.instance.sceneEvent.addEventListener(HumanEvent.DropRes, listenerDropHandler);
////捡东西
//			LayerDef.dropLayer.addEventListener(MouseEvent.MOUSE_DOWN, dropLayerMouseClickHandler);
			//--东西飘到了背包图标上
			Data.beiBao.addEventListener(BeiBaoSet.BAG_ADD, bagAddHandler);

			Body.instance.sceneEvent.addEventListener(HumanEvent.Arrived, humanArrivedHandler);
//			if (UI_index.indexMC != null)
//			{
//				originPoint=new Point(UI_index.indexMC["mrb"]["btnBeiBao"].x, UI_index.indexMC["mrb"]["btnBeiBao"].y);
//			}
//			else
//			{
//				originPoint=new Point(-50, -50);
//			}
//			delayDrapBag.addEventListener(TimerEvent.TIMER, delayDrapBagHandler);
			reposBag();
		}

		private var originPoint:Point;

		public function reposBag():void
		{
			if (UI_index.indexMC != null)
			{
				originPoint=new Point(UI_index.indexMC["mrb"]["mc_index_menu"]["btnBeiBao"].x, UI_index.indexMC["mrb"]["mc_index_menu"]["btnBeiBao"].y);
			}
			else
			{
				originPoint=new Point(-50, -50);
			}
			stageResizeHandler();
		}

		public function stageResizeHandler(w:int=0, h:int=0):void
		{
			bagPoint=UI_index.indexMC["mrb"]["mc_index_menu"].localToGlobal(UI_index.indexMC.localToGlobal(new Point(UI_index.indexMC["mrb"]["mc_index_menu"]["btnBeiBao"].x, UI_index.indexMC["mrb"]["mc_index_menu"]["btnBeiBao"].y)));
		}
		private var bagPoint:Point=new Point();

		private function listenerDropHandler(e:DispatchEvent):void
		{
			var len:int=dropedRes.length;
			while (--len > -1)
			{
				if (dropedRes[len].monsterid == e.getInfo)
				{
					showItem(dropedRes[len]);
					break;
				}
			}
			if (len > -1)
			{
				dropedRes.splice(len, 1);
			}
			else
			{
				Debug.warn("战斗要求掉落编号:" + e.getInfo + " 包,但服务端没有发来该掉落信息");
			}
		}

		public function getDropEffect():MovieClip
		{
			for (var m_effect:Object in dropEffect)
			{
				if (dropEffect[m_effect])
				{
					m_effect.play();
					dropEffect[m_effect]=false;
					return m_effect as MovieClip;
				}
			}
			m_effect=Gamelib.getInstance().getswflink("game_index", "dropEffect") as MovieClip;
			dropEffect[m_effect]=false;
			return m_effect as MovieClip;
		}

		public function cleanEffect(m_effect:MovieClip):void
		{
			dropEffect[m_effect]=true;
		}

		/**
		 * bodyLayerMouseClickHandler
		 * fux
		 */
		public function bodyLayerClick(x:Number, y:Number):void
		{
			var len:int=LayerDef.dropLayer.numChildren;

			for (var i:int=0; i < len; i++)
			{
				var resLd:ResItem=LayerDef.dropLayer.getChildAt(i) as ResItem;
//				var resLd:GameDrop=this._dropLayer.getChildAt(i) as GameDrop;

				if (null == resLd)
					continue;
				if (resLd.hitTestPoint(x, y))
				{
					pickResItem(resLd);
				}
			}

		}
		public var currDrop:ResItem;

		public function humanArrivedHandler(e:DispatchEvent):void
		{
			if (currDrop != null)
			{
				pickResItem(currDrop);
				currDrop=null;
			}
		}

//		private function dropLayerMouseClickHandler(e:MouseEvent):void
//		{
//			currDrop=e.target as ResItem;
//
////			currentRes=e.target as ResLoader;
////			if (currentRes != null)
////			{
////				pickResItem(currentRes);
////			}
//		}
//		private var loaderArray:Vector.<DisplayObject>=new Vector.<DisplayObject>();
//		private static var hash:Hash=new Hash
		private function bagAddHandler(e:DispatchEvent):void
		{
//			var url:String=e.getInfo.icon
//			if(hash[url])
//			{
//				var bitmap:Bitmap=new Bitmap
//				bitmap.bitmapData=hash[url] as BitmapData
//				loaderArray.push(bitmap);
//				delayDrapBag.start();
//			}
//			else
//			{
			ResTool.load(PathUtil.getTrimPath(e.getInfo.icon), loadComplete);
//				var loader:Loader=new Loader();
//				loader.name=url
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
//				loader.addEventListener(IOErrorEvent.IO_ERROR, loadErr);
//				loader.load(new URLRequest(url));
//			}
		}

//		private function loadErr(url:String):void
//		{
//		}
//		private var delayDrapBag:Timer=new Timer(300);

//		private function delayDrapBagHandler(e:TimerEvent):void
//		{
//			flapRes(loaderArray.shift());
//			if (loaderArray.length < 1)
//			{
//				delayDrapBag.stop();
//			}
//		}

		private function loadComplete(url:String):void
		{
//			var loader:Loader = e.currentTarget.loader;
//			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);

			var bmd:BitmapData=ResTool.getBmd(url);
			flapRes(new Bitmap(ResTool.getBmd(url)));
//			var _bmd:BitmapData=new BitmapData(bmd.width,bmd.height,false,0)
//			_bmd.copyPixels(bmd,_bmd.rect,new Point)
//			loader.unloadAndStop()
//			hash[PathUtil.getFullPath(url)]=bmd
//			loaderArray.push(new Bitmap(bmd));
//			delayDrapBag.start();
		}

		private function flapRes(loader:DisplayObject):void
		{
			//UI_index.indexMC.addChild(loader);
			if (loader == null || UI_Exclamation.instance.mc == null)
				return;
			if (BeiBao.getInstance().isOpen)
				return;
			UI_Exclamation.instance.mc.addChild(loader);

//			loader.x=bagPoint.x;
//			loader.y=bagPoint.y - 300;
			//-----------
			var rx:int=MathUtil.getRandomInt(-100, 100);
			var ry:int=MathUtil.getRandomInt(-100, 100);
			var rt:Number=MathUtil.getRandomInt(150, 200) * 0.01;
			loader.x=(UI_index.indexMC.stage.stageWidth >> 1) + rx;
			loader.y=(UI_index.indexMC.stage.stageHeight >> 1) + ry;
			loader.scaleX=loader.scaleY=2;
//			TweenMax.to(loader, 1, {scaleX: 1, scaleY: 1, bezier: [{x: UI_index.indexMC.stage.stageWidth / 3, y: UI_index.indexMC.stage.stageHeight * 2 / 3}, {x: bagPoint.x, y: bagPoint.y}], onComplete: fllowBag});
			TweenMax.to(loader, rt, {scaleX: 1, scaleY: 1, x: bagPoint.x, y: bagPoint.y, bezier: [{x: UI_index.indexMC.stage.stageWidth / 2, y: UI_index.indexMC.stage.stageHeight * 2 / 3}, {x: UI_index.indexMC.stage.stageWidth / 2, y: UI_index.indexMC.stage.stageHeight * 2 / 3}], onComplete: fllowBag});
			//-----------
//			TweenLite.to(loader, 0.5, {y: bagPoint.y, onComplete: fllowBag});
			function fllowBag():void
			{
				//loader.unload();
				//fux
//				loader.unloadAndStop(false);

				//saiman
				//掉落无图标改用Bitmap方式进行
				if (loader && loader.parent)
//				{
					loader.parent.removeChild(loader)
//				}
//				if (ControlButtonIndex.getInstance().hasBagBtnPosSet){
//					TweenMax.to(UI_index.indexMC["mrb"]["mc_index_menu"]["btnBeiBao"], 0.5, {ease: Elastic.easeOut, bezier: [{x: originPoint.x + 10, y: originPoint.y - 10}, {x: originPoint.x, y: originPoint.y}]});
//				}
			}
		}

		public function pickResItem(resItem:ResItem):void
//		public function pickResItem(resItem:GameDrop):void
		{
			sendPackage.index=resItem.indexID;
//			sendPackage.index=resItem.currIndex;
			sendPackage.objid=resItem.objID;
//			sendPackage.objid=resItem.currObj;
			//拾取物品
			DataKey.instance.send(sendPackage);
		}
		private var itemDisppear:PacketSCDropItemLeaveGrid=new PacketSCDropItemLeaveGrid();

		private function CPacketSCPick(p:PacketSCPick):void
		{
			if (p.tag == 0)
			{
				itemDisppear.objid=p.objid;
				itemDisppear.index=p.index;
				CPacketSCDropItemLeaveGrid(itemDisppear);
			}
			Lang.showMsg(Lang.getServerMsg(p.tag));
		}

		private function CPacketSCDropItemLeaveGrid(p:PacketSCDropItemLeaveGrid):void
		{
			var levelItemList:Vector.<ResItem>=dropDic[p.objid];
			if (levelItemList != null)
			{
				var len:int=levelItemList.length;
				while (--len > -1)
				{
					if (levelItemList[len].indexID == p.index)
					{
//						var m_point:Point=_dropLayer.localToGlobal(new Point(levelItemList[len].x, levelItemList[len].y));
//						UI_index.indexMC.addChild(levelItemList[len]);
//						levelItemList[len].x=m_point.x;
//						levelItemList[len].y=m_point.y;
//						TweenLite.to(levelItemList[len], 0.2, {x: bagPoint.x, y: bagPoint.y, scaleX: 1.5, scaleY: 1.5, onComplete: comeInBag, onCompleteParams: [levelItemList[len]]});
//						levelItemList.splice(len, 1);
						comeInBag(levelItemList[len]);
						break;
					}
				}
			}
		}

		private function comeInBag(resLoader:ResItem):void
		{
			resLoader.scaleX=resLoader.scaleY=1;
			resLoader.destory();
			//	TweenMax.to(UI_index.indexMC["mrb"]["btnBeiBao"], 0.5, {ease: Elastic.easeOut, bezier: [{x: originPoint.x + 10, y: originPoint.y - 10}, {x: originPoint.x, y: originPoint.y}]});
		}

		private function CPacketSCObjLeaveGrid(p:PacketSCObjLeaveGrid):void
		{
			var packageID:String=null;
			for (packageID in dropDic)
			{
				if (packageID == p.objid + "")
				{
					var itemList:Vector.<ResItem>=dropDic[packageID];
					var len:int=itemList.length;
					while (--len > -1)
					{
						itemList[len].destory();
					}
					//清除数据
					itemList.length = 0;
					dropDic[packageID] = null;
					delete dropDic[packageID];
				}
			}
		}

//		private function _needNewGuest1007(p:PacketSCDropEnterGrid2):Boolean
//		{
//			var _mapID:int=SceneManager.instance.currentMapId;
//
//			/*
//			策划部-王钊 2013-9-6 16:05:51
//			地图编号：
//			20210001
//
//			*/
//			if (20210001 != _mapID)
//			{
//				return false;
//			}
//
//			if (null == p.arrItemlist || p.arrItemlist.length <= 0)
//			{
//				return false;
//			}
//
//
//			var _itemID:int=0;
//			for (var i:int=0; i < p.arrItemlist.length; ++i)
//			{
//				/*
//
//				策划部-王钊 2013-9-6  16:05:41
//				装备编号：
//				11302407
//				11302408
//				11302409
//				11302410
//				11302411
//				11302412
//
//				*/
//				_itemID=p.arrItemlist[i].itemid;
//
//				if (11302407 == _itemID || 11302408 == _itemID || 11302409 == _itemID || 11302410 == _itemID || 11302411 == _itemID || 11302412 == _itemID)
//				{
//					return true;
//				}
//			}
//			return false;
//		}

		private var dropedRes:Vector.<PacketSCDropEnterGrid2>=new Vector.<PacketSCDropEnterGrid2>();

		private function CPacketSCDropEnterGrid(p:PacketSCDropEnterGrid2):void
		{
//			var king:King = SceneManager.instance.GetKing_Core(p.monsterid) as King;
//			if (king!=null)
//			{
//				king.dropList.push(p);
//			}
			setTimeout(showItem, MathUtil.getRandomInt(200, 500), p);
//			dropedRes.push(p);
		}

		private var itemRes:Pub_ToolsResModel=null;

		public function showItem(resPackage:PacketSCDropEnterGrid2):void
		{

			var itemList:Vector.<ResItem>=new Vector.<ResItem>();
			var resItemList:Vector.<StructDropList2>=resPackage.arrItemlist;
			var len:int=resItemList.length;
			var resLoader:ResItem=null;
			var resStruck:StructDropList2=null;
//			var area:int=50;
//			var radii:int=(int(len / 4) + 1) * area;
//			var endPoint:Point=new Point();
//			var middle:int=Math.sqrt(len);
//			var middle2:int=int(middle / 2);
//			var sidel:Number;
//			var anglel:Number;
			while (--len > -1)
			{
				resStruck=resItemList[len];
//				if (resStruck.itemid == 0)
//				{
//					UpdateToServer.instance.send("掉落物品 itemid为0");
//				}
				//11500001 钱币ID
				itemRes=XmlManager.localres.getToolsXml.getResPath(resStruck.itemid) as Pub_ToolsResModel;
				//项目转换			itemRes = Lib.getObj(LibDef.PUB_TOOLS, resStruck.itemid.toString());
				if (itemRes != null)
				{

					if (itemRes.tool_id >= 11800200 || itemRes.tool_id <= 11800208)
					{
						MusicMgr.playWave(MusicDef.ui_yinliang_diaoluo);
					}
					else if (itemRes.tool_sort == 13 || itemRes.tool_sort == 27)
					{
						MusicMgr.playWave(MusicDef.ui_zhuangbei_diaoluo);
					}
					else
					{
						MusicMgr.playWave(MusicDef.ui_wupin_diaoluo);
					}
					resLoader=ResItemPool.pop();
					resLoader.objID=resPackage.objid;
					resLoader.itemID=resStruck.itemid;
					resLoader.indexID=resStruck.index;
					resLoader.resDate=itemRes;
					resLoader.num=resStruck.num;
					resLoader.update();
					resLoader.PosX=resPackage.posx;
					resLoader.PosY=resPackage.posy;
					LayerDef.dropLayer.addChild(resLoader);
					itemList.push(resLoader);
					if (resPackage.flag == 1)
					{
						resLoader.playDrop(resPackage.spawn_posx2, resPackage.spawn_posy2, resPackage.posx2 - 11, resPackage.posy2 - 11);
//						resLoader.starPos=new Point(resPackage.posx2, resPackage.posy2);
//						resLoader.PosX=resPackage.posx2;
//						resLoader.PosY=resPackage.posy2;
//											resLoader.endPos=new Point(Math.random() * radii - area / 2, Math.random() * radii - area / 2);
//						endPoint.x=(len % middle - middle2) * area;
//						endPoint.y=(int(len / middle) - middle2) * area;
//						sidel=Math.sqrt(endPoint.x * endPoint.x + endPoint.y * endPoint.y);
//						anglel=Math.atan2(endPoint.y, endPoint.x) + Math.PI / 4;
//						endPoint.x=sidel * Math.cos(anglel);
//						endPoint.y=sidel * Math.sin(anglel);
//						resLoader.endPos=endPoint;
					}
					else
					{
						resLoader.x=resPackage.posx2 - 11;
						resLoader.y=resPackage.posy2 - 11;
					}
//					if (resLoader.isuse)
//					{
					resLoader.txt.visible=away;
//					}
				}
			}
			dropDic[resPackage.objid]=itemList;
		}
		//默认显示
		public static var away:Boolean=true; //false;

		/**
		 * 掉落地上的物品是否全部显示名称
		 * @param isshow 是否显示物品名字
		 * @param auto 是否自动显示物品名字
		 * */
		public function shiftEvent(isShow:Boolean, auto:Boolean=true):void
		{
			if (SysConfig.arrConfig[3] == 1)
			{
				isShow=true;
			}
			var packageID:String=null;
			away=isShow;
			for (packageID in dropDic)
			{
				var itemList:Vector.<ResItem>=dropDic[packageID];
				var len:int=itemList.length;
				while (--len > -1)
				{
//					if (itemList[len].isuse)
//					{
					itemList[len].txt.visible=isShow;
//					}
				}
			}
		}

		/**
		 * 清除掉落地上的全部物品
		 * */
		public function cleanAllDrop():void
		{
			var packageID:String=null;
			for (packageID in dropDic)
			{
				var itemList:Vector.<ResItem>=dropDic[packageID];
				var len:int=itemList.length;
				while (--len > -1)
				{
//					if (itemList[len].isuse)
//					{
					itemList[len].destory();
//					}
				}
				//清除数据
				itemList.length = 0;
				dropDic[packageID] = null;
				delete dropDic[packageID];
			}
		}



		//************sh**************//
		private var m_po:WorldPoint=new WorldPoint(0, 0, 0, 0);

		public function pickAuto():void
		{
			var rl:ResItem=getMinLenResLoader();
			if (rl != null)
			{
				currDrop=rl;
				m_po.x=rl.x;
				m_po.y=rl.y;
				m_po.mapx=rl.PosX;
				m_po.mapy=rl.PosY;
				if (Data.myKing.king.mapx == rl.PosX && Data.myKing.king.mapy)
				{
					humanArrivedHandler(null);
				}
				else
				{
					PathAction.moveTo(m_po);
				}
//  			PathAction.FindPathToMap(m_po);
//				rl.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		// 选择周围最近的掉落
		private function getMinLenResLoader():ResItem
		{
			var ResLoaderArr:Array=[];
			var resLoader:ResItem=null;
			var bodylen:int=LayerDef.dropLayer.numChildren;
			for (var s:int=0; s < bodylen; s++)
			{
				var body:Object=LayerDef.dropLayer.getChildAt(s);
				if (body is ResItem)
				{
					resLoader=body as ResItem;
					var abs:int=MapCl.getAbsInt(Data.myKing.king, resLoader);
					ResLoaderArr.push({resLoader: resLoader, abs: abs});
				}
			}
			if (ResLoaderArr.length > 0)
			{
				ResLoaderArr.sortOn("abs", Array.NUMERIC);
				resLoader=ResLoaderArr[0]["resLoader"] as ResItem;
				return resLoader;
			}
			else
			{
				return null;
			}
		}
	}
}
