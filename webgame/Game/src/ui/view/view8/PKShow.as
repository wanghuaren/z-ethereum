package ui.view.view8 {
	import flash.display.DisplayObject;
	
	import ui.frame.UIWindow;
	
	import common.managers.Lang;

	/**
	 * @author suhang
	 *create:2011-10
	 */
	public class PKShow extends UIWindow {
		private var func:Function=null;

		public function PKShow(act:Function,layer:int=1) {
			super(getLink("win_pk_ti_shi","game_newrole"),layer);
			func=act;
			mc["select1"].selected = true;
		}

		//面板点击事件
		override public function mcHandler(target:Object):void {
			super.mcHandler(target);
			switch(target.name) {
				case "btnSubmit":
					func(mc["select1"].selected,1);
					winClose();
					break;
				case "select1":
					target.selected  =! target.selected;
					break;
				case "btnclose":
					func(mc["select1"].selected,0);
					winClose();
					break;
			}
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must,type);
			
			//mc["new_guest_tip"]["tf"].text = "请点击确定";
			
			mc["new_guest_tip"]["tf"].text = Lang.getLabel("50007_PkShow");
			
			
		}
	}
}





