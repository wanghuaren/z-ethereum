package ui.base.login
{
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	
	import ui.frame.UIWindow;
	
	import common.managers.Lang;

	/**
	 * @author suhang
	 *create:2011-10
	 * 角色改名
	 */
	public class ChangeName extends UIWindow {
		private var func:Function=null;
		
		public function ChangeName() {
			super(getLink("pop_gai_ming","game_newrole"));
			func=act;
		}
		
		//面板点击事件
		override public function mcHandler(target:Object):void {
			super.mcHandler(target);
			switch(target.name) {
				case "btnSubmit":
					var len:int=0;
					var ba:ByteArray = new ByteArray;
					var txtLen:int = mc["txt"].text.length;
					for(var i:int=0;i<txtLen;i++){
						ba.clear();
						ba.writeUTFBytes(mc["txt"].text.charAt(i));
						if(ba.length==1){
							len++;
						}else{
							len += 2;
						}
					}
					
					if(len>12){
						alert.ShowMsg(Lang.getLabel("20012_NewRole"),2);
					}else if(len<2){
						alert.ShowMsg(Lang.getLabel("20007_NewRole"),2);
					}else{
						func(mc["txt"].text);
						winClose();
					}
					break;
			}
		}
	}
}
