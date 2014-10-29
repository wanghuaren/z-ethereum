package netc.process
{
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCHeart2;
	
	import engine.support.IPacket;
	
	public class PacketSCHeartProcess extends PacketBaseProcess
	{
		public function PacketSCHeartProcess()
		{
			super();
		}
		
		
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCHeart2 = pack as PacketSCHeart2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			
			
			return p;
		}
	}
}