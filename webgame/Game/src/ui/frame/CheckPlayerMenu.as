package ui.frame
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ui.base.jiaose.JiaoSeLook;
	import ui.base.shejiao.haoyou.ChatWarningControl;
	import ui.base.shejiao.haoyou.GameFindFriend;
	
	
	/**
	 * 点击玩家头像弹出菜单信息,  下拉窗中仅拥有三个功能：查看，私聊，加为好友
	 * @author steven guo
	 * 
	 */	
	public class CheckPlayerMenu extends UIWindow
	{
		private static var m_instance:CheckPlayerMenu = null;
		
		public function CheckPlayerMenu()
		{
			super(getLink(WindowName.win_CheckPlayerMenu));
		}
		
		public static function getInstance():CheckPlayerMenu
		{
			if(null == m_instance)
			{
				m_instance = new CheckPlayerMenu();
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			
			mc.addEventListener(MouseEvent.ROLL_OUT,_onCloseListener);
			mc.addEventListener(MouseEvent.CLICK,_onCloseListener);
			
			_replace();
		}
//		override protected function init():void
//		{
//			
//			
//			_replace(m_gPoint);
//		}
		
		override public function winClose():void
		{
			super.winClose();
			mc.removeEventListener(MouseEvent.ROLL_OUT,_onCloseListener);
			mc.removeEventListener(MouseEvent.CLICK,_onCloseListener);
		}
		
		override public function mcHandler(target:Object):void 
		{
			var _name:String = target.name;
			
			
			switch(_name)
			{
				case "abtn1":    //查看
					JiaoSeLook.instance().setRoleId(m_data.roleid);
					break;
				case "abtn2":    //密聊
					ChatWarningControl.getInstance().getChatPlayerInfo(m_data.roleid);
					break;
				case "abtn3":    //结交
					GameFindFriend.addFriend(m_data.rolename,1);
					break;
				default:
					break;
			}
		}
		
		private function _onCloseListener(e:MouseEvent):void
		{
			winClose();
		}
		
		public function setPosition(x:int,y:int):void
		{
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			m_gPoint.x = x - 3;
			m_gPoint.y = y - 3;
		}
		
		private var m_data:Object = null;
		public function setData(data:Object):void
		{
			m_data = data;
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function _replace():void
		{
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}

			m_lPoint = mc.parent.globalToLocal(m_gPoint);
			
			mc.x = m_lPoint.x;
			mc.y = m_lPoint.y;
		}
		
		
		
		
	}
}





