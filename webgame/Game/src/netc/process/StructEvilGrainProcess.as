package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructEvilGrain2;

	public class StructEvilGrainProcess extends PacketBaseProcess
	{
		public function StructEvilGrainProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructEvilGrain2=pack as StructEvilGrain2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}