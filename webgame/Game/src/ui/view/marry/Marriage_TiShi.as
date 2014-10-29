package ui.view.marry
{
	import common.managers.Lang;
	
	import flash.text.TextField;
	
	import nets.packets.PacketCSOppReadyMarry;

	/**
	 *收到求婚信息 打开 
	 * @author Administrator
	 * 
	 */
	public class Marriage_TiShi extends MarriageTiShiWin
	{
		
		private static var _instance:Marriage_TiShi = null;
		public function Marriage_TiShi()
		{
			super();
		}
			private var msg:String ="";//祝福界面  /花车
		override protected function init():void{
			super.init();
			mc["txt_msg"].htmlText = msg;
			mc["btnSubmit1"].label = Lang.getLabel("pub_que_ding");
			mc["btnSubmit2"].label = Lang.getLabel("pub_qu_xiao");
		}
		
		public static function getInstance():Marriage_TiShi{
			if (_instance == null){
				_instance = new Marriage_TiShi();
			}
			return _instance;
		}
		private var isok:int = 2;
		override public function mcHandler(target:Object):void{
			//super.mcHandler(target);
			var target_name:String = target.name;
			
			switch (target_name){
				case "btnSubmit1":
					isok = 1;
					break;
				case "btnSubmit2":
					isok = 2;
					break;
				
			}
			var p:PacketCSOppReadyMarry = new PacketCSOppReadyMarry();
			p.isok = isok;
			uiSend(p);
			this.winClose();
		}
		
		public function setMsg(msg:String):void
		{
			// TODO Auto Generated method stub
			this.msg = msg;
			this.open();
		}
	}
}