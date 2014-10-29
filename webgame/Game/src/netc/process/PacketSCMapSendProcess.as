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
	import netc.packets2.PacketSCMapSend2;
	
	import engine.support.IPacket;
	
	import scene.manager.SceneManager;
	
	public class PacketSCMapSendProcess extends PacketBaseProcess
	{
		public function PacketSCMapSendProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCMapSend2 = pack as PacketSCMapSend2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			SceneManager.instance.setCurrentMapId(p.mapid,0);
			
			
			return p;
		}
	}
}