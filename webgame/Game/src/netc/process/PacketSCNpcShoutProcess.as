package netc.process
{
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCNpcShout2;
	
	import engine.support.IPacket;
	
	public class PacketSCNpcShoutProcess extends PacketBaseProcess
	{
		public function PacketSCNpcShoutProcess()
		{
			super();
		}
		
		
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCNpcShout2 = pack as PacketSCNpcShout2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			
			return p;
		}
	}
}