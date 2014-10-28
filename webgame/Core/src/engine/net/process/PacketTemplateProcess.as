package engine.net.process
{
	import engine.support.IPacket;

	public class PacketTemplateProcess extends PacketBaseProcess
	{
		public function PacketTemplateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			//var p:PacketGCServerList = pack as PacketGCServerList;
			
			//if(null == p)
			//{
			//	throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			//}
			
			//step 2			
			//var datas:Array = [];
			
			//step 2-1
			//var o:Object = {
				
			//	ip:p.ip
					
			//};
			
			//or
			//o = super.helpByReflect(pack);
			
			//you can use DataCenter get other data
			//and you can set data for  DataCenter
			
			//step3			
			//datas.push(o);
			
			//step 4
			//var dis:DispatchEvent = new DispatchEvent(DataKeyEvent.C_SERVER_LIST);
			//dis.getInfo = datas;
			
			//step 5
			//var arr:Array = [];
			//arr.push(dis);
			
			return null;
		}
	}
}