package ui.component
{
	import engine.load.GamelibS;
	import engine.utils.HashMap;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 下拉菜单组件
	 * @author Steven Guo
	 * 
	 */	
	public class XHComboBox extends EventDispatcher
	{
		
		private var m_ui:MovieClip = null;
		private var m_list:Array = null;
		private var m_selected:int = 0;
		private var m_panel:MovieClip = null;
		private var m_panel_parent:MovieClip = null;
		
		public function XHComboBox(ui:MovieClip)
		{
			m_ui = ui;
			_initCom();
		}
		
		private function _initCom():void
		{
			m_ui['btn'].addEventListener(MouseEvent.CLICK,_btnClick);
			m_ui.addEventListener(MouseEvent.MOUSE_OUT,_uiOut);
			m_panel = m_ui['mcPanel'];
			m_panel.visible = false;
			m_panel_parent = m_panel.parent as MovieClip;
			//m_panel_parent.removeChild(m_panel);
			
		}
		
		private var m_click:int = 0;
		private function _btnClick(e:MouseEvent=null):void
		{
			//显示
			if(0 == m_click)
			{
				m_click = 1;
				m_panel.visible = true;
				//_panel_parent.addChild(m_panel);
			}
			//关闭菜单
			else
			{
				m_click = 0;
				m_panel.visible = false;
				//m_panel_parent.removeChild(m_panel);
//				if(null != m_panel && null != m_panel.parent)
//				{
//					m_panel.parent.removeChild(m_panel);
//				}
			}
		}
		
		
		private function _uiOut(e:MouseEvent=null):void
		{
			if(null != m_panel && null != m_panel.parent)
			{
				m_panel.parent.removeChild(m_panel);
			}
		}
		
		
		public function set items(list:Array):void
		{
			m_list = list;
			
			while(m_panel.numChildren > 0)
			{
				m_panel.removeChildAt(0);
			}
			
			if(null == m_list)
			{
				return ;
			}
			
			var _item:XHComboBoxItem = null;
			var _itemH:int = 0;
			var _len:int = m_list.length;
			for(var i:int = 0 ;i < _len; ++i)
			{
				_item = _getItem(i);
				_item.y = i * _item.height;
				_itemH = _item.height;
				_item.setValue(m_list[i]);
				_item.setCallback(_callback);
				m_panel.addChild(_item);
			}
			
			m_panel['mcBg'].height = _itemH * _len;
			
		}
		
		public function get items():Array
		{
			return m_list;
		}
		
		public function set selected(idx:int):void
		{
			if(idx != m_selected)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
				m_selected = idx;
			}
		}
		
		public function get selected():int
		{
			return m_selected;
		}
	
		
		private var m_arrItems:HashMap=null;
		private function _getItem(index:int):XHComboBoxItem
		{
			if(null == m_arrItems)
			{
				m_arrItems = new HashMap();
			}
			if(index>=4) return null;
			var _item:XHComboBoxItem = null;
			if (m_arrItems.containsKey(index))
			{
				_item = m_arrItems.get(index);
				return _item;
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass('game_index2', "Gameplugin_XHComboBoxItem");
				if (null == c)
				{
					return null;
				}
				var sp:Sprite=new c() as Sprite;
				_item=new XHComboBoxItem(sp);
				_item.setIndex(index);
				_item.mouseChildren=false;
				
				m_arrItems.put(index, _item);
				return _item;
			}
		}
		
		
		private function _callback(idx:int):void
		{
			m_panel.visible = false;
			//m_panel_parent.removeChild(m_panel);
//			if(null != m_panel && null != m_panel.parent)
//			{
//				m_panel.parent.removeChild(m_panel);
//			}
		}
		
	}
	
	
}









