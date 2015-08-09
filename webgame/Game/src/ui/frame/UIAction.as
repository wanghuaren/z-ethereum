package ui.frame
{
	import common.config.EventACT;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SeekResModel;
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructSeekData2;
	
	import nets.packets.PacketCSMapSeekSend;
	import nets.packets.PacketCSRideOff;
	import nets.packets.PacketCSRideOn;
	import nets.packets.PacketSCAutoSeek;
	import nets.packets.PacketSCOpenNpcFuncList;
	import nets.packets.PacketSCOperateRes;
	import nets.packets.PacketSCOperateResCancel;
	import nets.packets.PacketSCOperateResStart;
	
	import scene.action.Action;
	import scene.action.PathAction;
	import scene.action.hangup.GamePlugIns;
	import scene.body.Body;
	import scene.event.HumanEvent;
	import scene.event.KingActionEnum;
	import scene.event.MapDataEvent;
	import scene.human.GameRes;
	import scene.king.FightSource;
	import scene.king.IGameKing;
	import scene.king.NpcInfo;
	import scene.king.ResInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.utils.MapData;
	
	import ui.base.mainStage.UI_index;
	import ui.base.npc.mission.MissionNPC;
	
	import world.WorldPoint;
	import world.type.BeingType;
	import world.type.ItemType;

	/**
	 *@author suhang
	 *@version 2011-12
	 *@界面行为控制
	 */
	public class UIAction
	{

		//寻路数组
		private static var _walkArr:Vector.<StructSeekData2>=new Vector.<StructSeekData2>();
		
		public static function get walkArr():Vector.<StructSeekData2>
		{
			return _walkArr;
		}
		
		public static function set walkArr(value:Vector.<StructSeekData2>):void
		{
			_walkArr = value;
		}
		
		//终点NPC id
//		public static var transId:int;
		private static var _transId:int;

		

		public static function get transId():int{
			return _transId;
		}
		public static function set transId(v:int):void{
			_transId=v;
		}
		//正在自动采集
		public static var caiJiID:int;
		//是否任务寻路
		public static var taskAuto:Boolean=false;

		public function UIAction()
		{
			//自动寻路
			DataKey.instance.register(PacketSCAutoSeek.id, SCAutoSeek);
			//寻路结束
			//MapData.AddEventListener(HumanEvent.OnStop, walkStop);
			Body.instance.sceneEvent.addEventListener(HumanEvent.Arrived, walkStop);
			//主角加载完成			
			Body.instance.sceneEvent.addEventListener(MapDataEvent.MyShowComplete, RefreshAndUpdate);
			//请求采集
			DataKey.instance.register(PacketSCOperateRes.id, SCOperateRes);
			//开始采集
			DataKey.instance.register(PacketSCOperateResStart.id, SCOperateResStart);
			//终止采集
			DataKey.instance.register(PacketSCOperateResCancel.id, SCOperateResCancel);
			//npc 人物  怪物 屏幕移除			
			Body.instance.sceneEvent.addEventListener(HumanEvent.RemoveThis, RemoveThis);
			//打开NPC面板
			DataKey.instance.register(PacketSCOpenNpcFuncList.id, SCOpenNpcFuncList);
		}

		//StageUtil.dispatchEvent(new DispatchEvent(EventACT.NPC,e.target));
		/**
		 * 寻路
		 */
		public function SCAutoSeek(p:IPacket):void
		{
			Body.instance.sceneKing.DelMeFightInfo(FightSource.Kb_Esc, Data.myKing.king.objid);
			Body.instance.sceneKing.DelMeTalkInfo(FightSource.Kb_Esc, Data.myKing.king.objid);
			
			//----------------------
			//0019756: 动作：“牛刀小试”杀完小鸡后人物挥着武器就走向下个npc了
			var myRoleZT:String = Data.myKing.king.roleZT;

			//
			walkArr=new Vector.<StructSeekData2>();
			var value:PacketSCAutoSeek=p as PacketSCAutoSeek;
			var curMapId:int = SceneManager.instance.currentMapId;
			if (value.seek.map_id == curMapId)
			{

			}
			else if (value.arrItemdata.length > 0)
			{
				//跨地图中间点
				walkArr=value.arrItemdata;
			}
			else if (value.arrItemdata.length == 0)
			{
				//无法跨越地图
				Lang.showMsg(Lang.getClientMsg("pub_not_auto_path"));
			}
			else
			{

			}
			//终点
			walkArr.push(value.seek);
			autoWalk();
		}

		public static function stopAutoWalk():void
		{
			transId=0;
			caiJiID=0;
		}

		private function autoWalk(changeMap:Boolean=false):void
		{

			var k:IGameKing=Data.myKing.king;

			if (null == k)
			{
				return;
			}
			
			//
//			if(changeMap)
//			{
//				if (walkArr.length == 0 && MapData.MapChangeSeekId != 0){
//					UIAction.transId=MapData.MapChangeSeekId;
//				}
//				walkStop();
//				return;
//			}
			var curMapId:int = SceneManager.instance.currentMapId;
			
			if (walkArr.length > 0 && walkArr[0].map_id == curMapId)
			{				
//					var po:WorldPoint=MapCl.getAbsoluteDistance(walkArr[0].map_x, walkArr[0].map_y,true);
					var toX:int = (walkArr[0].map_x);
					var toY:int = (walkArr[0].map_y);
					var po :WorldPoint = new WorldPoint(toX, toY, toX, toY);

					transId=walkArr[0].seek_id;

					walkArr.shift();
					
					//if (walkArr.length > 0
//					if (Point.distance(new Point(po.mapx, po.mapy), new Point(Data.myKing.king.mapx, Data.myKing.king.mapy)) > 10)
//					{
//						if (Data.myKing.s1 == 0)
//						{
							//ZuoQi.getInstance().qiCheng(1);
							
//							ZuoQi.getInstance().refresh();
//							var chuZhan:int=ZuoQi.getInstance().chuZhanHorsePos;
//
//							if (0 == chuZhan || -1 == chuZhan)
//							{
//								ZuoQi.getInstance().qiCheng(1);
//							}
//							else
//							{
//								ZuoQi.getInstance().qiCheng(chuZhan);
//							}
//						}
//					}
					
				//客户端改成自主寻路了，在执行某些特定任务时，不要干扰其移动
				if (PathAction.moveTo(po))
				{
					//自动寻路，人物头上自动寻路标识	
					Data.myKing.king.getSkin().getHeadName().setAutoPath=true;
				}
				else
				{
					walkStop();
				}
			}
			else
			{
				//2012-06-26 andy 点击{传}
				if (MapData.MapChangeSeekId != 0)
				{
					if (changeMap){
						UIAction.transId=MapData.MapChangeSeekId;
						MapData.MapChangeSeekId=0;
					}	
					//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived));
					walkStop();
				}

			}
		}

		private function walkStop(e:DispatchEvent=null):void
		{

			
			var i:int;
			var j:int;
			var len:int;
			if (transId != 0)
			{
				//是否是怪物
				var npc:IGameKing=SceneManager.instance.GetKing_Core(transId);
				if (npc == null)
				{
					//是否是npc
					var npcInfo:Vector.<NpcInfo>=Body.instance.sceneKing.npcList;

					len=npcInfo.length;

					for (i=0; i < len; i++)
					{
						if (npcInfo[i].dbid == transId)
						{
							npc=SceneManager.instance.GetKing_Core(npcInfo[i].objid);
							break;
						}
					}
				}

				if (npc == null)
				{
					//是否是采集资源
					var resList:Vector.<ResInfo>=Body.instance.sceneRes.resList;

					len=resList.length;

					for (j=0; j < len; j++)
					{
						if (resList[j].dbid == transId)
						{
							npc=SceneManager.instance.GetKing_Core(resList[j].objid);
							break;
						}
					}
					if (npc != null)
						caiJiID=transId;
				}
				if (Data.myKing.king!=null)
					Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
				if (npc != null && npc.name2.indexOf(BeingType.TRANS) >= 0)
				{
					//传送门执行语句
					if (null != Data.myKing.king)
					{
						var myPoint:Point=new Point(Data.myKing.king.mapx, Data.myKing.king.mapy);
						var transPoint:Point=new Point(npc.mapx, npc.mapy);
						
						MapCl.gridToMap(myPoint);
						MapCl.gridToMap(transPoint);

						if (Point.distance(myPoint, transPoint) < 150)//200)
						{
							//var vo:PacketCSMapSend = new PacketCSMapSend();
							//vo.sendid = npc.roleID;

							var vo:PacketCSMapSeekSend=new PacketCSMapSeekSend();
							vo.seekid=npc.roleID;
							DataKey.instance.send(vo);
							transId=0;

						}
					}

				}
				else if (npc != null && (npc.name2.indexOf(BeingType.NPC) >= 0 || npc.name2.indexOf(ItemType.PICK) >= 0))
				{
					UIActMap.instance.EventNpc(npc);
					transId = 0;
					//Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.NPC, npc));
				}
				else if (npc != null && npc.name2.indexOf(ItemType.PICK) >= 0)
				{
					if (Data.myKing.king!=null)
						Data.myKing.king.getSkin().getHeadName().setAutoPath=true;
				}
				else
				{
				//项目转换	var seek:Pub_SeekResModel = Lib.getObj(LibDef.PUB_SEEK, transId.toString());
					var seek:Pub_SeekResModel=XmlManager.localres.getPubSeekXml.getResPath(transId) as Pub_SeekResModel;
					if ((e==null || (null != e && e.type==HumanEvent.Arrived))&&seek!=null&&seek.kill==1)
//						if (null != e && e.type==HumanEvent.Arrived&&seek!=null&&npc.name2.indexOf("303") >= 0)
					{
						//					if(DataCenter.myKing.level<25){
						GamePlugIns.getInstance().start();
						//					}
						//接到24级的【如真似幻】任务，进入地图福溪村幻境(20200006)时
						//					if(DataCenter.myKing.level>=24 && 20200006 == SceneManager.instance.currentMapId)
						//					{
						//					}
						//寻路自动采集
					}
				}
			}
			else
			{
				if (Data.myKing.king!=null)
					Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
			}
		}

		private function RefreshAndUpdate(e:DispatchEvent=null):void
		{
			if (UI_index.indexMC != null && UI_index.indexMC["NPCStatus"] != null)
			{
				UI_index.indexMC["NPCStatus"].visible=false;
			}
			autoWalk(true);
		}

		/**
		 * 采集
		 */
		public static var timer_:Timer=new Timer(50);
		private static var lastTime:int;
		private static var delay_:int;
		private static var jump:int=1; //每次增加帧数

		public static function caiji(time:int, objid:int):void
		{
			if (timer_.running)
			{

			}
			else
			{
				var gameRes:GameRes=SceneManager.instance.GetKing_Core(objid) as GameRes;
				if (gameRes != null)
				{
					jinduStart(time, gameRes.intonate_desc, stopMyCaiji);
					Data.myKing.king.setKingAction(KingActionEnum.CJ);
				}
			}
		}

		/**
		 * 开始进度条  time：时间    txt：显示文字
		 */
		private static var func:Function;

		public static function jinduStart(time:int, txt:String, func_:Function=null):void
		{
			func=func_;
			if (!timer_.hasEventListener(TimerEvent.TIMER))
			{
				timer_.addEventListener(TimerEvent.TIMER, TIMER);
			}
			//UI_index.indexMC["mrb"]["jindu"]["txt"].text = txt;
			UI_index.indexMC_mrb_jindu["txt"].text=txt;

			time-=200;
			if (time <= 8000)
			{
				time=time * 5;
				jump=5;
			}
			else
			{
				jump=1;
			}
			if (time < 0)
				time=0;
			delay_=time / 100;
			//UI_index.indexMC["mrb"]["jindu"].visible = true;
			//UI_index.indexMC["mrb"]["jindu"].gotoAndStop(1);

			if (null == UI_index.indexMC_mrb_jindu.parent)
			{
				UI_index.indexMC_mrb.addChild(UI_index.indexMC_mrb_jindu);
			}

			UI_index.indexMC_mrb_jindu.gotoAndStop(1);

			//
			timer_.start();
			lastTime=getTimer();
		}

		/**
		 * 停止进度条
		 */
		public static function jinduStop():void
		{
			if (timer_.running)
				timer_.stop();
			if (timer_.hasEventListener(TimerEvent.TIMER))
				timer_.removeEventListener(TimerEvent.TIMER, TIMER);
			//UI_index.indexMC["mrb"]["jindu"].visible = false;

			if (null != UI_index.indexMC_mrb_jindu.parent)
			{
				UI_index.indexMC_mrb_jindu.parent.removeChild(UI_index.indexMC_mrb_jindu);
			}
		}

		private static function TIMER(e:TimerEvent=null):void
		{

			var frame:int;

			var nowTime:int=getTimer();
			if (nowTime - lastTime >= delay_)
			{
				lastTime+=delay_;
				if (nowTime - lastTime >= delay_)
				{
					lastTime+=delay_;
					frame=UI_index.indexMC_mrb_jindu.currentFrame;

					if (frame >= 100)
					{
						jinduStop();
						if (func != null)
						{
							func.call();
						}
					}
					else
					{
						//UI_index.indexMC["mrb"]["jindu"].gotoAndStop(frame+jump);	

						UI_index.indexMC_mrb_jindu.gotoAndStop(frame + jump);
					}
				}
			}
			else
			{
				return;
			}

			frame=UI_index.indexMC_mrb_jindu.currentFrame;

			if (frame >= 100)
			{
				jinduStop();
				if (func != null)
				{
//					if (func == stopMyCaiji)
//					{
//						stopAutoWalk();
//					}
					func.call();
				}
			}
			else
			{
				//UI_index.indexMC["mrb"]["jindu"].gotoAndStop(frame+jump);	

				UI_index.indexMC_mrb_jindu.gotoAndStop(frame + jump);
			}
		}

		private static function stopMyCaiji():void
		{
			Data.myKing.king.setKingAction(KingActionEnum.DJ);
			jinduStop();
			setTimeout(function():void
			{
				if (caiJiID != 0)
				{
					transId=caiJiID;
					Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived));
				}
			}, 500);
		}

		private function SCOperateRes(p:PacketSCOperateRes):void
		{
			if (caiJiID != 0)
			{
				if (p.tag != 0)
				{
					//tag 20 不可操作模型，
					//tag 10 无效目标
					if (20 == p.tag || 10 == p.tag)
					{
						stopAutoWalk();
						stopMyCaiji();

					}

					transId=caiJiID;
					Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(HumanEvent.Arrived));
				}
			}
			else
			{
				Lang.showResult(p);
			}
		}

		private function SCOperateResStart(p:IPacket):void
		{
			var value:PacketSCOperateResStart=p as PacketSCOperateResStart;
						if (value.userid == Data.myKing.roleID)
			{
				caiji(value.actiontime, value.objid);
			}
			else
			{
				var m_IGK:IGameKing=SceneManager.instance.GetKing_Core(value.userid);
				if (m_IGK != null)
				{
					m_IGK.setKingAction(KingActionEnum.CJ);
				}
			}
		}

		private function SCOperateResCancel(p:IPacket):void
		{
			var value:PacketSCOperateResCancel=p as PacketSCOperateResCancel;
			if (value.userid == Data.myKing.roleID)
			{
				stopMyCaiji();
			}
			else
			{
				var m_igk:IGameKing=SceneManager.instance.GetKing_Core(value.userid)
				if (m_igk != null)
				{
					m_igk.setKingAction(KingActionEnum.DJ);
				}
			}
		}

		/**
		 * npc 人物  怪物 屏幕移除
		 */
		private function RemoveThis(e:DispatchEvent=null):void
		{
			if (UI_index.indexMC["NPCStatus"].visible == true)
			{
				if (UIActMap.playerID == e.getInfo)
				{
					UI_index.indexMC["NPCStatus"].visible=false;
				}
			}
		}

		private function SCOpenNpcFuncList(p:IPacket):void
		{
			var value:PacketSCOpenNpcFuncList=p as PacketSCOpenNpcFuncList;
			MissionNPC.instance().setNpcId(value.npcid, false);
		}
		/**
		 *	 坐骑骑乘
		 */
		public static function qiCheng():void
		{
			if (PathAction.isHuSong == true)
				return;
//			if (Action.instance.yuJianFly.fly)
//				return;
//			if (Action.instance.yuBoat.boat)
//				return;
//			if (Data.myKing.king.isBoat)
//				return;
			var client:PacketCSRideOn = new PacketCSRideOn(); //上马
			client.horsepos = 1;
			DataKey.instance.send(client);
		}
		
		/**
		 *	 坐骑休息
		 */
		public static function xiuXi():void
		{
			var client:PacketCSRideOff = new PacketCSRideOff(); //下马
			DataKey.instance.send(client);
		}
	}
}
