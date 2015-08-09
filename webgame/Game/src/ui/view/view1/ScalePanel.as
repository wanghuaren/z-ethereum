package ui.view.view1
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.managers.Lang;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCPetData2;
	
	import ui.base.mainStage.UI_index;
	import ui.view.view1.zhanlizhi.ZhanLiZhi;
	import ui.base.jiaose.JiaoSe;
	import ui.base.jiaose.JiaoSeMain;
	import ui.base.vip.DuiHuan;
	import ui.base.vip.Vip;
	import ui.view.view4.yunying.ZhiZunVIP;
	import ui.view.view4.yunying.ZhiZunVIPMain;

//屏幕上边的属性显示条
	public class ScalePanel
	{
		private var mc:Sprite;

		private var vip:int;
		private var yuanbao:int;
		private var yiliang:int;
		private var zhanlizhi:int;
		private var shengwang:int;
		private var dengji:int;
		private var jingyan:int;

		private static var _instance:ScalePanel=null;

		public static function get instance():ScalePanel
		{
			if (null == _instance)
			{
				_instance=new ScalePanel();
			}
			return _instance;
		}

		public function ScalePanel()
		{
//			return;
			mc=UI_index.indexMC["scalePanel"];
			
			if(null == mc)
			{
				return;
			}
			
			mc["vip"].mouseChildren=false;
			mc["yuanbao"].mouseChildren=false;
			//2013-02-26 andy 绑定元宝
			mc["bangding_yuanbao"].mouseChildren=false;
			mc["yiliang"].mouseChildren=false;
			mc["zhanlizhi"].mouseChildren=false;
			mc["shengwang"].mouseChildren=false;
			mc["dengji"].mouseChildren=false;
			mc["jingyan"].mouseChildren=false;

//			mc.addEventListener(MouseEvent.MOUSE_OVER, MOUSE_OVER);

			//setTimeout(function():void
			//{
				vip_UPDATE();
				coin_UPDATE();
				zhanlizhi_UPDATE();
				shengwang_UPDATE();
				dengji_UPDATE();
				jingyan_UPDATE();
			//}, 2000);
            //监听各种属性的变化
			Data.myKing.addEventListener(MyCharacterSet.VIP_UPDATE, vip_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.TEST_VIP_UPDATE, vip_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.COIN_UPDATE, coin_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.FIGHT_VALUE_UPDATE, zhanlizhi_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.RENOWN_ADD, shengwang_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.LEVEL_UPDATE, dengji_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.EXP_UPDATE, jingyan_UPDATE);
			Data.myKing.addEventListener(MyCharacterSet.EXP_ADD, jingyan_UPDATE);
//			Data.huoBan.addEventListener(HuoBanSet.FIGHT_VALUE_UPDATE_PET, zhanlizhi_UPDATE);
//			Data.huoBan.addEventListener(HuoBanSet.FIGHT_UPDATE_PET, zhanlizhi_UPDATE);
//			
			//添加悬浮 【暂时废弃】
//			Lang.addTip(mc["vip"], "ui_index_scale_vip",170);
//			Lang.addTip(mc["yuanbao"], "ui_index_scale_yuanbao",170);
//			Lang.addTip(mc["bangding_yuanbao"], "ui_index_scale_bangding",170);
//			Lang.addTip(mc["yiliang"], "ui_index_scale_yiliang",170);
//			Lang.addTip(mc["zhanlizhi"], "ui_index_scale_zhanlizhi",170);
//			Lang.addTip(mc["shengwang"], "ui_index_scale_shengwang",170);
//			Lang.addTip(mc["dengji"], "ui_index_scale_dengji",170);
//			Lang.addTip(mc["jingyan"], "ui_index_scale_jingyan",170);
//
//			mc.addEventListener(MouseEvent.CLICK, mc_click);
		}

		private function MOUSE_OVER(e:MouseEvent):void
		{
			var target:MovieClip=e.target as MovieClip;
			if (target == null)
				return;
			target.gotoAndStop(2);
			target.addEventListener(MouseEvent.ROLL_OUT, ROLL_OUT);
		}

		private function ROLL_OUT(e:MouseEvent):void
		{
			(e.target as MovieClip).gotoAndStop(1);
			e.target.removeEventListener(MouseEvent.ROLL_OUT, ROLL_OUT);
		}

		private function vip_UPDATE(e:DispatchEvent=null):void
		{
			vip=Data.myKing.Vip;
			//2012-10-20 andy 策划说这个vip若真实vip为0，则显示体验vip
			if(vip==0){
				vip=Data.myKing.TestVIP;
			}
			mc["vip"]["txt"].text=vip + "";
		}

		private function coin_UPDATE(e:DispatchEvent=null):void
		{
			mc["yiliang"]["txt"].text=Data.myKing.coin1;
			mc["bangding_yuanbao"]["txt"].text=Data.myKing.coin2;
			mc["yuanbao"]["txt"].text=Data.myKing.coin3;
		}


		public function zhanlizhi_UPDATE(e:Event=null):void
		{
//			zhanlizhi=Data.myKing.FightValue;
//			var ccz:PacketSCPetData2 =  Data.huoBan.getCurrentChuZhan();
//			if(ccz){
//				zhanlizhi += ccz.FightValue;
//			}
//			mc["zhanlizhi"]["txt"].text=zhanlizhi.toString();
		}

		private function shengwang_UPDATE(e:DispatchEvent=null):void
		{
			shengwang=Data.myKing.Renown;
			mc["shengwang"]["txt"].text=shengwang + "";
		}

		private function dengji_UPDATE(e:DispatchEvent=null):void
		{
			dengji=Data.myKing.level;
			mc["dengji"]["txt"].text=dengji + "";
		}

		private function jingyan_UPDATE(e:DispatchEvent=null):void
		{
			var model:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level) as Pub_ExpResModel;
			
			if(null == model)
			{
				return;
			}
			
			var val:int=int(Data.myKing.exp / model.king * 100);
			jingyan=val;
			mc["jingyan"]["txt"].text=jingyan + "%";
		}

		private function mc_click(e:MouseEvent):void
		{
			switch (e.target.name)
			{
				case "vip":
				case "yuanbao":
				case "bangding_yuanbao":	
//					Vip.getInstance().setData(0);
					ZhiZunVIPMain.getInstance().open(true);
					break;
				case "yiliang":
					DuiHuan.getInstance().open();
					break;
				case "zhanlizhi":
					ZhanLiZhi.instance();
					break;
				case "dengji":
				case "jingyan":
					JiaoSeMain.getInstance().setType(1);
					break;
				case "shengwang":
					
					break;
				default:
					break;
			}
		}

	}
}