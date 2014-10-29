package ui.view.view1.chat
{

	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlRes;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.clock.GameClock;
	import common.utils.component.ButtonGroup;
	
	import engine.event.DispatchEvent;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	
	import nets.packets.PacketCSGetSayEnable;
	import nets.packets.PacketCSSayEnable;
	import nets.packets.PacketSCGetSayEnable;
	
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;
	import ui.frame.WindowName;
	import ui.base.shejiao.haoyou.GameChatFriend;
	
	import world.WorldEvent;

	/**聊天禁言 机器人
	 *@author andy
	 *@version 2014-03-14
	 */
	public class ChatFilterRobot extends UIWindow
	{
		//和第几个人聊天输入验证
		private static const CHAT_INDEX:int=10; 
		//2014-03-14 防止机器人聊天,策划策略
		public static var mapChatPeople:HashMap=new HashMap() ;
		//
		public static var count:int=0;
		//回调发送信息
		private var sendmsg:String="";
		//回调用户
		private var userid:int=0;
		
		private var numA:int=0;
		private var numB:int=0;
		
		public function ChatFilterRobot()
		{
			super(getLink(WindowName.pop_chat_filter_robot));
		}

		private static var _instance:ChatFilterRobot=null;

		public static function get instance():ChatFilterRobot
		{
			if (null == _instance)
			{
				_instance=new ChatFilterRobot();
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
			
			
			rand();
		}
		
		private function rand():void{
			numA=int(Math.random()*100);
			numB=int(Math.random()*50);
			
			if(numA<=numB){
				numA=numB+50;
			}
			mc["txt_mySort"].text= numA+" - "+numB+" =";
			mc["txt_result"].text="";
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);

			switch (target.name)
			{
				case "btnSubmit":
					var result:int=mc["txt_result"].text;
					if(numA-numB==result){
						GameChatFriend.sendPrivateMsg(sendmsg,userid);
						mapChatPeople.clear();
						super.winClose();
					}else{
						rand();
						Lang.showMsg(Lang.getClientMsg("10034_chatfilter"));
					}
					break;
			}
		}
		
		/***********通讯****************/

		
		/**
		 *	是否验证 
		 */
		public function isVerify(uid:int,msg:String):Boolean{
			var ret:Boolean=false;
			if(mapChatPeople.containsKey(uid)==false){
				mapChatPeople.put(uid,uid);
				count=mapChatPeople.size();
			}
			sendmsg=msg;
			userid=uid;
			if(count%CHAT_INDEX==0){	
				return true;
			}
			
			return ret;
		}
		

		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();

		}
	}
}