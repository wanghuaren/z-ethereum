package com.engine.core.controls.elisor
{
	
	import com.engine.core.Core;
	import com.engine.core.controls.IOrder;
	import com.engine.core.controls.Order;
	import com.engine.core.model.Proto;
	import com.engine.core.view.base.BaseTimer;
	import com.engine.namespaces.saiman;
	import com.engine.utils.Hash;
	
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;

	/**
	 *  心跳队列管理，由心跳管理器创建并维护
	 *  <br>本类维护相同频率的心跳指令并动态创建对另的频率Timer
	 *  <br>当一个FrameOrder被Stop后，并不会移出本队列，它会从移除遍历列表，当调用StartStop后将从新添加会遍历列表。
	 *  <br>如果只是更改FrameOrder的delay，则会移除本队列并移到对应的新队列管理器实例中。
	 *  <br>相对Stop方法此过程会产生一ying定消耗。因为它更改心跳频率需要移除本队列，心跳管理器也会进行相应的队列维护
	 * @author saiman
	 * 
	 */
	public class DeayQuene extends Proto
	{
		/**
		 * 心跳管理器进行遍历 
		 */		
		private var _openHash:Dictionary
		private var timer:BaseTimer
		private var _delay:int
		private var len:int
		private var enterFrame:Shape;
		private var _closeHash:Dictionary
		private var _isDispose:Boolean
		public function DeayQuene(delay:int=250)
		{
			
			_openHash=new Dictionary
			_closeHash=new Dictionary
			this._delay=delay
			len=0
		}
		public function get delay():int
		{
			return this._delay
		}
		private function timerFunc(e:TimerEvent):void
		{
			if(this.len<=0){
				this.len=0
				if(this.timer)this.timer.stop();
				this.dispose()
			}
			var order:IOrder
			for each( order in this._openHash)
				order.execute();
			
		}
		/**
		 * 暂停一个小心跳指令 
		 * @param id
		 * 
		 */		
		public function stopOrder(id:String):void
		{
			var order:FrameOrder=this._openHash[id];
			delete this._openHash[id];
			if(order){
				if(this._closeHash[id]==null)this._closeHash[id]=order;
			}
		}
		public function startOrder(id:String):void
		{
			var order:FrameOrder=this._closeHash[id];
			delete this._closeHash[id];
			if(order){
				if(this._openHash[id]==null)this._openHash[id]=order;
			}
		}
		public function addOrder(order:FrameOrder):void
		{
			if(order)
			{
				if(this._openHash[order.id]==null)
				{
					this._openHash[order.id]=order;
					len++
					if(len>0){
						timer=new BaseTimer(delay)
						timer.addEventListener(TimerEvent.TIMER,timerFunc)
						timer.start()
					}
				}
			}
		}
		public function removeOrder(id:String):void
		{
			var order:FrameOrder=this._openHash[id]
			if(order){
				delete this._openHash[id];
				order=null;
				len--
				if(this.len<=0){
					this.len=0
					this.timer.stop()
					this.dispose()
				}
			}else {
				order=this._closeHash[id]
				if(order){
					delete this._closeHash[id];
					order=null;
					len--
					if(this.len<=0){
						this.len=0
						this.timer.stop()
						this.dispose()
					}
				}
			}
		}
		public function hasOrder(id:String):Boolean
		{
			if(this._openHash[id])return true;
			if(this._closeHash[id])return true;
			return false
		}
		public function takeOrder(id:String):FrameOrder
		{
			var order:FrameOrder=this._openHash[id] as FrameOrder
			if(order==null)order=this._closeHash[id];
			return order
		}
		override public function dispose():void
		{
			if(_isDispose)return ;
			FrameElisor.saiman::getInstance().removeQuene(this._delay)
			for each (var order:IOrder in this._openHash)
			{
				order.dispose();
			}
			for each (var order2:IOrder in this._closeHash)
			{
				order2.dispose();
			}
			if(this.timer)
			{
				this.timer.removeEventListener(TimerEvent.TIMER,this.timerFunc);
				timer.dispose();
				timer.stop();
				timer=null
			}
			this._openHash=null;
			this._closeHash=null
			this.len=0;
			super.dispose()
			_isDispose=true
		}
	}
}