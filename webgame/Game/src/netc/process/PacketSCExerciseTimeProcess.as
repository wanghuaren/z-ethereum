/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ExpResModel;
	
	import engine.event.DispatchEvent;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCExerciseTime2;
	
	import engine.support.IPacket;
	
	import common.managers.Lang;
	
	public class PacketSCExerciseTimeProcess extends PacketBaseProcess
	{
		public function PacketSCExerciseTimeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCExerciseTime2 = pack as PacketSCExerciseTime2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			if(null != Data.myKing.king)
			{
				//根据秒数查表，换算成经验				
				//a/3*pub_exp.onlineexp
								var model:Pub_ExpResModel = XmlManager.localres.getPubExpXml.getResPath(Data.myKing.king.level);
				
				var cumulateExp:int;
				if(null == model)
				{
					cumulateExp = 0;
				}else
				{
					
					if(0 == p.fcmstate)
					{
						cumulateExp = Math.floor(p.second / 3) * model.onlineexp;
						
						//获得的离线经验打印
						
						Lang.showExpAddChange(new DispatchEvent(MyCharacterSet.EXP_ADD,cumulateExp));
					
					}else if(1 == p.fcmstate)
					{
						cumulateExp = (Math.floor(p.second / 3) * model.onlineexp) / 2;
						
						//获得的离线经验打印
						Lang.showExpAddChange(new DispatchEvent(MyCharacterSet.EXP_ADD,cumulateExp));
					
						
					}else 
					{
						cumulateExp = 0;
					}
					
				}
				
				Data.myKing.king.xiuLianInfo.cumulateExpByPanel = cumulateExp;
				Data.myKing.king.xiuLianInfo.cumulateExp = cumulateExp;
				Data.myKing.king.xiuLianInfo.cumulateSec = p.second;
												
			}
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}