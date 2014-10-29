package netc.process
{
	import common.managers.Lang;
	
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCCityActionSign2;
	
	import nets.*;
	
	public class PacketSCCityActionSignProcess extends PacketBaseProcess
	{
		public function PacketSCCityActionSignProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSCCityActionSign2 = pack as PacketSCCityActionSign2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			if(0 != p.tag)
			{
				Lang.showMsg(Lang.getServerMsg(p.tag));
			}
			return p;
		}
	}
}
