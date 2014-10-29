package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCStarCurrMaxID2;

	public class PacketSCStarCurrMaxIDProcess extends PacketBaseProcess
	{
		public function PacketSCStarCurrMaxIDProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCStarCurrMaxID2=pack as PacketSCStarCurrMaxID2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			Data.myKing.dragPoint=p.star_id;
			return p;
		}
	}
}