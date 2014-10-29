package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGameGM2;
	import netc.packets2.PacketSCMsg2;
	
	import engine.support.IPacket;
	
	public class PacketSCMsgProcess extends PacketBaseProcess
	{
		public function PacketSCMsgProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			
			//step 1
			var p:PacketSCMsg2 = pack as PacketSCMsg2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			//缓存好友数据
			//DataCenter.packZone.put(p.GetId(),p);
			return pack;
		}
		
		
	}
}