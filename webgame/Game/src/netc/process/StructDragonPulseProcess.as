package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDragonPulse2;

	public class StructDragonPulseProcess extends PacketBaseProcess
	{
		public function StructDragonPulseProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDragonPulse2=pack as StructDragonPulse2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}