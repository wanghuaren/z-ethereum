package ui.view.view1.guaji
{
	import com.greensock.plugins.VolumePlugin;
	
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.GamePrint;
	import common.utils.Stats;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	import common.utils.component.ButtonGroup;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.BeiBaoSet;
	import netc.dataset.SkillShortSet;
	import netc.packets2.StructAutoConfig2;
	import netc.packets2.StructShortKey2;
	import netc.packets2.StructSkillItem2;
	
	import nets.packets.PacketCSAddAutoTime;
	import nets.packets.PacketCSAutoAddtTime;
	import nets.packets.PacketCSAutoConfig;
	import nets.packets.PacketCSAutoGetConfig;
	import nets.packets.PacketSCAutoConfig;
	import nets.packets.PacketSCAutoGetConfig;
	import nets.packets.StructAutoConfig;
	
	import scene.action.PathAction;
	import scene.action.hangup.HangupModel;
	import scene.skill2.SkillEffectManager;
	
	import ui.frame.UIActMap;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.view.skill.SkillSelecter;
	import ui.base.jineng.SkillShort;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.FileManager;
	import world.WorldEvent;
	
	
	public class Guaji extends UIWindow
	{
		private static var KAISHI:String=Lang.getLabel("20100_guaji");//"开始挂机";
		private static var TINGZHI:String=Lang.getLabel("20101_guaji");//"停止挂机";
		private var fanwei:int;
		private static var _instance : Guaji = null;
		//new defines
		private static var replacePos:int = 0;//默认为0，表示丢弃，非有效值
		private static var replaceId:int = 0;//替换的技能或者物品ID
		private static var replaceType:int = 0;//默认为技能
		
		public function Guaji()
		{
			super(getLink("win_guaji"));
			//this.winClose();
		}
		
		/**
		 * 获得单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():Guaji
		{
			if (null == _instance)
			{
				_instance=new Guaji();
			}
			
			return _instance;
		}
		
		/**
		 * 获得单例并开启窗口 
		 * @return 
		 * 
		 */		
		public static function get instance() : Guaji {
			if (null == _instance)
			{
				_instance=new Guaji();
				_instance.addObjToStage(_instance.mc);
			}
			else
			{
				_instance.addObjToStage(_instance.mc);
			}
			
			return _instance;
		}
		
		/**
		 * 面板开启的时候初始化面板数据内容 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			Data.skillShort.addEventListener(SkillShortSet.SKILLSHORTCHANGE, skillShortChange);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,_onTimerListener);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,_onTimerListener);
			
//			mc['buchong'].visible = true;
//			mc['txt_HangupTime'].visible = true;
			this.initHotKeys();
			mc["mc_hotKey"].addEventListener(MouseEvent.CLICK, thisUI_MOUSE_DOWN);
			if (SkillShort.StructShortKeyEvent!=null){
				skillShortChange(SkillShort.StructShortKeyEvent);
			}
				
			repaint();
		}
		//技能数据变化
		private function skillShortChange(e:DispatchEvent):void
		{
			var vec:Vector.<StructShortKey2>;
			vec = Data.skillShort.contentList;
			var len:int = vec.length;
			var uilMC:MovieClip;
			var lock:int = Data.myKing.ShortKeyLock;
			for(var i:int=0;i<len;i++){
				var pos:int = vec[i].pos;
//				pos = pos<8?pos+8:pos;
				//if((pos>0&&pos<5)||pos==9||pos==10){
				//if((pos>0&&pos<5)){
				if((pos>=SkillShort.LIMIT&&pos<SkillShort.LIMIT_GUA_JI)){//原来是8---13
					
					if (!vec[i].del && vec[i].id != 0)
					{
						uilMC=mc["mc_hotKey"]["itjinengBox"+pos]["item_hotKey" + pos];
						uilMC["uil"].unload();
						SkillShort.IconKey.put(pos,vec[i].id);						
						if(1 == vec[i].type)
						{
						}
						else
						{
							//技能
//							uilMC["uil"].source=FileManager.instance.getSkillIconSById(vec[i].id);
							ImageUtils.replaceImage(uilMC,uilMC["uil"],FileManager.instance.getSkillIconSById(vec[i].id));
							uilMC.data= Data.skill.getSkill(vec[i].id);
							
							if (null != Data.myKing.king)
								SkillEffectManager.instance.preLoad(vec[i].id, Data.myKing.king.sex);
						}
						CtrlFactory.getUIShow().addTip(uilMC);
						//						if (lock==false)
						//							MainDrag.getInstance().regDrag(uilMC);
					}
					else
					{
						SkillShort.IconKey.remove(pos);
						vec[i].isNew=false;
						uilMC=mc["mc_hotKey"]["itjinengBox"+pos]["item_hotKey" + pos];
						uilMC["uil"].unload();
						uilMC.data=null;
						uilMC["txt_num"].text="";
						CtrlFactory.getUIShow().removeTip(uilMC);
						//						MainDrag.getInstance().unregDrag(uilMC);
					}
					uilMC["lengque"].visible=false;
					uilMC["shijian"].text="";
				}
			}
		}
		
		/**
		 * 初始化快捷键引用
		 */
		private function initHotKeys():void{
			//hotkey 中下部快捷键
			var i:int = 9;
			var target:* = mc["mc_hotKey"];
			var key:*;
			for (;i<13;i++){
				key = target["itjinengBox"+i]["item_hotKey"+i];
				key.mouseChildren = false;
				key["lengque"].visible = false;
				key.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				key.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			}
		}
		
		private function onMouseOver(e:MouseEvent):void{
			var key:Object = e.target;
			if (key["data"]==null){
				key["overState"].gotoAndStop(2);
			}else{
				key["overState"].gotoAndStop(3);
			}
		}
		
		private function onMouseOut(e:MouseEvent):void{
			var key:Object = e.target;
			if (key["data"]!=null){
				if (key["overState"].currentFrame!=1)
					key["overState"].gotoAndStop(1);
			}else{
				key["overState"].gotoAndStop(1);
			}
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must,type);
			
			//向服务器请求一次当前挂机的剩余时间。
			HangupModel.getInstance().requestPacketCSAutoConfig();
			
			repaint();
		}
		
		private function thisUI_MOUSE_DOWN(e:MouseEvent):void
		{
			if (e.target.name.indexOf("item_hotKey") == 0)
			{
				var pos:int = int(e.target.name.replace("item_hotKey",""));
				//点击弹出技能选择界面
				this.resetAllHotKeyStates();
				SkillSelecter.replacePos = pos;
				var uilMC:MovieClip=mc["mc_hotKey"]["itjinengBox"+pos]["item_hotKey" + pos];
				uilMC["mc_selected"].gotoAndStop(2);
				SkillSelecter.replaceId = -1;
				if (uilMC.data!=null){
					if (uilMC.data is StructSkillItem2){
						SkillSelecter.replaceId = StructSkillItem2(uilMC.data).skill_id;
						SkillSelecter.replaceType = 0;
					}
				}
				
				SkillSelecter.getInstance().open(true,false);
				SkillSelecter.getInstance().renderSkill();
				SkillSelecter.getInstance().addEventListener(MouseEvent.CLICK,onChooseSkill);
				PubData.mainUI.stage.addEventListener(MouseEvent.CLICK,onChooseSkill);
//				this.renderSkillShortDataProvider();
			}
		}
		
		private function onChooseSkill(e:MouseEvent):void{
			if (SkillSelecter.getInstance().isOpen){
				if (e.target.parent.parent == mc["mc_hotKey"] && e.target.name.indexOf("item_hotKey")==0) return;
				SkillSelecter.getInstance().winClose();
				this.resetAllHotKeyStates();
			}else{
				return;
			}
			SkillSelecter.getInstance().chooseSkill(e.target.name);
		}
		
		private function resetAllHotKeyStates():void{
			var i:int =SkillShort.LIMIT;
			var target:* = mc["mc_hotKey"];
			var key:*;
			for (;i<SkillShort.LIMIT_GUA_JI;i++){
				key = target["itjinengBox"+i]["item_hotKey"+i];
				key["mc_selected"].gotoAndStop(1);
			}
		}
		
		/**
		 * 从 HangupModel模块中获得挂机的配置信息,并设置面板显示内容。
		 * 
		 */		
		public function repaint():void
		{
			Stats.getInstance().addLog("["+getTimer()+"] Gua Ji ->> ");
			if(null == mc)
			{
				Stats.getInstance().addLog("["+getTimer()+"] Gua Ji no mc ->> ");
				setTimeout(repaint,2000);
				return ;
			}
			
			//默认吃药百分比设置  ，当前红蓝都为 80%
			mc["txt1"].addEventListener(Event.CHANGE,_onHpPercentListener);
			mc["txt1"].text = HangupModel.getInstance().getHpPercent();
			
			mc["txt2"].addEventListener(Event.CHANGE,_onMpPercentListener);
			mc["txt2"].text = HangupModel.getInstance().getMpPercent();
			
			//默认的拾取设置
			_repaintPickupSort(HangupModel.getInstance().getPickupSorts(),HangupModel.getInstance().getPickupOrtherSorts());
			
			//默认自动战斗设置
			mc["f_1"].selected = HangupModel.getInstance().getIsAutoSkill();
	
			//设置复活的方式
//			if(HangupModel.RELIVE_MODE_YUANDI == HangupModel.getInstance().getReliveMode())
//			{
//				mc["f_2"].selected = true;
//			}
//			else
//			{
//				mc["f_2"].selected = false;
//			}
			
			
			//设置是否在5分钟死亡两次就回城
			mc["f_3"].selected = HangupModel.getInstance().getIsNeedGoHomeInFiveMin();
			
			
			if(Data.myKing.Vip <= 0)
			{
				StringUtils.setUnEnable( mc["f_2"] );
//				StringUtils.setUnEnable( mc["f_3"] );
			}
			else
			{
				StringUtils.setEnable( mc["f_2"] );
				//StringUtils.setEnable( mc["f_3"] );
			}
			
			//敌对势力
			mc["f_4"].selected = HangupModel.getInstance().getIsAutoFightOtherPlayer();
			
			//是否优先攻击精英怪
			mc["f_5"].selected = HangupModel.getInstance().getFightBossFirst();
			
			//是否自动释放战魂
			mc["f_6"].selected = HangupModel.getInstance().getAutoZhanhun();
			
			//默认攻击范围
			//HangupModel.getInstance().setFightDiatance(600);
			switch(HangupModel.getInstance().getFightDiatance())
			{
				case HangupModel.FIGHT_DIATANCE_SMALL:
					mc["db1"].selected = true;
					break;
				case HangupModel.FIGHT_DIATANCE_MIDDLE:
					mc["db2"].selected = true;
					break;
				case HangupModel.FIGHT_DIATANCE_BIG:
					mc["db3"].selected = true;
					break;
				default:
					break;
			}
			
			if(HangupModel.getInstance().isHanguping())
			{
				mc["submit"].label=TINGZHI
			}
			else if(Data.myKing.king.hp >= 1 && HangupModel.getInstance().getHangupTime()>0)
			{
				mc["submit"].label=KAISHI;
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "submit":
					
					if(HangupModel.getInstance().isHanguping())
					{
						HangupModel.getInstance().stop();
						
						mc["submit"].label=KAISHI;
					}
					else if(Data.myKing.king.hp >= 1 && HangupModel.getInstance().getHangupTime()>0)
					{
						HangupModel.getInstance().start();
						mc["submit"].label=TINGZHI;
					}
					
					break;
				case "buchong":
					
					//if(DataCenter.myKing.Vip >=1 )
					//{
						if( (HangupModel.getInstance().getHangupTime() + 3*60*60*1000) > HangupModel.HANGUP_MAX_TIME )
						{
							alert.ShowMsg(Lang.getLabel("40010_guaji_max_time"),2,null,null);
						}
						else
						{
//							alert.ShowMsg(Lang.getLabel("40011_guaji_huafei"),4,null,function():void{
//								
//								HangupModel.getInstance().requestPacketCSAddAutoTime();
//								
//								
//							});
							
							GameAlertNotTiShi.instance.ShowMsg(Lang.getLabel("40011_guaji_huafei"),GameAlertNotTiShi.GUAJI,null,function():void{
								
								HangupModel.getInstance().requestPacketCSAddAutoTime();
								
								
							});
						}
					//}
					//else
					//{
					//	alert.ShowMsg(Lang.getLabel("40012_guaji_vip"),2,null,null);
					//}

					break;
				case "db1":   //小范围
					fanwei=1;
					HangupModel.getInstance().setFightDiatance(HangupModel.FIGHT_DIATANCE_SMALL);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "db2":   //中范围
					fanwei=2;
					HangupModel.getInstance().setFightDiatance(HangupModel.FIGHT_DIATANCE_MIDDLE);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "db3":   //大范围
					fanwei=3;
					HangupModel.getInstance().setFightDiatance(HangupModel.FIGHT_DIATANCE_BIG);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "f_1":   //自动释放技能
					mc["f_1"].selected = !mc["f_1"].selected;
					HangupModel.getInstance().setIsAutoSkill(mc["f_1"].selected);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "f_2":   //自动原地复活  vip
					mc["f_2"].selected = !mc["f_2"].selected;
//					if(mc["f_2"].selected)
//					{
//						HangupModel.getInstance().setReliveMode(HangupModel.RELIVE_MODE_YUANDI);
//					}
//					else
//					{
//						HangupModel.getInstance().setReliveMode(HangupModel.RELIVE_MODE_HUICHENG);
//					}
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					
					break;
				case "f_3":   //5分钟内死亡两次，回城复活  vip
					mc["f_3"].selected = !mc["f_3"].selected;
					
					HangupModel.getInstance().isNeedGoHomeInFiveMin(mc["f_3"].selected);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "f_4":   //主动攻击敌对势力玩家
					mc["f_4"].selected = !mc["f_4"].selected;
					
					HangupModel.getInstance().isAutoFightOtherPlayer(mc["f_4"].selected);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "f_5":   //主动攻击精英怪和Boss
					mc["f_5"].selected = !mc["f_5"].selected;
					HangupModel.getInstance().setFightBossFirst(mc["f_5"].selected);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "f_6":  // 自动释放战魂
					mc["f_6"].selected = !mc["f_6"].selected;
					HangupModel.getInstance().setAutoZhanhun(mc["f_6"].selected);
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "p_1":   //拾取装备
					mc["p_1"].selected = !mc["p_1"].selected;
					setPickupSort();
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "p_2":   //拾取药品
					mc["p_2"].selected = !mc["p_2"].selected;
					setPickupSort();
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "p_3":   //拾取材料
					mc["p_3"].selected = !mc["p_3"].selected;
					setPickupSort();
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				case "p_4":   //拾取其它
					mc["p_4"].selected = !mc["p_4"].selected;
					setPickupSort();
					
					//向服务器保存该数据
					HangupModel.getInstance().requestPacketCSSetAutoConfig();
					break;
				default:
					break;
			}
		}
		
		/**
		 * 设置一下拾取分类 
		 * 
		 */		
		private function setPickupSort():void
		{
			var _arrSorts:Array = [];
			if(mc["p_1"].selected)
			{
				_arrSorts.push(BeiBaoSet.ITEM_SORT_ZHUANGBEI);
			}
			
			if(mc["p_2"].selected)
			{
				_arrSorts.push(BeiBaoSet.ITEM_SORT_YAO);
			}
			
			if(mc["p_3"].selected)
			{
				_arrSorts.push(BeiBaoSet.ITEM_SORT_CAILIAO);
			}
			
			HangupModel.getInstance().setPickupSorts(_arrSorts);
			HangupModel.getInstance().setPickupOrtherSorts(mc["p_4"].selected);
		}
		
		/**
		 * 重新绘制捡取
		 * @param arr
		 * @param isOther
		 * 
		 */		
		private function _repaintPickupSort(arr:Array,isOther:Boolean):void
		{
			
			mc["p_1"].selected = false;
			mc["p_2"].selected = false;
			mc["p_3"].selected = false;
			mc["p_4"].selected = isOther;
			
			var _length:int = arr.length;
			for(var i:int = 0;i < _length ; ++i)
			{
				switch(arr[i])
				{
					case BeiBaoSet.ITEM_SORT_ZHUANGBEI:
						mc["p_1"].selected = true;
						break;
					case BeiBaoSet.ITEM_SORT_YAO:
						mc["p_2"].selected = true;
						break;
					case BeiBaoSet.ITEM_SORT_CAILIAO:
						mc["p_3"].selected = true;
						break;
					default:
						break;
				}
			}
			
		}
		
		
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			
			mc["txt1"].removeEventListener(Event.CHANGE,_onHpPercentListener);
			mc["txt2"].removeEventListener(Event.CHANGE,_onMpPercentListener);
			SkillSelecter.getInstance().winClose();
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,_onTimerListener);
			
			
		}
		
		override public function winClose():void
		{
			super.winClose();
		}
		
		private function _onHpPercentListener(event:Event):void
		{
			var _percent:int = int(mc["txt1"].text);
			
			if(_percent >=100)
			{
				_percent = 100;
				mc["txt1"].text = _percent;
			}
			else if(_percent <= 0)
			{
				_percent = 0;
				mc["txt1"].text = _percent;
			}
			
			HangupModel.getInstance().setHpPercent(_percent);
			
			//向服务器保存该数据
			HangupModel.getInstance().requestPacketCSSetAutoConfig();
			
			//更新一下主UI上的血量条判断条件
			UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_PLEASE_UPDATA_HP_MP));
		}
		
		
		private function _onMpPercentListener(event:Event):void
		{
			var _percent:int = int(mc["txt2"].text);
			
			if(_percent >=100)
			{
				_percent = 100;
				mc["txt2"].text = _percent;
			}
			else if(_percent <= 0)
			{
				_percent = 0;
				mc["txt2"].text = _percent;
			}
			
			HangupModel.getInstance().setMpPercent(_percent);
			
			//向服务器保存该数据
			HangupModel.getInstance().requestPacketCSSetAutoConfig();
			
			//更新一下主UI上的血量条判断条件
			UI_index.UIAct.dispatchEvent(new DispatchEvent(UIActMap.EVENT_PLEASE_UPDATA_HP_MP));
		}
		
		
		
		//private function _onTimerListener(event:TimerEvent):void
		private function _onTimerListener(event:WorldEvent):void
		{
//			var _sTime:String  =  StringUtils.getStringTime( HangupModel.getInstance().getHangupTime(),false );
//			mc["txt_HangupTime"].text =_sTime;
			
			if(HangupModel.getInstance().isHanguping())
			{
				mc["submit"].label=TINGZHI;
			}
			else
			{
				mc["submit"].label=KAISHI;
			}
		}
		//--------- 原有的未知方法  ---------------
		
		
		public function CAutoStart(e:DispatchEvent):void
		{
			GamePrint.Print(e.getInfo[0]["msg"]);
			if (int(e.getInfo[0]["tag"]) == 1)
			{
				Guaji.autoStart();
				this.mc["btnClose"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				winClose();
			}
		}
		//andy 修改使用 shift+Z
		public static function autoStart():void{
			//PathAction.autoFaBao=false;
			//AutoPlay.Start();
			
			//DataCenter.myKing.king.getSkin().getHeadName().nname.htmlText = "<font size='22'>挂机中...</font>";
			//DataCenter.myKing.king.getSkin().getHeadName().nname.x = -46;
			//DataCenter.myKing.king.getSkin().getHeadName().nname.y = -35;
			
			//UIFactory.getAlert.Close();
			//您已进入自动挂机打怪模式！
			GamePrint.Print(Lang.getLabel("20102_guaji"));
			
		}
		
		
		override public function getID():int
		{
			return 1021;
		}
		
		
	}
}




