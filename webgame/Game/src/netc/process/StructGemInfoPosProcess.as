package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGemInfoPos2;

	public class StructGemInfoPosProcess extends PacketBaseProcess
	{
		public function StructGemInfoPosProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGemInfoPos2=pack as StructGemInfoPos2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}