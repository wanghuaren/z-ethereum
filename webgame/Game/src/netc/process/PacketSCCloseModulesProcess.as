package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCCloseModules2;

	public class PacketSCCloseModulesProcess extends PacketBaseProcess
	{
		public function PacketSCCloseModulesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{

			var p:PacketSCCloseModules2=pack as PacketSCCloseModules2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}
