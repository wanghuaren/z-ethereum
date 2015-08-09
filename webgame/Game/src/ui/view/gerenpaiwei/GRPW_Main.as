package ui.view.gerenpaiwei
{
	import flash.display.DisplayObject;
	
	import model.gerenpaiwei.GRPW_Model;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.npc.NpcShop;
	
	
	
	/**
	 * 个人排位赛的主窗口 
	 * @author steven guo
	 * 
	 */	
	public class GRPW_Main extends UIWindow
	{
		private static const GRPW_NPCSHOP_ID:int = 70200011;
		
		private static var m_instance:GRPW_Main;
		
		private var m_selected:int = 1;
		
		private var m_p_1:GRPW_P_1 = null;
//		private var m_p_2:GRPW_P_2 = null;
//		private var m_p_3:GRPW_P_3 = null;
//		private var m_p_4:GRPW_P_4 = null;
		
		private var m_model:GRPW_Model = null;
		
		public function GRPW_Main()
		{
			blmBtn = 4;
			super(getLink(WindowName.win_jing_ji_sai_shi));
			
			m_model = GRPW_Model.getInstance();
		}
		
		override public function get height():Number{
			return 627;
		}
		public static function getInstance():GRPW_Main
		{
			if (null == m_instance)
			{
				m_instance= new GRPW_Main();
			}
			
			return m_instance;
		}
		
		
		
		
		override protected function init():void 
		{
			super.init();
			
			if(null == m_p_1)
			{
				m_p_1 = new GRPW_P_1(mc['p_1_0'],mc['p_1_1'],mc['mcPrizeSmallPanel']);//无奖励界面  有奖励界面  奖励界面
			}
			
			m_selected = 1;
			m_p_1.visible=true;
			mcHandler({name:"cbtn"+m_selected});
		}
		
		override public function winClose():void
		{
			super.winClose();
		}
		
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
//			if("cbtn1" == target_name)
//			{
//				m_selected = 1;
//				_changePanel(m_selected);
//			}
			 if("btnNPCShop" == target_name)
			{
				NpcShop.instance().setshopId(GRPW_NPCSHOP_ID);
			}
			else
			{
				switch(m_selected)
				{
					case 1:
					
						m_p_1.mcHandler(target);
						break;
					default:
						break;
				}    
			}
		}
		
	}
	
	
	
	
}



