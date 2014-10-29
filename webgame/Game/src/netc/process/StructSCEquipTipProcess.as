package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSCEquipTip2;

	public class StructSCEquipTipProcess extends PacketBaseProcess
	{
		public function StructSCEquipTipProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSCEquipTip2=pack as StructSCEquipTip2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}