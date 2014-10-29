package scene.gprs
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.AttrDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.model.lib.ext.IS;
	import com.bellaxu.res.ResTool;
	
	import comload.JPGLoader;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.config.xmlres.server.Pub_SeekResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import netc.Data;
	
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.MapDataEvent;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.libclass.SmBody;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.view.view2.NewMap.GameNowMap;
	
	import world.FileManager;
	import world.type.BeingType;
	import world.type.ItemType;

	public class GameSceneGprs
	{
		static private var beiW:Number;
		static private var beiH:Number;

		private static var Spritemap:Sprite=new Sprite();
		private static var isVisble:Boolean=true;
		private static var MAP:JPGLoader;
		private var thisUI:MovieClip;
		private var GPRS:MovieClip;
		private var MapPosText:TextField;
		private static var Spritenpc:Sprite=new Sprite();
		public static var SceneGprs:GameSceneGprs;
		private var MapGraphics:Sprite=new Sprite();

		//当前地图寻径数据
		public static var arrSeek:Vector.<Pub_SeekResModel> = new <Pub_SeekResModel>[];


		public function GameSceneGprs(smallmapui:MovieClip)
		{
			SceneGprs=this;
			thisUI=smallmapui;
			GPRS=thisUI["GPRS"];
			MAP=thisUI["GPRS"]["MAP"];
			MAP.setCompleteFunc=CompleteFunc;
			
			MAP.addChild(MapGraphics);
			GPRS.addChild(Spritenpc);
			GPRS.addChild(Spritemap);
			GPRS.mouseEnabled=GPRS.mouseChildren=false;
			MAP.mouseEnabled=MAP.mouseChildren=false;
			MapGraphics.mouseEnabled=MapGraphics.mouseChildren=false;
			Spritenpc.mouseEnabled=Spritenpc.mouseChildren=false;
			Spritemap.mouseEnabled=Spritemap.mouseChildren=false;

			MapPosText=thisUI["MapPosText"];
			MapPosText.text="x:0 y:0";
			MapPosText.mouseEnabled=false;
			addEvent(true);
		}

		private function RefreshAndUpdate(e:DispatchEvent=null):void
		{
				this.removeAll();
	
//项目转换				arrSeek = Lib.getVec(LibDef.PUB_SEEK, [AttrDef.map_id, IS, SceneManager.instance.currentMapId]);
arrSeek=XmlManager.localres.getPubSeekXml.getResPath2(SceneManager.instance.currentMapId, 0) as Vector.<Pub_SeekResModel>;
//				arrSeek.sortOn("pos");
				//var m:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId);
//项目转换				var m:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, SceneManager.instance.currentMapId.toString());
var m:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
				//雷达地图资源太大，需要修改(现在用的是原始地图资源)
				MAP.source=FileManager.instance.getRadarMapById(m.res_id.toString());
//				ImageUtils.replaceImage(thisUI["GPRS"],MAP,FileManager.instance.getRadarMapById(m.res_id.toString()));
				GameNowMap.instance().changeMap();
		}

		public function addEvent(bo:Boolean):void
		{
			isVisble=bo;
			if (bo)
			{
				MapData.AddEventListener(HumanEvent.RemoveAll, RemoveAllHuman);
				Body.instance.sceneEvent.addEventListener(HumanEvent.RemoveThis, RemoveThisHuman);
				Body.instance.sceneEvent.addEventListener(HumanEvent.AddShowToMap, AddShowToMap);

				MapData.AddEventListener(MapDataEvent.MapShowComplete, RefreshAndUpdate);

					//this.RefreshAndUpdate();

			}
			else
			{
				this.removeAll();
				MapData.RemoveEventListener(HumanEvent.RemoveAll, RemoveAllHuman);

				Body.instance.sceneEvent.removeEventListener(HumanEvent.RemoveThis, RemoveThisHuman);
				Body.instance.sceneEvent.removeEventListener(HumanEvent.AddShowToMap, AddShowToMap);

				MapData.RemoveEventListener(MapDataEvent.MapShowComplete, RefreshAndUpdate);
			}
		}

		public function CompleteFunc():void
		{
			MAP.setSize(MAP.getInfoWidth, MAP.getInfoHeight);
			beiW = MapData.MAPW / MAP.width;
			beiH = MapData.MAPH / MAP.height;

			if (LayerDef.bodyLayer != null)
			{
				var bodylen:int=LayerDef.bodyLayer.numChildren;

				for (var i:int=0; i < bodylen; i++)
				{
					var d:DisplayObject=LayerDef.bodyLayer.getChildAt(i);

					if (d is IGameKing)
					{
						ShowKing(d as IGameKing);
					}
				}

			}

			
			SetKingPos(Data.myKing.king);
//			this.MapPosText.text=MapData.getMapName+"("+int(DataCenter.myKing.king.x/MapData.TW)+","+int(DataCenter.myKing.king.y/MapData.TW)+")";
		}

		public function MapDrawPathLine(path:Array):void
		{

			if (null == path)
			{
				return;
			}
			//2012-01-30 小雷达不画寻径点
			//UIFactory.getFont.DrawPathLine(MAP,MapGraphics,path,beiW,beiH,2,9,0xFF0000);
		}

		public static function SetKingPos(GameKing:IGameKing):void
		{
			ShowKing(GameKing);
		}

		/**
		 *	小雷达玩家，怪物即时控制
		 */
		public static function ShowKing(GameKing:IGameKing):void
		{
			if (MAP == null) return;
			if (isVisble && GameKing != null)
			{
				var king:King=King(GameKing);
				if (king == null)
					return;
				//小鸡不显示
				//if (king.beingType == BeingType.MON || king.beingType == BeingType.NPC)
				if (GameKing.name2.indexOf(BeingType.NPC) >= 0)
				{
					if (king.getKingType == 4 || king.getKingType == 6)
						return;
				}
				if (king.name2.indexOf(ItemType.PICK) >= 0)
				{
					return;
				}
				//伙伴不显示
				//if (king.beingType == BeingType.PET)
				//	return;

				var uid:int=king.roleID;
				var PL:SmBody=Spritemap.getChildByName("spritemap_uid_" + uid.toString()) as SmBody;
								if (null == PL)
				{
					PL=ItemManager.instance().getSmBodyGprs();
					if(PL==null)return;
					PL.name="spritemap_uid_" + uid.toString();
					Spritemap.addChild(PL);

					if (king.isMe)
					{
						//小雷达主角形象是个球
						PL.gotoAndStop(5);
					}
					else
					{
						if (king.beingType == BeingType.HUMAN)
							PL.gotoAndStop(2);
						else if (king.beingType == BeingType.MON)
							PL.gotoAndStop(3);
						else
						{
							PL.gotoAndStop(4);
						}
					}
				}

				PL.x = king.x / beiW;
				PL.y = king.y / beiH;
				if (king.isMe)
				{
					//PL.rotation = GameKing.roleAngle;
					var WH:int=148;
					var MAPX:Number=-Number(PL.x - WH / 2);
					var MAPY:Number=-Number(PL.y - WH / 2);
					if (MAPX < WH - MAP.width)
						MAPX=WH - MAP.width;
					if (MAPX > 0)
						MAPX=0;
					if (MAPY < WH - MAP.height)
						MAPY=WH - MAP.height;
					if (MAPY > 0)
						MAPY=0;
					MAP.x=MAPX;
					MAP.y=MAPY;
					Spritemap.x=MAP.x;
					Spritemap.y=MAP.y;
//					trace("MAP---------",MAP.x,MAP.y);
					PL.alpha = 1.0;
					
				}else if(SceneManager.instance.isAtGhost())
				{
					PL.alpha = 0.0;
				
				}else
				{
					PL.alpha = 1.0;
				}
				
			}
		}


		private function AddShowToMap(e:DispatchEvent):void
		{
			ShowKing(SceneManager.instance.GetKing_Core(e.getInfo));
		}

		private function RemoveAllHuman(e:DispatchEvent=null):void
		{
			while (Spritemap.numChildren)
				Spritemap.removeChildAt(0);
		}

		private function RemoveThisHuman(e:DispatchEvent):void
		{
			var uid:String=e.getInfo;
			var PL:SmBody=Spritemap.getChildByName("spritemap_uid_" + uid) as SmBody;

			if (null != PL)
			{
				// parent有可能是spriteMap或spriteNpc
				if (null != PL.parent)
				{
					PL.parent.removeChild(PL);
				}
			}
		}

		private function removeAll():void
		{
			MapGraphics.graphics.clear();
			while (Spritenpc.numChildren)
				Spritenpc.removeChildAt(0);
			// while(Spritemap.numChildren)Spritemap.removeChildAt(0);
			this.RemoveAllHuman();
			MAP.unload();
		}

		public static function set setVisible(bo:Boolean):void
		{
			// 检查地图的事件
			if (SceneGprs != null)
				SceneGprs.addEvent(bo);
		}

		/**
		 *	返回当前地图的寻径数据
		 */
		public static function getSeekBySort(sort:int):Array
		{
			var arr:Array=new Array();
			var item:Pub_SeekResModel=null;
			for each (item in arrSeek)
			{
				if (item.sort == sort)
					arr.push(item);
			}
			if (sort == 1)
				arr.sortOn("pos", Array.NUMERIC);
			if (sort == 3)
				arr.sortOn("seek_level", Array.NUMERIC);
			return arr;
		}
	}
}
