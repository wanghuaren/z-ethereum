package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStarBaseInfo2;

	public class PacketCSStarBaseInfoProcess extends PacketBaseProcess
	{
		public function PacketCSStarBaseInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStarBaseInfo2=pack as PacketCSStarBaseInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}