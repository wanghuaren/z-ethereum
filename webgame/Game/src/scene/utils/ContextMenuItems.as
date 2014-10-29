package scene.utils {
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;

	/**
	 * @author shuiyue
	 */
	public class ContextMenuItems {
		private var MenuData : Object = {};
		private var RecvFunc : Function = null;
		private var MenuItem : ContextMenuItem;

		public function ContextMenuItems(caption : String, data : Object = null,MenuFunc : Function = null,separatorBefore : Boolean = false, enabled : Boolean = true, visible : Boolean = true) : void {
			MenuData = data;
			MenuItem = new ContextMenuItem(caption, separatorBefore, enabled, visible);
			if(MenuFunc != null) {
				RecvFunc = MenuFunc;
				MenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, clickMenuFunc);
			}
		}

		public function getContextMenuItem() : ContextMenuItem {
			return MenuItem;
		}

		private function clickMenuFunc(e : ContextMenuEvent) : void {
			if(RecvFunc != null)RecvFunc(MenuData);
		}
	}
}
