package ui.view.view4.qq
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_QQInviteFriendResModel;
	import common.utils.StringUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import model.qq.InviteFriend;

	
	public class InviteFriendItem
	{
		
		private var m_ui:MovieClip = null;
		
		private var m_index:int = 0;
		
		private var m_config:Pub_QQInviteFriendResModel = null;
		
		private var m_model:InviteFriend = null;
	
		
		public function InviteFriendItem(ui:MovieClip,index:int)
		{
			super();
			
			m_ui = ui;
			m_index = index;
			
			//m_config = GameData.getQQInviteFriend().getResPath(m_index+1);
			m_config =  XmlManager.localres.getQQInviteFriend().getResPath(m_index+1);
			
			m_model = InviteFriend.getInstance();
		}
		
		public function update():void
		{
			if(null == m_config)
			{
				return ;
			}
			
			m_ui['tf_name'].htmlText = m_config.condition_desc;

			m_ui['tf_num'].htmlText = "×"+StringUtils.changeToTenThousand(m_config.prize_para);
			
			//奖励类型
			m_ui['mcIcon'].gotoAndStop(m_config.prize_sort);
			
			var _is:Boolean = m_model.isReceived(m_index+1);
			var _can:Boolean = m_model.canReceived(m_index+1);
			
			if(_is)
			{
				m_ui['btn'].gotoAndStop(3);
				m_ui['btn'].removeEventListener(MouseEvent.CLICK,_onClickListener);
			}
			else if(_can)
			{
				m_ui['btn'].gotoAndStop(2);
				m_ui['btn'].addEventListener(MouseEvent.CLICK,_onClickListener);
			}
			else
			{
				m_ui['btn'].gotoAndStop(1);
				m_ui['btn'].removeEventListener(MouseEvent.CLICK,_onClickListener);
			}
			m_ui.y = 158 + (m_config.view_sort_id-1) * 32;

			
			
		}
		
		
		private function _onClickListener(e:MouseEvent):void
		{
			m_model.requestPacketCSInviteQQGift(m_index+1);
			update();
		}
	}
}









