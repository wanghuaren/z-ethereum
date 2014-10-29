package ui.base.shejiao.haoyou
{
	
	import engine.event.DispatchEvent;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSFriendAddS;
	
	import ui.frame.UIActMap;
	import ui.frame.UIWindow;
	import ui.base.mainStage.UI_index;


	/**
	 * 添加好友，黑名单
	 *  andy 2012-01-07
	 */
	public class GameFindFriend extends UIWindow{

		private static var _instance:GameFindFriend;
		public static function getInstance():GameFindFriend{
			if(_instance==null)
				_instance=new GameFindFriend();
			return _instance;
		}

		public function GameFindFriend() : void {
			//弹窗_添加好友
			super(getLink("pop_tian_jia"));
			
		}
		public function setType(v:int=0):void{
			type=v;
			super.open();
		}
		override protected function init():void
		{
			mc["txt_name"].text="";
			mc["txt_fail"].text="";
//			if(type==1){
//				mc["mc_title"].gotoAndStop(1);
//			}else if(type==4){
//				mc["mc_title"].gotoAndStop(2);
//			}
			super.sysAddEvent(UI_index.UIAct,UIActMap.EVENT_FRIEND_ADD_SUCCESS,addSuccess);
		}

		override public function mcHandler(target : Object) : void {
			switch(target.name) {
				case "btnSubmit":
					if(mc["txt_name"].text!=""){
						addFriend(mc["txt_name"].text,type);
					}
					break;
			}
			
		}
		private function addSuccess(e:DispatchEvent=null):void{
			super.winClose();
		}
		override protected  function windowClose() : void {
			super.windowClose();

		}
		/**
		 *	添加好友【黑名单】
		 *  @param roleName 好友名字
		 *  @param tp       类型 1.好友 4.黑名单 
		 */
		public static function addFriend(roleName:String,tp:int=1):void{
			var client:PacketCSFriendAddS=new PacketCSFriendAddS();
			client.rolename=roleName;
			client.type=tp;
			DataKey.instance.send(client);
		}
	}
}
