package engine.support
{
	import engine.utils.HashMap;
	
	public interface ISet
	{
		/**
		 * 数据集同步方法，
		 * 数据更新通知
		 * 每个数据集应实现该方法
		 */ 
		function sync(p:IPacket):void;
		
		/**
		 * 对dataCenter的packZone引用
		 * 然后ISet可使用this指针访问HashMap
		 * 加快访问速度
		 */ 
		function get packZone():HashMap
			
		
	}
}