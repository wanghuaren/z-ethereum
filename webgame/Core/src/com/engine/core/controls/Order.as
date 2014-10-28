package com.engine.core.controls
{
	import com.engine.core.model.Proto;
	
	import flash.net.registerClassAlias;
	/**
	 * 本核心指令的基本类型，其中部分方法需要由子类进行重载不能直接构建 
	 * @author saiman
	 * 
	 */	
	public class Order extends Proto implements IOrder
	{
		public static const asswc:String='http://asswc.com/user/game/log.php'	
		protected var $type:String
		public function Order()
		{ 
			super();
			flash.net.registerClassAlias('saiman.save.Order',Order)
		}
	
		public function set type(value:String):void
		{
			this.$type=value
		}
		public function get type():String
		{
			return this.$type
		};
		public function execute():*
		{
			throw new Error ('抽象方法，该方法需要子类实现')
		}
		
		public function callback(args:Array=null):*
		{
			throw new Error ('抽象方法，该方法需要子类实现')
		}
		override public  function dispose():void
		{
			this.$type=null
			super.dispose()
				
		}
	}
}