/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import common.config.xmlres.XmlManager;
	
	import flash.utils.getQualifiedClassName;
	
	import common.config.GameIni;
	
	import netc.Data;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCObjTeleport2;
	
	import engine.support.IPacket;
	import nets.packets.PacketSCMonsterEnterGrid;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;
	
	public class PacketSCObjTeleportProcess extends PacketBaseProcess
	{
		public function PacketSCObjTeleportProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCObjTeleport2 = pack as PacketSCObjTeleport2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step2
			
			
			//step3
			
			return p;
		}
	}
}