package scene.action
{
	import com.bellaxu.data.GameData;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.PacketSCFight2;
	import netc.packets2.PacketSCFightDamage2;
	import netc.packets2.PacketSCFightInstant2;
	import netc.packets2.PacketSCFightTarget2;
	import netc.packets2.PacketSCMonsterDetail2;
	import netc.packets2.PacketSCMonsterEnterGrid2;
	import netc.packets2.PacketSCMove2;
	import netc.packets2.PacketSCObjDetail2;
	import netc.packets2.PacketSCObjLeaveGrid2;
	import netc.packets2.PacketSCObjTeleport2;
	import netc.packets2.PacketSCPlayerDetail2;
	import netc.packets2.PacketSCPlayerEnterGrid2;
	import netc.packets2.StructMonsterInfo2;
	import netc.packets2.StructPlayerInfo2;
	import netc.packets2.StructTargetList2;
	import netc.packets2.StructWayPoint2;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffectManager;
	import scene.utils.MyWay;
	
	import world.WorldFactory;
	import world.type.BeingType;

	public class StoryAction
	{
		public function StoryAction()
		{
		}

		/**
		 * 创建NPC，怪物
		 *
		 * playername指主人的名字
		 *
		 * @param isnpc
		 * @param monstername
		 * @param title
		 * @param templateid
		 * @param playername
		 * @param playerid
		 * @param direct
		 * @param camp
		 * @param mapid
		 * @param mapzonetype
		 * @param mapx
		 * @param mapy
		 * @param maptox
		 * @param maptoy
		 * @param hp
		 * @param maxhp
		 * @param mp
		 * @param maxmp
		 * @param level
		 * @param grade
		 * @param movspeed
		 * @param atkspeed
		 * @param buffeffect
		 * @return                 返回 objectID
		 *
		 */
		public function CreateMonster(isnpc:int=1,

			monstername:String="", title:String="",

			templateid:int=-1, mapx:int=-1, mapy:int=-1, maptox:int=-1, maptoy:int=-1,

			direct:int=45, playername:String="", playerid:int=0,


			camp:int=10,

			mapid:int=-1, mapzonetype:int=-1,



			hp:int=100, maxhp:int=100, mp:int=0, maxmp:int=0, level:int=36, grade:int=0, movspeed:int=150, atkspeed:int=100, buffeffect:int=0):Array
		{
			if (-1 == templateid)
			{
				templateid=30100158;
			}

			if (-1 == mapid)
			{
				mapid=SceneManager.instance.currentMapId;
			}

			if (-1 == mapzonetype)
			{
				mapzonetype=Data.myKing.MapZoneType;
			}

			if (-1 == mapx)
			{
				mapx=Data.myKing.mapx;
			}

			if (-1 == mapy)
			{
				mapy=Data.myKing.mapy;
			}

			if (-1 == maptox)
			{
				maptox=Data.myKing.mapx;
			}

			if (-1 == maptoy)
			{
				maptoy=Data.myKing.mapy;
			}

			var monsterInfo:StructMonsterInfo2=new StructMonsterInfo2();

			//
			monsterInfo.objid=WorldFactory.createObjid();

			monsterInfo.name=monstername;
			monsterInfo.playername=playername;
			monsterInfo.playerid=playerid;
			monsterInfo.title=title;
			monsterInfo.mapid=mapid;
			monsterInfo.mapx=mapx;
			monsterInfo.mapy=mapy;
			monsterInfo.maptox=maptox;
			monsterInfo.maptoy=maptoy;
			monsterInfo.direct=direct;
			monsterInfo.hp=hp;
			monsterInfo.maxhp=maxhp;
			monsterInfo.level=level;
			monsterInfo.mp=mp;
			monsterInfo.maxmp=maxmp;
			monsterInfo.isnpc=isnpc;
			monsterInfo.camp=camp;
			monsterInfo.grade=grade;
			monsterInfo.movspeed=movspeed;
			monsterInfo.atkspeed=atkspeed;
			monsterInfo.buffeffect=buffeffect;
			monsterInfo.templateid=templateid;
			monsterInfo.mapzonetype=mapzonetype;

			//
			var simulate_monster:PacketSCMonsterEnterGrid2=new PacketSCMonsterEnterGrid2();
			simulate_monster.monsterinfo=monsterInfo;



			return [monsterInfo.objid, simulate_monster];

		}

		/**
		 * 创建玩家
		 */
		public function CreatePlayer(rolename:String,

			sex:int=1, metier:int=1, direct:int=45, camp:int=-1,

			icon:int=-1,

			s0:int=0, s1:int=0, s2:int=-1, s3:int=0,

			mapid:int=-1, mapzonetype:int=-1,

			mapx:int=-1, mapy:int=-1, maptox:int=-1, maptoy:int=-1,

			hp:int=1000, maxhp:int=1000, level:int=-1,

			movspeed:int=175, atkspeed:int=100, buffeffect:int=0, teamid:int=0, teamleader:int=0, exercise:int=0, pkmode:int=0, Title:int=0, vip:int=0):uint
		{
			if (-1 == level)
			{
				level=36
			}

			if (-1 == icon)
			{
				icon=10001;
			}

			if (-1 == s2)
			{
				s2=20102;
			}

			if (-1 == camp)
			{
				camp=10;
			}

			if (-1 == mapid)
			{
				mapid=SceneManager.instance.currentMapId;
			}

			if (-1 == mapzonetype)
			{
				mapzonetype=Data.myKing.MapZoneType;
			}

			if (-1 == mapx)
			{
				mapx=Data.myKing.mapx;
			}

			if (-1 == mapy)
			{
				mapy=Data.myKing.mapy;
			}

			if (-1 == maptox)
			{
				maptox=Data.myKing.mapx;
			}

			if (-1 == maptoy)
			{
				maptoy=Data.myKing.mapy;
			}

			var playerInfo:StructPlayerInfo2=new StructPlayerInfo2();

			//
			playerInfo.roleID=WorldFactory.createObjid();
			playerInfo.rolename=rolename;
			playerInfo.mapid=mapid;
			playerInfo.mapx=mapx;
			playerInfo.mapy=mapy;
			playerInfo.maptox=maptox;
			playerInfo.maptoy=maptoy;
			playerInfo.direct=direct;
			playerInfo.metier=metier;
			playerInfo.sex=sex;
			playerInfo.level=level;
			playerInfo.icon=icon;
			playerInfo.hp=hp;
			playerInfo.maxhp=maxhp;
			playerInfo.s0=s0;
			playerInfo.s1=s1;
			playerInfo.s2=s2;
			playerInfo.s3=s3;
			playerInfo.camp=camp;
			playerInfo.movspeed=movspeed;
			playerInfo.atkspeed=atkspeed;
			playerInfo.buffeffect=buffeffect;
			playerInfo.teamid=teamid;
			playerInfo.teamleader=teamleader;
			playerInfo.exercise=exercise;
			playerInfo.pkmode=pkmode;
			playerInfo.mapzonetype=mapzonetype;
			playerInfo.Title=Title;
			playerInfo.vip=vip;

			//
			var simulate_player:PacketSCPlayerEnterGrid2=new PacketSCPlayerEnterGrid2();
			simulate_player.playerinfo=playerInfo;

			//
			DataKey.instance.receive(simulate_player);

			return playerInfo.roleID;
		}

		public function DeleteObj(objid:int):void
		{
			var simulate_leave:PacketSCObjLeaveGrid2=new PacketSCObjLeaveGrid2();

			simulate_leave.objid=objid;

			//
			DataKey.instance.receive(simulate_leave);

		}

		/**
		 * 传送
		 */
		public function TeleportBeing(objid:int, end_point:Point):Array
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(objid);

			if (null == k)
			{
				return [false, "can not find objid: " + objid.toString()];
			}

			var simulate_tel:PacketSCObjTeleport2=new PacketSCObjTeleport2();

			simulate_tel.objid=objid;
			simulate_tel.posx=end_point.x;
			simulate_tel.posy=end_point.y;
			simulate_tel.seekid=0;
			simulate_tel.skillid=0;

			//
			DataKey.instance.receive(simulate_tel);

			return [true, ""];
		}

		private function MoveBeing_Sub_Me(start_point:Point, end_point:Point):void
		{
			MyWay.way = [
							[start_point.x,start_point.y],
							[end_point.x,end_point.y]
						];		
		}
		
		/**
		 * 移动
		*/
		public function MoveBeing(objid:int, start_point:Point, end_point:Point):Array
		{
			var k:IGameKing=SceneManager.instance.GetKing_Core(objid);

			if (null == k)
			{
				return [false, "can not find objid: " + objid.toString()];
			}

			if(k.isMe){
				
				setTimeout(MoveBeing_Sub_Me,200,start_point,end_point);

			}else{	
			//
			var simulate_move:PacketSCMove2=PacketSCMove2.getInstance().getItem;
			simulate_move.aid=objid;


			//
			simulate_move.cur_point=StructWayPoint2.getInstance().getItem;
			simulate_move.cur_point.point_x=start_point.x;
			simulate_move.cur_point.point_y=start_point.y;

			//
			simulate_move.way_point=StructWayPoint2.getInstance().getItem;
			simulate_move.way_point.point_x=end_point.x;
			simulate_move.way_point.point_y=end_point.y;

			//
			DataKey.instance.receive(simulate_move);
			}
			//PacketSCMoveStop2

			var timeOutSec:int=Point.distance(start_point, end_point) / (k.speed * GameData.curFps);
			var timeOut:int=timeOutSec * 1000;

			return [true, timeOut];
		}

		/**
		 * 发技能
		 */
		public function SkillBeing(srcA_objid:int, skill_id:int, targetB_objid:int=0, targetB_Die:Boolean=true):Array
		{
			var srcKingA:IGameKing=SceneManager.instance.GetKing_Core(srcA_objid);

			if (null == srcKingA)
			{
				return [false, "can not find srcA_objid: " + srcA_objid.toString()];
			}


			var tagetKingB:IGameKing=SceneManager.instance.GetKing_Core(targetB_objid);

			/*
			允许tagetKingB为空，自身技能，或无目标技能

			if(null == tagetKingB)
			{
				return [false,"can not find targetB_objid: " + targetB_objid.toString()];
			}*/

		//项目转换	var mode:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill_id.toString());
	var mode:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill_id) as Pub_SkillResModel;
			if (null == mode)
			{
				return [false, "can not find skill_id: " + skill_id.toString()];
			}

			//是０的，目标都是自身
			if (0 != mode.select_type)
			{
				//必须要有目标
				if (null == tagetKingB)
				{
					return [false, "can not find targetB_objid: " + targetB_objid.toString()];
				}
			}


			var simulate_CFight:PacketSCFight2=PacketSCFight2.getInstance().getItem;
			simulate_CFight.msg="";
			simulate_CFight.tag=0;

			var simulate_CFightInstant:PacketSCFightInstant2=PacketSCFightInstant2.getInstance().getItem;
			simulate_CFightInstant.direct=6;
			simulate_CFightInstant.level=1;
			simulate_CFightInstant.logiccount=1;
			simulate_CFightInstant.skill=skill_id;
			simulate_CFightInstant.srcid=srcA_objid;
			simulate_CFightInstant.targetid=null == tagetKingB ? 0 : targetB_objid;
			simulate_CFightInstant.targetx=null == tagetKingB ? srcKingA.mapx : tagetKingB.mapx;
			simulate_CFightInstant.targety=null == tagetKingB ? srcKingA.mapy : tagetKingB.mapy;

			var simulate_CFightDamage:PacketSCFightDamage2=new PacketSCFightDamage2();
			simulate_CFightDamage.damage=true == targetB_Die ? tagetKingB.hp : tagetKingB.hp / 2; //0;
			simulate_CFightDamage.flag=0;
			simulate_CFightDamage.logiccount=1;
			simulate_CFightDamage.srcid=srcA_objid;
			simulate_CFightDamage.targethp=true == targetB_Die ? 0 : tagetKingB.hp / 2;
			simulate_CFightDamage.targetid=null == tagetKingB ? 0 : targetB_objid;

			var simulate_CFightTarget:PacketSCFightTarget2=new PacketSCFightTarget2();
			simulate_CFightTarget.arrItemtargets=new Vector.<StructTargetList2>();
			var listItem:StructTargetList2=new StructTargetList2();
			listItem.flag=1;
			listItem.objid=srcA_objid;
			simulate_CFightTarget.arrItemtargets.push(listItem);

			simulate_CFightTarget.direct=6;
			simulate_CFightTarget.level=1;
			simulate_CFightTarget.logiccount=1;
			simulate_CFightTarget.skill=skill_id;
			simulate_CFightTarget.targetid=null == tagetKingB ? 0 : targetB_objid;
			simulate_CFightTarget.targetx=null == tagetKingB ? srcKingA.mapx : tagetKingB.mapx;
			simulate_CFightTarget.targety=null == tagetKingB ? srcKingA.mapy : tagetKingB.mapy;

			//血量
			var simulate_monsterDetail:PacketSCMonsterDetail2;
			var simulate_playerDetail:PacketSCPlayerDetail2;

			var simulate_monsterObjDetail:PacketSCObjDetail2;
			var simulate_playerObjDetail:PacketSCObjDetail2;

			if (null != tagetKingB)
			{
				//
				if (tagetKingB.name2.indexOf(BeingType.MONSTER) >= 0)
				{
					simulate_monsterDetail=new PacketSCMonsterDetail2();
					simulate_monsterObjDetail=new PacketSCObjDetail2();

					simulate_monsterDetail.objid=tagetKingB.objid;
					simulate_monsterObjDetail.objid=tagetKingB.objid;

					simulate_monsterDetail.flags=-1;
					simulate_monsterDetail.level=-1;
					simulate_monsterDetail.name=null;
					simulate_monsterDetail.outlook=-1;
					simulate_monsterDetail.campid=-1;

					//simulate_monsterDetail.movspeed = -1;
					//simulate_monsterDetail.hp = -1;
					//simulate_monsterDetail.maxhp = -1;

					simulate_monsterObjDetail.movspeed=-1;
					simulate_monsterObjDetail.hp=-1;
					simulate_monsterObjDetail.maxhp=-1;

					simulate_monsterDetail.isnpc=-1;

					//simulate_monsterDetail.mp = -1;
					//simulate_monsterDetail.maxmp = -1;

					simulate_monsterObjDetail.mp=-1;
					simulate_monsterObjDetail.maxmp=-1;

					//simulate_monsterDetail.buffeffect = -1;
					simulate_monsterDetail.PlayerName=null;
					simulate_monsterDetail.MapZoneType=-1;
					simulate_monsterDetail.AtkSpeed=-1;

					if (targetB_Die)
					{
						//simulate_monsterDetail.hp = 0;
						simulate_monsterObjDetail.hp=0;
					}
					else
					{
						//simulate_monsterDetail.hp = tagetKingB.hp / 2;
						simulate_monsterObjDetail.hp=tagetKingB.hp / 2;
					}

				}

				//
				if (tagetKingB.name2.indexOf(BeingType.HUMAN) >= 0)
				{
					simulate_playerDetail=new PacketSCPlayerDetail2();
					simulate_playerObjDetail=new PacketSCObjDetail2();

					simulate_playerDetail.objid=tagetKingB.objid;
					simulate_playerObjDetail.objid=tagetKingB.objid;

					simulate_playerDetail.flags=-1;
					simulate_playerDetail.level=-1;
					simulate_playerDetail.name=null;
					simulate_playerDetail.s0=-1;
					simulate_playerDetail.s1=-1;
					simulate_playerDetail.s2=-1;
					simulate_playerDetail.s3=-1;
					simulate_playerDetail.campid=-1;

					//simulate_playerDetail.movspeed = -1;
					//simulate_playerDetail.hp = -1;
					//simulate_playerDetail.maxhp = -1;
					//simulate_playerDetail.mp = -1;
					//simulate_playerDetail.maxmp = -1;

					simulate_playerObjDetail.movspeed=-1;
					simulate_playerObjDetail.hp=-1;
					simulate_playerObjDetail.maxhp=-1;
					simulate_playerObjDetail.mp=-1;
					simulate_playerObjDetail.maxmp=-1;

					simulate_playerDetail.vim=-1;
					simulate_playerDetail.maxvim=-1;

					//simulate_playerDetail.buffeffect = -1;
					simulate_playerObjDetail.buffeffect=-1;

					simulate_playerDetail.teamid=-1;
					simulate_playerDetail.teamleader=-1;
					simulate_playerDetail.exercise=-1;
					simulate_playerDetail.UnderWrite=-1;
					simulate_playerDetail.UnderWrite_p1=-1;
					simulate_playerDetail.UnderWrite_p2=-1;
					simulate_playerDetail.MapZoneType=-1;
					simulate_playerDetail.PkMode=-1;
					simulate_playerDetail.Title=-1;
					simulate_playerDetail.Vip=-1;
					simulate_playerDetail.AtkSpeed=-1;

					if (targetB_Die)
					{
						//simulate_playerDetail.hp = 0;
						simulate_playerObjDetail.hp=0;
					}
					else
					{
						//simulate_playerDetail.hp = tagetKingB.hp / 2;
						simulate_playerObjDetail.hp=tagetKingB.hp / 2;
					}

				}


			}

			//
			DataKey.instance.receive(simulate_CFight);
			DataKey.instance.receive(simulate_CFightInstant);
			DataKey.instance.receive(simulate_CFightDamage);
			DataKey.instance.receive(simulate_CFightTarget);

			if (null != simulate_monsterDetail)
			{
				setTimeout(function():void
				{
					DataKey.instance.receive(simulate_monsterDetail);
					DataKey.instance.receive(simulate_monsterObjDetail);
				}, SkillEffectManager.MOVE_TIME_MIN * 1000);
			}

			if (null != simulate_playerDetail)
			{
				setTimeout(function():void
				{
					DataKey.instance.receive(simulate_playerDetail);
					DataKey.instance.receive(simulate_playerObjDetail);
				}, SkillEffectManager.MOVE_TIME_MIN * 1000);
			}

			return [true, SkillEffectManager.MOVE_TIME_MIN * 1000]

		}





	}
}
