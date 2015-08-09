package common.utils {
	import com.greensock.TweenLite;
	
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import display.components.ScrollContent;
	
	import flash.display.DisplayObject;
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
	public class GamePrint {
		//private var _this : MovieClip = null;
		private var _this : Sprite = null;
		
		private var panel : ScrollContent = null;
		private static var PrintMain : GamePrint = null;
		private var _width : int;
		private var OldTextArr : Array = [];
		private var TextArr : Array = [];
		
		//----------------------------------------------------
		private var MaxNum : int = 30;//显示的最多条数
		//----------------------------------------------------
	
		private var timer:int;
		private var MOUSE_OVER:Boolean = false;
		
		public function GamePrint() : void {
			
			var GamePrintSp:Sprite = new Sprite();
			GamePrintSp.name = "GamePrint";
			GamePrintSp.x = -152;
			GamePrintSp.y = 538;		
			
			//_this = UI_index.indexMC["mrt"]["GamePrint"];
			_this = GamePrintSp;
			
			UI_index.indexMC["mrt"].addChild(GamePrintSp);
			UI_index.indexMC.addChild(youXiaJiaoMsg.instance());
			
			//_width = _this.width;
			
			_width = 135;
			
			//
			panel = UI_index.indexMC["messagePanel"];
			panel.source = _this;
//			panel.scroll.alpha = 0;
//			panel.content.alpha = 0;
//			panel.bgmc.alpha = 0;
			panel.alpha = 0;
			panel.mouseChildren = true;
			
			
			//while(_this.numChildren)_this.removeChildAt(0);
			
			
			
			//pool
			for(var i:int=0;i<MaxNum;i++)
			{
				var tf:TextField = createTf();
				
				OldTextArr.push(tf);
			
			}
			
			panel.addEventListener(MouseEvent.CLICK,panelClick);
			panel.addEventListener(MouseEvent.MOUSE_OVER,MOUSE_OVER_Handler);
			panel.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_OUT_Handler);
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_HALF_OF_SECOND,timerHandle);
		}
	
		private function timerHandle(we:WorldEvent):void{
			if(TextArr!=null&&TextArr.length>0){
				var txt:TextField=TextArr.shift();
				txt.x=820;
				txt.y=-160;
				txt.alpha=1;
				UI_index.indexMC_mrb.addChild(txt);
				TweenLite.to(txt, 0.8, {alpha:.8,y:-260,onComplete: onCompelte,onCompleteParams: [txt]});
					
			}
		}
		private function onCompelte(obj:DisplayObject):void{
			TweenLite.killTweensOf(obj,true);
			if(obj!=null&&obj.parent!=null){
				obj.parent.removeChild(obj);
				OldTextArr.push(obj);
			}
		}
		
		
		private function createTf():TextField
		{
			var tf:TextField = new TextField();
			
			tf.width = _width;
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.autoSize = "left";
			tf.mouseWheelEnabled = false;				
			tf.mouseEnabled = false;				
			tf.htmlText = "";
			//tf.textColor=0xe29e47;
			//2012-11-21  策划说调成白色
			tf.textColor=0xfff5d2;
			
			var f:TextFormat =new TextFormat();
			f.leading=4;
//			tf.font="NSimSun";
			f.font=Lang.getLabel("pub_font");
			
			tf.defaultTextFormat = f;
		
			CtrlFactory.getUIShow().setfilters(tf);
			tf.cacheAsBitmap=true
			return tf;
		}
		
		private function REMOVE_TEXT_HAND(e : TimerEvent) : void {
			if(TextArr.length > 0) {
				var txt : TextField = TextArr.slice() as TextField;
				if(txt!=null&&txt.parent!=null){
					txt.parent.removeChild(txt);
					OldTextArr.push(txt);
				}	
			}
		}
		
		private function panelClick(e:MouseEvent):void
		{
						
			BodyAction.indexUI_GameMap_Mouse_Down(e);
			
		}
		
		private function MOUSE_OVER_Handler(e : Event=null) : void {
//			TweenLite.to(panel.scroll, 1, {alpha:1});
//			TweenLite.to(panel.content, 1, {alpha:1});
//			TweenLite.to(panel.bgmc, 1, {alpha:1});
			
			//TweenLite.to(panel, 1, {alpha:1});
			TweenLite.to(panel, 0.75, {alpha:1});
			if(!panel.parent)UI_index.indexMC.addChild(panel);
			MOUSE_OVER = true;
			clearTimeout(timer);
		}
		
		private function MOUSE_OUT_Handler(e : Event=null) : void {
//			TweenLite.to(panel.scroll, 4, {alpha:0});
//			TweenLite.to(panel.content, 1, {alpha:0});
//			TweenLite.to(panel.bgmc, 1, {alpha:0});
			
			//TweenLite.to(panel, 1, {alpha:0});
			TweenLite.to(panel, 0.75,{alpha:0,onComplete:remove,onCompleteParams:[panel]});
			
			MOUSE_OVER = false;
		}
		private function remove (panel:ScrollContent):void{
			TweenLite.killTweensOf(panel);
			if(panel.parent!=null)
			panel.parent.removeChild(panel);
		}
		private function ShowMsg(msg : String) : void {
			if(_this == null)return;
			
			if("" == msg)
			{
				MOUSE_OUT_Handler();
				return;
			}
			msg="<font color='#'>"+msg+"</font>";
			var txt : TextField = null;
			//---------------------------------------------------
			if(TextArr.length >= MaxNum)REMOVE_TEXT_HAND(null);
			if(OldTextArr.length > 0) {
				txt = OldTextArr.shift();
			} else {
				//txt = new TextField();
				//txt.textColor=0xCCCCCC;
				txt = createTf();
				OldTextArr.push(txt);
			}
			if(txt == null)return;
			//---------------------------------------------------
			/*txt.width = _width;
			txt.selectable = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.autoSize = "left";
			txt.mouseWheelEnabled = false;			
			txt.mouseEnabled = false;*/
			
			//txt.htmlText ="<font size='14'>"+msg+"</font>";
			//_this.addChild(txt);
			var txtStr:String ="<font size='12'>"+msg+"</font>"; 
			
			//2012-11-13 andy 策划说右下个人信息改成漂浮
			
			
			//CtrlFactory.getUIShow().setfilters(txt);
			//---------------------------------------------------
			//txt.x = 200;
			//TweenLite.to(txt, 0.5, {x:0});
			//---------------------------------------------------
			//TextArr.push(txt);
			youXiaJiaoMsg.instance().addTxt(txtStr);
//			var TW : int = 2;
//			
//			var len:int = TextArr.length - 1;
//			//for(var s : int = TextArr.length - 1;s >= 0;s--) {
//			for(var s : int = len;s >= 0;s--) {
//				var atxt : TextField = TextArr[s];
//				if(atxt != null) {
//					atxt.y = TW;
//					atxt.x = 3;
//					TW = TW + atxt.textHeight;
//				}
//			}
//			if(!MOUSE_OVER){
//				MOUSE_OVER_Handler();
//								
//				timer = setTimeout(MOUSE_OUT_Handler,10000)
//			}
//			panel.source = _this;
		}
		
		
		
		public static function Print(msg : String) : void {
			//if(UI_index.indexMC != null && UI_index.indexMC["mrt"]["GamePrint"] != null) {
			msg=Lang.filterMsg(msg);
			if(UI_index.indexMC != null) 
			{
				if(PrintMain == null)PrintMain = new GamePrint();
				if(PrintMain != null&&msg!=null)PrintMain.ShowMsg(msg);
			}
		}
	}
}
