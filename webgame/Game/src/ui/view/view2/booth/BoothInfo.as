package ui.view.view2.booth{

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import ui.view.view6.GameAlert;
	import com.greensock.TweenMax;
	
	import ui.frame.UIMovieClip;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	import common.config.GameIni;
	
	import netc.Data;
	import netc.packets2.StructBoothLeaveWord2;
	import netc.packets2.StructBoothSaleItem2;
	
	import engine.support.IPacket;
	import nets.packets.PacketCSBoothLog;
	import nets.packets.PacketSCBoothLog;
	
	import common.utils.CtrlFactory;
	import common.utils.res.ResCtrl;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import common.managers.Lang;

	
	/**
	 * 摆摊信息
	 * @author andy
	 * @date   2013-02-20
	 */
	public final class BoothInfo extends UIWindow {

		
		private static var _instance:BoothInfo;
		public static function getInstance():BoothInfo{
			if(_instance==null)
				_instance=new BoothInfo();
			return _instance;
		}
		public function BoothInfo() {
			super(getLink(WindowName.win_booth_info));
		}
		
		override protected function openFunction():void{
			init();
		}
		
		override protected function init():void {
			mc["txt_booth"].mouseEnabled=false;
			mc["txt_leaveWord"].mouseEnabled=false;
			getBoothLog();
		}
		
		override public function mcHandler(target:Object):void {
			var name:String=target.name;
				
			switch(target.name) {
				case "":
					//
					
					break;
				default:
					break;
				
			}
		}
		

		/*****************通讯***************/
		/**
		 *	获得摆摊日志
		 */
		private function getBoothLog():void{
			this.uiRegister(PacketSCBoothLog.id,SCBoothLogReturn);
			var client:PacketCSBoothLog=new PacketCSBoothLog();
			this.uiSend(client);
			
		}
		private function SCBoothLogReturn(p:PacketSCBoothLog):void{
			mc["txt_booth_time"].htmlText=Lang.getLabel("10172_boothinfo",[Booth.getInstance().getStartTime(),p.total_income]);
			
			var content:String="";
			var tool:Pub_ToolsResModel=null;
			var toolName:String;
			//购买日志
			for each(var item:StructBoothSaleItem2 in p.arrItemsale_items){
				tool=XmlManager.localres.getToolsXml.getResPath(item.itemid) as Pub_ToolsResModel;
				toolName=tool==null?"":tool.tool_name;
				content+=Lang.getLabel("10173_boothinfo",[fmt(item.time),item.count,toolName,item.price])+"\n";
			}
			mc["txt_booth"].htmlText=content;
			mc["txt_booth"].height=mc["txt_booth"].textHeight+5;
			mc["sp1"].source=mc["txt_booth"];
			//留言
			content="";
			for each(var item1:StructBoothLeaveWord2 in p.arrItemleave_words){
				content+=Lang.getLabel("10174_boothinfo",[fmt(item1.time),item1.leave_word])+"\n";
			}
			mc["txt_leaveWord"].htmlText=content;
			mc["txt_leaveWord"].height=mc["txt_leaveWord"].textHeight+5;
			mc["sp2"].source=mc["txt_leaveWord"];
		}
		
		
		/**
		 *	101->1:01 
		 */
		private function fmt(num:int):String{
			var ret:String="";
			ret=(num/100).toFixed(2).replace(".",": ");
			return ret;
		}
		
		
		override public function getID():int
		{
			return 1071;
		}
	}
	
}





