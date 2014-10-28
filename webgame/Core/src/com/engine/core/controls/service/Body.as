package com.engine.core.controls.service
{
	import com.engine.core.controls.Order;
	/**
	 *	信件主题，可以传递一些执行方法或者回调方法 
	 * @author saiman
	 * 
	 */	
	public class Body extends Order
	{
		private var _execFunc:Function;
		private var _args:Array
		private var _callbackFunc:Function
		public function Body()
		{
			super();
		}
		
		public function setUpFunction(execFunc:Function=null,args:Array=null,callbackFunc:Function=null):void
		{
			this._args=args;
			this._execFunc=execFunc;
			this._callbackFunc=callbackFunc
		}
		override public function execute():*
		{
			if(this._execFunc!=null){
				if(this._args==null)this._args=[];
				return	this._execFunc.apply(null,this._args)
			}
		}
		override public function  callback(args:Array=null):*
		{
			if(this._callbackFunc!=null){
				if(args==null)args=[];
				this._callbackFunc.apply(null,args)
			}
		}
		override public function dispose():void
		{
			this.proto=null;
			this._args=null;
			this._execFunc=null;
			this._callbackFunc=null;
			super.dispose()
		}
	}
}