package com.engine.core.controls.elisor
{
	import com.engine.core.controls.IOrder;
	import com.engine.core.model.Proto;
	import com.engine.namespaces.saiman;
	/**
	 *  指管理器
	 * 	核心事，心跳管理机制的实现体；
	 *  事件管理由EventElisor单例进行维护
	 *  心跳管理由FrameElisor单例进行维护
	 * 	所有注册的指令为IOrder接口的实现.
	 * 	所有引擎外的指令注册都需经由本单例进行统一注册销毁。
	 * @author saiman
	 * 
	 */
	public class Elisor extends Proto
	{
		/**
		 * @private 事件管理器 
		 */		
		private var _EventElisor:EventElisor
		/**
		 * private 心跳管理器 
		 */		
		private var _FrameElisor:FrameElisor
		/**
		 * @private 指令管理器单例 
		 */		 
		private static var _instance:Elisor;
		
		public function Elisor()
		{
		}
		/**
		 *　获取指令管理器单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():Elisor
		{
			if(_instance==null){
				_instance=new Elisor
				_instance.initialize();
			}
			return _instance
		}
		/**
		 *　初始化指 令管理器 
		 *  <br>初始化中会将指令管理器跟心跳管理器进行一次赋值处理，从而降低往后执行过程中的调用反射
		 */		
		public function initialize():void
		{
			this._EventElisor=EventElisor.saiman::getInstance();
			this._FrameElisor=FrameElisor.saiman::getInstance();
		}
		/**
		 *　创建一个心跳指令 
		 * @param oid　拥有者id
		 * @param type　　幀听的事件类型
		 * @param listener　事件触发的执行方法
		 * @return 一个事件指令
		 * 
		 */		
		public function createEventOrder(oid:String,type:String,listener:Function):EventOrder
		{
			var order:EventOrder=order=new EventOrder
			order.register(oid,type,listener)
			return order
		}
		/**
		 * 创建一个心跳指令 
		 * @param oid 拥有者id
		 * @param deay 心跳频率
		 * @param action 心跳中执行的方法 
		 * @param arguments 心跳中执行方法的参数
		 * @param callbackFunc 回调方法
		 * @param between 存活时间周期,单位毫秒
		 * @return 返回一个心跳指令
		 * 
		 */		
		public function createFrameOrder(oid:String,deay:int,action:Function,arguments:Array=null,callbackFunc:Function=null,between:int=-1):FrameOrder
		{
			if(action==null)throw new Error('action 不能为 null');
			var order:FrameOrder=order=new FrameOrder
			order.setUp(oid,deay,between)
			order.register(action,arguments,callbackFunc)
			return order
		}
		/**
		 *  在指定的时间后执行指定的方法.
		 * @param oid 拥有者id
		 * @param between 存活时间
		 * @param action 时间到后执行的方法
		 * @param args action方法对应的参数数组
		 * @return 返回一个FrameOrder心跳指令
		 * 
		 */		
		public function setTimeOut(oid:String,between:int,action:Function,args:Array):FrameOrder
		{
			var order:FrameOrder=order=new FrameOrder
			order.setUp(oid,20,between)
			order.setTimeOut(action,args)
			return order
		}
		/**
		 * 将一个指令添加到指令管理器 
		 * @param order 实现了IOrder的具体指令
		 * @param override 是否覆盖 如果为true，当指令管理器已经存在该指令时则覆盖，false 则不覆盖
		 * @return 返回添加是否成功，如果指令已经存在而又没设置覆盖参数，在返回添加失败。
		 * 
		 */				
		public function addOrder(order:IOrder,override:Boolean=false):Boolean
		{
			
			switch(order.type){
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.addOrder(order as EventOrder)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.addOrder(order as FrameOrder)
					break;
			}
			
			return false
		}
		
		/**
		 *  根据一个指令id将一个指令直接冲指令管理器移除.该方法同时在指令所属对象中移除.
		 * @param id 指令id
		 * @param orderMode 指令类型  OrderMode.FRAME_ORDER为心跳指令，OrderMode.EVENT_ORDER为事件指令
		 * @return 返回一个实现了IOrder接口的指令实实例,不存在则返回null
		 * 
		 */		
		public function removeOrder(id:String,orderMode:String):IOrder
		{
			switch(id){
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.removeOrder(id)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.removeOrder(id)
					break;
			}
			return null;
		}
		/**
		 * 判断一个指定指令id的指令是否存在
		 * @param id 指令id
		 * @param orderMode OrderMode.FRAME_ORDER为心跳指令，OrderMode.EVENT_ORDER为事件指令
		 * @return 
		 * 
		 */		
		public function hasOrder(id:String,orderMode:String):Boolean
		{
			switch(id){
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.hasOrder(id)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.hasOrder(id)
					break;
			}
			
			return false;
		}
		/**
		 * 根据一个IOrder接口的指令id返回一个实现了IOrder接口的指令 
		 * @param id 指令id
		 * @param orderMode  指令类型  OrderMode.FRAME_ORDER为心跳指令，OrderMode.EVENT_ORDER为事件指令
		 * @return 返回一个实现了IOrder接口的指令 
		 * 
		 */		
		public function takeOrder(id:String,orderMode:String):IOrder
		{
			
			switch(id){
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.takeOrder(id)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.takeOrder(id)
					break;
			}
			return null;
		}
		/**
		 * 根据某id判断是否有其对应的指令对象存在。 
		 * @param oid 拥有者id
		 * @param orderMode 返回的指令类型 OrderMode.TOTAL为全部指令，   OrderMode.FRAME_ORDER为心跳指令，OrderMode.EVENT_ORDER为事件指令
		 * @return 回一个IOrder接口密集型数组
		 * 
		 */		
		public function hasGroup(oid:String,orderMode:String='total'):Boolean
		{
			switch(orderMode){
				case OrderMode.TOTAL:
					return (this._EventElisor.hasGroup(oid)||this._FrameElisor.hasGroup(oid))
					break;
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.hasGroup(oid)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.hasGroup(oid)
					break;
			}
			return false;
		}
		/**
		 * 获取个对象的多有注册指令 
		 * @param oid 拥有者id
		 * @param orderMode 返回的指令类型 OrderMode.TOTAL为全部指令，   OrderMode.FRAME_ORDER为心跳指令，OrderMode.EVENT_ORDER为事件指令
		 *   
		 *     
		 * @return 返回一个IOrder接口密集型数组
		 * 
		 */		
		public function takeGroupOrders(oid:String,orderMode:String='total'):Vector.<IOrder>
		{
			var array:Vector.<IOrder>
			switch(orderMode){
				case OrderMode.TOTAL:
					array=new Vector.<IOrder>
					array=array.concat(this._EventElisor.takeGroupOrder(oid));
					array.concat(this._FrameElisor.takeGroupOrder(oid))
					return array
					break;
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.takeGroupOrder(oid)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.takeGroupOrder(oid)
					break;
			}
			return null;
		}
		/**
		 * 销毁某个注册对象的所有指令组包括事件指令与心跳指令。 
		 * @param oid 拥有者id
		 * @param orderMode 返回的指令类型 OrderMode.TOTAL为全部指令，   OrderMode.FRAME_ORDER为心跳指令，OrderMode.EVENT_ORDER为事件指令
		 * @return 返回一个IOrder接口密集型数组
		 * 
		 */		
		public function disposeGroupOrders(oid:String,orderMode:String='total'):Vector.<IOrder>
		{
			var array:Vector.<IOrder>
			switch(orderMode){
				case OrderMode.TOTAL:
					array=new Vector.<IOrder>
					array=array.concat(this._EventElisor.disposeGroupOrders(oid));
					array=array.concat(this._FrameElisor.disposeGroupOrders(oid))
					return array
					break;
				case OrderMode.EVENT_ORDER:
					return this._EventElisor.disposeGroupOrders(oid)
					break;
				case OrderMode.FRAME_ORDER:
					return this._FrameElisor.disposeGroupOrders(oid)
					break;
			}
			return null;
		}
		
		/**
		 * 销毁 
		 * 
		 */
		override public function  dispose():void
		{
			this._EventElisor.dispose();
			this._FrameElisor.dispose();
			this._EventElisor=null
			this._FrameElisor=null;
			super.dispose();
			_instance=null
		}
		
		
	}
}