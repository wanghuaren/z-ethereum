package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWSignInQueryLog2;

	public class PacketSWSignInQueryLogProcess extends PacketBaseProcess
	{
		public function PacketSWSignInQueryLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWSignInQueryLog2=pack as PacketSWSignInQueryLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}