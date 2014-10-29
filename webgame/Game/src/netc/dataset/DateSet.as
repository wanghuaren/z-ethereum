package netc.dataset
{
	import common.config.xmlres.XmlRes;
	
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	
	import flash.events.EventDispatcher;
	
	import common.config.GameIni;
	
	import netc.Data;
	import netc.DataKey;
	import engine.support.ISet;
	import engine.net.dataset.VirtualSet;
	import netc.packets2.PacketGCRoleLogin2;
	import netc.packets2.PacketWCServerTimeSync2;
	
	import engine.support.IPacket;
	
	import engine.utils.HashMap;
	
	import world.FileManager;
	import world.WorldEvent;
	
	public class DateSet extends VirtualSet
	{
		/**
		 * 1970 年 1 月 1 日午夜之间的豪秒数	
		 */ 
		private var _t:Number;
			
		public function DateSet(pz:HashMap)
		{
			refPackZone(pz);
			
			//创建一个不带参数的新 Date 对象 now。
			//然后，调用 getTime() 方法，以检索 now 创建时与 1970 年 1 月 1 日午夜之间的毫秒数
			
			var now:Date = new Date();
			
						
			//初始化时取一次本地时间
			//_t = Math.round(now.getTime() / 1000);
			_t = now.getTime();
			
			
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,clockHandler);
						
		}
		
		public function clockHandler(e:WorldEvent):void
		{
			_t += 1000;
			
					
		}
		
		public function syncByGameServerSystemTime(p:PacketWCServerTimeSync2):void
		{
			_t = p.servertime;
			//var ht:int = p.servertime.hi_time;
			
			//var lt:int = p.servertime.low_time;
			
						//_t = ht*100000000.0 + lt;
		
		}
		
		public function syncByGameServerSystemTimeByLogin(p:PacketGCRoleLogin2):void
		{
			_t = p.servertime;
		}
		
		
		/*public function get nowTime():Number
		{
			//服务器发的是秒，所以这里x 1000
			return _t * 1000;
		}*/
		/**
			month : Number 
			按照本地时间返回 Date 对象的月份值(0 代表一月，1 代表二月，依此类推)。
		 * 
		 * */
		public function get nowDate():Date
		{
			//服务器时间现在准了
			var now:Date = new Date();			
			now.time = _t ;
			
			//上面服务器时间不准，取本地时间			
			//var now:Date = new Date();
			//_t = now.getTime();
			
			return now;
		}
		
		public function nowDateExt(days:int):Date
		{
			//服务器时间现在准了
			var now:Date = new Date();			
			
			var t2:Number = days * 24 * 60 * 60 * 1000;
			
			now.time = _t + t2;
			
			//上面服务器时间不准，取本地时间			
			//var now:Date = new Date();
			//_t = now.getTime();
			
			return now;
		}
		
		public function spliteDateByMssqlDb():void
		{
			
		
		
		}
		
		
		
		
		
		
		
		
		
	}
}