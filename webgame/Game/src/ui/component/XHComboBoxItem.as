package ui.component
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class XHComboBoxItem extends Sprite
	{
		private var m_ui:Sprite = null;
		private var m_index:int = 0;
		private var m_value:* = null;
		private var m_fn:Function = null;
		
		public function XHComboBoxItem(ui:Sprite)
		{
			//TODO: implement function
			super();
			m_ui = ui;
			m_ui.addEventListener(MouseEvent.CLICK,_onClick);
		}
		
		private function _onClick(e:MouseEvent = null):void
		{
			if(null != m_fn)
			{
				m_fn(m_index);
			}
		}
		
		public function setIndex(index:int):void
		{
			m_index = index;
			_repaint();
		}
		
		public function getIndex():int 
		{
			return m_index;
		}
		
		public function setValue(v:*):void
		{
			m_value = v;
		}
		
		public function getValue():*
		{
			return m_value;
		}
		
		private function _repaint():void
		{
			
		}
		
		public function setCallback(ck:Function):void
		{
			m_fn = ck;
		}
		
		
		
	}
	
	
}





