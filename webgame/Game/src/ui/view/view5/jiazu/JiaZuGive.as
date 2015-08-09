package ui.view.view5.jiazu
{
	import flash.display.DisplayObject;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 * 家族捐助窗口
	 * @author steven guo
	 * 
	 */	
	public class JiaZuGive extends UIWindow
	{
		private static var _instance:JiaZuGive;
		
		public function JiaZuGive()
		{
			super(getLink(WindowName.win_jz_give));
		}
		
		public static function getInstance():JiaZuGive
		{
			if(null == _instance)
			{
				_instance = new JiaZuGive();
			}
			
			return _instance;
		}
		
		//面板初始化
		override protected function init():void 
		{
			JiaZuModel.getInstance();
			
			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			
			//super.sysAddEvent(mc["txtGuild"],FocusEvent.FOCUS_IN,clearGuild);
			
			//clearGuild();
			mc['tf_money'].text = "";
		}	
		
		override public function winClose():void
		{
			JiaZuModel.getInstance().removeEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			super.winClose();
		}
		
		override public function mcHandler(target:Object):void
		{
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btnSubmit":
					JiaZuModel.getInstance().requestGuildGiveMoney(Data.myKing.Guild.GuildId,int(mc['tf_money'].text));
					break;
				case "btnCancel":
					winClose();
					break;
				default:
					break;
			}
			
		}
		
		
		public function jzEventHandler(e:JiaZuEvent):void
		{
			var sort:int = e.sort;
			switch(e.sort)
			{
				case JiaZuEvent.JZ_GUILD_GIVE_MONEY_SUCCESS_EVENT:
					winClose();
					break;
				
			}
			
			
		}
		
	}
	
	
}


