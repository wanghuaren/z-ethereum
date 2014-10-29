package ui.view.view5.jiazu
{
	import common.config.xmlres.XmlRes;
	
	import flash.display.Sprite;
	
	import netc.packets2.StructGuildRequire2;

	public class JiaZuInfoScrollPanelItem  extends Sprite
	{
		private var m_ui:Sprite;
		
		private var m_data:StructGuildRequire2 = null;
		
		public function JiaZuInfoScrollPanelItem(ui:Sprite)
		{
			super();
			
			m_ui = ui;
			addChild(m_ui);
		}
		
		public function setData(data:StructGuildRequire2):void
		{
			m_data = data;
			
			m_ui['txt1'].text = m_data.name;
			m_ui['txt2'].text = XmlRes.GetGuildDutyName(m_data.job);
			m_ui['txt3'].text = m_data.level
			m_ui['txt4'].text = XmlRes.GetJobNameById(m_data.metier);
			m_ui['txt5'].text = m_data.faight;
			
			if(m_data.vip <= 0)
			{
				m_ui['mc_vip'].visible = false;
			}
			else
			{
				m_ui['mc_vip'].visible = true;
			}
			
			m_ui['mc_vip'].gotoAndStop(m_data.vip);
			
		}
		
		
		
		
	}
}