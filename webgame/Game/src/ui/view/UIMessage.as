package ui.view
{
	import com.bellaxu.def.FilterDef;
	import com.bellaxu.def.LayerDef;
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_QQShareResModel;
	import common.config.xmlres.server.Pub_TaskResModel;
	import common.managers.Lang;
	import common.utils.AsToJs;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCMsg2;
	import netc.packets2.PacketSCTaskAcceptEvent2;
	import netc.packets2.StructPrizeMsgInfo2;
	
	import nets.packets.PacketCSPrizeMsgGet;
	import nets.packets.PacketCSPrizeMsgList;
	import nets.packets.PacketSCAlert;
	import nets.packets.PacketSCMsg;
	import nets.packets.PacketSCPrizeMsgDel;
	import nets.packets.PacketSCPrizeMsgGetResult;
	import nets.packets.PacketSCPrizeMsgList;
	import nets.packets.PacketSCPrizeMsgNew;
	import nets.packets.PacketSCTaskAcceptEvent;
	
	import scene.utils.MapData;
	
	import ui.base.jiaose.JiaoSe;
	import ui.base.mainStage.UI_index;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view2.other.FangChenMi;
	import ui.view.view6.GameAlert;
	
	import world.FileManager;
	import world.WorldEvent;

	/**
	 * suhang
	 */
	public class UIMessage
	{
		//信息1的出现时间
		private static var messagetime1:int;
		private static var messagetime2:int;
		//private static var messagetime3:int;
		//信息1的y值
		private static var messagey1:int;
		private static var messagey2:int;
		private static var messagey3:int;
		//信息1数组
		private static var msg1Vec:Vector.<TextField>=new Vector.<TextField>;
		//信息2数组
		private static var msg2Arr:Array=new Array;
		//信息3 对象池
		private static var msg3Vec:Vector.<TextField>=new Vector.<TextField>;
		//防沉迷
		public static var gamealert:ui.view.view6.GameAlert=new GameAlert();
//
		private static var msg19:Array=[];
		private static var lock19:Boolean=false;
		private static var msg20:Array=[];
		private static var lock20:Boolean=false;
		public static var zoneMC:*;

		public function UIMessage()
		{
		}

		public static function setVisibleByCMessage2(value:Boolean):void
		{
			if (!value)
			{
				if (null != UI_index.indexMC["message"]["CMessage2"].parent)
				{
					(UI_index.indexMC["message"]["CMessage2"].parent as DisplayObjectContainer).removeChild(UI_index.indexMC["message"]["CMessage2"]);
				}
				return;
			}
			if (value)
			{
				if (null == UI_index.indexMC["message"]["CMessage2"].parent)
				{
					(UI_index.indexMC["message"] as DisplayObjectContainer).addChild(UI_index.indexMC["message"]["CMessage2"]);
				}
				return;
			}
		}

		public static function init():void
		{
			PubData.mainUI.Layer5.addChild(UI_index.indexMC["message"]);
			
			zoneMC = UI_index.indexMC["message"]["zone"];
			LayerDef.tipLayer.addChild(zoneMC);
			zoneMC.x = 360;
			zoneMC.mouseChildren = zoneMC.mouseEnabled = false;
			
			UI_index.indexMC["message"].mouseChildren=false;
			UI_index.indexMC["message"].mouseEnabled=false;
			//UI_index.indexMC["message"]["CMessage2"].visible = false;
			setVisibleByCMessage2(false);
			for (var i:int=1; i < 4; i++)
			{
				UI_index.indexMC["message"]["CMessage1" + i].parent.removeChild(UI_index.indexMC["message"]["CMessage1" + i])
			}
			UI_index.indexMC["message"].removeChild(UI_index.indexMC["message"]["CMessage3"]);
			msg1Vec.push(UI_index.indexMC["message"]["CMessage11"]);
			msg1Vec.push(UI_index.indexMC["message"]["CMessage12"]);
			msg1Vec.push(UI_index.indexMC["message"]["CMessage13"]);
			messagey1=msg1Vec[0].y;
			messagey2=msg1Vec[1].y;
			messagey3=msg1Vec[2].y;
//			GameClock.instance.removeEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,messageTimer);
//			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,messageTimer);
			DataKey.instance.register(PacketSCMsg.id, SCMsg);
			//防沉迷
			DataKey.instance.register(PacketSCAlert.id, SCAlert);
			//奖励消息
			DataKey.instance.register(PacketSCPrizeMsgList.id, SCPrizeMsgList);
			DataKey.instance.register(PacketSCPrizeMsgGetResult.id, SCPrizeMsgGetResult);
			DataKey.instance.register(PacketSCPrizeMsgNew.id, SCPrizeMsgNew);
			DataKey.instance.register(PacketSCPrizeMsgDel.id, SCPrizeMsgDel);
			//接任务消息
			DataKey.instance.register(PacketSCTaskAcceptEvent.id, CTaskAcceptEvent);
//			Data.myKing.addEventListener(MyCharacterSet.FIGHT_VALUE_UPDATE, fightUpd);
			//伙伴穿装备引发战力值发生变化
			//Data.huoBan.addEventListener(HuoBanSet.FIGHT_VALUE_UPDATE_PET, fightUpdByHuoBan);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND, chkC19);
		}

//		private static var _zhanLiTotalOld:int=0;
//		private static var _fightUpdRunning:Boolean=false;
//
//		private static function fightUpdByHuoBan(e:DispatchEvent):void
//		{
//			if (e.getInfo["PetId"] == Data.huoBan.curFightPetID)
//			{
//				fightUpd(e);
//			}
//		}
		//uiactMap EVENT_FIGHT_UPDATE_PET会调用,无参，以初始化_zhanLiTotalOld
//		public static function fightUpd(e:DispatchEvent=null):void
//		{
//			//
//			var zhanLiTotal:int=JiaoSe.getZhanLiTotal();
//
//			//test
//			//_zhanLiTotalOld = 50;
//
//			if (_zhanLiTotalOld > zhanLiTotal)
//			{
//				_zhanLiTotalOld=zhanLiTotal;
//				return;
//			}
//			//初始化人物属性
//			if (0 == _zhanLiTotalOld)
//			{
//				_zhanLiTotalOld=zhanLiTotal;
//				return;
//			}
//
//
//
//
//			if (_fightUpdRunning)
//			{
//				return;
//			}
//
//			//负数不飘
//			var zhanLiAdd:int=zhanLiTotal - _zhanLiTotalOld;
//
//			if (zhanLiAdd <= 0)
//			{
//				return;
//			}
//
//			_fightUpdRunning=true;
		//
//			if (null == UI_index.indexMC_fight.parent)
//			{
//				PubData.mainUI.Layer5.addChild(UI_index.indexMC_fight);
//				UI_index.indexMC.stage.dispatchEvent(new Event(Event.RESIZE));
//			}
//
//			UI_index.indexMC_fight.alpha=1.0;
//			//
//			UI_index.indexMC_fight["effect_fight"].visible=false;
//
//			//数字变化
//			//zhanLiAdd需变为+0
//			//_zhanLiTotalOld需加上zhanLiAdd减去的值			
//			UI_index.indexMC_fight["txt_fight"].text=_zhanLiTotalOld.toString();
//			UI_index.indexMC_fight["txt_fightAdd"].text="+" + zhanLiAdd.toString();
		//
//			var w:int=UI_index.indexMC.stage.stageWidth;
//			var h:int=UI_index.indexMC.stage.stageHeight;
//			UI_index.indexMC_fight.x=w / 2 - 410 / 2;
//
//			//var old_y:int = UI_index.indexMC_fight.y =  h - 45 - 200; //
//			var old_y:int=UI_index.indexMC_fight.y=h - 45 - h / 3; //
//
//			//从下往上
//			UI_index.indexMC_fight.y+=45;
//
//			TweenLite.to(UI_index.indexMC_fight, 0.75, {y: old_y});
		//数字
//			_zhanLiTotalTmp=zhanLiTotal;
//			_zhanLiTotalOldTmp=_zhanLiTotalOld;
//			_zhanLiAddTmp=zhanLiAdd;
//			_zhanLiIncreTmp=Math.floor(zhanLiAdd / 9);
//			if (0 == _zhanLiIncreTmp)
//			{
//				_zhanLiIncreTmp=1;
//			}
//
//			TweenLite.killTweensOf(FightEffectNNN);
//			TweenLite.delayedCall(0.75, FightEffectNNN);
		//上
		//TweenLite.killTweensOf(FightEffectOver);			
		//TweenLite.delayedCall(4.0,FightEffectOver);
		//
//			_zhanLiTotalOld=zhanLiTotal;
//		}
		//
//		private static var _zhanLiTotalTmp:int;
//		private static var _zhanLiTotalOldTmp:int;
//		private static var _zhanLiAddTmp:int;
//		private static var _zhanLiIncreTmp:int;
//		private static var _zhanLiIncreTimer:Timer;
//		public static function get zhanLiIncreTimer():Timer
//		{
//			if (null == _zhanLiIncreTimer)
//			{
//				_zhanLiIncreTimer=new Timer(40, 12);
//				_zhanLiIncreTimer.addEventListener(TimerEvent.TIMER, FightEffectNNNSub);
//				_zhanLiIncreTimer.addEventListener(TimerEvent.TIMER_COMPLETE, FightEffectOver);
//			}
//
//			return _zhanLiIncreTimer;
//		}
//
//		private static var _zhanLiEffectTimer:Timer;
//
//		public static function get zhanLiEffectTimer():Timer
//		{
//			if (null == _zhanLiEffectTimer)
//			{
//				_zhanLiEffectTimer=new Timer(40, 10);
//				_zhanLiEffectTimer.addEventListener(TimerEvent.TIMER, FightEffectNNNSub2);
//				_zhanLiEffectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, FightEffectNNNSub2Over);
//			}
//
//			return _zhanLiEffectTimer;
//		}
//		private static function FightEffectNNN():void
//		{
//			zhanLiIncreTimer.reset();
//			zhanLiIncreTimer.start();
//			FightEffectNNNSub();
//		}
//
//		private static function FightEffectNNNSub(e:TimerEvent=null):void
//		{
//			_zhanLiTotalOldTmp+=_zhanLiIncreTmp;
//			_zhanLiAddTmp-=_zhanLiIncreTmp;
//
//			if (_zhanLiAddTmp < 0)
//			{
//				_zhanLiAddTmp=0;
//			}
//
//			if (_zhanLiTotalOldTmp > _zhanLiTotalTmp)
//			{
//				_zhanLiTotalOldTmp=_zhanLiTotalTmp;
//			}
//
//			UI_index.indexMC_fight["txt_fight"].text=_zhanLiTotalOldTmp.toString();
//			UI_index.indexMC_fight["txt_fightAdd"].text="+" + _zhanLiAddTmp.toString();
//		}
//
//
//		private static function FightEffectOver(e:TimerEvent=null):void
//		{
//			//加完
//			UI_index.indexMC_fight["txt_fightAdd"].text="";
//
//			//
//			UI_index.indexMC_fight["effect_fight"].visible=true;
//			UI_index.indexMC_fight["effect_fight"].gotoAndStop(1);
//			UI_index.indexMC_fight["effect_fight"]["txt_fight"].text="";
//
//			zhanLiEffectTimer.reset();
//			zhanLiEffectTimer.start();
		//
		/*var w:int=UI_index.indexMC.stage.stageWidth;
		var h:int=UI_index.indexMC.stage.stageHeight;
		TweenLite.to(UI_index.indexMC_fight, 1.5, {delay:1.0,alpha: 0, y: 0, onComplete: FightEffectOverComplete});
*/
//		}
//		private static function FightEffectNNNSub2(e:TimerEvent):void
//		{
//			UI_index.indexMC_fight["effect_fight"].gotoAndStop(zhanLiEffectTimer.currentCount);
//
//			UI_index.indexMC_fight["effect_fight"]["txt_fight"].text=UI_index.indexMC_fight["txt_fight"].text;
//
//			UI_index.indexMC_fight["effect_fight"]["txt_fight"].alpha=(10 - zhanLiEffectTimer.currentCount) * 0.1;
//		}
//		private static function FightEffectNNNSub2Over(e:TimerEvent):void
//		{
//			var w:int=UI_index.indexMC.stage.stageWidth;
//			var h:int=UI_index.indexMC.stage.stageHeight;
//
//			TweenLite.to(UI_index.indexMC_fight, 1.5, {alpha: 0, y: 0, onComplete: FightEffectOverComplete});
//
//		}
//		private static function FightEffectOverComplete():void
//		{
//			_fightUpdRunning=false;
//			TweenLite.killTweensOf(UI_index.indexMC_fight,true);
//		}
	/**
		 * 接任务成功,底栏上面大字提示
		 */
		private static function CTaskAcceptEvent(p:PacketSCTaskAcceptEvent2):void
		{
			var m:Pub_TaskResModel=XmlManager.localres.getPubTaskXml.getResPath(p.taskid) as Pub_TaskResModel;
			if (null == m)
			{
				return;
			}
			if ("" == m.task_aim)
			{
				return;
			}
			//UI_index.indexMC_taskAccept.text = "我经中石油!我经中石油!我经中石油!我经中石油!";//m.task_aim;
			UI_index.indexMC_taskAccept.text=m.task_aim+"";
			UI_index.indexMC_taskAccept.alpha=1.0;
			//
			if (null == UI_index.indexMC_taskAccept.parent)
			{
				PubData.mainUI.Layer5.addChild(UI_index.indexMC_taskAccept);
				UI_index.indexMC.stage.dispatchEvent(new Event(Event.RESIZE));
			}
			//
			var w:int=UI_index.indexMC.stage.stageWidth;
			var h:int=UI_index.indexMC.stage.stageHeight;
			//- UI_index.indexMC_taskAccept.textWidth / 2
			UI_index.indexMC_taskAccept.x=w / 2 - UI_index.indexMC_taskAccept.textWidth / 2;
			var old_y:int=UI_index.indexMC_taskAccept.y=h - 45 - 40 - 100; //- 180;
			//从下往上
			UI_index.indexMC_taskAccept.y+=45;
			//newcodes
			TweenLite.killTweensOf(UI_index.indexMC_taskAccept);
			TweenLite.to(UI_index.indexMC_taskAccept, 1.2, {y: old_y});
//			TweenLite.killTweensOf(TaskAcceptEffectOver);
			TweenLite.delayedCall(10, TaskAcceptEffectOver);
		}

		public static function TaskAcceptEffectOver():void
		{
			TweenLite.to(UI_index.indexMC_taskAccept, 2, {alpha: 0});
		}

		private static function SCMsg(p:IPacket):void
		{
			var value:PacketSCMsg2=p as PacketSCMsg2;
			Lang.showResult({tag: value.tag, arrItemequipattrs: value.arrItemequipattrs, arrItemparams: value.arrItemparams});
//			if(value.sort==1||value.sort==2||value.sort==4){
//				PubData.chat.SCSayXiTong({userid:0,username:"系统",content:value.content});	
//			}
		}

		public static function SCAlert(p:IPacket):void
		{
			var value:PacketSCAlert=p as PacketSCAlert;
			FangChenMi.getInstance().setData(value.tag);
		}

		public static function CMessage1(msg:String=null):void
		{
			msg=Lang.filterMsg(msg);
			var vec:Vector.<TextField>=msg1Vec.splice(0, 2);
			msg1Vec.push(vec[0], vec[1]);
			var txt:TextField=msg1Vec[0];
			txt.alpha=1;
			txt.y=messagey1;
			txt.htmlText=msg;
			txt.width=txt.textWidth + 20;
			txt.height=txt.textHeight + 20;
			txt.x=(600 - txt.width) / 2
			UI_index.indexMC["message"].addChild(txt)
			//TweenLite.to(txt, 3, {alpha:0,delay:5});
			TweenLite.to(txt, 2.75, {alpha: 0, delay: 4, onComplete: function(txt:TextField):void
			{
				TweenLite.killTweensOf(txt);
				txt.parent.removeChild(txt);
			}, onCompleteParams: [txt]});
			msg1Vec[1].y=messagey2;
			msg1Vec[2].y=messagey3;
		}

		/**
		 *	跑马灯
		 */
		private static function initMessage2():void
		{
			if (msg2Arr.length > 0)
			{
				var txt:TextField=UI_index.indexMC["message"]["CMessage2"]["txt"];
				txt.htmlText=msg2Arr.shift();
				txt.width=txt.textWidth + 20;
				txt.x=460;
//				txt.cacheAsBitmap=true;
			}
			else
			{
				//UI_index.instance.GameClock.instance.removeEventListener(WorldEvent.CLOCK__,message2Timer);
				run=false;
				//UI_index.indexMC["message"]["CMessage2"].visible = false;
				setVisibleByCMessage2(false);
			}
		}

		public static function message2Timer(e:Event=null):void
		{
			var txt:TextField=UI_index.indexMC["message"]["CMessage2"]["txt"];
			txt.x-=2;
			if (txt.x + txt.width < 0)
			{
				initMessage2();
			}
		}
		public static var run:Boolean=false;

		public static function CMessage2(msg:String=null):void
		{
			msg=Lang.filterMsg(msg);
			msg2Arr.push(msg);
			if (!run)
			{
				//	UI_index.instance.GameClock.instance.addEventListener(WorldEvent.CLOCK__,message2Timer);
				run=true;
				//UI_index.indexMC["message"]["CMessage2"].visible = true;
				setVisibleByCMessage2(true);
				initMessage2();
			}
		}
		// 屏幕中间提示信息[个人信息]
		private static var msgVec:Vector.<String>=new Vector.<String>;
		private static var lastTime:int;

		public static function CMessage3(msg:String=null):void
		{
			if (msg == null || msg == "")
				return;
			msg=Lang.filterMsg(msg);
			//msgVec.push(msg);
		
			if (UI_index.indexMC == null)
				return;
			
			lastTime=getTimer();
			var tf:TextField;
			if (msg3Vec.length > 0)
			{
				tf=msg3Vec.pop();
			}
			else
			{
				tf=createTFByMessage3();
			}
			if (msg == tf.htmlText)
			{
				return;
			}
			tf.htmlText=msg;
			tf.x=int((UI_index.indexMC["message"]["CMessage3"].width - tf.width) >> 1);
			tf.y=UI_index.indexMC["message"]["CMessage3"].y;
			tf.width=tf.textWidth + 20;
			tf.height=tf.textHeight + 20;
			tf.alpha=1;
			tf.cacheAsBitmap=true;
			UI_index.indexMC["message"].addChild(tf);
			UI_index.indexMC["message"].addChild(UI_index.indexMC["message"]["CMessage3"])
			TweenLite.to(tf, 2.5, {alpha: 0, y: int(tf.y - tf.height), delay: 1, onComplete: removeText, onCompleteParams: [tf]});
		}
		private static function removeText(tf:TextField):void
		{
			TweenLite.killTweensOf(tf, true);
			UI_index.indexMC["message"].removeChild(tf);
			msg3Vec.push(tf);
			
			
			//			if(UI_index.indexMC["message"]["CMessage3"].numChildren==0)UI_index.indexMC["message"].removeChild(UI_index.indexMC["message"]["CMessage3"]);
		}
		public static function createTFByMessage3():TextField
		{
			var tf:TextField;
			tf=new TextField();
			tf.selectable=false;
			tf.multiline=false;
			tf.wordWrap=false;
			tf.autoSize=TextFieldAutoSize.CENTER;
			tf.mouseWheelEnabled=false;
			tf.mouseEnabled=false;
			tf.textColor=0xFFFB80;
			tf.htmlText="";
			tf.width=tf.textWidth + 20;
			tf.height=tf.textHeight + 20;
			var tfm:TextFormat=new TextFormat();
			tfm.align=TextFormatAlign.CENTER;
			tfm.size=18;
			tfm.color=0xFFFB80;
//			tfm.font="Microsoft YaHei";
			tf.defaultTextFormat=tfm;
			var gl:GlowFilter=FilterDef.MSG3_FILTER;
			tf.filters=[gl];
			return tf;
		}
		private static var msg:String;

		


		public static var donghuaList:Vector.<DisplayObject>=new Vector.<DisplayObject>();

		public static function get dh():DisplayObject
		{
			var len:int=donghuaList.length;
			var d:DisplayObject;
			for (var i:int=0; i < len; i++)
			{
				d=donghuaList[i];

				if (d == null)
				{
					delete donghuaList[i];
				}
				else if (null == d.parent)
				{
					if (d.hasOwnProperty("mouseEnabled"))
					{
						d["mouseEnabled"]=false;
					}
					return d;
				}
			}
			d=GamelibS.getswflink("game_index", "donghuaxiaoxi");
			if (d && d.hasOwnProperty("mouseEnabled"))
			{
				d["mouseEnabled"]=false;
			}
			donghuaList.push(d);
			return d;
		}

		public static function CMessage4(msg:String):void
		{
			msg=Lang.filterMsg(msg);
			var donghua:DisplayObject=dh;
			if (donghua != null)
			{
				donghua.alpha=0;
				donghua["txt"].htmlText="<b>" + msg + "</b>";
				donghua.x=(GameIni.MAP_SIZE_W - donghua.width) / 2;
				donghua.y=(GameIni.MAP_SIZE_H - donghua.height) / 2;
				PubData.mainUI.addChild(donghua);
				//TweenLite.to(donghua, 0.5, {alpha: 1, y: donghua.y - 50, onComplete: donghuaComplete, onCompleteParams: [donghua]});
				TweenLite.to(donghua, 0.4, {alpha: 0.75, y: donghua.y - 50, onComplete: donghuaComplete, onCompleteParams: [donghua]});
			}
		}

		public static function chkC19(event:WorldEvent):void
		{
			CMessage19();
			CMessage20();
		}

		public static function CMessage19(msg:String=null):void
		{
			if (null != msg && "" != msg)
			{
				msg19.push(msg);
				return;
			}
			if (lock19)
			{
				return;
			}
			if (0 == msg19.length)
			{
				return;
			}
			if (null == msg)
			{
				msg=msg19.shift();
			}
			lock19=true;
			var txt:TextField=UI_index.indexMC["message"]["CMessage19"];
			txt.alpha=1;
			txt.y=messagey2 + 20;
			txt.htmlText=msg;
			//txt.width=txt.textWidth + 60;
			//txt.height=txt.textHeight + 20;
			//tf.x=(UI_index.indexMC["message"]["CMessage3"].width - tf.width) / 2;
			txt.x=(UI_index.indexMC["message"]["CMessage3"].width - txt.width) / 2; //(800-txt.width)/2
			UI_index.indexMC["message"].addChild(txt)
			//TweenLite.to(txt, 3, {alpha:0,delay:5});
			TweenLite.to(txt, 6, {alpha: 0, delay: 4, onComplete: function(txt:TextField):void
			{
				TweenLite.killTweensOf(txt);
				txt.parent.removeChild(txt);
				lock19=false;
			}, onCompleteParams: [txt]});
		}

		public static function CMessage20(msg:String=null):void
		{
			if (null != msg && "" != msg)
			{
				msg20.push(msg);
				return;
			}
			if (lock20)
			{
				return;
			}
			if (0 == msg20.length)
			{
				return;
			}
			if (null == msg)
			{
				msg=msg20.shift();
			}
			lock20=true;
			var txt:TextField=UI_index.indexMC["message"]["CMessage20"];
			txt.alpha=1;
			txt.y=messagey1 + 20;
			txt.htmlText=msg;
			//txt.width=txt.textWidth + 60;
			//txt.height=txt.textHeight + 20;
			txt.x=(UI_index.indexMC["message"]["CMessage3"].width - txt.width) / 2; //(800-txt.width)/2
			UI_index.indexMC["message"].addChild(txt)
			//TweenLite.to(txt, 3, {alpha:0,delay:5});
			TweenLite.to(txt, 6, {alpha: 0, delay: 6, onComplete: function(txt:TextField):void
			{
				TweenLite.killTweensOf(txt);
				txt.parent.removeChild(txt);
				lock20=false;
			}, onCompleteParams: [txt]});
		}

		private static function donghuaComplete(donghua:DisplayObject):void
		{
			//TweenLite.to(donghua, 0.5, {alpha: 0, delay: 1, y: donghua.y - 50, onComplete: donghuaComplete2, onCompleteParams: [donghua]});
			TweenLite.to(donghua, 0.4, {alpha: 0, delay: 2, y: donghua.y - 50, onComplete: donghuaComplete2, onCompleteParams: [donghua]});
		}

		private static function donghuaComplete2(donghua:DisplayObject):void
		{
			if (donghua.parent != null)
				TweenLite.killTweensOf(donghua, true);
			donghua.parent.removeChild(donghua);
		}
		private static var fight_come:MovieClip;
		private static var fight_out:MovieClip;
		//private static var auto_seek:MovieClip;
		private static var task_take:MovieClip;
		private static var task_complete:MovieClip;
		private static var booth_On:MovieClip;
		private static var find_ghost_success:MovieClip;
		private static var find_ghost_failed:MovieClip;
		private static var lvl_up:MovieClip;

		public static function showLvlUp():void
		{
			var do_:DisplayObject=PubData.mainUI.Layer5.getChildByName("lvl_up");
			if (do_ != null)
				PubData.mainUI.Layer5.removeChild(do_);
			if (null == lvl_up)
			{
				lvl_up=GamelibS.getswflink("game_index", "effect_lvl_up_ui") as MovieClip;
				if (null != lvl_up)
				{
					lvl_up.name="lvl_up";
				}
				else
				{
					return;
				}
			}
			do_=lvl_up;
			//do_.width
			do_.x=(GameIni.MAP_SIZE_W - 412) / 2;
			do_.y=140;
			PubData.mainUI.Layer5.addChild(do_);
			(do_ as MovieClip).gotoAndStop(1);
			(do_ as MovieClip).play();
			TweenLite.delayedCall(1.5, showLvlUpComplete);
		}

		public static function showLvlUpComplete():void
		{
			var do_:DisplayObject=PubData.mainUI.Layer5.getChildByName("lvl_up");
			if (do_ != null)
			{
				PubData.mainUI.Layer5.removeChild(do_);
				(do_ as MovieClip).gotoAndStop(1);
			}
		}

		/**
		*增加状态显示   1：进入战斗 2：脱离战斗 3：自动寻路 4：接受任务 5：任务完成 6:摆摊中 7:找到鬼 8:没找到鬼
		*/
		public static function showState(type:int):void
		{
			var do_:DisplayObject=PubData.mainUI.Layer5.getChildByName("show_state");
			if (do_ != null)
				PubData.mainUI.Layer5.removeChild(do_);
			switch (type)
			{
				case 1:
					if (null == fight_come)
					{
						fight_come=GamelibS.getswflink("game_index", "fight_ComeOn") as MovieClip;
						if (null != fight_come)
						{
							fight_come.name="show_state";
						}
					}
					do_=fight_come;
					break;
				case 2:
					if (null == fight_out)
					{
						fight_out=GamelibS.getswflink("game_index", "fight_GameOver") as MovieClip;
						if (null != fight_come)
						{
							fight_out.name="show_state";
						}
					}
					do_=fight_out;
					break;
//				case 3:
//					if(null==auto_seek){
//						auto_seek = GamelibS.getswflink("game_login","te_xun_lu") as MovieClip;
//						auto_seek.name = "show_state";
//					}
//					do_ = auto_seek;
//					break;
				//////////			DataCenter.myking.king.setAutoPath(true);
				case 4:
					if (null == task_take)
					{
						//task_take=GamelibS.getswflink("game_login", "te_jie_shou") as MovieClip;
						task_take=GamelibS.getswflink("game_index", "te_jie_shou") as MovieClip;
						if (null != task_take)
						{
							task_take.name="show_state";
						}
					}
					do_=task_take;
					break;
				case 5:
					if (null == task_complete)
					{
						//task_complete=GamelibS.getswflink("game_login", "te_wan_cheng") as MovieClip;
						task_complete=GamelibS.getswflink("game_index", "te_wan_cheng") as MovieClip;
						if (null != task_complete)
						{
							task_complete.name="show_state";
						}
					}
					do_=task_complete;
					break;
				case 6:
					if (null == booth_On)
					{
						booth_On=GamelibS.getswflink("game_index", "booth_On") as MovieClip;
						if (null != booth_On)
						{
							booth_On.name="show_state";
						}
					}
					do_=booth_On;
					break;
				case 7:
					if (null == find_ghost_success)
					{
						find_ghost_success=GamelibS.getswflink("game_index", "find_ghost_success") as MovieClip;
						if (null != find_ghost_success)
						{
							find_ghost_success.name="show_state";
						}
					}
					do_=find_ghost_success;
					break;
				case 8:
					if (null == find_ghost_failed)
					{
						find_ghost_failed=GamelibS.getswflink("game_index", "find_ghost_failed") as MovieClip;
						if (null != find_ghost_failed)
						{
							find_ghost_failed.name="show_state";
						}
					}
					do_=find_ghost_failed;
					break;
			}
			if (null == do_)
			{
				return;
			}
			PubData.mainUI.Layer5.addChild(do_);
			(do_ as MovieClip).gotoAndStop(1);
			do_.x=(GameIni.MAP_SIZE_W - do_.width) / 2;
			do_.y=140;
			(do_ as MovieClip).play();
		}

		//删除状态显示
		public static function deleteState(type:int):void
		{
			switch (type)
			{
				case 1:
					if (fight_come != null && PubData.mainUI.Layer5.contains(fight_come))
					{
						PubData.mainUI.Layer5.removeChild(fight_come);
					}
					break;
				case 2:
					if (fight_out != null && PubData.mainUI.Layer5.contains(fight_out))
					{
						PubData.mainUI.Layer5.removeChild(fight_out);
					}
					break;
//				case 3:
//					if(auto_seek!=null&&PubData.mainUI.Layer5.contains(auto_seek)){
//						PubData.mainUI.Layer5.removeChild(auto_seek);
//					}
//					break;
				case 4:
					if (task_take != null && PubData.mainUI.Layer5.contains(task_take))
					{
						PubData.mainUI.Layer5.removeChild(task_take);
					}
					break;
				case 5:
					if (task_complete != null && PubData.mainUI.Layer5.contains(task_complete))
					{
						PubData.mainUI.Layer5.removeChild(task_complete);
					}
					break;
				case 6:
					if (booth_On != null && PubData.mainUI.Layer5.contains(booth_On))
					{
						PubData.mainUI.Layer5.removeChild(booth_On);
					}
					break;
				case 7:
					if (find_ghost_success != null && PubData.mainUI.Layer5.contains(find_ghost_success))
					{
						PubData.mainUI.Layer5.removeChild(find_ghost_success);
					}
					break;
				case 8:
					if (find_ghost_failed != null && PubData.mainUI.Layer5.contains(find_ghost_failed))
					{
						PubData.mainUI.Layer5.removeChild(find_ghost_failed);
					}
					break;
			}
		}

		private static function SCPrizeMsgList(p:PacketSCPrizeMsgList):void
		{
			setTimeout(function():void
			{
				var len:uint=p.arrItemlist.length;
				for (var i:int=0; i < len; i++)
				{
					addPrizeIcon(p.arrItemlist[i]);
				}
			}, 3000);
		}

		private static function addPrizeIcon(spmi:StructPrizeMsgInfo2):void
		{
			var msg:String=spmi.msg;
			if (msg == "")
			{
				if (spmi.tag == 0)
				{
					msg="";
				}
				else
				{
					msg=Lang.getServerMsg(spmi.tag).msg;
				}
			}
			var type:int=spmi.tag;
			var func:Function=getPrize;
			if (type == 5)
			{
			}
			else
			{
				type=2;
			}
			GameTip.addTipButton(func, type, msg, spmi.sn);
		}

		/**
		 *	分享
		 *  2012-11-23 andy
		 */
		public static function fenXiang(id:int):void
		{
			//steven guo 代码写在这里即可
			//通过ID获得QQ分享的配置内容
			var _QQShareResModel:Pub_QQShareResModel=XmlManager.localres.QQShareXml.getResPath(id) as Pub_QQShareResModel;
			if (null == _QQShareResModel)
			{
				return;
			}
			//desc: desc ==>> 可选。默认展示在分享弹框的输入框里的分享理由，建议传入，而且分享理由要简短而有吸引力
			var _desc:String=_QQShareResModel.qqdesc;
			//summary: summary ==>> 必须。应用简要描述。
			var _summary:String=_QQShareResModel.summary;
			//title: title ==>> 必须。分享的标题。
			var _title:String=_QQShareResModel.title;
			//pics: pics ==>> 可选。图片的URL。建议为应用的图标或者与分享相关的主题图片，规格为120*120 px
			// hosting应用要求将图片存放在APP域名下或腾讯CDN
			// non-hosting应用要求将图片上传到该应用开发者QQ号对应的QQ空间加密相册中。 
			// 即non-hosting应用图片域名必须为：qq.com、pengyou.com、qzoneapp.com、qqopenapp.com、tqapp.cn。
			var _picsURL:String=FileManager.instance.getIconQQClewBuyId(_QQShareResModel.pics);
			//context: context ==>> 可选。透传参数，用于onSuccess回调时传入的参数，用于识别请求。
			var _context:String="";
			//AsToJs.instance.callJS_tweet("tweet",_desc,_summary,_title,_picsURL,_context);
			//0010819: 【腾讯版本特有】分享接口更新
			//function sendStory(title, summary, msg, img, button, source, context) 
			AsToJs.instance.callJS_tweet("sendStory", _title, _summary, _desc, _picsURL, null, null, _context);
		}

		private static function getPrize(sn:int):void
		{
			if (sn == 0)
				return;
			var vo:PacketCSPrizeMsgGet=new PacketCSPrizeMsgGet();
			vo.sn=sn;
			DataKey.instance.send(vo);
		}

		private static function SCPrizeMsgGetResult(p:PacketSCPrizeMsgGetResult):void
		{
			if (p.tag != 0)
			{
				Lang.showMsg(Lang.getServerMsg(p.tag));
			}
			else
			{
				//	gamealert.ShowMsg(p.msg,2);
			}
		}

		private static function SCPrizeMsgNew(p:PacketSCPrizeMsgNew):void
		{
			addPrizeIcon(p.list);
		}

		private static function SCPrizeMsgDel(p:PacketSCPrizeMsgDel):void
		{
			GameTip.removeIcon(p.sn);
		}
	}
}
