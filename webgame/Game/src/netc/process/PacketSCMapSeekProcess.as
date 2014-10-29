/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCMapSeek2;
	
	import engine.support.IPacket;
	
	import scene.manager.SceneManager;
	
	public class PacketSCMapSeekProcess extends PacketBaseProcess
	{
		public function PacketSCMapSeekProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCMapSeek2 = pack as PacketSCMapSeek2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2
			//var i:int;
			//var len:int = p.arrItemlist.length;
			
			//for(i=0;i<len;i++)
			//{
				//
				//SceneManager.instance.currentMapTransList.push();
			
			//}
				
		    
			
			
			return p;
		}
	}
}