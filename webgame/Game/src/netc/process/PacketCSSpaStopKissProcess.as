package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSSpaStopKiss2;

	public class PacketCSSpaStopKissProcess extends PacketBaseProcess
	{
		public function PacketCSSpaStopKissProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSSpaStopKiss2=pack as PacketCSSpaStopKiss2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}