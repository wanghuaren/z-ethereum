package com.engine.utils
{
	import com.engine.core.Core;
	
	import flash.display.Scene;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/**
	 * @author saiman
	 * 2012-10-9  下午1:58:56
	 **/
	public class SuperKey extends EventDispatcher
	{
		public static const SUPER:String='SAIMAN';
		public static const DEBUG:String='DEBUG';
		public static const HELLP:String='HELLP';
		public static const GM:String='GM';
		
		private var keyArray:Array=[];
		private var stage:Stage
		private var time:int=0;
		private static var _instance:SuperKey
		private  var inputMode:Boolean
		private  var inputTime:int
		public function SuperKey()
		{
		
		}
		
		public function setUp(stage:Stage):void
		{
			this.stage=stage;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,keydownFunc)
			this.stage.addEventListener(KeyboardEvent.KEY_UP,keyupFunc)	;
		
		}
		public static function getInstance():SuperKey
		{
			if(!_instance)_instance=new SuperKey;
			return _instance
		}
		
		
		private function keydownFunc(e:KeyboardEvent):void
		{
			
			if(inputMode)
			{
				if(getTimer()-inputTime>10000)
				{
					inputMode=false;
					keyArray=[]
					return
				}
				if(e.shiftKey&&e.keyCode==16)
				{
					keyArray=[];
				}
				if(getTimer()-time<200||time==0)
				{
					time=getTimer()
					keyArray.push(String.fromCharCode(e.keyCode))
				}else {
					time=0
					keyArray=[]
					keyArray.push(String.fromCharCode(e.keyCode))
				}
				
			}
			if(e.shiftKey&&String.fromCharCode(e.keyCode)=='¿')
			{
				this.inputMode=true;
				this.inputTime=getTimer()
				this.keyArray=[]
			}
			var key:String=keyArray.join('')
			var bool:Boolean=false
			if(key==SUPER)
			{
				this.dispatchEvent(new Event(SUPER))
			}else if(key==DEBUG){
				this.dispatchEvent(new Event(DEBUG))
				
			}else if(key==HELLP){
				this.dispatchEvent(new Event(HELLP))
			}else if(key==GM){
				this.dispatchEvent(new Event(GM))
			}
			if(bool)
			{
				this.keyArray=[]
				this.inputMode=false
				return
			}
		
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keydownFunc)
			this.stage.removeEventListener(KeyboardEvent.KEY_UP,keyupFunc)	;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,keydownFunc)
			this.stage.addEventListener(KeyboardEvent.KEY_UP,keyupFunc)	;
		
		}
		private function keyupFunc(e:KeyboardEvent):void
		{
			
		}
		
		
	}
}