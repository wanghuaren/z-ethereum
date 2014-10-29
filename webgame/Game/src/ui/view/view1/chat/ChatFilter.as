package ui.view.view1.chat
{

	import common.config.xmlres.XmlRes;
	
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import common.config.GameIni;
	import common.config.PubData;
	
	import netc.Data;
	
	import nets.packets.PacketCSGetSayEnable;
	import nets.packets.PacketCSSayEnable;
	import nets.packets.PacketSCGetSayEnable;
	
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.component.ButtonGroup;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.mainStage.UI_index;
	
	import common.managers.Lang;
	import world.WorldEvent;

	/**聊天禁言
	 *@author andy
	 *@version 2013-01-28
	 */
	public class ChatFilter extends UIWindow
	{
		//过滤字符
		private var arrFilterFont:Array=null;
		//验证码输错次数【只对当前打开的界面有效，下次打开又从0开始】
		private var errVerifyCount:uint=0;
		//输错几次禁言
		private const ERR_VERIFY_COUNT_MAX:int=3;
		//发送敏感字符的次数，累计
		private var filterCount:int=0;
		//发送敏感字累计次数最大值
		private var filterCountMax:int=0;
		//几个敏感字算一次
		private const FILTER_CHAT_NUMBER:int=5;
		
		//回调发送信息
		private var sendmsg:String="";
		//禁言开始时间 服务端时间 1301010101
		public var enableNum:int=0;
		//禁言多长时间 暂定60分钟
		private const FILTER_TIME:int=60;

		
		public function ChatFilter()
		{
			super(getLink(WindowName.pop_chat_filter));
		}

		private static var _instance:ChatFilter=null;

		public static function get instance():ChatFilter
		{
			if (null == _instance)
			{
				_instance=new ChatFilter();
			}
			return _instance;
		}

		// 面板初始化
		override protected function init():void
		{
			var randX:int=Math.random()*(GameIni.MAP_SIZE_W-this.width);
			var randY:int=Math.random()*(GameIni.MAP_SIZE_H-this.height);
			this.x=randX;
			this.y=randY;
			
			i=60;
			super.sysAddEvent(GameClock.instance,WorldEvent.CLOCK_SECOND,timerHandler)
			mc["txt_verify"].text= createVerify();
			mc["txt_msg"].text= "";
			mc["txt_time"].mouseEnabled=false;
			mc["txt_verify"].mouseEnabled=false;
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);

			switch (target.name)
			{
				case "btnSubmit":
					if(mc["txt_verify_input"].text==mc["txt_verify"].text){
						PubData.chat.send(sendmsg,MainChat.channel);
						filterCount=0;
						super.winClose();
					}else{
						errVerifyCount++;
						mc["txt_msg"].htmlText=Lang.getLabel("10170_chatfilter",[errVerifyCount,(ERR_VERIFY_COUNT_MAX-errVerifyCount)]);
						if(errVerifyCount>=ERR_VERIFY_COUNT_MAX){
							stopChat();
						}
						mc["txt_verify"].text= createVerify();
					}
					break;
			}
		}
		
		/***********通讯****************/
		/**
		 *	禁言 
		 */
		private function stopChat():void{
			var client:PacketCSSayEnable=new PacketCSSayEnable();
			client.enable=0;
			//单位 分钟
			client.enable_time=1;
			super.uiSend(client);
			super.winClose();
		}
		
		/**
		 *	60秒倒计时 
		 */
		private function timerHandler(te:WorldEvent):void{
			i--;
			showTime();
			if(i==0){
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
				stopChat();
			}
		}
		private function showTime():void{
			mc["txt_time"].text="("+i+Lang.getLabel("pub_miao")+")"
		}
		
		
		/**
		 *	是否验证 
		 */
		public function isVerify(msg:String):Boolean{
			var ret:Boolean=false;
			if(isSayEnabled())return ret;
			sendmsg=msg;
			if(arrFilterFont==null){
				arrFilterFont=Lang.getLabelArr("arrFilterFont");
			}
			if(isHaveFilterWord(msg))filterCount++;
			
			if(filterCount>=getWarningCountMax()){
				ret=true;
			}
			return ret;
		}
		/**
		 *	是否包含敏感字
		 *  包含三个敏感字才算一次 
		 */
		private var k:int=0;
		private var msgLen:int=0;
		private var haveFilterCount:int=0;
		private function isHaveFilterWord(msg:String):Boolean{
			var ret:Boolean=false;
			if(arrFilterFont!=null){
				msgLen=msg.length;
				haveFilterCount=0;
				for(k=0;k<msgLen;k++){
					if(arrFilterFont.indexOf(msg.charAt(k))!=-1)
						haveFilterCount++;
				}
				if(haveFilterCount>=FILTER_CHAT_NUMBER)
					ret=true;
			}
			return ret;
		}
		
		/**
		 *	发送敏感字符的最大次数 
		 *  跟玩家等级有关系
		 */
		private function getWarningCountMax():int{
			var level:int=Data.myKing.level;
			if(level<40)
				return 10;
			else if(level<45)
				return 30;
			else
				return 1000000;
		}
		/**
		 *	产生验证码 
		 */
		private function createVerify():String{
			var ret:String="";
			for(k=1;k<=4;k++){
				ret+=int(Math.random()*10)+"";
			}
			return ret;
		}
		/**
		 *	根据时间判断是否被禁言 
		 */
		private var enableDate:Date=new Date();
		private function isSayEnabled():Boolean{
			var ret:Boolean=false;
			if(enableNum==0)return ret;
			
			enableDate.fullYear=Data.date.nowDate.fullYear;
			enableDate.month=int(enableNum.toString().substr(2,2))-1;
			enableDate.date=int(enableNum.toString().substr(4,2));
			enableDate.hours=int(enableNum.toString().substr(6,2));
			enableDate.minutes=int(enableNum.toString().substr(8,2));
			var longStart:Number=enableDate.time/1000;
			var longEnd:Number=Data.date.nowDate.time/1000;
			
			if((longEnd-longStart)<FILTER_TIME*60){
				ret=true;
			}
			return ret;
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
			errVerifyCount=0;
			filterCount=0;
		}
	}
}