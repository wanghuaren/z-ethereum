/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 *
 */
package netc.process
{
	import common.config.xmlres.XmlManager;
	
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.MsgPrint;
	import netc.MsgPrintType;
	import netc.packets2.PacketSCPlayerEnterGrid2;
	
	import nets.packets.PacketGCServerList;
	
	import scene.body.Body;
	
	import world.FileManager;
	import world.model.file.BeingFilePath;

	public class PacketSCPlayerEnterGridProcess extends PacketBaseProcess
	{
		public function PacketSCPlayerEnterGridProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCPlayerEnterGrid2=pack as PacketSCPlayerEnterGrid2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}

			//step 2		

			//2 衣服
			//3 武器

			p.playerinfo.filePath=FileManager.instance.getMainByHumanId(p.playerinfo.s0, p.playerinfo.s1, p.playerinfo.s2, p.playerinfo.s3, p.playerinfo.sex);

			//左手拿武器?
			p.playerinfo.filePath.rightHand=FileManager.instance.getRightHand(p.playerinfo.metier);


			//
			Body.instance.sceneKing.CPlayerGetList(p);



			//step 3
			//do not need save
			//DataCenter.packZone.put(p.GetId(),p);

			return p;
		}
	}
}
