package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSpaKissInvite2;

	public class PacketCSSpaKissInviteProcess extends PacketBaseProcess
	{
		public function PacketCSSpaKissInviteProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSpaKissInvite2=pack as PacketCSSpaKissInvite2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}