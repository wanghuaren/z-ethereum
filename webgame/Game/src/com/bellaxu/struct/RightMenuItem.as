package com.bellaxu.struct {
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;

	/**
	 * 右键菜单项
	 * @author BellaXu
	 */
	public class RightMenuItem 
	{
		private var data:Object = {};
		private var callback:Function = null;
		private var item:ContextMenuItem;

		public function RightMenuItem(caption:String, data:Object = null, func:Function = null, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true):void 
		{
			this.data = data;
			this.item = new ContextMenuItem(caption, separatorBefore, enabled, visible);
			if(func != null) 
			{
				callback = func;
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, clickMenuFunc);
			}
		}

		public function getContextMenuItem() : ContextMenuItem 
		{
			return item;
		}

		private function clickMenuFunc(e:ContextMenuEvent) : void 
		{
			if(callback != null)
				callback(data);
		}
	}
}
