package engine.net.dataset
{
	import engine.support.IPacket;
	import engine.support.ISet;
	import engine.utils.HashMap;
	
	import flash.events.EventDispatcher;

	public class VirtualSet extends EventDispatcher implements ISet
	{
		private var _packZone:HashMap;
		
		public function VirtualSet()
		{
		}
		
		
		/**
		 * 此方法在需要时应覆写
		 */ 
		public function sync(p:IPacket):void
		{
		
		}
		
		/**
		 * 
		 */ 
		public function get packZone():HashMap
		{
			return _packZone;
		}
		
		public function refPackZone(value:HashMap):void
		{
			_packZone = value;
		}
		
		
		
	}
}