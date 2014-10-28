package com.engine.core.controls.elisor
{

	
	import com.engine.core.Core;
	import com.engine.core.controls.Order;
	import com.engine.namespaces.saiman;
	
	import flash.net.registerClassAlias;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	/**
	 *  <b>心跳指令</b>。
	 * 	<br>心跳指令需要先调用初始化化方法setUp,并赋值心跳拥有者id，心跳频率(delay，单位毫秒)，超时时间（between，单位毫秒。当值为-1时表示一直执行）。
	 *  <br>开发者可根据需要初始化指令后调用超时回调方法SetTimeOut（）或循环调用方法register（）
	 *  <br>心跳管理器维护列表的信息载体。
	 *  <br>本指令与对应的心跳队列及心跳管理器对应。
	 * 	<br>修改本指令的一些属性会导致心跳队列或心跳管理器维护列表的更新
	 *  <br>指令实例可附属于某一对象也可以单独存在。销毁时会自动调用心跳管理器方法进行回收。
	 *  <br>实例的频率delay属性支持动态更改，更改时会从心跳队列队列中删除并加入到新的队列中，
	 *  <br>Stop属性的修改不会使对象从心跳队列实例中删除，当值为True时会移出心跳队列的遍历列表，为false时将添加会遍历列表中。
	 *  <br>实例声明后需要添加到心跳管理器并调用start（）方法，才可生效。start（）方法每次调用会从新设置开始时间。超时失效=开始时间+超时时间
	 * @author saiman
	 * 
	 */	
	public class FrameOrder extends Order
	{
		 
		
		private var _applyFunc:Function;
		private var _arguments:Array
		private var _callbackFunc:Function
		private var _timeOutFunc:Function
		private var _timeOutargs:Array
		private var _stop:Boolean;
		private var _startTime:Number;
		private var _between:int
		private var _delay:int;
		
		public function FrameOrder()
		{
			super();
			
			flash.net.registerClassAlias('saiman.save.FrameOrder',FrameOrder)
			this.$type=OrderMode.FRAME_ORDER;
			this.$id=Core.saiman::nextInstanceIndex().toString(16)
			this._stop=true;
		}
		public function get delay():int
		{
			return this._delay
		}
		saiman function set delay(value:int):void
		{
			this._delay=value
		}
		public function set delay(value:int):void
		{
			if(_delay!=value)
			{
				if(FrameElisor.saiman::getInstance().chageDeay(this.$id,value)==false)this._delay=value;
			}
		}
		public function setUp(oid:String,delay:int,between:int=-1):void
		{
			oid==null?this.$oid=Core.saiman::nextInstanceIndex().toString(16):this.$oid=oid;
			this.$oid=oid;
			this._delay=delay;
			this._between=between
			
		}
		public function setTimeOut(action:Function,args:Array):void
		{
			this._timeOutFunc=action;
			this._timeOutargs=args
		}
		public function register(applyFunc:Function,arguments:Array,callbackFunc:Function=null):void
		{
			if(applyFunc!=null)_applyFunc=applyFunc;
			arguments==null?arguments=[]:''
			this._arguments=arguments;
			if(callbackFunc!=null)_callbackFunc=callbackFunc;
			
		}
		public function start():void
		{
			_startTime=Core.delayTime;	
			this._stop=false;
		}
		public function set stop(value:Boolean):void
		{
			if(this._stop!=value)
			{
				this._stop=value
				var deayQuene:DeayQuene=FrameElisor.saiman::getInstance().takeQuene(this._delay.toString())
				if(value){
					deayQuene.stopOrder(this.$id)
				}else {
					deayQuene.startOrder(this.$id)
				}
			}
		}
		public function get stop():Boolean
		{
			return this._stop;
		}
		override public function execute():*
		{
			if(this._stop==false){
			
//			try{
				if(this._applyFunc!=null){
					var result:*=_applyFunc.apply(null,this._arguments);
					this.callback([result])
				}
			
//			}catch(e:Error){
//				this.dispose();
//				throw new Error('【异常】：'+e.message)
//			}
			
				if(this._between!=-1){
					var time:int=Core.delayTime
					if((time-(this._startTime+this._between))>=0)
					{
						this._stop=true;
						if(_timeOutargs==null)_timeOutargs=[];
						if(this._timeOutFunc!=null)this._timeOutFunc.apply(null,this._timeOutargs);
						this.dispose();
						return ;
					}
				}
			}
		}
		
		override public function callback(args:Array=null):*
		{
			try{
				if(this._callbackFunc==null)return;
				_callbackFunc.apply(null,args)
			}catch(e:Error)
			{
				this.dispose();
				throw new Error('【异常】：'+e.message)
			}
		}
		override public function dispose():void
		{
			if(FrameElisor.saiman::getInstance().hasOrder(this.id))
			{
				FrameElisor.saiman::getInstance().removeOrder(this.id)
			}
			
			this._stop=false
			this._applyFunc=null;
			this._callbackFunc=null;
			this._arguments=null
			this._timeOutFunc=null;
			this._timeOutargs=null
			this._startTime=0
			this._delay=0;
			this._startTime=0;
			this._between=0;
			super.dispose();
		}
		
	}
}