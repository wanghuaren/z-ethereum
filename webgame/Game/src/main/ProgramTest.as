package main
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.utils.CtrlFactory;
	import common.utils.Stats;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.event.KeyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.MsgEvent;
	import netc.MsgPrint;
	
	import ui.frame.UIWindow;
	import ui.view.view1.chat.MainChat;
	import ui.base.beibao.BeiBao;
	import ui.view.view4.gm.GmWin;

	/**
	 *@author wanghuaren
	 *@version 1.0 2010-4-21
	 */
	public class ProgramTest extends Sprite
	{
		private var k1:Boolean=false;
		private var k2:Boolean=false;
		private var moveBar:Sprite=null;
		public static var canBuyCount:int=0;

		//private var k2:Boolean=false;
		public function ProgramTest(DO:DisplayObject)
		{
			if (null == DO)
			{
				return;
			}

			this.addChild(DO);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			//PubData.mainUI.stage.addChild(this);

			this.visible=false;

			this.x=20;
			this.y=30;

			MsgPrint.panel=DO;
			(MsgPrint.panel["infoSendTxt"] as TextField).text="";
			(MsgPrint.panel["infoRecvTxt"] as TextField).text="";

			//测试用途
			var _testStats:Stats=Stats.getInstance();
			_testStats.x=5;
			_testStats.y=2;
			MsgPrint.panel["mc_log"].addChild(_testStats);

		}

		private static function numRefreshHandler(msgEvt:MsgEvent):void
		{
			if (null == MsgPrint.panel)
			{
				return;
			}

			var o:Object=msgEvt.data;

//			if (o.hasOwnProperty("send"))
//			{
//				(MsgPrint.panel["title1_num"] as TextField).text=o["send"];
//			}
//
//			if (o.hasOwnProperty("recv"))
//			{
//				(MsgPrint.panel["title2_num"] as TextField).text=o["recv"];
//			}
		}

		private static function dataRefreshHandler(msgEvt:MsgEvent):void
		{
			if (null == MsgPrint.panel)
			{
				return;
			}

			//
			var line:String=msgEvt.data;

			var show:Boolean=false;

			//默认不显示
			if (MsgPrint.filterPacketNameList2.length > 0)
			{
				if (MsgPrint.isFilter2(line))
				{
					return;
				}
			}

			//仅显示
			if (MsgPrint.filterPacketNameList.length > 0)
			{
				if (MsgPrint.isFilter(line))
				{
					//把过滤的信息显示出来
					show=true;
				}

			}
			else
			{
				show=true;
			}

			//发送也受限

			if (show)
			{
				(MsgPrint.panel["infoSendTxt"] as TextField).appendText(MsgPrint.isSend(line));
				(MsgPrint.panel["infoSendTxt"] as TextField).scrollV=(MsgPrint.panel["infoSendTxt"] as TextField).maxScrollV;


				//
				(MsgPrint.panel["infoRecvTxt"] as TextField).appendText(MsgPrint.isRecv(line));

				(MsgPrint.panel["infoRecvTxt"] as TextField).scrollV=(MsgPrint.panel["infoRecvTxt"] as TextField).maxScrollV;

			}
		}



		public function INFO_FROM_S(e:DispatchEvent):void
		{
			//			mc["txtOrderResult"].text+=e.getInfo+"\n";		
			//			if(mc["txtOrderResult"].multiline > 100) {
			//				mc["txtOrderResult"].text="";
			//			}
			if (this.visible)
			{
				//]+X:显示一条交互数据
				//]+A:显示全部交互数据
				//]+S:显示点击对象和调用面板名称
				//]+Q:无间隔快速发言
				//]+D:把背包中物品全部清除(非调试状态慎用)
				//以上显示类功能,按第一下为开,第二下为关
				//mc["taCSInfo"].text+=e.getInfo+"\n";	
				//if(mc["taCSInfo"].multiline > 200) {
				//	mc["taCSInfo"].text="";
				//}
			}
		}

		public function INFO_TO_S(e:DispatchEvent):void
		{
			if (this.visible)
			{
				//mc["taCSInfo"].text+=e.getInfo+"\n";		
				//if(mc["taCSInfo"].multiline > 200) {
				//	mc["taCSInfo"].text="";
				//}
			}
		}

		private function sendTxtScroll(e:Event):void
		{
			var tf:TextField=e.target as TextField;

			(MsgPrint.panel["infoRecvTxt"] as TextField).scrollV=tf.scrollV;

		}

		private function btnFilterResetClick(e:MouseEvent):void
		{
			var i:int;
			var len:int=MsgPrint.filterPacketNameList.length;

			for (i=0; i < len; i++)
			{
				MsgPrint.filterPacketNameList.pop();
			}

			// 
			CtrlFactory.getUIShow().comboboxFill(MsgPrint.panel["filterPacketList"], MsgPrint.filterPacketNameListToObj(), {label: "label"});
		}

		private function btnRightClick(e:MouseEvent):void
		{
			MsgPrint.panel["mc_log"].visible=!MsgPrint.panel["mc_log"].visible;
		}

		private function btnCopyRecvClick(e:MouseEvent):void
		{

			StringUtils.copyFont((MsgPrint.panel["infoRecvTxt"] as TextField).text);

		}

		private function btnCopySendClick(e:MouseEvent):void
		{

			StringUtils.copyFont((MsgPrint.panel["infoSendTxt"] as TextField).text);

		}

		private function btnFilterReset2Click(e:MouseEvent):void
		{
			var i:int;
			var len:int=MsgPrint.filterPacketNameList2.length;

			for (i=0; i < len; i++)
			{
				MsgPrint.filterPacketNameList2.pop();
			}

			// 
			CtrlFactory.getUIShow().comboboxFill(MsgPrint.panel["filterPacketList2"], MsgPrint.filterPacketNameList2ToObj(), {label: "label"});
		}

		private function btnFilterAddClick(e:MouseEvent):void
		{
			var filterPacketName:String=(MsgPrint.panel["filterPacketNameInput"] as TextField).text;

			if ("" == filterPacketName)
			{
				return;
			}

			if (!MsgPrint.hasFilter(filterPacketName))
			{
				MsgPrint.filterPacketNameList.push(filterPacketName);

				(MsgPrint.panel["filterPacketNameInput"] as TextField).text="";

				// 
				CtrlFactory.getUIShow().comboboxFill(MsgPrint.panel["filterPacketList"], MsgPrint.filterPacketNameListToObj(), {label: "label"});


			}
		}


		private function btnFilterAdd2Click(e:MouseEvent):void
		{
			var filterPacketName:String=(MsgPrint.panel["filterPacketNameInput2"] as TextField).text;

			if ("" == filterPacketName)
			{
				return;
			}

			if (!MsgPrint.hasFilter2(filterPacketName))
			{
				MsgPrint.filterPacketNameList2.push(filterPacketName);

				(MsgPrint.panel["filterPacketNameInput2"] as TextField).text="";

				// 
				CtrlFactory.getUIShow().comboboxFill(MsgPrint.panel["filterPacketList2"], MsgPrint.filterPacketNameList2ToObj(), {label: "label"});


			}
		}

		private function recvTxtScroll(e:Event):void
		{
			var tf:TextField=e.target as TextField;

			(MsgPrint.panel["infoSendTxt"] as TextField).scrollV=tf.scrollV;

		}

		private function keyDownListener(e:KeyboardEvent):void
		{
			//Debug.instance.traceMsg(e.keyCode);
			if (e.keyCode == 187)
			{
				//+ 两个地方要修改,还有下面的
				k1=true;
			}
			else if (k1 && (e.keyCode == 191))
			{
				//?
				//mc["taCSInfo"].text="";
				MonsterDebugger.initialize(Main.instance());

				this.visible=!this.visible;
				MsgPrint.printOpen=this.visible;

				if (this.visible)
				{
					this.scaleX=1;
					this.scaleY=1;

					GameIni.MsgPrintOpen=true;
					GameIni.MonitorOpen=true;

					// 
					CtrlFactory.getUIShow().comboboxFill(MsgPrint.panel["filterPacketList"], MsgPrint.filterPacketNameListToObj(), {label: "label"});

					CtrlFactory.getUIShow().comboboxFill(MsgPrint.panel["filterPacketList2"], MsgPrint.filterPacketNameList2ToObj(), {label: "label"});

					(MsgPrint.panel["infoSendTxt"] as TextField).text="";
					(MsgPrint.panel["infoRecvTxt"] as TextField).text="";

//					(MsgPrint.panel["title1_num"] as TextField).text=DataKey.instance.socket.SEND.toString();
//					(MsgPrint.panel["title2_num"] as TextField).text=DataKey.instance.socket.RECV.toString();

					if (MsgPrint.panel.hasOwnProperty("title3"))
					{
						(MsgPrint.panel["title3"] as TextField).text=GameIni.SELECT_GAME_TYPE + "," + DataKey.instance.ServerVersion;
					}

					if (MsgPrint.panel.hasOwnProperty("title4"))
					{
						var now:Date=Data.date.nowDate;

						(MsgPrint.panel["title4"] as TextField).text=now.fullYear.toString() + "-" + (now.month + 1).toString() + "-" + now.date.toString() + " " + now.hours.toString() + ":" + now.minutes.toString();
					}

					if (MsgPrint.panel.hasOwnProperty("title5"))
					{
						(MsgPrint.panel["title5"] as TextField).text=GameIni.CONNECT_IP.toString() + ":" + GameIni.CONNECT_PORT.toString();
					}


					(MsgPrint.panel["infoSendTxt"] as TextField).addEventListener(Event.SCROLL, sendTxtScroll);
					(MsgPrint.panel["infoRecvTxt"] as TextField).addEventListener(Event.SCROLL, recvTxtScroll);

					(MsgPrint.panel["infoRecvTxt"] as TextField).addEventListener(Event.SCROLL, recvTxtScroll);


					MsgPrint.panel["btnFilterAdd"].addEventListener(MouseEvent.CLICK, btnFilterAddClick);
					MsgPrint.panel["btnFilterReset"].addEventListener(MouseEvent.CLICK, btnFilterResetClick);

					MsgPrint.panel["btnFilterAdd2"].addEventListener(MouseEvent.CLICK, btnFilterAdd2Click);
					MsgPrint.panel["btnFilterReset2"].addEventListener(MouseEvent.CLICK, btnFilterReset2Click);

					//var x:DisplayObject = MsgPrint.panel;

					if (MsgPrint.panel.hasOwnProperty("btnRight"))
					{
						MsgPrint.panel["btnRight"].addEventListener(MouseEvent.CLICK, btnRightClick);
						MsgPrint.panel["mc_log"].visible=false;
					}

					if (MsgPrint.panel.hasOwnProperty("btnCopyRecv"))
					{
						MsgPrint.panel["btnCopyRecv"].addEventListener(MouseEvent.CLICK, btnCopyRecvClick);

					}

					if (MsgPrint.panel.hasOwnProperty("btnCopySend"))
					{
						MsgPrint.panel["btnCopySend"].addEventListener(MouseEvent.CLICK, btnCopySendClick);

					}
					MsgPrint.panel.addEventListener(MsgEvent.MSG_EVENT_DATA_REFRESH, dataRefreshHandler);
					MsgPrint.panel.addEventListener(MsgEvent.MSG_EVENT_NUM_REFRESH, numRefreshHandler);

					MsgPrint.showStopPoint=true;
					//
					PubData.mainUI.stage.addChild(this);

					//PubData.socket.send(null,"INFO_FROM_S",INFO_FROM_S);
					//PubData.socket.send(null,"INFO_TO_S",INFO_TO_S);
					this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

					this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
					if (moveBar == null)
					{
						moveBar=CtrlFactory.getUICtrl().getRect(this.width, 25, 0xffffff, 0);
						this.addChild(moveBar);
						moveBar.y=5;
						moveBar.x=0;
						moveBar.name="moveBar";
						moveBar.mouseChildren=false;
					}
				}
				else
				{

					//
					GameIni.MsgPrintOpen=false;
					GameIni.MonitorOpen=false;
					PubData.mainUI.stage.removeChild(this);
					(MsgPrint.panel["infoSendTxt"] as TextField).text="";
					(MsgPrint.panel["infoRecvTxt"] as TextField).text="";

					MsgPrint.panel.removeEventListener(MsgEvent.MSG_EVENT_DATA_REFRESH, dataRefreshHandler);
					MsgPrint.panel.removeEventListener(MsgEvent.MSG_EVENT_NUM_REFRESH, numRefreshHandler);

					MsgPrint.showStopPoint=false;
					MsgPrint.panel["btnFilterAdd"].removeEventListener(MouseEvent.CLICK, btnFilterAddClick);
					MsgPrint.panel["btnFilterReset"].removeEventListener(MouseEvent.CLICK, btnFilterResetClick);

					MsgPrint.panel["btnFilterAdd2"].removeEventListener(MouseEvent.CLICK, btnFilterAdd2Click);
					MsgPrint.panel["btnFilterReset2"].removeEventListener(MouseEvent.CLICK, btnFilterReset2Click);


					//PubData.socket.removeEvent(this);
					this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

					this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				}

			}
			else if (k1 && (e.keyCode == 88))
			{
				//x
				PubData.sockRSShow=!PubData.sockRSShow;
			}
			else if (k1 && (e.keyCode == 65))
			{
				//a
				PubData.sockRSShowALL=!PubData.sockRSShowALL;
			}
			else if (k1 && (e.keyCode == 81))
			{
				//q
				MainChat.chatQuk=!MainChat.chatQuk;
			}
			else if (k1 && (e.keyCode == 83))
			{
				//s
				if(ProgramTest.canBuyCount==0){
					ProgramTest.canBuyCount=1000;
				}else{
					ProgramTest.canBuyCount=0;
				}
			}
			else if (k1 && (e.keyCode == 68))
			{
				//d
				return;
				BeiBao.delAll();
				k2=false;
			}
			else if (k1 && (e.keyCode == 48))
			{
				// 0
				GmWin.instance().open();
			}
		}

		private function keyUpListener(e:KeyboardEvent):void
		{
			if (e.keyCode == 187)
			{
				//+
				k1=false;
			}
		}

		private function mouseDownHandler(e:Event):void
		{
			switch (e.target.name)
			{
				case "moveBar":
					e.target.parent.startDrag();
					break;
				default:
			}
		}

		private function mouseUpHandler(e:Event):void
		{
			switch (e.target.name)
			{
				case "moveBar":
					e.target.parent.stopDrag();
					break;
				default:
			}
		}
//		override public function mcHandler(target:Object):void {
//			//面板点击事件
//			super.mcHandler(target);
//			switch(target.name) {
//				case "btnRun":
//					var str:String=mc["txtOrder"];
//					var SF:String=str.substr(0,str.indexOf(" "));
//					
//					break;
//			}
//		}

	}
}
