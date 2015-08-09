package ui.view.view4.gm
{
	import common.config.GameIni;
	import common.utils.AsToJs;
	
	import flash.text.TextField;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSGmCmd;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *	游戏中程序调试的GM 
	 */
	public class GmWin extends UIWindow
	{
		public function GmWin()
		{
			super(getLink(WindowName.win_game_GM));
		}
		
		private static var _instance:GmWin;
		public static function instance():GmWin{
			if(_instance==null){
				_instance=new GmWin();
			}
			return _instance;
		}
		
		public var txt:TextField =new TextField();
		override protected function init():void
		{
			txt.text=GameIni.CONNECT_IP.toString() + ":" + GameIni.CONNECT_PORT.toString();
			txt.textColor=0xfff5d2;
			txt.x=30;txt.y=10;
			this.addChild(txt);
		}
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			var name:String=target.name;
			
			switch(name) 
			{
				case "btnCount":
					SendGmCmd("gmplayers");
					break;
				
				case "btnClear":
					mc["content"].text="";
					break;
				
				case "btnClear2":
					mc["context"].text="";
					
					break;
				
				case "btnCom":
					if (mc["context"].text.indexOf("@Gm-Release@coinup@_1_@") >= 0)
					{
						AsToJs.callJS("payment", 1);
					}
					else if (mc["context"].text != "" && mc["context"].text != "@gm-debug@")
					{
						SendGmCmd(mc["context"].text);
					}
					break;
			}
		
		}
		
		
		
		private function SubmitFunc():void
		{
			
			if(mc["content"].text!="") {
				var msg:String=mc["content"].text;
				msg=msg.split("\n").join("");
				msg=msg.replace(/<.*?>/g,"");
				
				//				msg="@gm-debug@post@"+"<font color='#"+hexValue+"'>"+msg+"@3@";
				SendGmCmd(msg);
			} else {
				//UIFactory.getMessage.Print("请输入相关内容");
			}
			
		}
		
		private function SendGmCmd(msg:String):void {
			
			var mArr:Array = msg.split('\r');
						
			for(var j:int=0;j<mArr.length;j++)
			{
				if("" != mArr[j])
				{
					var vo:PacketCSGmCmd = new PacketCSGmCmd();
					vo.msg = mArr[j];
					DataKey.instance.send(vo);
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
}