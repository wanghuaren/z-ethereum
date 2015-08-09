package ui.view.view2.other
{

	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_ExploitResModel;
	import common.managers.Lang;
	
	import display.components.CmbArrange;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.FontColor;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;
	
	
	/**
	 *	悬赏兑换军阶
	 *  andy 2013-12-30  3000万
	 */
	public class XuanShangDuiHuan extends UIWindow
	{
		/**
		 *	军阶最高等级 
		 */
		public static const MAX_LEVEL:int=10;
		private var nextLevel:int=0;
		
		private static var _instance:XuanShangDuiHuan;
		
		public static function getInstance():XuanShangDuiHuan
		{
			if (_instance == null)
			{
				_instance=new XuanShangDuiHuan();
			}
			return _instance;
		}
		
		//是否还能免费刷新
		private var isFreeRefresh:Boolean=true;
		
		public function XuanShangDuiHuan()
		{
			super(this.getLink(WindowName.win_xuanshang_exchange));
		}
		
		override protected function init():void
		{
			super.init();
			super.uiRegister(PacketSCExChangePloit.id, SCExChangePloitReturn);
			Lang.addTip(mc["btnSource"],"xuanshang_duihuan");
			mc["btnDuiHuan"].visible=true;
			show();
		}
		
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;

			switch (name)
			{
				case "btnDuiHuan":
					//购买次数
					SCExChangePloit();
					break;
				case "btnXuanShang":
					//悬赏
					super.winClose();
					XuanShang.getInstance().open();
					break;
				default :
					break;
			}
		}
		
		/**
		 *	悬赏任务列表信息
		 */
		public function show():void
		{
			//威望值
			mc["txt_rep"].htmlText=Data.myKing.exp2;
			var curLevel:int=Data.myKing.ploitLv;
			nextLevel=curLevel+1;
			if(nextLevel>MAX_LEVEL){
				nextLevel=MAX_LEVEL;
			}
			var curLevelChina:String=XmlRes.getChinaNumber(nextLevel);
			var ploitModel:Pub_ExploitResModel=XmlManager.localres.exploitXml.getResPath(nextLevel) as Pub_ExploitResModel;
			if(ploitModel!=null){
				if(curLevel<MAX_LEVEL){
					var color:String=Data.myKing.exp2>=ploitModel.need_exploit?FontColor.TOOL_ENOUGH:FontColor.TOOL_NOT_ENOUGH;
					mc["txt_need"].htmlText="<font color='#"+color+"'>"+Lang.getLabel("10005_xuanshang",[curLevelChina,ploitModel.need_exploit])+"</font>";
				}else{
					mc["txt_need"].htmlText="<font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>"+Lang.getLabel("10006_xuanshang")+"</font>";
					mc["btnDuiHuan"].visible=false;
				}
				mc["txt_name1"].text=curLevelChina;
				mc["txt_name2"].htmlText=ploitModel.exploit_name;
				
				mc["txt_att1"].text=curLevelChina;
				mc["txt_att2"].htmlText=ploitModel.exploit_desc;
			}else{
				
			}
		}
		
		/**
		 *	得到军阶名字
		 *  2013-01-03
		 */
		public static function getJunJieName(level:int):String
		{
			var ploitModel:Pub_ExploitResModel=XmlManager.localres.exploitXml.getResPath(level) as Pub_ExploitResModel;
			if(ploitModel!=null)
				return ploitModel.exploit_name;
			else
				return "";
			
		}
		/********通讯*************/
		/**
		 *	兑换 
		 *  2013-12-30
		 */
		private function SCExChangePloit():void
		{
			var client:PacketCSExChangePloit=new PacketCSExChangePloit();
			client.index=nextLevel;
			super.uiSend(client);
		}
		
		private function SCExChangePloitReturn(p:PacketSCExChangePloit):void
		{
			if(super.showResult(p)){
				show();
			}else{
				
			}
		}

		
		/************内部方法*************/

		/**
		 *	 
		 */
		private function clear():void{
			for(i=0;i<8;i++){
				child=mc["item"+(i+1)];
				if(child==null)continue;
				child.visible=false;
			}
		}


		
		override public function getID():int
		{
			return 0;
		}
		
	}
}


