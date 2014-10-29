package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructMapSeek2;

	public class StructMapSeekProcess extends PacketBaseProcess
	{
		public function StructMapSeekProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructMapSeek2=pack as StructMapSeek2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}