package common.utils {
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import display.components.ScrollContent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import scene.action.BodyAction;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view7.UI_MessagePanel3;
	
	import world.WorldEvent;
	
	
	//游戏信息输出
	public class GamePrintByShiHuang 
	{
		//
		private var panel:Sprite = null;
		
		private static var PrintMain : GamePrintByShiHuang = null;
		
		private var _width : int;
		
		private var OldTextArr : Array = [];
		//private var TextArr : Array = [];
		
		//----------------------------------------------------
		private var MaxNum : int = 5;//显示的最多条数
		//----------------------------------------------------
		
		//private var timer:int;
		//private var MOUSE_OVER:Boolean = false;
		
		private var _msgArr:Array = [];
		
		public const pointArr:Array =[80,60,40,20,0];
		
		public var sortArr:Array = [null,null,null,null,null];
		
		public function GamePrintByShiHuang() : void 
		{
			
			var GamePrintSp:Sprite = new Sprite();
			GamePrintSp.name = "GamePrintByShiHuang";
			GamePrintSp.x = -152;//
			GamePrintSp.y = 538;		
			
			UI_index.indexMC["mrt"].addChild(GamePrintSp);
			
			//_width = _this.width;
			
			_width = 340;//135;
			
			//
			panel = UI_index.indexMC["messagePanel3"];
		
			panel["msgPanBg"].alpha = 0;
			
			panel.mouseEnabled = false;
			panel.mouseChildren = false;
			
			
			//pool
			for(var i:int=0;i<MaxNum;i++)
			{
				var tf:TextField = createTf();
				
				OldTextArr.push(tf);
				
			}
			
			youXiaJiaoMsg2.instance().initDraw(panel);
		}
		
		private function createTf():TextField
		{
			var tf:TextField = new TextField();
			
			tf.width = _width;
			tf.selectable = false;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.autoSize = "left";
			tf.mouseWheelEnabled = false;				
			tf.mouseEnabled = false;				
			tf.htmlText = "";
			//tf.textColor=0xe29e47;
			//tf.textColor=0x06c907;
			tf.textColor=0x00FF00;
			
			var f:TextFormat =new TextFormat();
			f.leading=4;
			//tf.font="NSimSun";
			f.font=Lang.getLabel("pub_font");
			
			tf.defaultTextFormat = f;
			
			CtrlFactory.getUIShow().setfilters(tf);
			
			return tf;
		}
		
		
		
		private function ShowMsg(msg : String) : void 
		{
			//王聪  删除任务状态的提示框 
			//0019735: 信息提示 任务需要打怪时，打怪飘字跟获取经验信息飘字放在一个位置
			//return;
			
			if("" == msg)
			{
				return;
			}
			
			//
			if(!UI_MessagePanel3.instance.isOpen)
			{
				UI_MessagePanel3.instance.open(true);
			}
			
			
			//
			//_msgArr.push(msg);
			
			//
			youXiaJiaoMsg2.instance().addTxt(msg);
			
			
		}
		
	
		
		public static function Print(msg : String) : void 
		{		
			if(UI_index.indexMC != null) 
			{
				if(PrintMain == null)PrintMain = new GamePrintByShiHuang();
				if(PrintMain != null&&msg!=null)PrintMain.ShowMsg(msg);
			}
		}
		
		
	}
}
