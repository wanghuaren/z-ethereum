package common.managers {
	
	
	import com.bellaxu.mgr.KeyboardMgr;
	
	import common.config.GameIni;
	import common.config.PubData;
	
	import engine.event.KeyEvent;
	import engine.utils.Debug;
	
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.utils.*;
	
	import netc.Data;
	
	import scene.action.Action;
	
	import ui.base.mainStage.UI_index;
	import ui.frame.UIWindowManager;


	//public class GameKeyBoard extends UIMovieClip {
	public class GameKeyBoard extends EventDispatcher {
		private static var keytime : int = getTimer();
		public static var hotKeyEnabled : Boolean = true;
		private static var keyDelayTimer:Timer = new Timer(50,2);

		public function GameKeyBoard() : void {
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN, BOARD_KEY_DOWN);
			PubData.mainUI.stage.addEventListener(FocusEvent.FOCUS_IN, FOCUS_IN);
			PubData.mainUI.stage.addEventListener(FocusEvent.FOCUS_OUT, FOCUS_OUT);
			PubData.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP, BOARD_KEY_UP);
		}

		private function BOARD_KEY_UP(e : KeyboardEvent) : void {
			KeyboardMgr.getInstance().onKeyUp(e);
			var isKey : Boolean = false;
			var keyCode : String = "key_" + e.keyCode;
			switch(keyCode) {
				case KeyEvent.KEY_SHIFT:
					isKey = true;
					break;
			}
			if (isKey) PubData.mainUI.stage.dispatchEvent(new KeyEvent(KeyEvent.KEY_UP, keyCode));
		}

		private function FOCUS_IN(e : FocusEvent) : void {
			// Debug.instance.traceMsg(e.target);
			if (e.target is TextField) {
				KeyEvent.Enabled = false;
			} else {
				// fux_
			}
		}

		private function FOCUS_OUT(e : FocusEvent) : void {
			if (e.target is TextField) {
				KeyEvent.Enabled = true;
			}
		}

		public static function RestTime() : void {
			keytime = getTimer() - 250;
		}

		private function BOARD_KEY_DOWN(e : KeyboardEvent) : void {
			KeyboardMgr.getInstance().onKeyDown(e);
			if (KeyboardMgr.getInstance().shiftKeyIsDown())
			{
				Action.instance.fight.followUpPlayer();
			}
			if (PubData.mainUI.stage.focus is TextField){
				return;
			}
			if (!hotKeyEnabled) {
				return;
			}
			if (getTimer() - keytime < GameIni.KEYDOWNDELAY && e.keyCode != 192) {
				return;
			} else {
				keytime = getTimer();
			}
			// -------------
			//var focusObject : Object = new FocusManager(PubData.mainUI.stage).getFocus();
			
			var focusObject : Object = UIWindowManager.getInstance().GetFocusManager().getFocus();
			
			if (focusObject is TextField) {
				return;
			}
			if (Data.myKing.king != null && Data.myKing.king.hp <= 0) {
				return;
			}
			// -------------
			// if(!KeyEvent.Enabled)return;
			var isKey : Boolean = false;

			// fux_关闭输入法，获取正确的键值
			try {
				if (Capabilities.hasIME) {
					IME.enabled = false;
				}
			} catch(err : Error) {
				Debug.instance.traceMsg(err.message + " line:95 func:BOARD_KEY_DOWN");
			}

			var keyCode : String = "key_" + e.keyCode;
			switch(keyCode) {
				case KeyEvent.KEY_0:
					isKey = true;
					break;
				case KeyEvent.KEY_1:
					isKey = true;
					break;
				case KeyEvent.KEY_2:
					isKey = true;
					break;
				case KeyEvent.KEY_3:
					isKey = true;
					break;
				case KeyEvent.KEY_4:
					isKey = true;
					break;
				case KeyEvent.KEY_5:
					isKey = true;
					break;
				case KeyEvent.KEY_6:
					isKey = true;
					break;
				case KeyEvent.KEY_7:
					isKey = true;
					break;
				case KeyEvent.KEY_8:
					isKey = true;
					break;
				case KeyEvent.KEY_9:
					isKey = true;
					break;
				case KeyEvent.KEY_A:
					isKey = true;
					break;
				case KeyEvent.KEY_B:
					isKey = true;
					break;
				case KeyEvent.KEY_C:
					isKey = true;
					break;
				case KeyEvent.KEY_D:
					isKey = true;
					break;
				case KeyEvent.KEY_E:
					isKey = true;
					break;
				case KeyEvent.KEY_F:
					isKey = true;
					break;
				case KeyEvent.KEY_G:
					isKey = true;
					break;
				case KeyEvent.KEY_H:
					isKey = true;
					break;
				case KeyEvent.KEY_I:
					isKey = true;
					break;
				case KeyEvent.KEY_J:
					isKey = true;
					break;
				case KeyEvent.KEY_K:
					isKey = true;
					break;
				case KeyEvent.KEY_L:
					isKey = true;
					break;
				case KeyEvent.KEY_M:
					isKey = true;
					break;
				case KeyEvent.KEY_N:
					isKey = true;
					break;
				case KeyEvent.KEY_O:
					isKey = true;
					break;
				case KeyEvent.KEY_P:
					isKey = true;
					break;
				case KeyEvent.KEY_Q:
					isKey = true;
					break;
				case KeyEvent.KEY_R:
					isKey = true;
					break;
				case KeyEvent.KEY_S:
					isKey = true;
					break;
				case KeyEvent.KEY_T:
					isKey = true;
					break;
				case KeyEvent.KEY_U:
					isKey = true;
					break;
				case KeyEvent.KEY_V:
					isKey = true;
					break;
				case KeyEvent.KEY_W:
					isKey = true;
					break;
				case KeyEvent.KEY_X:
					isKey = true;
					break;
				case KeyEvent.KEY_Y:
					isKey = true;
					break;
				case KeyEvent.KEY_Z:
					isKey = true;
					break;
				case KeyEvent.KEY_ESC:
					isKey = true;
					break;
				case KeyEvent.KEY_ENTER:
					isKey = true;
					break;
				case KeyEvent.KEY_ヘ:
					isKey = true;
				case KeyEvent.KEY_SPACE:
					isKey = true;
					break;
				case KeyEvent.KEY_CTRL:
					isKey = true;
					break;
				case KeyEvent.KEY_SHIFT:
					isKey = true;
					break;
				case KeyEvent.KEY_TAB:
					isKey = true;
					break;
				case KeyEvent.KEY_FenHao:
					break;
			}
			// if(isKey)PubData.mainUI.stage.dispatchEvent(new KeyEvent(keyCode));
			// if(isKey)PubData.mainUI.stage.dispatchEvent(new KeyEvent(KeyEvent.KEY_DOWN,keyCode));

			if (isKey) {
				if (KeyEvent.KEY_TAB != keyCode) {
					//if(!UI_index.cgBegin){
					if(!Action.instance.cg.cgBegin){
						PubData.mainUI.stage.dispatchEvent(new KeyEvent(keyCode));
						PubData.mainUI.stage.dispatchEvent(new KeyEvent(KeyEvent.KEY_DOWN, keyCode));	
					}
				} else {
//					e.stopPropagation();
//					e.stopImmediatePropagation();
					//
					if(!keyDelayTimer.running)
					{
						if(!keyDelayTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
						{
							//setTimeout(noDispatch, 200);
							keyDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,noDispatch);
						}
						
						keyDelayTimer.reset();
						keyDelayTimer.start();
					}	
					
				}
			}
		}

		// fux
		public function noDispatch(event:TimerEvent = null) : void {
			UI_index.instance.listener(new KeyEvent(KeyEvent.KEY_TAB, KeyEvent.KEY_TAB));
		}
	}
}
