package ui.view
{
	import com.bellaxu.display.FubenTips;
	
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.GamePrintByShiHuang;
	
	import engine.load.GamelibS;
	
	import flash.display.Sprite;
	
	import model.guest.NewGuestModel;
	
	import netc.Data;
	import netc.packets2.PacketSCMsg2;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketSCNpcSysDialog;
	
	import scene.human.GameRes;
	
	import ui.base.huodong.LeFanTian;
	import ui.base.huodong.ZhenMoGu;
	import ui.base.npc.mission.MissionNPC;
	import ui.frame.RightDownTip;
	import ui.frame.RightDownTipManager;
	import ui.view.view1.desctip.GameTip;
	import ui.view.view1.xiaoGongNeng.WuPinShiYongTiShi;
	import ui.view.view2.other.ExpiredTip;
	import ui.view.view2.other.TuLongDao;
	import ui.view.view4.shenbing.Shenbing;

	/**
	 * 测试使用
	 *  @author wangwen
	 * 
	 */	
	public class Test
	{
		public function Test()
		{
			
		}
		
		private static var cnt:int=0;
		public static function excute():void{
			if(GameIni.urlval!=null)return;
//			FubenTips.show(360, "有一种感情叫兄弟", "有一处圣地叫沙城", "还记得那热血激情吗");
//			FubenTips.show(360,GamelibS.getswflink("game_index","MapTips20220032") as Sprite);
//			var _rightDownTip:RightDownTip = null;
//			var item:StructBagCell2=new StructBagCell2();
//			item.itemid=11309102;
//			Data.beiBao.fillCahceData(item);
//			var _rightDownTip = RightDownTipManager.getInstance().getOneTipZB();
//			_rightDownTip.setData(item.icon,item.itemname,item.desc);
//			_rightDownTip.setDataByStructBagCell2(item);
//			_rightDownTip.open();
			
			
//			var value:PacketSCMsg2=new PacketSCMsg2();
//			value.tag=18908;
//			Lang.showResult({tag: value.tag, arrItemequipattrs: value.arrItemequipattrs, arrItemparams: value.arrItemparams});
			
//			LeFanTian.getInstance().open();
			
			//镇蘑菇
//			GameTip.addTipButton(null, 2, "1", {type: 1});
//			GameTip.addTipButton(null, 2, "2", {type: 2});
//			GameTip.addTipButton(null, 2, "3", {type: 3});
//			GameTip.addTipButton(null, 2, "4", {type: 4});
//			GameTip.addTipButton(null, 2, "5", {type: 5});
			
//			GamePrintByShiHuang.Print("始皇");
//			UIMessage.CMessage19("19");
//			UIMessage.CMessage20("20");
			//测试npc消息
//				var dia:PacketSCNpcSysDialog=new PacketSCNpcSysDialog();
//				dia.r_id=1;
//				dia.param1=81;
//				MissionNPC.instance().NpcSysDialog(dia);
			
			//测试引导
			NewGuestModel.getInstance().handleNewGuestEvent(1068,0,null);
			//测试服务端显示消息
//			Lang.showMsg(Lang.getServerMsg(99975));
			//
//			GameTip.addTipButton(null, 5, "12000001", {msg:"" });
			
//			WuPinShiYongTiShi.instance().open();
//			ExpiredTip.getInstance().setData(12000001);
			
//			Shenbing.getInstance().open();
//			TuLongDao.instance.open();
		}
	}
}