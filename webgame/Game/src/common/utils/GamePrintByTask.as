package common.utils {
	import com.greensock.TweenLite;
	
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
	
	import world.WorldEvent;
	
	
	//游戏信息输出
	public class GamePrintByTask 
	{
		//
		private var panel:Sprite = null;
		
		private static var PrintMain : GamePrintByTask = null;
		
		private var _width : int;
		
		private var OldTextArr : Array = [];
		private var TextArr : Array = [];
		
		//----------------------------------------------------
		private var MaxNum : int = 12;//显示的最多条数
		//----------------------------------------------------
		
		//private var timer:int;
		//private var MOUSE_OVER:Boolean = false;
		
		private var _msgArr:Array = [];
		
		public function GamePrintByTask() : void 
		{
			
			var GamePrintSp:Sprite = new Sprite();
			GamePrintSp.name = "GamePrintByTask";
			GamePrintSp.x = -152;//
			GamePrintSp.y = 538;		
						
			UI_index.indexMC["mrt"].addChild(GamePrintSp);
			
			//_width = _this.width;
			
			_width = 340;//135;
			
			//
			panel = UI_index.indexMC["messagePanel2"];
			
			panel["msgPanBg"].alpha = 0;
						
			panel.mouseEnabled = false;
			panel.mouseChildren = false;
			
			//pool
			for(var i:int=0;i<MaxNum;i++)
			{
				var tf:TextField = createTf();
				
				OldTextArr.push(tf);
				
			}
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,ShowMsg2);
			
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
		
//		private function REMOVE_TEXT_HAND(e : TimerEvent) : void {
//			if(TextArr.length > 0) {
//				var txt : TextField = TextArr[0] as TextField;
//				txt.parent.removeChild(txt);
//				OldTextArr.push(txt);
//				TextArr.splice(0, 1);
//			}
//		}
		
		/*private function panelClick(e:MouseEvent):void
		{
						
			BodyAction.indexUI_GameMap_Mouse_Down(e);
			
		}
		*/
		private function ShowMsg2(e:WorldEvent):void
		{
			if(_msgArr.length > 0)
			{
				var msg:String = _msgArr.shift();
				
				
				var txt : TextField = null;
				
				if(OldTextArr.length > 0) 
				{
					txt = OldTextArr[0];
					OldTextArr.splice(0, 1);
				} 
				else 
				{				
					txt = createTf();
				}
				
				//
				txt.x = 0;
				txt.y = 115;
				
				txt.alpha = 1;
				
				txt.htmlText =  msg;
				
				panel.addChild(txt);
				
				//
				//TweenLite.to(txt, 1.5, {
				//TweenLite.to(txt, 2.25, {
				TweenLite.to(txt, 0.8, {
					alpha:.8,
					y:30,
					onComplete:function ():void
					{
						txtFade(txt);
					}
				}
				);		
				
			}
			
			
		
		}
		
		
		
		private function ShowMsg(msg : String) : void 
		{
			//王聪  删除任务状态的提示框 
			//0019735: 信息提示 任务需要打怪时，打怪飘字跟获取经验信息飘字放在一个位置
			return;
			
			if("" == msg)
			{
				return;
			}
			
			_msgArr.push(msg);
			
				
			
		}
		
		public function txtFade(txt:TextField):void
		{
			TweenLite.to(txt, 
				//0.25, 
				0.1,
				{
														y:-10,
														alpha:0,
														onComplete:function ():void
														{	
															TweenLite.killTweensOf(txt,true);
															panel.removeChild(txt);
															TextArr.push(txt);
														}
													}
									);			
		}
		
		public static function Print(msg : String) : void 
		{		
			if(UI_index.indexMC != null) 
			{
				if(PrintMain == null)PrintMain = new GamePrintByTask();
				if(PrintMain != null&&msg!=null)PrintMain.ShowMsg(msg);
			}
		}
		
		
	}
}
