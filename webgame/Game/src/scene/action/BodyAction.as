package scene.action
{
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.mgr.KeyboardMgr;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import common.managers.Lang;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import netc.Data;
	import netc.DataKey;

	import scene.action.hangup.GamePlugIns;
	import scene.event.KingActionEnum;
	import scene.human.GameHuman;
	import scene.human.GameMonster;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.king.Skin;
	import scene.manager.SceneManager;
	import scene.utils.MapData;

	import ui.frame.BiShaJiWin;
	import ui.frame.UIActMap;
	import ui.frame.UIAction;
	import ui.base.jineng.SkillShort;
	import ui.view.view2.booth.Booth;
	import ui.view.view3.drop.ResDrop;

	import world.WorldPoint;
	import world.cache.res.ResItem;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;

	//sh 鼠标选择屏幕上的对象
	public class BodyAction
	{
		/**
		 * 绝杀技黑屏时间
		 */
		private static var DarkScreen_Time:int=-1;

		private static function npcMouseDown(e:MouseEvent, npc:GameMonster):void
		{
			//记录鼠标信息
			if (null != e)
			{
				npc.mouseClicked=true;
			}
			//
			Action.instance.fight.ClickNpc(npc);
		}

		private static function monsterMouseDown(e:MouseEvent, monster:GameMonster):void
		{
			//记录鼠标信息
			if (null != e)
			{
				monster.mouseClicked=true;
			}
			//
			if (KingActionEnum.Dead == monster.roleZT)
			{
				//如果怪物死了，则认为点到了空地上，即clickPoint
				//鼠标外观则也会发生变化
//				ClickPoint(e);

				UIActMap.instance.EventRole(e.target as IGameKing);
//				Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.ROLE, e.target));
			}
			else
			{
				if (SkillShort.HasSkillLock == false)
				{
//					Data.myKing.king.getSkill().selectSkillId = Data.myKing.king.getSkill().basicSkillId;
					Data.myKing.king.getSkill().basicAttackEnabled=true;
					Action.instance.fight.ClickEnemy(monster);

				}
			}
		}

		public static function humanMouseDown(e:MouseEvent, human:GameHuman):void
		{
			//记录鼠标信息
			if (null != e)
			{
				human.mouseClicked=true;
			}
			//
			if (human.isMe)
			{
				Action.instance.fight.Clickme(human);
			}
			else
			{
				if(e!=null)
					Data.myKing.attackLockObjID=human.objid; //锁定怪物
				if (SkillShort.HasSkillLock == false)
				{
					//相同阵营	
					if (Action.instance.fight.chkSameCamp(Data.myKing.king, human))
					{

						Action.instance.fight.ClickSameCmap(human);

					}
					else
					{
						var withoutShiftKey:Boolean=GamePlugIns.getInstance().withoutShiftKey;
						if (e!=null&&(withoutShiftKey || KeyboardMgr.getInstance().shiftKeyIsDown()))
						{
							Data.myKing.king.getSkill().basicAttackEnabled=true;
							Action.instance.fight.ClickEnemy(human);
						}
						else
						{
							Action.instance.fight.focusKing(human);
						}
					}
				}
			} //human camp
			//
			if (human.isBooth)
			{
				Booth.getInstance().boothCheck(human.roleID);
			}
		}
		//165每秒可点6下
		//现改成167
		//170 * 6 = 1020
		//本游戏以轻松休闲为主，现改成200
		public static const pTime:int=200; //200;
		public static var curTime:int=0;
		//---------------------------------------------------------------------
		private static var _hangupTimer:Timer;

		private static function get HangupTimer():Timer
		{
			if (null == _hangupTimer)
			{
				_hangupTimer=new Timer(1000, 3);
			}
			return _hangupTimer;
		}
		private static var _autoPathTimer:Timer;

		private static function get AutoPathTimer():Timer
		{
			if (null == _autoPathTimer)
			{
				_autoPathTimer=new Timer(1000, 3);
			}
			return _autoPathTimer;
		}

		//-------------------------
		// 新增接口
		//-------------------------
		/**
		 * 检测body是否被点击
		 * @param body
		 * @return
		 *
		 */
		public static function checkBodyClick(body:IGameKing):Boolean
		{
			var roleList:Array=body.getSkin().roleList;
			var mainBody:ResMc=roleList[Skin.MAIN_DISPLAY_LAYER];
			var zojBody:ResMc=roleList[Skin.ZOJ_DISPLAY_LAYER];
			if ((mainBody && mainBody.checkMovieClick()) || (zojBody && zojBody.checkMovieClick()))
			{
				return true;
			}
			return false;
		}

		public static function indexUI_GameMap_Mouse_Down(e:MouseEvent):void
		{
			if (DataKey.instance.sleep || !Data.myKing || !Data.myKing.king)
			{
				return;
			}
			//采集点地图中断后,行走停止后还会返回采集点
			var evtTarget:Object=e.target;
//			Data.myKing.king.getSkill().basicAttackEnabled = false;	
//			if (SkillShort.getInstance() != null)
//			{
//				SkillShort.getInstance().onChooseSkill(e);
//			}
			//newcodes
			//-end
			if (Math.abs(getTimer() - curTime) < pTime)
			{
				if (!GamePlugIns.getInstance().running)
				{
					return;
				}
			}
			curTime=getTimer();
			//2012-12-19 andy 拥吻中玩家结束
			if (null != Data.myKing.king)
			{
				if (Data.myKing.king.isBooth)
				{
					return;
				}
				if (Data.myKing.king.isJump)
				{
					return;
				}
				//西游，本人不是队长
				if (Data.myKing.king.isXiYou)
				{
					if (Data.myKing.king.teamId > 0 && Data.myKing.king.objid != Data.myKing.king.teamleader)
					{
						return;
					}
				}
				if (Data.myKing.king.isGhost)
				{
					return;
				}
				if (Data.myKing.king.isStun)
				{
					return;
				}
//				if (Data.myKing.king.fightInfo.turning)
//				{
////					return;
//				}
			}
			var po:WorldPoint;
			//如果不判断点击的目标，会造成和NPC对话闪烁
//			if (evtTarget == LayerDef.mapLayer || (evtTarget)
//			{
////				if (0 == Data.myKing.Exercise)
////				{
//					GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND400, Action.instance.mapMouseDownTimer);
////				}
//
//			}
			if (null != Data.myKing.king)
			{
//				if (Data.myKing.king.fightInfo.rangeAttackEnabled)
//				{
//					po=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
//					Action.instance.fight.FA1_ATTACK(Data.myKing.king, null, po.mapx, po.mapy);
//					Data.myKing.king.fightInfo.rangeAttackEnabled=false;
//					return;
//				}
//				else
//				{
//					//MouseManager.instance.show(MouseSkinType.MouseHide);
//				}
			}
			if (evtTarget == LayerDef.mapLayer || evtTarget == LayerDef.dropLayer || evtTarget == LayerDef.bodyLayer || evtTarget == LayerDef.gridLayer)
			{
				UIAction.transId=0;
				var TipStopAutoFight:Boolean=false;
				//如果处于挂机状态要停止 - add by steven guo
				if (GamePlugIns.getInstance().running)
				{
					HangupTimer.stop();
					GamePlugIns.getInstance().stop();
					(Data.myKing.king as King).stopAction();
					return;
				}
				if (GamePlugIns.getInstance().isTaskAutoFighting())
				{
					GamePlugIns.getInstance().stopTaskAutoFight();
				}
				//
				var TipStopAutoPath:Boolean=false;
				if (null != Data.myKing.king)
				{
					//Data.myKing.king.getSkin().getHeadName().setAutoPath=false;			
					if (Data.myKing.king.getSkin().getHeadName().isAutoPath)
					{
						AutoPathTimer.stop();
						Data.myKing.king.getSkin().getHeadName().setAutoPath=false;
//						(Data.myKing.king as King).stopAction();
					}
				}

				//如果点的地面，判断地面格子是否有怪
				var target:IGameKing=SceneManager.instance.getKingInMapGridForMouseClick();
				if (!(evtTarget is ResItem))
				{
					if (target != null)
						evtTarget=target;
					else
						Data.myKing.king.getSkill().basicAttackEnabled=false;
				}
				else
				{
					Data.myKing.king.getSkill().basicAttackEnabled=false;
				}
			}
			//
			if (TipStopAutoPath)
			{
				return;
			}

			//loop use
			var i:int;
			var len:int;
			//
			//
			var human:GameHuman;
			var npc:GameMonster;
			var mon:GameMonster;
			var monster:GameMonster;

			var igk:IGameKing;
			//
			len=UIAction.walkArr.length;
			//BellaXu 修改
			if (evtTarget is ResItem)
			{
				//走路
//				ResDrop.instance.bodyLayerClick(po.x, po.y);
				var ritem:ResItem=evtTarget as ResItem;
				po=WorldPoint.getInstance().getItem(ritem.x, ritem.y, ritem.PosX, ritem.PosY);
				ResDrop.instance.currDrop=ritem;
				(Data.myKing.king as King).stopAction();
				PathAction.moveTo(po);
				return;
			}
			//		
//			if (evtTarget as Stage || "GameMap" == evtTarget.name || "GameMap_Body" == evtTarget.name)
//			{
//
//				//test							
//				//DataCenter.myKing.king.getSkin().getHeadName().showBubbleChat("xxxxxxxxxx");
//				//EarthShake();
//
//				//走路
//				po=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
//
//
//				if ("GameMap_Body" == evtTarget.name)
//				{
//					ResDrop.instance.bodyLayerClick(po.x, po.y);
//				}
//
//				//PathAction.FindPathToMap(po);
//
//				if (TipStopAutoFight || TipStopAutoPath)
//				{
//
//				}
//				else
//				{
//					
//					Action.instance.fight.ClickGround(po);
//				}
//
//			} //end if
			//
//			if ("GameMap" != evtTarget.name)
//			{
			var hasYouXianNPC:Boolean=false;
			var hasYouXianHuman:Boolean=false;

			//优先处理NPC点击
			if (evtTarget.name && evtTarget.name.indexOf(WorldType.WORLD) >= 0 && evtTarget.name2.indexOf(BeingType.NPC) == -1)
			{
				//new Point(PubData.mainUI.stage.mouseX,PubData.mainUI.stage.mouseY)
				var underPo:Point=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
				var underList:Array=LayerDef.mapLayer.getObjectsUnderPoint(underPo);
				len=underList.length;
				for (i=len - 1; i >= 0; i--)
				{
					curPn=0;
					igk=p5Npc(underList[i]);
					if (null != igk && igk.name2.indexOf(BeingType.NPC) >= 0)
					{
						npcMouseDown(e, igk as GameMonster);
						hasYouXianNPC=true;
						break;

					}

				} //end for 


				if (!hasYouXianNPC)
				{
					for (i=len - 1; i >= 0; i--)
					{
						curPn=0;
						igk=p5Npc(underList[i]);
						if (null != igk && igk.name2.indexOf(BeingType.HUMAN) >= 0 && !igk.isMe)
						{
							humanMouseDown(e, igk as GameHuman);
							hasYouXianHuman=true;
							break;
						}
					} //end for 

				}

			}
			//
			if (hasYouXianNPC || hasYouXianHuman)
			{
				//nothing
			}
			else if (evtTarget.name && evtTarget.name.indexOf(WorldType.WORLD) >= 0)
			{

				if (evtTarget.name2.indexOf(BeingType.HUMAN) >= 0)
				{
					human=evtTarget as GameHuman;
					if (!human.isQianXing)
					{
						humanMouseDown(e, human);
						//
						if (!human.isMe)
						{
							UIActMap.instance.EventRole(human);
//								Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.ROLE, human));
						}
					}
				} //human
				else if (evtTarget.name2.indexOf(BeingType.FAKE_HUM) >= 0)
				{
					human=evtTarget as GameHuman;
					Data.myKing.king.getSkill().basicAttackEnabled=true;
					Action.instance.fight.ClickEnemy(human);
				}
				else if (evtTarget.name2 && evtTarget.name2.indexOf(BeingType.MONSTER) >= 0)
				{
					//
					if (evtTarget.name2.indexOf(BeingType.NPC) >= 0)
					{
						npc=evtTarget as GameMonster;
						npcMouseDown(e, npc);
					}
					else if (evtTarget.name2 && evtTarget.name2.indexOf(BeingType.TRANS) >= 0)
					{
						//走路
						po=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
						PathAction.moveTo(po);
						//设置自动打怪ID【当自动寻路结束时，会自动攻击这个ID】
						UIAction.transId=evtTarget.roleID;
					}
					else if (evtTarget.name2 && evtTarget.name2.indexOf(BeingType.SKILL) < 0)
					{
						monster=evtTarget as GameMonster;
						//
						if (monster.selectable)
						{
							monsterMouseDown(e, monster);

						}
					}
				} //monster
				else if (evtTarget.name2 && evtTarget.name2.indexOf(ItemType.PICK) >= 0)
				{
					UIActMap.instance.EventNpc(evtTarget as IGameKing);
//						Body.instance.sceneEvent.dispatchEvent(new DispatchEvent(EventACT.NPC, evtTarget));
				}
			} //world
			else if (evtTarget is Stage)
			{
				ClickPoint(e);
			}
//			} //end if
		}

		public static function ClickPoint(e:MouseEvent):void
		{
			//如果处于挂机状态要停止 - add by steven guo
			if (GamePlugIns.getInstance().running)
				GamePlugIns.getInstance().stop();
			var po:WorldPoint;
			//认为是点到了空地上
			//走路
			po=SceneManager.instance.getIndexUI_GameMap_MouseGridPoint();
			Action.instance.fight.stopAction();
			PathAction.moveTo(po);
		}
		public static const PN:int=5;
		public static var curPn:int=0;

		public static function p5Npc(d:DisplayObject):IGameKing
		{
			var d_o_:DisplayObject=d;
			while (curPn < PN)
			{
				if (d_o_.parent != null)
				{
					d_o_=d_o_.parent;
					if (d_o_ as GameMonster)
					{
						return d_o_ as GameMonster;
					}
					else if (d_o_ as GameHuman)
					{
						return d_o_ as GameHuman;
					}
				}
				curPn++;
			}
			return null;
		}
		private static var m_dx:int=0;
		private static var m_dy:int=150;

		/**
		 * 强行移动
		 * @param b  true : 移动  ，false ： 退回
		 *
		 */
		public static function forceMoveMap(b:Boolean):void
		{
			var _list:Array=[LayerDef.gridLayer, LayerDef.bodyLayer, LayerDef.dropLayer];
			var _len:int=_list.length;
			for (var i:int=0; i < _len; i++)
			{
				var d:DisplayObject=_list[i] as DisplayObject;
				if (b)
				{
					d.x=d.x + m_dx;
					d.y=d.y + m_dy;
				}
				else
				{
					d.x=d.x - m_dx;
					d.y=d.y - m_dy;
				}
			}
		}
		private static var DarkMask:Shape=null;

		/**
		 * 地图黑屏
		 *
		 */
		public static function EarthDark():void
		{
			if (DarkScreen_Time == -1)
			{
				var arr:Array=Lang.getLabelArr("arr_profession_darkscreen_time");
				var prof:int=Data.myKing.metier;
				DarkScreen_Time=int(arr[prof]);
			}
			if (DarkMask == null)
			{
				DarkMask=new Shape();
				if (LayerDef.gridLayer.parent)
				{
					var mIndex:int=LayerDef.gridLayer.parent.getChildIndex(LayerDef.gridLayer) + 1;
					LayerDef.gridLayer.parent.addChildAt(DarkMask, mIndex);
				}
				renderDarkMask();
				setTimeout(EarthDarkOver, DarkScreen_Time);
				return;
			}
			if (DarkMask.visible)
			{
				return;
			}
			DarkMask.visible=true;
			setTimeout(EarthDarkOver, DarkScreen_Time);
		}

		/**
		 * 结束黑屏
		 *
		 */
		public static function EarthDarkOver():void
		{
			DarkMask.visible=false;
			BiShaJiWin.getInstance().winClose();
		}

		public static function renderDarkMask():void
		{
			DarkMask.graphics.clear();
			DarkMask.graphics.beginFill(0, 0.8);
			DarkMask.graphics.drawRect(0, 0, MapData.MAPW, MapData.MAPH);
			DarkMask.graphics.endFill();
		}
		/**
		 * 地面震动
		 */
		public static var shake_lock:Boolean=false;

		public static function EarthShake():void
		{
			if (shake_lock)
			{
				return;
			}
			var shakeList:Array=[LayerDef.gridLayer, LayerDef.bodyLayer, LayerDef.dropLayer];
			var len:int=shakeList.length;
			//
			shake_lock=true;
			for (var i:int=0; i < len; i++)
			{
				var d:DisplayObject=shakeList[i] as DisplayObject;
				var dx:int=d.x
				var dy:int=d.y;
				var zz:int=d.y + 50;
				d.y=zz;
				TweenLite.to(d, 0.5, {x: dx, y: dy, ease: Elastic.easeOut, onComplete: EarthShakeComplete, onCompleteParams: [d]});
			} //end for
		}

		private static function EarthShakeComplete(p:DisplayObject):void
		{
			TweenLite.killTweensOf(p, true);
			shake_lock=false;
		}
	}
}
