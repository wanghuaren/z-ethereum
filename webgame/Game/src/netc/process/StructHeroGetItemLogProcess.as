package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructHeroGetItemLog2;

	public class StructHeroGetItemLogProcess extends PacketBaseProcess
	{
		public function StructHeroGetItemLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructHeroGetItemLog2=pack as StructHeroGetItemLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}