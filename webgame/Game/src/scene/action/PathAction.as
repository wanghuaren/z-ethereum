 package scene.action
{
	import com.bellaxu.debug.Debug;
	
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.MsgPrint;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.acts.ActMove;
	import scene.acts.ActRun;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.human.GameLocalHuman;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.TargetInfo;
	import scene.manager.AlchemyManager;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect35;
	import scene.skill2.SkillEffectManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	import scene.utils.MyWay;
	
	import ui.view.view2.NewMap.GameNowMap;
	import ui.view.zuoqi.ZuoQiMain;
	
	import world.WorldFactory;
	import world.WorldPoint;
	import world.type.BeingType;
	import world.type.ItemType;

	/**
	 * 行走
	 * [改]人物行走过程中客户端预先处理，然后由服务器进行过程校验
	 * modified by liuaobo at 2013-07-10
	 */
	public class PathAction
	{
		//偏差
		//偏差35太大，现改为10
		public static const windage:int=35; //MapData.TW / 2;
		public static const windage_half:int=18;
		public static const windage_half_half:int=9;
		/**
		 *	是否在护送美女中
		 */
		public static var isHuSong:Boolean=false;
		/**
		 * 是否通过操作移动
		 */
		public static var MoveWithClientCmd:Boolean=false;
		public static var isCanPutIn:Boolean=false;

		public function PathAction()
		{
			DataKey.instance.register(PacketSCPlayerMove.id, CPlayerPath);
			DataKey.instance.register(PacketSCObjNewMove.id, CPlayerMove);
			//			DataKey.instance.register(PacketSCMove.id, CPlayerMove);
			//			DataKey.instance.register(PacketSCMoveStop.id, CPlayerMoveStop);
			DataKey.instance.register(PacketSCMoveServerReq.id, CMoveServerReq);
			DataKey.instance.register(PacketSCObjVerifyPos.id, CPlayerVerifyPos);
		}

		static public function sendMove(destX:int, destY:int, dir:int, isRun:Boolean):void
		{
			var pack:PacketCSNewPlayerMove=new PacketCSNewPlayerMove();
			pack.dir=dir;
			pack.step=isRun ? 2 : 1;
			pack.way_point.point_x=destX
			pack.way_point.point_y=destY;
			pack.mapid=MapData.MAPID;
			DataKey.instance.send(pack);
		}

		public function CPlayerMove(p:PacketSCObjNewMove):void
		{
			var king:King;
			if (p.objid == Data.myKing.objid)
			{
				king=Data.myKing.king as King;
			}
			else
				king=SceneManager.instance.GetKing_Core(p.objid) as King;
			if (king == null)
				return;
			if (p.step == 2)
			{
				var runAct:ActRun=new ActRun();
				runAct.nDestX=p.cur_point.point_x;
				runAct.nDestY=p.cur_point.point_y;
				king.postAction(runAct);
			}
			else
			{
				var moveAct:ActMove=new ActMove();
				moveAct.nDestX=p.cur_point.point_x;
				moveAct.nDestY=p.cur_point.point_y;
				king.postAction(moveAct);
			}
			king.moveActionCount++;
		}

		public function CPlayerVerifyPos(p:PacketSCObjVerifyPos2):void
		{
			var po:WorldPoint=new WorldPoint(p.cur_point.point_x, p.cur_point.point_y, p.cur_point.point_x, p.cur_point.point_y);
			var k:IGameKing=Data.myKing.king;
			if (k != null)
			{
				if (k is King)
					(k as King).idle();
				k.setKingData(k.roleID, k.objid, k.getKingName, k.sex, k.metier, k.level, k.hp, k.maxHp, k.camp, k.campName, p.cur_point.point_x, p.cur_point.point_y, k.masterId, k.masterName, k.mapZoneType, k.grade, k.isMe);
				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived));
//				moveTo(po);
				Debug.warn("服务端校验坐标  client: " + k.mapx + ", " + k.mapy + "  server: " + po.mapx + ", " + po.mapy);
			}
		}

		static public function moveTo(po:WorldPoint, depth:int=15000):Boolean
		{
			var path:Array=[];
			var sPt:Point=(Data.myKing.king as GameLocalHuman).getCurPos();
			var m_to:Point=new Point(po.mapx, po.mapy);
			var result:int=AlchemyManager.instance.getPath(sPt.x, sPt.y, po.mapx, po.mapy, path, depth);
			var mergePath:Array=merge(path);
			if (result == -1 || mergePath.length == 0)
			{
				//移动失败;
				return false;
			}
			(Data.myKing.king as GameLocalHuman).moveByPath(mergePath);
			GameNowMap.MapDrawPathLine(new Array().concat(mergePath));
			(Data.myKing.king as GameLocalHuman).btUseRun=true; //微端使用flase;
			if (mergePath.length > 20) //移动距离大于20个格子*64，则上马
			{
				if ((Data.myKing.king as King).onHorse() == false)
				{
					setTimeout(function():void
					{
						ZuoQiMain.qiCheng();
					}, 100);
				}
			}
			return true;
		}

		static public function moveToByDirection(king:IGameKing, po:WorldPoint, direction:int=1, depth:int=5000):Boolean
		{
			var path:Array=[];
			var sPt:Point=(king as King).getCurPos();
			var result:int=AlchemyManager.instance.getPath(sPt.x, sPt.y, po.mapx, po.mapy, path, depth);
			var mergePath:Array=merge(path);
			if (result == -1)
			{
				//移动失败;
				return false;
			}
			(king as King).moveByPathForSkill(mergePath);
			return true;
		}

		static public function merge(path:Array):Array
		{
			var dirMap:Array=[];
			var nSize:int=path.length;
			var lastPt:Point=null;
			var pt:Point;
			var dir:int;
			for (var i:int=0; i < nSize; ++i)
			{
				pt=path[i];
				if (lastPt)
				{
					dir=MapCl.getDirEx(lastPt.x, lastPt.y, pt.x, pt.y);
					dirMap.push(dir);
				}
				lastPt=pt;
			}
			path.shift();
			var result:Array=[];
			var lastDir:int=0;
			var step:int=0;
			lastPt=null;
			nSize=path.length;
			for (var j:int=0; j < nSize; )
			{
				pt=path[j];
				if (j == nSize - 1)
				{
					result.push(pt);
					break;
				}
				dir=dirMap[j];
				var nextDir:int=dirMap[j + 1];
				if (dir == nextDir)
				{
					result.push(path[j + 1]);
					j+=2;
				}
				else
				{
					result.push(pt);
					++j
				}
			}
			return result;
		}

		public function CMoveServerReq(p:PacketSCMoveServerReq2):void
		{
			//
			//
			if (0 == p.flag)
			{
				var len:int=p.arrItemway_point.length;
				var newpath:Array=[];
				for (var i:int=0; i < len; i++)
				{
					newpath.push(new Point(p.arrItemway_point[i].point_x, p.arrItemway_point[i].point_y));
				}
				(Data.myKing.king as GameLocalHuman).moveByPath(newpath);
					//
			}
			else
			{
				var po:WorldPoint=new WorldPoint(p.arrItemway_point[0].point_x, p.arrItemway_point[0].point_y, p.arrItemway_point[0].point_x, p.arrItemway_point[0].point_y);
				moveTo(po);
			}
		}

		public function CPlayerMoveStop(p:PacketSCMoveStop2):void
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(p.aid);
			if (null == k)
			{
				return;
			}
			//var p1:Point = new Point(GameKing.x,GameKing.y);
			//var p2:Point = new Point(p.stop_point.point_x,p.stop_point.point_y);
			//if(Point.distance(p1,p2) > 0)
			if (k.x != p.stop_point.point_x || k.y != p.stop_point.point_y)
			{
				var newpath:Point=new Point(p.stop_point.point_x, p.stop_point.point_y);
				//targetWay
				if (k.isMe)
				{
					//直接停就行
					k.setKingMoveStop(true);
					//
					var nowpath:Point=new Point(k.x, k.y);
					//
					if (Point.distance(nowpath, newpath) >= (windage + windage_half + windage_half_half))
					{
						MyWay.way=[[k.x, k.y], [p.stop_point.point_x, p.stop_point.point_y]];
					}
					else
					{
						MyWay.way=[[k.x, k.y], [k.x, k.y]];
					}
				}
				else
				{
					// 设置人物新移动路径，最终将移动到指定的点
					k.setKingMoveTarget(newpath);
				}
			}
			else
			{
				if (k.isMe)
				{
					k.setKingMoveStop(true);
					MyWay.isJump_=0;
				}
				else
				{
					k.setKingMoveStop(true);
				}
				//修正方向
				//怪物不修正方向
				if (k.name2.indexOf(BeingType.HUMAN) >= 0)
				{
					var fx:String=MapCl.getWASD(p.adirect);
					k.roleFX=fx;
				}
			} //end if
			//记录服务器发的最后一个stop坐标
			k.setLastServerMoveStop(p.stop_point.point_x, p.stop_point.point_y);
			//
			if (MsgPrint.showStopPoint)
			{
				if (k.isMe)
				{
					var se35:SkillEffect35=WorldFactory.createItem(ItemType.SKILL, SkillEffect35.SKILL_EFFECT_X) as SkillEffect35;
					var ti:TargetInfo=TargetInfo.getInstance().getItem(k.objid, k.sex, k.mapx, k.mapy, 100, 100, 100, 100, 0, p.stop_point.point_x, p.stop_point.point_y, 100, 100, 100, 100, 0);
					se35.setData(0, ti);
					SkillEffectManager.instance.send(se35);
				}
			}
		}
		private static var lastTime:int=-1;

		// 得到行走路径
		//public static function CPlayerPath(e : DispatchEvent) : void {+
		public function CPlayerPath(p:PacketSCPlayerMove2):void
		{
			if (0 == p.tag)
			{
				//可以走，具体走路是别外一条消息控制
			}
			else
			{
				Lang.showMsg(Lang.getServerMsg(p.tag));
			}
		}

		public static function FindPathToMap(m_po:WorldPoint):void
		{
			// TODO Auto Generated method stub
			moveTo(m_po);
		}
	}
}
