package ui.base.jineng
{
	import com.engine.utils.HashMap;
	
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.drag.MainDrag;
	
	import engine.event.DispatchEvent;
	import engine.event.KeyEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.MyCharacterSet;
	import netc.dataset.SkillSet;
	import netc.dataset.SkillShortSet;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructCooldown2;
	import netc.packets2.StructShortKey2;
	import netc.packets2.StructSkillItem2;
	
	import nets.packets.PacketCSCooldownList;
	import nets.packets.PacketSCCooldown;
	import nets.packets.PacketSCCooldownList;
	import nets.packets.StructBagCell;
	import nets.packets.StructSkillItem;
	
	import scene.action.Action;
	import scene.action.hangup.GamePlugIns;
	import scene.skill2.SkillEffectManager;
	
	import ui.base.beibao.BeiBao;
	import ui.base.jiaose.JiaoSe;
	import ui.base.mainStage.UI_index;
	import ui.frame.ImageUtils;


	//主界面技能快捷显示框
	public class SkillShort
	{
		public static const FUHUO_RING_COOLDOWN_ID:int=100;

		/**
		 * 技能快捷栏数量
		 */
		public static const LIMIT:int=15; //9;//15个技能，包含挂机两个
		public static const LIMIT_GUA_JI:int=17; //挂机技能上限编号
		public static const HLIMIT:int=5; //技能选择栏横向个数
		public static const HLIMIT_BIG:int=4; //技能兰横向大图标个数
		public static const OrigH:int=100; //技能选择栏背景初始高度
		public static const BG_STEP:int=42; //技能选择栏背景每增加一行纵向高度增量
		public static const OFFSET_X_UP_SKIIL_SHORT:int=-60; //技能选择框距离技能快捷栏的纵向偏移量
		public static const ITEM_HSPACE:int=4; //-4,1
		public static const ITEM_VSPACE:int=1; //-5
		public static const BG_HSPACE:int=4; //6
		public static const BG_VSPACE:int=4;
		public static const BG_X:int=13; //30,13
		public static const BG_Y:int=36; //46
		public static const ITEM_X:int=13; //17,13
		public static const ITEM_Y:int=38; //50,48

		public static const ITEM_BIG_X:int=14; //大图标X
		public static const ITEM_BIG_Y:int=40; //大图标Y
		public static const ITEM_BIG_HSPACE:int=3; //大图标之间空隙
		public static const BG_BIG_STEP:int=53; //技能选择栏背景每增加一行纵向高度增量
		public static const BG_BIG_Y:int=38; //-40
		public static const ITEM_BIG_WIDTH:int=52;
		public static const ITEM_BIG_HEIGHT:int=52;
		public static const ITEM_WIDTH:int=37;
		public static const ITEM_HEIGHT:int=38;

		private var mc:Sprite;
		public static var startPoint:Point=null; //new Point(GameIni.MAP_SIZE_W-350,250)

		//技能冷却计时器

		private static var _t:Timer=null;

		//new defines
		private static var replacePos:int=0; //默认为0，表示丢弃，非有效值
		private static var replaceId:int=0; //替换的技能或者物品ID
		private static var replaceType:int=0; //默认为技能
		private static var CanInstallItems:Array=null;
		private static var CanInstallItemsConfig:String=null;
//		private static var KeyArray:Array = ["","1","2","3","4","5","6","Q","W","E","R","T","Y"];
		public static var IconKey:HashMap=new HashMap();
		public static var StructShortKeyEvent:DispatchEvent=null;
		//技能被锁定，不能释放
		public static var HasSkillLock:Boolean=false;
		public static var isBishajiUse:Boolean=true;
		/**
		 * 技能锁定原始状态
		 */
		public static var SkillShortLockOrigState:int=-1;

		private function get T():Timer
		{
			if (null == _t)
			{
				_t=new Timer(100);
			}
			return _t;
		}
		private var lastTime:int;
		//技能公共冷却时间
		private var skillcooldown:int;
		private var skillcooldownTotal:int;
		//物品公共冷却时间
		private var itemcooldown:int;
		private var itemcooldownTotal:int;

		//需要冷却的技能
		private var skillArr:Array=new Array();

		private var key_has_up:Boolean=true;

		//自动挂机保存的技能ID
		private var autoSkillArr:Array=[];

		//默认技能id
//		private var defaultSkill:int;
		private var esoul:Number=100 / 36; //角度范围
		private var zuid:Number=-140; //初始角度

		private static var _instance:SkillShort=null;

		public static function getInstance():SkillShort
		{
			return _instance;
		}

		public function SkillShort(value:Sprite)
		{
			mc=value;
			_instance=this;
			this.initHotKeys();
			Data.skillShort.addEventListener(SkillShortSet.SKILLSHORTCHANGE, skillShortChange);
			Data.beiBao.addEventListener(BeiBaoSet.BAG_UPDATE, bagUpdate);
			if (!T.hasEventListener(TimerEvent.TIMER))
				T.addEventListener(TimerEvent.TIMER, coolingTimer);

			DataKey.instance.register(PacketSCCooldownList.id, addCooling);
			DataKey.instance.register(PacketSCCooldown.id, addCooling);
//			DataKey.instance.register(PacketSCShortKeyLock.id,shortKeyLockHandler);
			Data.myKing.addEventListener(MyCharacterSet.SHORT_KEY_LOCK_UPD, shortKeyLockHandler);
			Data.myKing.addEventListener(MyCharacterSet.PLAYER_STATE_UPD, onPlayerStateChange);
			var vo:PacketCSCooldownList=new PacketCSCooldownList();
			DataKey.instance.send(vo);

//			PubData.mainUI.stage.addEventListener(KeyEvent.KEY_DOWN, mainUI_KEY_DOWN);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN, mainUI_KEY_DOWN1);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP, mainUI_KEY_UP);
			if (null != mc["mrb"]["skillSelecter"])
				mc["mrb"]["skillSelecter"].visible=false; //技能选择界面初始化时关闭
			mc["mrb"]["mc_hotKey"].addEventListener(MouseEvent.CLICK, thisUI_MOUSE_DOWN);
			mc["mrb"]["skillSelecter"].addEventListener(MouseEvent.CLICK, onChooseSkill);
//			mc["mrb"]["mc_hotKey1"].addEventListener(MouseEvent.CLICK, thisUI_MOUSE_DOWN);

			GamePlugIns.getInstance().setSkillShort(this);

//			MainDrag.getInstance().regDrag(mc["mrb"]["mc_hotKey"]["item_hotKey5"]);
//			MainDrag.getInstance().regDrag(mc["mrb"]["mc_hotKey"]["item_hotKey6"]);
			PubData.mainUI.stage.addEventListener(MainDrag.DRAG_UP, dragUpHandler);
			PubData.mainUI.stage.addEventListener(MouseEvent.CLICK, onChooseSkill);
//			UI_index.instance.regCustomEvent(PubData.mainUI.stage,MainDrag.DRAG_UP,dragUpHandler);

			Data.skill.addEventListener(SkillSet.LIST_UPD, listUpd);
		}

		public function listUpd(e:DispatchEvent):void
		{
			if (null != StructShortKeyEvent)
			{
				//skillShortChange(StructShortKeyEvent);
				this.refresh();
			}
		}


		public function refresh(data:StructSkillItem2=null):void
		{
			var i:int=1;
			var target:*=mc["mrb"]["mc_hotKey"];
			var uiMC:MovieClip;
			for (; i < LIMIT; i++)
			{
				if (target["itjinengBox" + i] == null)
					break;
				uiMC=target["itjinengBox" + i]["item_hotKey" + i];

				if (uiMC["data"] != null)
				{

					if (uiMC["data"] is StructSkillItem2)
					{

						if (null != data)
						{
							if (StructSkillItem2(uiMC["data"]).skill_id == data.skill_id)
							{
								uiMC["data"]=data;
								break;
							}
						}
						else
						{
							uiMC["data"]=Data.skill.getSkill(

								StructSkillItem2(uiMC["data"]).skill_id

								);

						}

					}
				}




			}
		}

		/**
		 * 初始化快捷键引用
		 */
		private function initHotKeys():void
		{
			//hotkey 中下部快捷键
			var i:int=1;
			var target:*=mc["mrb"]["mc_hotKey"];
			var key:*;
			for (; i < LIMIT; i++)
			{
				if (target["itjinengBox" + i] == null)
					break;
				key=target["itjinengBox" + i]["item_hotKey" + i];
				key.mouseChildren=false;
				key["lengque"].visible=false;
				key.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				key.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
		}

		/**
		 * 重置技能快捷栏
		 */
		public function resetAllKeyState():void
		{
			var i:int=1;
			var target:*=mc["mrb"]["mc_hotKey"];
			var key:*;
			for (; i < LIMIT; i++)
			{
				if (target["itjinengBox" + i] == null)
					break;
				key=target["itjinengBox" + i]["item_hotKey" + i];
				if (key["data"] != null)
				{
					if (key["overState"].currentFrame != 1)
						key["overState"].gotoAndStop(1);
				}
				else
				{
					key["overState"].gotoAndStop(1);
				}
			}
		}

		private function onMouseOver(e:MouseEvent):void
		{
			if (Data.myKing.ShortKeyLock == 1)
				return;
			var key:Object=e.target;
			if (key["data"] == null)
			{
				key["overState"].gotoAndStop(2);
			}
			else
			{
				key["overState"].gotoAndStop(3);
			}
		}

		private function onMouseOut(e:MouseEvent):void
		{
//			if (Data.myKing.ShortKeyLock==1) {
//				return;
//			}
			var key:Object=e.target;
			if (key["data"] != null)
			{
				if (key["overState"].currentFrame != 1)
					key["overState"].gotoAndStop(1);
			}
			else
			{
				key["overState"].gotoAndStop(1);
			}
		}

		//技能数据变化
		private function skillShortChange(e:DispatchEvent):void
		{
			var vec:Vector.<StructShortKey2>=e.getInfo as Vector.<StructShortKey2>;
			StructShortKeyEvent=e;
			var uilMC:MovieClip;
			var len:int=vec.length;
			var lock:int=Data.myKing.ShortKeyLock;

			for (var i:int=0; i < len; i++)
			{
				var pos:int=vec[i].pos;
				if (pos == 13 || pos == 14)
					continue;
				if ((pos > 0 && pos < LIMIT))
				{

					if (!vec[i].del && vec[i].id != 0)
					{
						uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
						uilMC["uil"].unload();
						IconKey.put(pos, vec[i].id);
						if (1 == vec[i].type)
						{
//							uilMC["mcBiShaEffect"].gotoAndStop(1);
							//药
							var bag:StructBagCell2=new StructBagCell2();
							bag.itemid=vec[i].id;
							bag.num=Data.beiBao.getBeiBaoCountById(vec[i].id);
							Data.beiBao.fillCahceData(bag);
//							uilMC["uil"].source=bag.icon;
							ImageUtils.replaceImage(uilMC, uilMC["uil"], bag.icon);
							uilMC["txt_num"].text=bag.num;
							uilMC.data=bag;
							if (bag.num == 0)
							{
//								StringUtils.setUnEnable(uilMC, true);
							}
							else
							{
								StringUtils.setEnable(uilMC);
							}
							CtrlFactory.getUIShow().addTip(uilMC);
							if (lock == false)
								MainDrag.getInstance().regDrag(uilMC);
						}
						else
						{
							//技能
							var prof:int=Data.myKing.metier;
							//uilMC["uil"].source=FileManager.instance.getSkillIconSById(vec[i].id);
//							uilMC["uil"].source=vec[i].icon;
							ImageUtils.replaceImage(uilMC, uilMC["uil"], vec[i].icon);
							uilMC["txt_num"].text="";
							uilMC.data=Data.skill.getSkill(vec[i].id);
//							if (vec[i].id==biShaJiSkillId){
//								uilMC["mcBiShaEffect"].gotoAndStop(2);
//							}else{
//								uilMC["mcBiShaEffect"].gotoAndStop(1);
//							}
							//2012-10-25 andy 技能飘动效果n
							//当新手指引装备技能时执行飞行
							if (uilMC["overState"].currentFrame != 1)
								uilMC["overState"].gotoAndStop(1);
							if (null != Data.myKing.king)
								SkillEffectManager.instance.preLoad(vec[i].id, Data.myKing.king.sex);
						}
						//技能栏悬浮
						CtrlFactory.getUIShow().addTip(uilMC);

						if (lock == false)
							MainDrag.getInstance().regDrag(uilMC);
					}
					else
					{
						IconKey.remove(pos);
						vec[i].isNew=false;
						uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
//						uilMC["uil"].unload();
						ImageUtils.cleanImage(uilMC);
						uilMC.data=null;
						uilMC["txt_num"].text="";
						//uilMC["mcBiShaEffect"].gotoAndStop(1);
						CtrlFactory.getUIShow().removeTip(uilMC);
						MainDrag.getInstance().unregDrag(uilMC);
					}
					uilMC["lengque"].visible=false;
					uilMC["shijian"].text="";
				}
				else if (pos >= LIMIT && pos < LIMIT_GUA_JI)
				{
					if (!vec[i].del && vec[i].id != 0)
					{
						if (1 != vec[i].type)
						{
							autoSkillArr[pos]=Data.skill.getSkill(vec[i].id);
						}
					}
					else
					{
						autoSkillArr[pos]=null;
					}
				}
			}

		}


		/**
		 *	背包物品有变化,同步更新快捷栏上的道具
		 */
		private function bagUpdate(e:DispatchEvent):void
		{
			var uilMC:MovieClip;
			for (var i:int=1; i < LIMIT; i++)
			{
				if (mc["mrb"]["mc_hotKey"]["itjinengBox" + i] == null)
					break;
				uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + i]["item_hotKey" + i];
				if (uilMC.data != null && uilMC.data is StructBagCell2)
				{
					uilMC["txt_num"].text=Data.beiBao.getBeiBaoCountById((uilMC.data as StructBagCell2).itemid);
					if (uilMC["txt_num"].text == 0)
					{
//						StringUtils.setUnEnable(uilMC,true);
					}
					else
					{
						StringUtils.setEnable(uilMC);
					}
				}
			}
		}

		//技能冷却时间变化
		private function addCooling(p:IPacket):void
		{
			var value:Object;
			if (p is PacketSCCooldownList)
			{
				value=p as PacketSCCooldownList;
				var len:int=value.arrItemlist.length;
				for (var i:int=0; i < len; i++)
				{
//					value.arrItemlist[i].cooldown.needtime = int(value.arrItemlist[i].cooldown.needtime - 300);
					skillArr.push(value.arrItemlist[i]);
				}
			}
			else
			{
				value=p as PacketSCCooldown;
				if (value.cooldown.needtime == 0)
					value.cooldown.needtime=value.skillcooldown;
//				value.cooldown.needtime = int(value.cooldown.needtime - 300);
				skillArr.push(value.cooldown);
			}

			if (!T.running)
			{
				lastTime=getTimer();
				T.start();
			}
			skillcooldownTotal=skillcooldown=value.skillcooldown;
			itemcooldownTotal=itemcooldown=value.itemcooldown;
		}

		//半秒刷新处理

		private function coolingTimer(e:TimerEvent):void
		{
			var lock:Boolean=Data.myKing.ShortKeyLock == 1;
			if (skillArr.length == 0)
			{
				T.stop();
			}
			else
			{
				var uilMC:MovieClip;
				var j:int;
				//公共技能转圈
				var currentF:int=0;
				//技能公共CD
				if (skillcooldown >= 0)
				{
					skillcooldown-=100;
					if (skillcooldown > 0)
					{
						currentF=int((skillcooldownTotal - skillcooldown) / skillcooldownTotal * 36);
						//1.2.3.4.5.6第一排技能栏，7,8,9,10,11,12第二排技能栏
						for (j=1; j < LIMIT; j++)
						{
							if (mc["mrb"]["mc_hotKey"]["itjinengBox" + j] == null)
								break;
							uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + j]["item_hotKey" + j];
							if (uilMC.data != null && uilMC.data is StructSkillItem)
							{
								uilMC["lengque"].visible=true;
								uilMC["lengque"].gotoAndStop(currentF);
							}
						}
					}
					else
					{
						for (j=1; j < LIMIT; j++)
						{
							if (mc["mrb"]["mc_hotKey"]["itjinengBox" + j] == null)
								break;
							uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + j]["item_hotKey" + j];
							if (uilMC.data != null && uilMC.data is StructSkillItem)
							{
								uilMC["lengque"].visible=false;
							}
						}
					}
				}
				//道具公共CD
				if (itemcooldown >= 0)
				{
					itemcooldown-=100;
					currentF=int((itemcooldownTotal - itemcooldown) * 36 / itemcooldownTotal);
					if (itemcooldown >= 0)
					{
						for (j=1; j < LIMIT; j++)
						{
							if (mc["mrb"]["mc_hotKey"]["itjinengBox" + j] == null)
								break;
							uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + j]["item_hotKey" + j];
							if (uilMC.data != null && uilMC.data is StructBagCell)
							{
								uilMC["lengque"].visible=true;
								uilMC["lengque"].gotoAndStop(currentF);
							}
						}
					}
					else
					{
						for (j=1; j < LIMIT; j++)
						{
							if (mc["mrb"]["mc_hotKey"]["itjinengBox" + j] == null)
								break;
							uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + j]["item_hotKey" + j];
							if (uilMC.data != null && uilMC.data is StructBagCell)
							{
								uilMC["lengque"].visible=false;
							}
						}
					}
				}
				//主动技能转圈
				for (var i:int=skillArr.length - 1; i >= 0; i--)
				{
					skillArr[i].elapsed+=100;
					var skillNeedTime:int=1;
					//默认不需要CD时间
					//					if (skillArr[i].needtime>0){
					skillNeedTime=skillArr[i].needtime > skillcooldownTotal ? skillArr[i].needtime : skillcooldownTotal;
					//					}

					//					var fn:Number=(36 * skillArr[i].elapsed) / skillNeedTime;
					var frame:int=(36 * skillArr[i].elapsed) / skillNeedTime;
					var k:int;
					BeiBao.showCD(skillArr[i].id, frame);
					JiaoSe.showCD(skillArr[i].id, frame);
					if (frame >= 36)
					{
						for (k=1; k < LIMIT; k++)
						{
							if (mc["mrb"]["mc_hotKey"]["itjinengBox" + k] == null)
								break;
							uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + k]["item_hotKey" + k];
							if (uilMC.data == null || (uilMC.data is StructSkillItem2 && skillArr[i].id == StructSkillItem2(uilMC.data).skillModel.cooldown_id) || (uilMC.data is StructBagCell2 && skillArr[i].id == StructBagCell2(uilMC.data).cooldown_id))
							{
								uilMC["lengque"].visible=false;
								uilMC["shijian"].text="";
							}
						}

						//------------ 复活戒指 begin ------------------
						if (null != UI_index.indexMC_character['mc_fuhuo_ring'])
						{
							uilMC=UI_index.indexMC_character['mc_fuhuo_ring'];
							if (skillArr[i].id == FUHUO_RING_COOLDOWN_ID)
							{
								uilMC["shijian"].htmlText="";
								uilMC.visible=false;
							}
						}
						//------------ 复活戒指 end ------------------

						skillArr.splice(i, 1);
					}
					else
					{
						for (k=1; k < LIMIT; k++)
						{
							if (mc["mrb"]["mc_hotKey"]["itjinengBox" + k] == null)
								break;
							uilMC=mc["mrb"]["mc_hotKey"]["itjinengBox" + k]["item_hotKey" + k];
							if (uilMC.data != null && ((uilMC.data is StructSkillItem2 && skillArr[i].id == StructSkillItem2(uilMC.data).skillModel.cooldown_id) || (uilMC.data is StructBagCell2 && skillArr[i].id == StructBagCell2(uilMC.data).cooldown_id)))
							{
								uilMC["lengque"].visible=true;
								uilMC["lengque"].gotoAndStop(frame);
								//时间去掉
								uilMC["shijian"].text="";
									//uilMC["shijian"].text=getskillcolltime(skillArr[i].needtime - skillArr[i].elapsed);
							}
						}
						//------------ 复活戒指 begin ------------------
						if (null != UI_index.indexMC_character['mc_fuhuo_ring'])
						{
							uilMC=UI_index.indexMC_character['mc_fuhuo_ring'];
							if (skillArr[i].id == FUHUO_RING_COOLDOWN_ID)
							{
								uilMC["shijian"].htmlText="<b>" + getskillcolltime2(skillArr[i].needtime - skillArr[i].elapsed) + "</b>";
								uilMC.visible=true;
							}
						}
							//------------ 复活戒指 end ------------------
					}
				}

				if (skillArr.length == 0)
				{
					T.stop();
				}
			}
		}


		private function getskillcolltime(value:int):String
		{
			//如下图，应该是15秒，但是使用技能后，冷却特效上显示的少了一秒，最后又多显示了一个0秒
			//预期：从正确的冷却时间开始倒计时，最后不显示0秒
			value+=100; //补偿CD时间
			var cdTime:Number=value / 1000;
			if (cdTime >= 1)
			{
				cdTime=Math.round(cdTime);
			}
			else
			{
//				value = Math.round(value / 100);
//				cdTime = value/10;
				cdTime=1;
			}
//			value++;
			return cdTime + Lang.getLabel("pub_miao");

		/*value=value / 1000;
		var fen:int=value / 60;
		if (fen > 0)
		{
			return fen + Lang.getLabel("pub_fen");
		}
		else
		{
			value=value % 60 + 1;
			return value + Lang.getLabel("pub_miao");
		}*/
		}









		private function getskillcolltime2(value:int):String
		{
			//如下图，应该是15秒，但是使用技能后，冷却特效上显示的少了一秒，最后又多显示了一个0秒
			//预期：从正确的冷却时间开始倒计时，最后不显示0秒
			value+=100; //补偿CD时间


			//value=value / 1000;


			return StringUtils.getStringJianhuaTime(value);

		}








		public static var isSkillkeydown:Boolean=false;

		private function mainUI_KEY_DOWN1(e:KeyboardEvent):void
		{
//			if (e.altKey==false) {
//				return;
//			}
			if (PubData.mainUI.stage.focus is TextField)
			{
				return;
			}
			var cKey:String="key_" + e.keyCode;
			var pos:int=0;
			switch (cKey)
			{
				case KeyEvent.KEY_1:
					pos=1;
					break;
				case KeyEvent.KEY_2:
					pos=2;
					break;
				case KeyEvent.KEY_3:
					pos=3;
					break;
				case KeyEvent.KEY_4:
					pos=4;
					break;
				case KeyEvent.KEY_5:
					pos=5;
					break;
				case KeyEvent.KEY_6:
					pos=6;
					break;
				case KeyEvent.KEY_Q:
					pos=7;
					break;
				case KeyEvent.KEY_W:
					pos=8;
					break;
				case KeyEvent.KEY_E:
					pos=9;
					break;
				case KeyEvent.KEY_A:
					pos=10;
					break;
				case KeyEvent.KEY_S:
					pos=11;
					break;
				case KeyEvent.KEY_D:
					pos=12;
					break;
			}
			if (pos != 0 && key_has_up)
			{
				mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["shanguang" + pos].gotoAndPlay(1);

				mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos].y=12;

				flash.utils.setTimeout(

					function():void
					{
						mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos].y=8;
					}, 90);

