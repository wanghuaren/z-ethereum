package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPk_Rank_Info2;

	public class StructPk_Rank_InfoProcess extends PacketBaseProcess
	{
		public function StructPk_Rank_InfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPk_Rank_Info2=pack as StructPk_Rank_Info2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}