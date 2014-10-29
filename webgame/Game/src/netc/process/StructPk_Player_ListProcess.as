package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPk_Player_List2;

	public class StructPk_Player_ListProcess extends PacketBaseProcess
	{
		public function StructPk_Player_ListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPk_Player_List2=pack as StructPk_Player_List2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}