//				SkillShort.isSkillkeydown=true;
				clickSkill(pos, true);
//				SkillShort.isSkillkeydown=false;
			}
			key_has_up=false;
		}

		private function mainUI_KEY_UP(e:KeyboardEvent):void
		{
			key_has_up=true;
		}

		private function thisUI_MOUSE_DOWN(e:MouseEvent):void
		{
			if (e.target.name.indexOf("item_hotKey") == 0)
			{
				var lock:int=Data.myKing.ShortKeyLock;
				var pos:int=int(e.target.name.replace("item_hotKey", ""));
				if (lock)
				{
					clickSkill(pos);
				}
				else
				{ //点击弹出技能选择界面
					this.resetAllHotKeyStates();
					replacePos=pos;
					var uilMC:MovieClip=mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
					uilMC["mc_selected"].gotoAndStop(2);
					replaceId=-1;
					if (uilMC.data != null)
					{
						if (uilMC.data is StructSkillItem2)
						{
							replaceId=StructSkillItem2(uilMC.data).skill_id;
							replaceType=0;
						}
						else
						{
							replaceId=StructBagCell2(uilMC.data).itemid;
							replaceType=1;
						}
					}
					this.renderSkillShortDataProvider();
				}
			}
		}

		private function resetAllHotKeyStates():void
		{
			var i:int=1;
			var target:*=mc["mrb"]["mc_hotKey"];
			var key:*;
			for (; i < LIMIT; i++)
			{
				if (target["itjinengBox" + i] == null)
					break;
				key=target["itjinengBox" + i]["item_hotKey" + i];
				if (key["mc_selected"] != null)
					key["mc_selected"].gotoAndStop(1);
			}
		}

		/**
		 * 从技能选择框里选择技能或者物品替换快捷栏指定位置
		 * @param e
		 *
		 */
		public function onChooseSkill(e:MouseEvent):void
		{
			if (mc["mrb"]["skillSelecter"].visible)
			{
				if (e.target.parent.parent == mc["mrb"]["mc_hotKey"] && e.target.name.indexOf("item_hotKey") == 0)
					return;
				mc["mrb"]["skillSelecter"].visible=false;
				this.resetAllHotKeyStates();
			}
			else
			{
				return;
			}
			if (e.target.name == "btnRemove")
			{
				uninstall(replacePos);
				return;
			}
			var skillIcon:Sprite=null;
			if (e.target.name.indexOf("skill_SkillShort_") == 0)
			{
				var sIndex:int=int(e.target.name.replace("skill_SkillShort_", ""));
				skillIcon=this.skillIconCache[sIndex];
				if (skillIcon["data"] != null)
				{
					installSkill(replacePos, StructSkillItem2(skillIcon["data"]).skill_id);
				}
			}
			else if (e.target.name.indexOf("item_SkillShort_") == 0)
			{
				var iIndex:int=int(e.target.name.replace("item_SkillShort_", ""));
				skillIcon=this.itemIconCache[iIndex];
				if (skillIcon["data"] != null)
				{
					installItem(replacePos, StructBagCell2(skillIcon["data"]).itemid);
				}
			}
		}

		//点击一个技能
		private function clickSkill(pos:int, key:Boolean=false):void
		{
			var uilMC:MovieClip=mc["mrb"]["mc_hotKey"]["itjinengBox" + pos]["item_hotKey" + pos];
			if (uilMC.data != null)
			{
				Action.instance.fight.KeyDownJiNengLan(uilMC.data);
			}
			else
			{
				//TODO 打开技能栏选择框
			}
		}


		/**
		 * 获得自动释放技能的ID
		 *
		 */
		private static const m_cPos:int=15;

		/**
		 * 需要修改
		 * @return
		 *
		 */
		public function getAutoFightSkillID(skillPos:int):int
		{
			if (skillPos > 0)
			{
				var _ret:int=-1;
				var targetSkillId:int;
				if (this.autoSkillArr[skillPos] == null)
				{
					skillPos=skillPos == 15 ? 16 : 15;
				}
				if (this.autoSkillArr[skillPos] != null)
				{
					if (!Data.myKing.king.fightInfo.turning2(this.autoSkillArr[skillPos].skill_id))
					{
						targetSkillId=this.autoSkillArr[skillPos].skill_id;
						if (inCD(targetSkillId) == false)
						{
							if (Data.skill.getSkill(targetSkillId).cc1_para1ByMP <= Data.myKing.mp)
							{
								_ret=targetSkillId;
							}
							else
							{
								_ret=GamePlugIns.getInstance().getAutoFightSkillId();
							}
						}
					}
				}
				else
				{
					_ret=GamePlugIns.getInstance().getAutoFightSkillId();
				}
			}
			return _ret;
		}

		private function dragUpHandler(e:DispatchEvent):void
		{
//外网此处会报错			
			try
			{
				var start:Object=MainDrag.currTarget;
				if (null == start || null == start.parent || null == start.data)
				{
					return;
				}
				var end:Object=e.getInfo;
				//原位置
				var fromPos:int=0;

				if (null == end || null == end.parent || end.hasOwnProperty("data") == false || null == end["data"])
				{
					if (end)
					{
						var nem1:String=end.parent.name;
						var nem2:String=start.parent.name;
						if (nem1.slice(0, 5) != nem2.slice(0, 5))
						{
//					if (end != start){
							//丢弃
							var sInd:int=start.name.indexOf("item_hotKey");
							if (sInd != -1)
							{
								fromPos=int(String(start.name).replace("item_hotKey", ""));
								this.uninstall(fromPos);
								return;
							}
						}
					}
				}

				if (start == end)
					return;
				//是否是交换操作
				var exchange:Boolean=start.parent.name..slice(0, 5) == end.parent.name..slice(0, 5);
				var lock:Boolean=Data.myKing.ShortKeyLock == 1;
				if (lock)
				{ //锁定状态下不允许往技能栏拖拽道具或者技能
					if (end != null && end.name.indexOf("item_hotKey") != -1)
					{
						Lang.showMsg(Lang.getClientMsg("20073_lock_skillShort"));
					}
					return;
				}
				for (var i:int=1; i < LIMIT; i++)
				{
					if (CtrlFactory.getUICtrl().checkParent(end, "item_hotKey" + i))
					{
						if (exchange)
						{
							fromPos=int(String(start.name).replace("item_hotKey", ""));
						}
						this.install(i, start.data, fromPos);
						break;
					}
				}
			}
			catch (e:Error)
			{
			}
		}

		/**
		 * 装配技能或道具
		 * @param pos 目标位置
		 * @param data 原数据
		 * @param fromPos 源位置
		 *
		 */
		private function install(pos:int, data:Object, fromPos:int=0):void
		{
			if (data is StructBagCell)
			{
				if (StructBagCell2(data).config.is_layup == 1)
				{
					this.installItem(pos, StructBagCell(data).itemid, fromPos);
				}
			}
			else if (data is StructSkillItem)
			{
				this.installSkill(pos, StructSkillItem(data).skillId, fromPos);
			}
		}

		/**
		 * 卸载道具或者技能
		 * @param pos 目标位置
		 *
		 */
		public function uninstall(pos:int, flag:int=0):void
		{
			Jineng.instance.selectItem(pos, 0, 0, flag);
		}

		/**
		 * 放置道具
		 * @param pos
		 * @param itemId
		 * @param fromPos
		 *
		 */
		private function installItem(pos:int, itemId:int, fromPos:int=0):void
		{
			Jineng.instance.selectItem(pos, itemId, fromPos);
		}

		/**
		 * 放置技能
		 * @param bar_pos
		 * @param skill_id
		 * @param fromPos
		 * @param flag 默认为0：技能快捷栏 1：挂机快捷栏
		 *
		 */
		public function installSkill(bar_pos:int, skill_id:int, fromPos:int=0, flag:int=0):void
		{
			//SkillShort.setFlyStartPostion(currBtn);
			Jineng.instance.selectSkill(bar_pos, skill_id, fromPos, flag);
		}

		/**
		 *	得到技能快捷栏一个空位置
		 *  @2013-06-18 andy
		 */
		public static function getEmptyPos():int
		{
			var ret:int=0;
			var uilMC:MovieClip=null
			for (var q:int=1; q < LIMIT; q++)
			{
				if (UI_index.indexMC_mrb["mc_hotKey"]["itjinengBox" + q] == null)
					break;
				uilMC=UI_index.indexMC_mrb["mc_hotKey"]["itjinengBox" + q]["item_hotKey" + q];
				if (uilMC.data == null)
				{
					ret=q;
					break;
				}
			}
			return ret;
		}

		/**
		 *	设置飞行开始全局坐标
		 *  @2012-10-26 andy
		 */
		public static function setFlyStartPostion(start:DisplayObject):void
		{
			if (start == null)
				return;
			startPoint=(start.parent as DisplayObject).localToGlobal(new Point(start.x, start.y));
		}

		private function shortKeyLockHandler(e:DispatchEvent=null):void
		{
			var lock:int=Data.myKing.ShortKeyLock;
//			SkillShortLockOrigState = lock;
			var uilMC:MovieClip;
			var hkMC:MovieClip=mc["mrb"]["mc_hotKey"];
			for (var i:int=1; i < LIMIT; i++)
			{
				if (hkMC["itjinengBox" + i] == null)
					break;
				uilMC=hkMC["itjinengBox" + i]["item_hotKey" + i];
				if (uilMC.data != null)
				{
					if (lock)
					{ //锁定状态下不允许拖拽，点击技能操作
						MainDrag.getInstance().unregDrag(uilMC);
					}
					else
					{
						MainDrag.getInstance().regDrag(uilMC);
					}
				}
			}
		}

		private function onPlayerStateChange(e:DispatchEvent):void
		{
			var states:Array=Data.myKing.StateArr;
			//位运算对应的位置标记：2：沉默 3：眩晕4：旋风斩
			HasSkillLock=(states[1] == 0 || states[2] == 0 || states[3] == 1);
		}

		private var skillIconCache:Array=[];
		private var skillIconBgCache:Array=[];

		private var itemIconCache:Array=[];
		private var itemIconBgCache:Array=[];

		private var IconRecycle:Array=[];
		private var IconBgRecycle:Array=[];



		/**
		 * 渲染技能选择栏里的道具列表
		 */
		private function renderSkillShortDataProvider():void
		{
			var container:Sprite=mc["mrb"]["skillSelecter"];
			var skillIcon:Sprite=null;
			var skillIconBg:MovieClip=null;
			var row:int=0; //标签处于第几行
			var skillRow:int=0;
			var itemRow:int=0; //道具位于第几行
			//获取已学技能列表
			var learnedSkillList:Vector.<StructSkillItem2>=Data.skill.getLearnedAutoSkillList();
			var posToFrame:int=1; //根据位置跳转到的帧数
			var fromIndex:int=0;
			var len:int=0;
			var sitem:StructSkillItem2;
			var bitem:StructBagCell2;
			var tempIcon:Sprite;
			var tempIconBg:Sprite;
			len=skillIconCache.length;
			while (fromIndex < len)
			{
				sitem=StructSkillItem2(skillIconCache[fromIndex]["data"]);
				posToFrame=this.getPosById(sitem.skill_id) + 1;
				skillIconCache[fromIndex]["key"].gotoAndStop(posToFrame);
				fromIndex++;
			}

			if (learnedSkillList.length > len)
			{
				//添加新的技能
				fromIndex=skillIconCache.length;
				len=learnedSkillList.length;
				while (fromIndex < len)
				{
					skillIcon=GamelibS.getswflink("game_index", "SkillIconBigL") as Sprite;
					skillIconBg=GamelibS.getswflink("game_index", "SkillIconBgBigL") as MovieClip;
					skillIcon.mouseChildren=false;
					skillIconBg.mouseChildren=skillIconBg.mouseEnabled=false;
					sitem=learnedSkillList[fromIndex];
					posToFrame=this.getPosById(sitem.skill_id) + 1;
					skillIcon["key"].gotoAndStop(posToFrame);
					skillIcon.name="skill_SkillShort_" + fromIndex;
//					skillIcon["lengque"].visible = false;
//					skillIcon["uil"].source=sitem.icon;
					ImageUtils.replaceImage(skillIcon, skillIcon["uil"], sitem.iconX);
					skillIcon["data"]=sitem;

					CtrlFactory.getUIShow().addTip(skillIcon);
					container.addChild(skillIconBg);
					container.addChild(skillIcon);

					if (fromIndex % HLIMIT_BIG == 0)
					{ //X坐标从头开始，换行
//						skillIcon.x = ITEM_X;
//						skillIconBg.x = BG_X;
						skillIcon.x=ITEM_BIG_X;
						skillIconBg.x=BG_X;
						row=int(fromIndex / HLIMIT_BIG); //当前处于第几行
						if (row == 0)
						{
							skillIcon.y=ITEM_BIG_Y;
							skillIconBg.y=BG_BIG_Y;
						}
						else
						{
							skillIcon.y=skillIconCache[fromIndex - 1].y + ITEM_BIG_HEIGHT + ITEM_VSPACE;
//							skillIconBg.y = skillIconBgCache[fromIndex-1].y + skillIconBgCache[fromIndex-1].height + BG_VSPACE;
							skillIconBg.y=skillIcon.y - 2;
						}
					}
					else
					{ //同行
						skillIcon.x=skillIconCache[fromIndex - 1].x + ITEM_BIG_HEIGHT + ITEM_BIG_HSPACE;
//						skillIconBg.x = skillIconBgCache[fromIndex-1].x + ITEM_BIG_WIDTH + BG_HSPACE;
						skillIconBg.x=skillIcon.x - 1;
						skillIcon.y=skillIconCache[fromIndex - 1].y;
						skillIconBg.y=skillIcon.y - 2;
					}
					skillIconCache.push(skillIcon);
					skillIconBgCache.push(skillIconBg);
					//TODO 添加监听事件
					fromIndex++;
				}
			}
			skillRow=skillIconCache.length == 0 ? 0 : int((skillIconCache.length - 1) / HLIMIT_BIG) + 1;

			//获取可以装配的的物品列表
//			if (CanInstallItems==null){
//				var itemConfig:String = XmlManager.localres.ConfigXml.getResPath(105).contents;//技能栏装配界面显示的道具
//				if (itemConfig.length>0){
//					if (itemConfig.indexOf(",")==-1){
//						CanInstallItems = [itemConfig];
//					}else{
//						CanInstallItems = itemConfig.split(",");
//					}
//				}
//			}//10801001,10801101,10801201,10801301,10801401,10801501,10801601,10801701,10801801,10801901,10901001,10901101,10901201,10901301,10901401,10901501,10901601,10901701,10901801,10901901,10902001,10902101,10902201,10902301,10902401,10902501,10902601,10902701,10902801,10902901
			if (CanInstallItemsConfig == null)
			{
				CanInstallItemsConfig=XmlManager.localres.ConfigXml.getResPath(105)["contents"]; //技能栏装配界面显示的道具
			}

			var canInstallItemList:Vector.<StructBagCell2>=Data.beiBao.getItemsForSkillShort(CanInstallItemsConfig);

			fromIndex=0;
			len=canInstallItemList.length;
			while (fromIndex < len)
			{
				skillIcon=this.itemIconCache[fromIndex];
				skillIconBg=this.itemIconBgCache[fromIndex];
				if (skillIcon == null)
				{
					if (this.IconRecycle.length > 0)
					{
						skillIcon=this.IconRecycle.shift();
						skillIconBg=this.IconBgRecycle.shift();
					}
					else
					{
						skillIcon=GamelibS.getswflink("game_index", "SkillIconSmallL") as Sprite;
						skillIconBg=GamelibS.getswflink("game_index", "SkillIconBgSmallL") as MovieClip;
						skillIcon.mouseChildren=false;
						skillIconBg.mouseChildren=skillIconBg.mouseEnabled=false;
//						skillIcon["lengque"].visible = false;
					}
					CtrlFactory.getUIShow().addTip(skillIcon);
					container.addChild(skillIconBg);
					container.addChild(skillIcon);
					this.itemIconCache.push(skillIcon);
					this.itemIconBgCache.push(skillIconBg);
				}
				bitem=canInstallItemList[fromIndex];
				posToFrame=this.getPosById(bitem.itemid) + 1;
				skillIcon["key"].gotoAndStop(posToFrame);
				skillIcon.name="item_SkillShort_" + fromIndex;
//				skillIcon["uil"].source=bitem.icon;
				ImageUtils.replaceImage(skillIcon, skillIcon["uil"], bitem.icon);
				skillIcon["txt_num"].text=bitem.num.toString();
				skillIcon["data"]=bitem;

				if (fromIndex % HLIMIT == 0)
				{ //X坐标从头开始，换行
					skillIcon.x=ITEM_BIG_X;
					skillIconBg.x=BG_X;
					row=int(fromIndex / HLIMIT); //当前处于第几行

					if (row == 0)
					{
						if (skillRow == 0)
						{
							skillIcon.y=ITEM_BIG_Y;
							skillIconBg.y=BG_BIG_Y;
						}
						else
						{
							var tempIndex:int=skillIconCache.length - 1;
							skillIcon.y=skillIconCache[tempIndex].y + ITEM_BIG_HEIGHT + BG_VSPACE - 1;
							skillIconBg.y=skillIcon.y - 2;
						}
					}
					else
					{
						skillIcon.y=itemIconCache[fromIndex - 1].y + ITEM_HEIGHT + BG_VSPACE - 1;
						skillIconBg.y=itemIconBgCache[fromIndex - 1].y + itemIconBgCache[fromIndex - 1].height + BG_VSPACE;
					}
				}
				else
				{ //同行
					skillIcon.x=itemIconCache[fromIndex - 1].x + ITEM_WIDTH + ITEM_HSPACE;
//					skillIconBg.x = itemIconBgCache[fromIndex-1].x + itemIconBgCache[fromIndex-1].width + BG_HSPACE;
					skillIconBg.x=skillIcon.x - 1;
					skillIcon.y=itemIconCache[fromIndex - 1].y;
					skillIconBg.y=itemIconBgCache[fromIndex - 1].y;
				}
				fromIndex++;
			}

			if (len < this.itemIconCache.length)
			{ //执行删除
				fromIndex=len;
				len=this.itemIconCache.length;
				while (fromIndex < len)
				{
					skillIcon=this.itemIconCache.pop();
					skillIconBg=this.itemIconBgCache.pop();
					container.removeChild(skillIcon);
					container.removeChild(skillIconBg);
					CtrlFactory.getUIShow().removeTip(skillIcon);
					this.IconRecycle.push(skillIcon);
					this.IconBgRecycle.push(skillIconBg);
					fromIndex++;
				}
			}

			skillIcon=null;
			skillIconBg=null;

			itemRow=itemIconCache.length == 0 ? 0 : int((itemIconCache.length - 1) / HLIMIT) + 1;

			mc["mrb"]["skillSelecter"]["back"].height=OrigH + skillRow * BG_BIG_STEP + (itemRow - 1) * BG_STEP;
			mc["mrb"]["skillSelecter"].y=mc["mrb"]["mc_hotKey"].y - mc["mrb"]["skillSelecter"].height + OFFSET_X_UP_SKIIL_SHORT;
			container.visible=true;
			this.updateSkillIconSelected();
		}

		/**
		 * 更新要被替换的技能或者道具选中状态
		 *
		 */
		private function updateSkillIconSelected():void
		{
			if (replacePos == -1)
				return;
			var skillIcon:Sprite;
			for each (skillIcon in this.skillIconCache)
			{
				if (skillIcon["data"] != null)
				{
					if (replaceType == 0)
					{
						if (StructSkillItem2(skillIcon["data"]).skill_id == replaceId)
						{
							skillIcon["mc_selected"].gotoAndStop(2);
						}
						else
						{
							skillIcon["mc_selected"].gotoAndStop(1);
						}
					}
					else
					{
						skillIcon["mc_selected"].gotoAndStop(1);
					}
				}
			}
			for each (skillIcon in this.itemIconCache)
			{
				if (skillIcon["data"] != null)
				{
					if (replaceType == 1)
					{
						if (StructBagCell2(skillIcon["data"]).itemid == replaceId)
						{
							skillIcon["mc_selected"].gotoAndStop(2);
						}
						else
						{
							skillIcon["mc_selected"].gotoAndStop(1);
						}
					}
					else
					{
						skillIcon["mc_selected"].gotoAndStop(1);
					}
				}
			}
		}

		/**
		 * [废弃]
		 * 针对新数据处理 需要根据类型区分是技能还是道具，因为需要依赖type为skillIcon.name属性赋值
		 * @param container
		 * @param source 当前数据
		 * @param target 新数据
		 * @param fromIndex 数据起始位置
		 * @param len 数据长度
		 * @param row 起始第几行
		 * @param type 数据类型 0-技能；1-物品
		 *
		 */
		private function renderIcon(container:Sprite, source:Object, target:Object, fromIndex:int, len:int, fromRow:int, type:int):void
		{
			var skillIcon:Sprite=null;
			var skillIconBg:MovieClip=null;
			var row:int=0;
			//添加新的技能
			var fromIndex:int=source.length;
			var len:int=target.length;
			var item:Object;
			var tempIcon:Sprite;
			var tempIconBg:MovieClip;
			var tempIndex:int;
			while (fromIndex < len)
			{
				skillIcon=GamelibS.getswflink("game_index", "SkillIconL") as Sprite;
				skillIconBg=GamelibS.getswflink("game_index", "SkillIconBgL") as MovieClip;
				item=target[fromIndex];
//				skillIcon["lengque"].visible = false;
//				skillIcon["uil"].source=item.icon;
				ImageUtils.replaceImage(skillIcon, skillIcon["uil"], item.icon);
				skillIcon["data"]=item;
				CtrlFactory.getUIShow().addTip(skillIcon);
				container.addChild(skillIconBg);
				container.addChild(skillIcon);

				if (fromIndex % HLIMIT == 0)
				{ //X坐标从头开始，换行
					skillIcon.x=ITEM_X;
					skillIconBg.x=BG_X;
					row=int(fromIndex / HLIMIT); //当前处于第几行
					if (row == 0)
					{
						if (fromRow == 0)
						{
							skillIcon.y=ITEM_Y;
							skillIconBg.y=BG_Y;
						}
						else
						{ //上一行的的Y位置
							tempIndex=(fromRow - 1) * HLIMIT;
							tempIcon=skillIconCache[tempIndex];
							tempIconBg=skillIconCache[tempIndex];
							skillIcon.y=tempIcon.y + tempIcon.height + ITEM_VSPACE;
							skillIconBg.y=tempIconBg.y + tempIcon.height + BG_VSPACE;
						}
					}
					else
					{
						tempIndex=fromIndex - 1;
						tempIcon=skillIconCache[tempIndex];
						tempIconBg=skillIconCache[tempIndex];
						skillIcon.y=tempIcon.y + tempIcon.height + ITEM_VSPACE;
						skillIconBg.y=tempIconBg.y + tempIconBg.height + BG_VSPACE;
					}
				}
				else
				{ //同行
					tempIndex=fromIndex - 1;
					tempIcon=skillIconCache[tempIndex];
					tempIconBg=skillIconBgCache[tempIndex];

					skillIcon.x=tempIcon.x + tempIcon.width + ITEM_HSPACE;
					skillIconBg.x=tempIconBg.x + tempIconBg.width + BG_HSPACE;
					skillIcon.y=tempIcon.y;
					skillIconBg.y=tempIconBg.y;
				}
				skillIconCache.push(skillIcon);
				skillIconBgCache.push(skillIconBg);
				//TODO 添加监听事件
				fromIndex++;
			}
			tempIconBg=null;
			tempIcon=null;
		}

		/**
		 * 根据ID获取对应在快捷栏上的位置
		 * @param id
		 * @return
		 *
		 */
		public function getPosById(id:int):int
		{
			var pos:int=0;
			var arr:Array=IconKey.keys();
			for each (var key:* in arr)
			{
				if (IconKey.getValue(key) == id)
				{
					pos=int(key);
					break;
				}
			}
			return pos;
		}

		/**
		 * 判定当前操作快捷栏上的对象是否在Cd中
		 * @param targetId 对象ID
		 * @return
		 *
		 */
		public function inCD(targetId:int):Boolean
		{
			for each (var cd:StructCooldown2 in this.skillArr)
			{
				if (cd.id == targetId)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * 获取前四个技能id
		 */
		public function getFourSkillIDList():Array
		{
			var arr:Array=[];
			var i:int=0;
			var hkMC:MovieClip=mc["mrb"]["mc_hotKey"];
			var uilMC:MovieClip;
			for (i=1; i < 5; i++)
			{
				if (hkMC["itjinengBox" + i] == null)
					break;
				uilMC=hkMC["itjinengBox" + i]["item_hotKey" + i];
				if (uilMC.data != null)
				{
					arr.push((uilMC.data as StructSkillItem2).skill_id);
				}
			}
			return arr;
		}
	}
}
