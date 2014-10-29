package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructInvest2;

	public class StructInvestProcess extends PacketBaseProcess
	{
		public function StructInvestProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructInvest2=pack as StructInvest2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}