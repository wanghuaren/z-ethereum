package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSpaKissInviteOp2;

	public class PacketCSSpaKissInviteOpProcess extends PacketBaseProcess
	{
		public function PacketCSSpaKissInviteOpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSpaKissInviteOp2=pack as PacketCSSpaKissInviteOp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}