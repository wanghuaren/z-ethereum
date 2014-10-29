package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStarCurrMaxID2;

	public class PacketCSStarCurrMaxIDProcess extends PacketBaseProcess
	{
		public function PacketCSStarCurrMaxIDProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStarCurrMaxID2=pack as PacketCSStarCurrMaxID2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}