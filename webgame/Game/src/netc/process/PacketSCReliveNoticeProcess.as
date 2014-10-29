package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCReliveNotice2;
	
	import scene.manager.SceneManager;
	
	import ui.view.view1.fuhuo.FuHuo;

	public class PacketSCReliveNoticeProcess extends PacketBaseProcess
	{
		public function PacketSCReliveNoticeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCReliveNotice2=pack as PacketSCReliveNotice2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//服务器10秒发一次
			FuHuo.flag = p.flag;
			FuHuo.killer_name = p.killer_name;
			
			if(20210065 == SceneManager.instance.currentMapId||
				20200186==SceneManager.instance.currentMapId){
			
				//略过
				
			}else{
				
				FuHuo.instance().open(true);
			}
			
			return p;
		}
	}
}