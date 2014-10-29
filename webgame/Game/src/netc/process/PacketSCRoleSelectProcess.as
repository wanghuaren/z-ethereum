/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCRoleSelect2;
	
	import engine.support.IPacket;
	import nets.packets.PacketGCServerList;
	import nets.packets.PacketSCSelectServer;
	
	import scene.manager.SceneManager;
	
	public class PacketSCRoleSelectProcess extends PacketBaseProcess
	{
		public function PacketSCRoleSelectProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCRoleSelect2 = pack as PacketSCRoleSelect2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			//SceneManager.instance.currentMapId = p.mapid;
			SceneManager.instance.setCurrentMapId(p.mapid,p.tag);
						
			//step 2		
			Data.packZone.put(p.GetId(),p);
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}