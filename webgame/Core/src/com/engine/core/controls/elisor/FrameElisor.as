package com.engine.core.controls.elisor
{
	import com.engine.core.Core;
	import com.engine.core.controls.IOrder;
	import com.engine.core.model.Proto;
	import com.engine.core.view.base.BaseTimer;
	import com.engine.namespaces.saiman;
	
	import flash.utils.Dictionary;
	/**
	 * 给予EnterFrame的心跳管理器 
	 * @author saiman
	 * 
	 */
	public class FrameElisor extends Proto
	{
		private static var _instance:FrameElisor;
		private var _owners:Dictionary
		private var _quenes:Dictionary;
		private var _orders:Dictionary
		private var _len:int
		public function FrameElisor()
		{
			super();
		}
		
		saiman static function getInstance():FrameElisor
		{
			if(_instance==null){
				_instance=new FrameElisor
				_instance.initialize();
			}
			return _instance
			
		}
		
		public function initialize():void
		{
			_owners=new Dictionary;
			_quenes=new Dictionary
			_orders=new Dictionary;
		}
		public function addOrder(order:FrameOrder,override:Boolean=false):Boolean
		{
			
			if(order==null)return false;
			var oid:String=order.oid;
			var id:String=order.id;
			var delay:String=order.delay.toString();
			
			if(oid&&id&&delay)
			{
				if(this._owners[oid]==null)this._owners[oid]=new Dictionary;
				var quene:DeayQuene
				if(this._quenes[delay]==null)
				{
					quene=new DeayQuene(order.delay);
					this._quenes[delay]=quene
				}
				quene=this._quenes[delay]
				quene.addOrder(order)
				this._owners[oid][id]=this._orders[id]=order;
				_len++
				return true;
			}
			return false
			
		}
		public function stopOrder(id:String):void
		{
			var order :FrameOrder=this._orders[id] as FrameOrder;
			if(order)
			{
				order.stop=false;
			}
				
		}
		public function startOrder(id:String):void
		{
			var order :FrameOrder=this._orders[id] as FrameOrder;
			if(order)
			{
				order.stop=true;
			}
			
		}
		public function removeOrder(id:String):FrameOrder
		{
			if(this._orders[id]){
				var order:FrameOrder=this._orders[id]as FrameOrder
				order.stop=true;
				delete this._orders[id]
				if(this._owners[order.oid])delete this._owners[order.oid][id];
				var dic:Dictionary=this._owners[order.oid]
				var quene:DeayQuene=this._quenes[order.delay.toString()] as DeayQuene
				if(quene)quene.removeOrder(id);
				_len--
				for each(var o:FrameOrder in dic )
				{
					order.dispose();
					return order
				}
				delete this._owners[order.oid]
				order.dispose();
				return order
			}
			return null	
		}
		public function hasOrder(id:String):Boolean
		{
			if(this._orders[id])return true;
			return false
		}
		public function removeQuene(id:String):void
		{
			delete this._quenes[id]
		}
		public function hasQuene(id:String):Boolean
		{
			if(this._quenes[id])return true;
			return false
		}
		public function takeQuene(id:String):DeayQuene
		{
			return this._quenes[id] 
		}
		public function takeOrder(id:String):FrameOrder
		{
			
			return this._orders[id] as FrameOrder
		}
		
		public function hasGroup(gid:String):Boolean
		{
			if(this._owners[gid])return true;
			return false
		}
		public function takeGroupOrder(gid:String):Vector.<IOrder>
		{
			var array:Vector.<IOrder>=new Vector.<IOrder>
			if(this._owners[gid]){
				for each (var order:IOrder in this._owners[gid]){
					array.push(order)
				}		
			}
			return array
		}
		public function disposeGroupOrders(gid:String):Vector.<IOrder>
		{
			var array:Vector.<IOrder>=new Vector.<IOrder>
			if(this._owners[gid]){
				for (var i:String in this._owners[gid]){
					var order:FrameOrder=this._owners[gid][i]
					order.stop
					order.dispose();
					array.push(order as IOrder)
					_len++
				}	
				delete this._owners[gid]
			}
			return array
		}
		public function chageDeay(id:String,delay:int):Boolean
		{
			var order:FrameOrder=this._orders[id] as FrameOrder
			if(order)
			{
				var quene:DeayQuene=this._quenes[order.delay.toString()] as DeayQuene;
				var newQuene:DeayQuene
				if(quene){
					if(quene.delay==order.delay)quene.removeOrder(id);
					order.saiman::delay=delay
					if(this._quenes[delay.toString()]){
						DeayQuene(this._quenes[delay.toString()]).addOrder(order)
					}else {
						newQuene=new DeayQuene(delay);
						this._quenes[delay]=quene
						newQuene.addOrder(order)
					}
				}else {
					order.saiman::delay=delay
					 newQuene=new DeayQuene(delay);
					this._quenes[delay]=quene
					newQuene.addOrder(order)
				}
				return true;
			}
			return false
		}
		override public function dispose():void
		{
			_instance=null;
			for(var i:String in this._quenes)
			{
				var quene:DeayQuene=this._quenes[i]
					quene.dispose();
					delete this._quenes[i]
			}
			_quenes=null;
			for each(var order:FrameOrder in this._orders )
			{
				order.dispose()
			}
			this._orders=null;
			this._owners=null;
			_len=0
			
			super.dispose();
				
		}
			
	}
}