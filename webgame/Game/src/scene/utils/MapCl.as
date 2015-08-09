package scene.utils
{
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.MapDef;
	import com.bellaxu.mgr.TimeMgr;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.res.ResMc;
	import com.bellaxu.util.StageUtil;
	import com.engine.core.tile.TileConstant;
	
	import common.config.GameIni;
	import common.config.PubData;
	
	import flash.geom.Point;
	
	import netc.Data;
	import netc.DataKey;
	
	import scene.action.Action;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	
	import world.WorldPoint;
	import world.WorldState;

	public class MapCl
	{
		public static const SOUTH:uint=1;
		public static const SOUTHWEST:uint=2;
		public static const WEST:uint=3;
		public static const NORTHWEST:uint=4;
		public static const NORTH:uint=5;
		public static const NORTHEAST:uint=6;
		public static const EAST:uint=7;
		public static const SOUTHEAST:uint=8;
		public static const DEFAULT:uint=1;
		/**
		 *	{0, 0},
		{0, 1},
		{-1, 1},
		{-1, 0},
		{-1, -1},
		{0, -1},
		{1, -1},
		{1, 0},
		{1, 1},
		 */
		static public const DIR_MAP1:Array=[new Point(0, 0), new Point(0, 1), new Point(-1, 1), new Point(-1, 0), new Point(-1, -1), new Point(0, -1), new Point(1, -1), new Point(1, 0), new Point(1, 1)];
		static public const DIR_MAP2:Array=[new Point(0, 0), new Point(0, 2), new Point(-2, 2), new Point(-2, 0), new Point(-2, -2), new Point(0, -2), new Point(2, -2), new Point(2, 0), new Point(2, 2)];
		
		public static var TeleportForRelocate:Boolean = false;

		static public function mapToGrid(pt:Point):void
		{
			pt.x=int(pt.x / TileConstant.TILE_Width)
			pt.y=int(pt.y / TileConstant.TILE_Height)
		}

		static public function gridToMap(pt:Point):void
		{
			pt.x=pt.x * TileConstant.TILE_Width + TileConstant.TILE_Width / 2
			pt.y=pt.y * TileConstant.TILE_Height + TileConstant.TILE_Height / 2;
		}

		static public function mapXToGrid(px:int):int
		{
			return int(px / TileConstant.TILE_Width);
		}

		static public function mapYToGrid(py:int):int
		{
			return int(py / TileConstant.TILE_Height);
		}

		static public function gridXToMap(px:int):int
		{
			return px * TileConstant.TILE_Width + TileConstant.TILE_Width / 2;
		}

		static public function gridYToMap(py:int):int
		{
			return py * TileConstant.TILE_Height + TileConstant.TILE_Height / 2;
		}

		static public function mapXToTile(px:int):int
		{
			return int(px / MapDef.TILE_WIDTH);
		}

		static public function mapYToTile(py:int):int
		{
			return int(py / MapDef.TILE_HEIGHT);
		}

		static public function getDir(x:int, y:int):int
		{
			var radian:Number=Math.atan2(-x, -y);
			var angle:int=int(radian * 180 / Math.PI);
			angle=180 - angle;
			return getFXtoInt(angle);
		}

		static public function getDirEx(sx:int, sy:int, x:int, y:int):int
		{
			return getFXtoInt(getAngleEx(sx, sy, x, y));
		}

		static public function getMoveFXByDir(fx:String, dir:int):String
		{
			var nFX:int=int(fx.replace("F", ""));
			if (dir < 0)
			{
				nFX=(nFX + 4) % 8;
			}
			return "F" + nFX;
		}

		static public function getAngleEx(sx:int, sy:int, x:int, y:int):int
		{
			var dx:Number=Number(sx - x);
			var dy:Number=Number(sy - y);
			var radian:Number=Math.atan2(dx, dy);
			var angle:int=int(radian * 180 / Math.PI);
			angle=180 - angle;
			return angle;
		}

		static public function getDistance(sx:int, sy:int, x:int, y:int):int
		{
			var dx:int=Math.abs(x - sx);
			var dy:int=Math.abs(y - sy);
			return Math.max(dx, dy);
		}

		static public function moveByDir1(pt:Point, dir:int):void
		{
			var p:Point=DIR_MAP1[dir];
			pt.x+=p.x;
			pt.y+=p.y;
		}

		static public function moveByDir2(pt:Point, dir:int):void
		{
			var p:Point=DIR_MAP2[dir];
			pt.x+=p.x;
			pt.y+=p.y;
		}

		/**
		 *                    180度(原来这个地方是90度)
		 *                    5方向
		 *
		 *   90度      <-                ->           7方向
		 *   3方向
	 *                    0度
								*                    1方向
		 *
		 */
		public static function getAngle(mca:Object, mcb:Object):int
		{
			var dx:Number=Number(mca.x - mcb.x);
			var dy:Number=Number(mcb.y - mca.y);
			var radian:Number=Math.atan2(dx, dy);
			var angle:int=int(-radian * 180 / Math.PI);
			angle=180 - angle;
			return angle;
		}

		public static function getAbs(bodya:Object, bodyb:Object, len:int):Boolean
		{
			// 如果距离过远=false;在距离过程中=true;
			if (bodya == null || bodyb == null)
				return false;
			var dx:Number=Math.abs(bodya.x - bodyb.x);
			var dy:Number=Math.abs(bodya.y - bodyb.y);
			var abs:Number=Math.sqrt(dx * dx + dy * dy);
			if (abs > len)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		public static function getAbsInt(bodya:Object, bodyb:Object):Number
		{
			if (bodya == null || bodyb == null)
				return 99999;
			var dx:Number=Math.abs(bodya.x - bodyb.x);
			var dy:Number=Math.abs(bodya.y - bodyb.y);
			var abs:Number=Number(Math.sqrt(dx * dx + dy * dy));
			return abs;
		}

		public static function getFXtoXOR(FX:String):String
		{
			var F:int=int(int(FX.substr(1, 1)) + 4);
			F=F > 8 ? F - 8 : F;
			return "F" + F;
		}

//		private static var SkillAngleConfig:Array = [0,45,90,135,180,225,270,315];
		/**
		 * 获取技能朝向，返回值只有八个固定角度 针对激光电影
		 */
		public static function getSpecialSkillAngle(fx:String):int
		{
			if (fx.length > 0)
			{
				var dir:int=int(fx.charAt(1));
				var srcPoint:Point=DIR_MAP1[0];
				var tarPoint:Point=DIR_MAP1[dir];
				var tarAbsPoint:Point=tarPoint.clone(); //目标实际坐标
				tarAbsPoint.x*=TileConstant.TILE_Width;
				tarAbsPoint.y*=TileConstant.TILE_Height;
				var angle:int=getAngle(tarAbsPoint, srcPoint);
				return angle;
			}
			return 0;
		}

		/**
		 *
		 *  int(45/2+45*7): 337
			int(45/2): 22
			int(45/2+45*6): 292
			int(45/2+45*5) 247
			int(45/2+45*4) 202
			int(45/2+45*3) 157
			int(45/2+45*2) 112
			int(45/2+45*1) 67
			int(45/2+45*0) 22
		 *
		 *
		 */
		public static function getFXtoInt(angle:int):int
		{
			//默认向下，即F1
			if (angle < 23)
			{
				return SOUTH;
			}
			else if (angle < 68)
			{
				return SOUTHWEST;
			}
			else if (angle < 113)
			{
				return WEST;
			}
			else if (angle < 158)
			{
				return NORTHWEST;
			}
			else if (angle < 203)
			{
				return NORTH;
			}
			else if (angle < 248)
			{
				return NORTHEAST;
			}
			else if (angle < 293)
			{
				return EAST;
			}
			else if (angle < 338)
			{
				return SOUTHEAST;
			}
			return SOUTH;
		}

		public static function getFX16toInt(angle:int):int
		{
			//默认向下，即F1
			if (angle < 23)
			{
				return 1;
			}
			else if (angle < 46)
			{
				return 2;
			}
			else if (angle < 69)
			{
				return 3;
			}
			else if (angle < 92)
			{
				return 4;
			}
			else if (angle < 115)
			{
				return 5;
			}
			else if (angle < 138)
			{
				return 6;
			}
			else if (angle < 161)
			{
				return 7;
			}
			else if (angle < 184)
			{
				return 8;
			}
			else if (angle < 207)
			{
				return 9;
			}
			else if (angle < 230)
			{
				return 10;
			}
			else if (angle < 253)
			{
				return 11;
			}
			else if (angle < 276)
			{
				return 12;
			}
			else if (angle < 299)
			{
				return 13;
			}
			else if (angle < 322)
			{
				return 14;
			}
			else if (angle < 345)
			{
				return 15;
			}
			return 16;
		}

		public static function getWASD(angle:int):String
		{
			return "F" + getFXtoInt(angle);
		}

		public static function getWASDByDir(dir:int):String
		{
			if (dir == 0)
				dir=1;
			return "F" + dir;
		}

		public static function getGameKingFXtoInt(targetA:Object, targetB:Object):int
		{
			return getFXtoInt(getAngle(targetA, targetB));
		}

		public static function getABWASD(targetA:Object, targetB:Object):String
		{
			return getWASD(getAngle(targetA, targetB));
		}

		public static function getMapBodyMousePoint():Point
		{
			if (LayerDef.bodyLayer != null)
			{
				return getPoint(LayerDef.bodyLayer.mouseX, LayerDef.bodyLayer.mouseY);
			}
			else
			{
				return new Point(0, 0);
			}
		}

		/**
		 * 在哪一个单元格
		 */
		public static function getCube(p_x:Number, p_y:Number, type:Boolean=true):Point
		{
			var tw:int=MapData.TW;
			var th:int=MapData.TH;
			if (type)
			{
				p_x=Math.floor(p_x / tw);
				p_y=Math.floor(p_y / th);
				//check
				var m_x:Number=Math.floor(MapData.MAPW / tw);
				var m_y:Number=Math.floor(MapData.MAPH / th);
				if (p_x > m_x)
					p_x=m_x;
				if (p_y > m_y)
					p_y=m_y;
			}
			else
			{
				p_x=Math.floor(p_x * tw);
				p_y=Math.floor(p_y * th);
			}
			return new Point(p_x, p_y);
		}

		public static function getPoint(p_x:Number, p_y:Number, type:Boolean=true):Point
		{
			var tw:int=MapData.TW;
			var th:int=MapData.TH;
			var p_x2:int;
			var p_y2:int;
			if (type)
			{
				p_x2=Math.floor(p_x / tw);
				p_y2=Math.floor(p_y / th);
				//check
				var m_x:int=Math.floor(MapData.MAPW / tw);
				var m_y:int=Math.floor(MapData.MAPH / th);
				if (p_x2 > m_x)
					p_x2=m_x;
				if (p_y2 > m_y)
					p_y2=m_y;
			}
			else
			{
				p_x2=Math.floor(p_x * tw);
				p_y2=Math.floor(p_y * th);
			}
			return new Point(p_x2, p_y2);
			//return new Point(p_x,p_y);
		}

		public static function getRelateDistance(x:int, y:int):WorldPoint
		{
			var d_x:int;
			var d_y:int;
			var k_x:int=Data.myKing.mapx * TileConstant.TILE_Width;
			var k_y:int=Data.myKing.mapy * TileConstant.TILE_Height;
			var c_x:int=Math.round(StageUtil.stageWidth / 2);
			var c_y:int=Math.round(StageUtil.stageHeight / 2);
			d_x=x + (k_x - c_x);
			d_y=y + (k_y - c_y);
			return new WorldPoint(x, y, d_x, d_y);
		}

		public static function getAbsoluteDistance(mapx:int, mapy:int, isMe:Boolean=false):WorldPoint
		{
			var d_x:int;
			var d_y:int;
			if (isMe)
			{
				d_x=Math.round(StageUtil.stageWidth / 2);
				d_y=Math.round(StageUtil.stageHeight / 2);
			}
			else
			{
				var k_x:int=gridXToMap(Data.myKing.mapx);
				var k_y:int=gridYToMap(Data.myKing.mapy);
				var k:IGameKing=Data.myKing.king;
				if (null != k)
				{
					k_x=gridXToMap(k.mapx);
					k_y=gridYToMap(k.mapy);
				}
				var c_x:int=Math.round(StageUtil.stageWidth / 2);
				var c_y:int=Math.round(StageUtil.stageHeight / 2);
				d_x=mapx - (k_x - c_x);
				d_y=mapy - (k_y - c_y);
			}
			return new WorldPoint(d_x, d_y, mapx, mapy);
		}

		public static function setPoint(mc:Object, mapx:int, mapy:int, isMe:Boolean=false):void
		{
			var p:Point=new Point(mapx, mapy);
			gridToMap(p);
			mc.x=p.x;
			mc.y=p.y;
			if (isMe)
				trace("KingPos-----------------------",mapx,mapy,mc.x,mc.y);
		}

		/**
		 * 把类型转换嶙实际的动作值
		 * */
		public static function getACT(zt:String):String
		{
			switch (zt)
			{
				case KingActionEnum.DJ:
					zt="D1";
					break;
				case KingActionEnum.ZhanDou_DJ:
				case KingActionEnum.XL:
					zt="D2";
					break;
				case KingActionEnum.GJ:
				case KingActionEnum.GJ1:
				case KingActionEnum.GJ_DJ:
					zt="D3";
					break;
				case KingActionEnum.GJ2:
					zt="D9";
					break;
				case KingActionEnum.MAGIC_GJ_DJ:
				case KingActionEnum.JiNeng_GJ:
					zt="D4";
					break;
				case KingActionEnum.PB:
					zt="D5";
					break;
				case KingActionEnum.ZL:
					zt="D6";
//					zt="D5";//BellaXu修改。。。D6不是受伤么？？？？
					break;
				case KingActionEnum.SJ:
					zt="D13";
					break;
//				case KingActionEnum.SJ_DJ:
//					zt="D13";
//					break;
				case KingActionEnum.Dead:
					zt="D7";
					break;
				case KingActionEnum.CJ:
					zt="D8";
					break;
				case KingActionEnum.ZOJ_DJ:
					zt="D10";
					break;
				case KingActionEnum.ZOJ_PB:
					zt="D11";
					break;
				case KingActionEnum.ZOJ_GJ:
					zt="D3";
					break;
				case KingActionEnum.ZOJ_Dead:
//					zt="D13";
					zt="D7";
					break;
				case KingActionEnum.JP:
					zt="D12";
					break;
				default:
					zt="D1";
					break;
			}
			return zt;
		}

//---------------Warren----------------
		/**
		 * 当前动作 D1待机 D2 修炼
		 * D3 攻击1 D4 技能攻击
		 * D5 跑步 D6  受伤 D7 死亡
		 *
		 * 注意没有受伤
		 *
		 * D8 采集
		 * D9 攻击2
		 * D10 坐骑攻击 D11 坐骑死亡
		 * D13 现在为受伤(受击)D6为走路
		 */
		public static function setFangXiang(role:ResMc, ZT:String, FX:String="F1", GameKing:IGameKing=null, PlayCount:int=0, PlayOverAct:Function=null, Frame:int=0, midActionIndex:int=-1, midActionHandler:Function=null):void
		{
			if (null == role)
				return;
			var currentLabel:String=role.frameName;
//			if (role.mcName.indexOf("Main")!=-1)
//			var curDZ:String = null;
//			if(currentLabel)
//				curDZ = currentLabel.substr(0, currentLabel.length - 2);
			var DZ:String=getACT(ZT);
//			if((curDZ == "D10" || curDZ == "D11") && (DZ == "D5" || DZ == "D6"))
//				DZ = "D11";
			if (DZ == "D7")
				FX="F1";
			if (!FX)
				FX="F1";
			if (DZ != "D1")
			{
				if (GameKing && GameKing.getSkin())
				{
					GameKing.getSkin().visibleAll(!GameKing.getSkin().canShow);
//					if (GameKing.getSkin().getHeadName() && GameKing.getSkin().getHeadName().ChengHao)
//						GameKing.getSkin().getHeadName().ChengHao.visible=!Action.instance.sysConfig.alwaysHideChengHao;
				}
			}
//			GameData.state == StateDef.IN_SCENE;
			//修炼
//			if (null != GameKing)
//			{
//				if (KingActionEnum.XL == ZT && 10 > GameKing.level && GameKing.name2.indexOf(BeingType.HUMAN) >= 0)
//				{
//					DZ=KingActionEnum.DJ;
//				}
//			}
//			if (null != GameKing)
//			{
//				var s2Id:int = GameKing.getSkin().filePath.s2;
//				if ("D4" == DZ && isBianShen(s2Id))
//					DZ="D3";
//			}
			role.playCount=PlayCount;
			role.playOverAct=PlayOverAct;
			role.midActionIndex=midActionIndex;
			var m_king:King=Data.myKing.king as King;
			if(m_king&&m_king.seList&&m_king.seList.length>0&&role.midActionHandler!=null){
				role.midActionHandler();
			}
			role.midActionHandler=midActionHandler;
			var DZFX:String=DZ + FX;
			//DZFX=(FX == null) ? DZ + currentLabel.substr(currentLabel.length - 2, currentLabel.length) : DZ + FX;
//			trace("E"+","+currentLabel+","+DZFX)
			if (currentLabel != DZFX)
			{
//				trace("F")
				role.gotoAndPlay(DZFX);
			}
			else
			{
//				trace("G")
				if (ZT == KingActionEnum.GJ_DJ)
				{
//					trace("H")
					role.gotoAndStop(DZFX);
				}
				else if (ZT == KingActionEnum.MAGIC_GJ_DJ)
				{
//					trace("I")
					role.stopAtEnd();
				}
				else
				{
//					trace("J")
					if (role.isStoped)
					{
//						trace("K")
						role.gotoAndPlay(DZFX);
					}
				}
			}
		}
		private static var TestStart:Boolean=false;
		public static var DelAll:Boolean=false;
		public static var DelAllOUT:uint=0;

		//public static function playerCenterMap(player:Object,map:Object):void{
		public static function playerCenterMap(player:King):Boolean
		{
//			trace("playerCenterMap-----------",TimeMgr.passedTime);
			if (null == player.parent)
			{
				var state:String=GameIni.currentState;
				if (state == WorldState.ground && false == DelAll)
//项目转换			if (GameData.state == StateDef.IN_SCENE && false == DelAll)
				{
					SceneManager.instance.AddKing_Core(player);
				}
				return false;
			}
			var screen_w:int=StageUtil.stageWidth;
			var screen_h:int=StageUtil.stageHeight;
			//最小宽高，同stageResizeHandler
			if (screen_w < 200)
			{
				screen_w=200;
			}
			if (screen_h < 200)
			{
				screen_h=200;
			}
			var map_w:int=MapData.MAP_RES_WIDTH;
			var map_h:int=MapData.MAP_RES_HEIGHT;
			//有可能地图数据未加载完成，但要求加载地图图片的协议已到，所以此时宽高都为0.因为此方法是一直刷新的，检测状态正确的时候赋值即可
			if (MapData.MAP_RES_WIDTH == 0 || MapData.MAP_RES_HEIGHT == 0)
			{
				return false;
			}
			else
			{
				map_w=MapData.MAP_RES_WIDTH;
				map_h=MapData.MAP_RES_HEIGHT;
			}
//			if (0 == map_w || 0 == map_h)
//			{
//				//默计主城地图宽高
//				map_w=10000;
//				map_h=6000;
//			}
			var king_x:Number;
			var king_y:Number;
			var map_x:Number;
			var map_y:Number;
//				king_x=(player.mapx);
//				king_y=(player.mapy);
			king_x=(player.x);
			king_y=(player.y);
			map_x=LayerDef.mapLayer.x;
			map_y=LayerDef.mapLayer.y;
			//Mapx = -k_x (移动距离)
			//中心点
			var center_x:Number=(screen_w >> 1) - king_x;
			var center_y:Number=(screen_h >> 1) - king_y;
			if (center_x > 0)
			{
				center_x=0;
			}
			else if (center_x < map_w * -1 + screen_w)
			{
				center_x=map_w * -1 + screen_w;
			}
			if (center_y > 0)
			{
				center_y=0;
			}
			else if (center_y < map_h * -1 + screen_h)
			{
				center_y=map_h * -1 + screen_h;
			}
			//
			var cX:int=Math.round(center_x);
			var cY:int=Math.round(center_y);
			var isUpdate:Boolean = false;
			if (LayerDef.mapLayer.x != cX)
			{
				LayerDef.mapLayer.x=cX;
				isUpdate = true;
			}
			if (LayerDef.mapLayer.y != cY)
			{
				LayerDef.mapLayer.y=cY;
				isUpdate = true;
			}
			if (isUpdate)
			{
				if (TeleportForRelocate)
				{
					TeleportForRelocate = false;
					SceneManager.instance.reloadTile(true,true);
				}
				else
				{
					SceneManager.instance.reloadTile();
				}
			}
			return isUpdate;
		}
//		//--------------------- 新增 ------------------------------------------
		/**
		 * 获取两点之间的格子数
		 */
		public static function getDistanceGrids(destX:int, destY:int, fromX:int, fromY:int):int
		{
			var dx:int=Math.abs(destX - fromX);
			var dy:int=Math.abs(destY - fromY);
			var count:int=0;
			if (dx > 0)
			{
				count=dx;
			}
			else if (dy > 0)
			{
				count=dy;
			}
			return count;
		}

		/**
		 * 获取指定范围所在的8个格子
		 */
		public static function getGridsAround(centerX:int, centerY:int, range:int=1):Array
		{
			var px:int;
			var py:int;
			var p:Point;
			var grids:Array=[];
			var map_w:int=MapData.MAP_RES_WIDTH;
			var map_h:int=MapData.MAP_RES_HEIGHT;
			var absX:int;
			var absY:int;
			for (var i:int=1; i <= 8; i++)
			{
				p=DIR_MAP1[i];
				px=centerX + p.x * range;
				py=centerY + p.y * range;
				absX=gridXToMap(px);
				absY=gridYToMap(py);
				if (absX > 0 && absX < map_w && absY > 0 && absY < map_h)
				{
					grids.push([px, py]);
				}
			}
			return grids;
		}

		/**
		 * 返回两个格子直接距离的格子数
		 */
		public static function getGridsBetween(fromX:int, fromY:int, toX:int, toY:int):int
		{
			var absX:int=Math.abs(toX - fromX);
			var absY:int=Math.abs(toY - fromY);
			var max:int=Math.max(absX, absY);
			return max;
		}

		/**
		 * 变身
		 */
		public static function isBianShen(s2:int):Boolean
		{
			if (s2.toString().indexOf("310") != -1) //变身状态下，没有走路动作，以跑步替换
			{
				return true;
			}
			return false;
		}

		public static function isRunDistance(from:Point, to:Point):Boolean
		{
			return Point.distance(from, to) >= 2;
		}

		public static function isWalkDistance(from:Point, to:Point):Boolean
		{
			return Point.distance(from, to) < 2;
		}

		public static function searchStepPoint(from:Point, to:Point, checkValid:Function, step:int=1):Point
		{
			var path:Vector.<Point>=getBeeline(from, to, step);
			if (checkBeeline(path, checkValid))
			{
				return path.pop();
			}
			return null;
		}

		public static function searchStepPoints(from:Point, to:Point, checkValid:Function, step:int=1):Vector.<Point>
		{
			var path:Vector.<Point>=getBeeline(from, to, step);
			if (checkBeeline(path, checkValid))
			{
				return path;
			}
			return null;
		}

		public static function checkInLine(from:Point, second:Point, third:Point):Boolean
		{
			var stepX:int=second.x - from.x;
			var stepY:int=second.y - from.y;
			if ((second.x + stepX == third.x) && (second.y + stepY == third.y))
			{
				return true;
			}
			return false;
		}

		private static function checkBeeline(path:Vector.<Point>, check:Function):Boolean
		{
			var p:Point;
			for each (p in path)
			{
				if (!check(p))
				{
					return false;
				}
			}
			return true;
		}

		public static function getBeeline(from:Point, to:Point, step:int=1):Vector.<Point>
		{
			var path:Vector.<Point>;
			var rate:Number;
			if (from.y == to.y)
			{
				if (to.x > from.x)
				{
					path=make(from, step, 1, 0);
				}
				else
				{
					path=make(from, step, -1, 0);
				}
			}
			else
			{
				rate=(to.x - from.x) / (to.y - from.y);
				if (rate <= -2)
				{
					if (to.y < from.y)
					{
						path=make(from, step, 1, 0);
					}
					else
					{
						path=make(from, step, -1, 0);
					}
				}
				else
				{
					if (rate <= -0.5)
					{
						if (to.y < from.y)
						{
							path=make(from, step, 1, -1);
						}
						else
						{
							path=make(from, step, -1, 1);
						}
					}
					else
					{
						if (rate <= 0.5)
						{
							if (to.y < from.y)
							{
								path=make(from, step, 0, -1);
							}
							else
							{
								path=make(from, step, 0, 1);
							}
						}
						else
						{
							if (rate <= 2)
							{
								if (to.y < from.y)
								{
									path=make(from, step, -1, -1);
								}
								else
								{
									path=make(from, step, 1, 1);
								}
							}
							else
							{
								if (to.x < from.x)
								{
									path=make(from, step, -1, 0);
								}
								else
								{
									path=make(from, step, 1, 0);
								}
							}
						}
					}
				}
			}
			return path;
		}

		private static function make(from:Point, step:int, xOffset:int, yOffset:int):Vector.<Point>
		{
			var p:Point;
			var path:Vector.<Point>=new Vector.<Point>();
			var index:int;
			while (index < step)
			{
				p=from.clone();
				p.x=p.x + xOffset;
				p.y=p.y + yOffset;
				path.push(p);
				from.x=from.x + xOffset;
				from.y=from.y + yOffset;
				index++;
			}
			return path;
		}

		/**
		 * 采用螺旋算法获取指定区域内的点集合
		 */
		public static function getHelixGroup(centerX:int, centerY:int, left:int, right:int, top:int, bottom:int):Vector.<Point>
		{
			var gridIndex:int;
			var grids:Vector.<Point>=new Vector.<Point>();
			var gridCount:int=(right - left + 1) * (bottom - top + 1);
			var offset:int=2;
			grids.push(new Point(centerX, centerY));
			while (grids.length < gridCount)
			{
				centerX--;
				centerY--;
				gridIndex=centerX;
				while (gridIndex <= centerX + offset)
				{
					if (gridIndex >= left && gridIndex <= right)
					{
						if (centerY >= top)
						{
							grids.push(new Point(gridIndex, centerY));
						}
						if (centerY + offset <= bottom)
						{
							grids.push(new Point(gridIndex, centerY + offset));
						}
					}
					gridIndex++;
				}
				gridIndex=centerY + 1;
				while (gridIndex <= (centerY + offset - 1))
				{
					if (gridIndex >= top && gridIndex <= bottom)
					{
						if (centerX >= left)
						{
							grids.push(new Point(centerX, gridIndex));
						}
						if (centerX + offset <= right)
						{
							grids.push(new Point(centerX + offset, gridIndex));
						}
					}
					gridIndex++;
				}
				offset=offset + 2;
			}
			return grids;
		}

		public static function isKingInSameGrid(k1:IGameKing, k2:IGameKing):Boolean
		{
			return isSamePoint(k1.mapx, k1.mapy, k2.mapx, k2.mapy);
		}

		public static function isSamePoint(x1:int, y1:int, x2:int, y2:int):Boolean
		{
			return x1 == x2 && y1 == y2;
		}
	}
}
