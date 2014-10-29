package ui.view.view1.xiaoGongNeng{
	import common.config.GameIni;
	import common.managers.Lang;

	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;


	/**
	 * 欢迎界面
	 * @author andy
	 * @date   2012-05-08
	 */
	public final class Welcome extends UIWindow {
		
		public static var _instance:Welcome;
		public static function instance():Welcome{
			if(_instance==null){
				_instance=new Welcome();
			}
			return _instance;
			
		}

		public function Welcome() {
			super(getLink(WindowName.win_girl_welcome),null,1,false);
		}

		override protected function init():void {
			super.init();
			//this.x+=200;
			//this.y+=100;
			
			this.x=(GameIni.MAP_SIZE_W - this.width) / 2;
			this.y=(GameIni.MAP_SIZE_H - this.height) / 2;
			
//			this.x=GameIni.MAP_SIZE_W / 2;
//			this.y=GameIni.MAP_SIZE_H / 2;
			
			var num:int=Data.myKing.roleID & 0xFFFFF;
//			mc["txt_num"].htmlText=Lang.getLabel("10169_welcome",[num]);
			
		}
		
		
		override public function mcHandler(target:Object):void{
			if(target.name=="btnOk"){
				GameAutoPath.seek(30100501);
				winClose();
			}
		} 

		override protected function windowClose():void{
			super.windowClose();
			
		}

		
		
	}
}




