/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import flash.utils.getQualifiedClassName;
	import netc.Data;
	import netc.packets2.PacketSCRelive2;
	import scene.body.Body;
	import scene.king.FightSource;
	import ui.view.view1.fuhuo.FuHuo;
	public class PacketSCReliveProcess extends PacketBaseProcess
	{
		public function PacketSCReliveProcess()
		{
			super();
		}
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCRelive2 = pack as PacketSCRelive2;
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			//step 2		
			if(null != Data.myKing.king)
			{
				//收到复活指令，客户端自行将hp调为1
				//仅只调hp
				if(Data.myKing.king.roleID == p.userid)
				{
					if(0 == Data.myKing.hp){
						Data.myKing.hp = 1;
					}
					//
					Data.myKing.king.setHp = 1;
					//复活事件
					Body.instance.sceneKing.DelMeFightInfo(FightSource.Relive,Data.myKing.king.objid);
					Body.instance.sceneKing.DelMeTalkInfo(FightSource.Relive,Data.myKing.king.objid);
					//
					Data.idleTime.syncByClearIdleXiuLian();
					Data.idleTime.syncByClearIdleNewGuest();
					//重置怪物点击信息
					Body.instance.sceneKing.ResetAllMonByMouseClick();
					//关闭复活面板
					FuHuo.instance().close();
				}
			}
			return p;
		}
	}
}