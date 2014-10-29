package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSAgreeSignSH2;

	public class PacketCSAgreeSignSHProcess extends PacketBaseProcess
	{
		public function PacketCSAgreeSignSHProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSAgreeSignSH2=pack as PacketCSAgreeSignSH2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}