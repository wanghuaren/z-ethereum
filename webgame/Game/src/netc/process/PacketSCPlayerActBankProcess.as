package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCPlayerActBank2;

	public class PacketSCPlayerActBankProcess extends PacketBaseProcess
	{
		public function PacketSCPlayerActBankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPlayerActBank2=pack as PacketSCPlayerActBank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			Data.packZone.put(p.GetId(),p);
			Data.beiBao.reloadXunBaoData();
			
			return p;
		}
	}
}