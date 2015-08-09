package ui.view.marry
{
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	public class MarriageTiShiWin extends UIWindow
	{
		
		private static var _instance:MarriageTiShiWin = null;
		private var name1:String;
		private var name2:String;
		
		
		public function MarriageTiShiWin()
		{
			super(getLink(WindowName.win_jie_hun_zhufu_ti_shi));
		}
		public static function getInstance():MarriageTiShiWin{
			if (_instance == null){
				_instance = new MarriageTiShiWin();
			}
			return _instance;
		}
		override protected function init():void{
			super.init();
			var msg:String = Lang.getLabel("900015_marry_alert5");//XX和XX喜结良缘，快去祝福他们获得丰厚奖励吧！
			msg = Lang.replaceParam(msg,[name1,name2]);
			mc["txt_msg"].htmlText = msg;
		}
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var target_name:String = target.name;
			
			switch (target_name){
				case "btnSubmit1":
					BlessingWin.getInstance().open();
					this.winClose();
					break;
				case "btnSubmit2":
					this.winClose();
					break;
			
			}
		}
	
		public function setName(_name1:String, _name2:String):void
		{
			// TODO Auto Generated method stub
			name1 = _name1;
			name2 = _name2;
		}
	}
}