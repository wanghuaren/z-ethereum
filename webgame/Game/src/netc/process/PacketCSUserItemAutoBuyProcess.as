package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSUserItemAutoBuy2;

	public class PacketCSUserItemAutoBuyProcess extends PacketBaseProcess
	{
		public function PacketCSUserItemAutoBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSUserItemAutoBuy2=pack as PacketCSUserItemAutoBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}