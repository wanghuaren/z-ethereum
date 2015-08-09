package ui.view.view1.xiaoGongNeng
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	
	import display.components2.UILd;
	
	import flash.net.*;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSOnlinePrize;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIActMap;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	public class ZaiXianLiBao678 extends UIWindow
	{
		
		
		private static var _instance:ZaiXianLiBao678;
		
		public var btnOkEnabled:Boolean;
		
		public static function getInstance():ZaiXianLiBao678{
			if(_instance==null){
				_instance=new ZaiXianLiBao678();
			}
			return _instance;
		}
		
		public function ZaiXianLiBao678()
		{
			super(getLink(WindowName.win_on_line_gift));
		}
		
		
		override protected function init():void 
		{			
			//10200008
//			(mc["uil"] as UILd).source = FileManager.instance.getIconXById(10200008);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getIconXById(10200008));
			//
			var dropId:int  = UIActMap.zaiXianLiBao_Instance.dropId;
			
			var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(dropId) as Vector.<Pub_DropResModel>;
			
			//filter ------------------------------------------------------------
			var myLvl:int = Data.myKing.level;
			
			for(var j:int=0;j<arr.length;j++)
			{
				if(myLvl >= arr[j].min_level &&
					myLvl <= arr[j].max_level)
				{
					//nothing
				}else
				{
					arr.splice(j,1);
					j=-1;
				}
			
			}
			//------------------------------------------------------------------------------
			
			var item:Pub_ToolsResModel;
			arrayLen=arr.length;
			for(var i:int=1;i<=6;i++){
				item=null;
				child=mc["item"+i];
				if(i<=arrayLen)
					item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
				if(item!=null){
//					child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
					ImageUtils.replaceImage(child,child["uil"],FileManager.instance.getIconSById(item.tool_icon));
					var num_:String = VipGift.getInstance().getWan(arr[i-1].drop_num);	
					
					child["txt_num"].text=	num_;
					var bag:StructBagCell2=new StructBagCell2();
					bag.itemid=item.tool_id;					
					Data.beiBao.fillCahceData(bag);
					bag.num = arr[i-1].drop_num;
					child.data=bag;
					CtrlFactory.getUIShow().addTip(child);
					ItemManager.instance().setEquipFace(child);
				}else{
					child["uil"].unload();
					child["txt_num"].text="";
					child.data=null;
					CtrlFactory.getUIShow().removeTip(child);
					ItemManager.instance().setEquipFace(child,false);
				}
			}
			
			
			/*5、界面显示信息为:
			
			第【】次领取奖励
			尊敬的玩家，您今日第【】次开启在线大礼包，奖励【】元宝的礼包奖励
			再过【】分钟可以继续领取元宝奖励哦。
			
			
			
			若为今日最后一次领取礼包，则提示：
			
			第【】次领取奖励
			尊敬的玩家，您今日第【】次开启在线大礼包，奖励【】元宝的礼包奖励。
			今日在线大礼包已领取完毕，明天还可以继续领取哦!*/
			
			var t_l:int = UIActMap.zaiXianLiBao_Instance.times_logic();
			//第几次领取奖励
			mc["txt_name"].text = Lang.getLabel("20096_zaixianlibao",[t_l.toString()]);
			
			if(3 == t_l)
			{
				//尊敬的玩家，您今日第XX次开启在线大礼包，获得XX元宝和道具奖励。\n今日在线大礼包已领取完毕，明天还可以继续领取哦!
				mc["txt_desc"].text = Lang.getLabel("20097_zaixianlibao",[t_l.toString(),arr[0].drop_num.toString()]);
			}else
			{
				
				var nextTime:int  = UIActMap.zaiXianLiBao_Instance.nextTime;
				
				nextTime = int(nextTime/60);
				//尊敬的玩家，您今日第XX次开启在线大礼包，获得XX元宝和道具奖励。\n再过XX分钟可以继续领取元宝奖励哦。
				mc["txt_desc"].text = Lang.getLabel("20098_zaixianlibao",[t_l.toString(),arr[0].drop_num.toString(),nextTime.toString()]);
			}
			
			//test
			//btnOkEnabled = true;
	
			if(btnOkEnabled)
			{
				//领取
				mc["btnOk"].label = Lang.getLabel("pub_ling_qu");
				
				StringUtils.setEnable(mc["btnOk"]);
				
			}else
			{
				//稍后领取
				mc["btnOk"].label = Lang.getLabel("20099_zaixianlibao");
			
				StringUtils.setUnEnable(mc["btnOk"]);
			}
			
			
		
		}
		
		
		
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
		
			var target_name:String= target.name;
			
			switch(target_name) 
			{
				case "btnOk":
					GameMusic.playWave(WaveURL.ui_lingqu_jiangli);
				case "btnAtk":
					var vo9:PacketCSOnlinePrize=new PacketCSOnlinePrize();					
					uiSend(vo9);
					break;
			
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
}