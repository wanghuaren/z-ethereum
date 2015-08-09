package ui.view.view2.other{
	import common.config.GameIni;
	import common.config.XmlConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_DropResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_UptargetResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import display.components2.UILd;
	
	import flash.display.MovieClip;
	import flash.net.*;
	
	import netc.Data;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSFetch;
	
	import ui.base.mainStage.UI_index;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;


	/**
	 * 升级奖励【主界面右下】
	 * @author andy
	 * @date   2012-07-11
	 */
	public final class UpTarget extends UIWindow {
		public static var isLoadData:Boolean=false;
		private var isGet:Boolean=false;

		private static var _instance:UpTarget;
		

		public static function getInstance():UpTarget{
			if(_instance==null)
				_instance=new UpTarget();
			
			return _instance;
		}

		
		
		public function UpTarget() {
			super(getLink(WindowName.win_first_see));
		
		}
		
		public function reset():void{
			init();
		}
		
		override protected function init():void {
//			super.init();
//			//升级领取最后一个也领取了，界面直接关闭
//			if(Data.myKing.upTarget==-1){
//				winClose();
//				return;
//			}
//		
//		
//			//
//			var myUpTarget:int =  Data.myKing.upTarget;
//			
//			if(1 == myUpTarget)
//			{
//				(mc as MovieClip).gotoAndStop(2);
//			
//			}else if(2 == myUpTarget)
//			{
//				(mc as MovieClip).gotoAndStop(3);
//			
//			}
////			else if(3 == myUpTarget)
////			{
////				(mc as MovieClip).gotoAndStop(4);
////				
////			}
//			else
//			{
//				(mc as MovieClip).gotoAndStop(1);
//			}			
//						
//			var xml:Pub_UptargetResModel=XmlManager.localres.getUpTargetXml.getResPath(Data.myKing.upTarget) as Pub_UptargetResModel;
//			
//			var next:int=1;
//			
//			if(1 == (mc as MovieClip).currentFrame)
//			{
//				mc["txt_name"].text=xml.title;
//				if (xml.res_id!=0){
//					mc["uil"].source=FileManager.instance.getUpTargetIconById(xml.res_id);
//				}
//			}
//			
//			
//			mc["txt_desc"].text=xml.up_desc;
//			
//			if(xml.level<=Data.myKing.level){
//				if(1 == (mc as MovieClip).currentFrame)
//				{
//					mc["btnOk"].label=Lang.getLabel("pub_ling_qu");
//				}
//				
//				if(2 == (mc as MovieClip).currentFrame)
//				{
//					mc["btnOk3"].label=Lang.getLabel("pub_ling_qu");
//					
//				}
//				
//				if(3 == (mc as MovieClip).currentFrame)
//				{
//					mc["btnOk2"].label=Lang.getLabel("pub_ling_qu");
//				}
//				
//				isGet=true;
//			}else{
//				
//				if(1 == (mc as MovieClip).currentFrame)
//				{
//					mc["btnOk"].label=Lang.getLabel("10077_uptarget",[xml.level]);
//					
//					
//				}
//				
//				if(2 == (mc as MovieClip).currentFrame)
//				{
//					mc["btnOk3"].label=Lang.getLabel("10077_uptarget",[xml.level]);
//				}
//				
//				if(3 == (mc as MovieClip).currentFrame)
//				{
//					mc["btnOk2"].label=Lang.getLabel("10077_uptarget",[xml.level]);
//					
//				}
//				
//				
//				isGet=false;
//				
//			}
//		
//			if(1 == (mc as MovieClip).currentFrame)
//			{
//				var arr:Vector.<Pub_DropResModel>=XmlManager.localres.getDropXml.getResPath2(xml.drop_id) as Vector.<Pub_DropResModel>;
//				var item:Pub_ToolsResModel;
//				arrayLen=arr.length;
//				for(var i:int=1;i<=6;i++){
//					item=null;
//					child=mc["item"+i];
//					if(i<=arrayLen)
//						item=XmlManager.localres.getToolsXml.getResPath(arr[i-1].drop_item_id) as Pub_ToolsResModel;
//					if(item!=null){
//						child["uil"].source=FileManager.instance.getIconSById(item.tool_icon);
//						child["txt_num"].text=VipGift.getInstance().getWan(arr[i-1].drop_num);		
//						var bag:StructBagCell2=new StructBagCell2();
//						bag.itemid=item.tool_id;
//						Data.beiBao.fillCahceData(bag);
//						child.data=bag;
//						CtrlFactory.getUIShow().addTip(child);
//						ItemManager.instance().setEquipFace(child);
//					}else{
//						child["uil"].unload();
//						child["txt_num"].text="";
//						child.data=null;
//						CtrlFactory.getUIShow().removeTip(child);
//						ItemManager.instance().setEquipFace(child,false);
//					}
//				}
//			
//			}
		}
		

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnOk":
				case "btnOk2":
				case "btnOk3":
					if(isGet)
						lingQu();
					else
						winClose();
					break;

			}			
			
		}
		
		/******通讯********/
		/**
		 *	领取
		 */
		public function lingQu():void{
		
			
			var client:PacketCSFetch=new PacketCSFetch();
			client.type=1;
			super.uiSend(client);
			
		}
		

		/**
		 *	是否显示 
		 */
		public static function isShow():void{
//			if(isLoadData==false)return;
//			//var mc_up_target:MovieClip=UI_index.indexMC_mrt["mc_up_target"];
////			if(Data.myKing.level<4){
////				UI_index.indexMC_mrt["btnFreeVIP"].visible=true;
////				mc_up_target.visible=false;
////				return;
////			}else{
//				//mc_up_target.visible=true;
//				if(Data.myKing.level==4)
//					Lang.showMsg(Lang.getClientMsg("10030_uptarget"));
////			}
//			
//			var upId:int=Data.myKing.upTarget;
//			if(upId>0){
//				//mc_up_target.gotoAndStop(upId);
//				var xml:Pub_UptargetResModel=XmlManager.localres.getUpTargetXml.getResPath(upId) as Pub_UptargetResModel;
//				if(xml==null)return;
//				if(Data.myKing.level>=xml.level){
//					
//					//if(null != mc_up_target["mc_effect"]){
//					//mc_up_target["mc_effect"].visible=true;
//					//mc_up_target["mc_effect"].play();
//					//}
//					
//					if(UpTarget.getInstance().isOpen)UpTarget.getInstance().init();
//
//				}else{
//					//
//					//if(mc_up_target["mc_effect"]){
//					//mc_up_target["mc_effect"].visible=false;
//					//mc_up_target["mc_effect"].stop();
//					//}
//				}
//				
//				//mc_up_target.visible=true;
//			}else{
//				//if(mc_up_target!=null&&mc_up_target.parent!=null)mc_up_target.parent.removeChild(mc_up_target);
//			}
		}
		override public function winClose():void
		{
			super.winClose();
		}
		
		/**
		 * 升级目标显示 2014-08-18 
		 */		
		private var arrLevel:Array=null;
		private var mc_target:MovieClip=null;
		private var uild:UILd=null;
		public function checkLevel():void{
			if(arrLevel==null){
				arrLevel=XmlManager.localres.getUpTargetXml.getResPath2(0) as Array;
				uild=new UILd();
				uild.width=141;
				uild.height=97;
				mc_target=new MovieClip();
				//mc_target.mouseChildren=false;
				mc_target.addChild(uild);
				mc_target.name="mc_up_target";	
				mc_target.y=140;
			}	
			if(mc_target.parent!=null)
				mc_target.parent.removeChild(mc_target);
			var curLevel:int=Data.myKing.level;
			for each(var config:Pub_UptargetResModel in arrLevel){
				if(curLevel>=config.min_lv&&curLevel<=config.max_lv){
					uild.source=FileManager.instance.getUpTargetIconById(config.id);
					mc_target["tipParam"]=[config.up_desc];
					Lang.addTip(mc_target,"pub_param");
					UI_index.indexMC_character.addChild(mc_target);
					break;
				}
			}
		}
	}
}




