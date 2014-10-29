package ui.base.login
	import flash.display.DisplayObject;

	import ui.frame.UIWindow;
	/**
	 * @author suhang
	 *create:2011-10
	 * 删除角色
	 */
	public class Delete extends UIWindow {
		private var func:Function=null;

		public function Delete(act:Function,layer:int=1) {
			super(getLink("pop_shan_chu ","game_newrole"),layer);
			func=act;
		}

		//面板点击事件
		override public function mcHandler(target:Object):void {
			super.mcHandler(target);
			switch(target.name) {
				case "btnSubmit":
				//	if(mc["txt"].text.toLowerCase()=="delete") {
						func();
						winClose();
				//	}
					break;
			}
		}
	}
}
