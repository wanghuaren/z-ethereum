package com.bellaxu.mgr
{
	import com.bellaxu.def.KeyboardKeyDef;
	
	import engine.event.KeyEvent;
	
	import flash.events.KeyboardEvent;

	/**
	 * 键盘管理
	 * @author BellaXu
	 */
	public class KeyboardMgr
	{
		private static var m_nInstance:KeyboardMgr;
		private var m_nKeyState:Array;
		
		public static function getInstance():KeyboardMgr
		{
			if (m_nInstance==null)
			{
				m_nInstance = new KeyboardMgr();
			}
			return m_nInstance;
		}
		
		public function KeyboardMgr()
		{
			m_nKeyState = [];
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			this.m_nKeyState[e.keyCode] = true;
		}
		
		public function onKeyUp(e:KeyboardEvent):void
		{
			this.m_nKeyState[e.keyCode] = false;
		}
		
		public function isKeyDown(keyCode:int):Boolean
		{
			return m_nKeyState[keyCode];
		}
		
		public function shiftKeyIsDown():Boolean
		{
			return isKeyDown(KeyboardKeyDef.SHIFT.keyCode);
		}
		
	}
}