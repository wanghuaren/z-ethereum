package ui.view.view5.jiazu
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 * 家族设定界面 其中包括 家族公告 ，家族介绍。 家族管理员可以修改，其它家族成员只能查看
	 * @author
	 * 
	 */	
	public class JiaZuSetting extends UIWindow
	{
		private static var _instance:JiaZuSetting;
		
		
		public static function getInstance():JiaZuSetting
		{
			if(null == _instance)
			{
				_instance = new JiaZuSetting();
			}
			
			return _instance;
		}
		
		public function JiaZuSetting()
		{
			super(getLink(WindowName.win_jz_setting));
		}
		
		//面板初始化
		override protected function init():void 
		{
			JiaZuModel.getInstance();
			
			if(null == mc)
			{
				return ;
			}
			//初始化的时候 根据当前玩家权限控制 是否可以修改
			var _Duty:int =  Data.myKing.Guild.GuildDuty;
			
			
			//1 - 申请中 2 - 族员 3 - 副族长 4 - 族 长
			if(_Duty <= 2)
			{
				mc['tf_GongGao'].type = TextFieldType.DYNAMIC;
				mc['tf_JieShao'].type = TextFieldType.DYNAMIC;
			}
			else if(3 == _Duty || 4 == _Duty)
			{
				mc['tf_GongGao'].type = TextFieldType.INPUT;
				mc['tf_JieShao'].type = TextFieldType.INPUT;
			}
			
			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			
			_repaint();
		}	
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			var _Duty:int;
			
			switch(name)
			{
				case "btnSubmit":
					_Duty =  Data.myKing.Guild.GuildDuty;
					if(3 == _Duty || 4 == _Duty)
					{
						JiaZuModel.getInstance().requestGuildSetText(mc['tf_GongGao'].text,mc['tf_JieShao'].text);
					}
					else
					{
						winClose();
					}
					
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
				case JiaZuEvent.JZ_GUILD_SET_TEXT_SUCCESS_EVENT:
					winClose();
					break;
			}
			
			
		}
		
		
		private function _repaint():void
		{
			mc['tf_GongGao'].text = Data.jiaZu.GetGuildMoreInfo().bull;
				
			mc['tf_JieShao'].text = Data.jiaZu.GetGuildMoreInfo().desc;
		}
		
	}
}













