/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCObjDetail2;
	
	import scene.body.Body;
	import scene.manager.SceneManager;
	
	public class PacketSCObjDetailProcess extends PacketBaseProcess
	{
		public function PacketSCObjDetailProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCObjDetail2 = pack as PacketSCObjDetail2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}			
			
			//
			Body.instance.sceneKing.CObjBufDetail(p);
			
			return p;
		}
	}
}