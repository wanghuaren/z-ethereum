package ui.view.view4.yunying
{
	import common.config.PubData;
	
	import model.guest.NewGuestModel;
	
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view4.qq.QQYellowCenterPay;

	public class ZhiZunVIPMain extends UIWindow
	{
		//curMc
		private var panel:UIPanel;

		private var childIndex:int=0;

		private static var _instance:ZhiZunVIPMain;

		public function ZhiZunVIPMain()
		{
			super(getLink(WindowName.win_zhizun_vip_xin));
		}

		public static function getInstance():ZhiZunVIPMain
		{
			if(_instance==null){
				_instance=new ZhiZunVIPMain();
			}
			return _instance;
		}
		
		override protected function openFunction():void{
			init();
		}
		override protected function init():void{
			super.init();
			super.blmBtn=2;
			if(type==0) type=1;
			mcHandler({name:"cbtn"+type});
			
		}	
		
		override protected function mcDoubleClickHandler(target:Object):void
		{
			if(panel!=null){
				panel.mcDoubleClickHandler(target);
			}
		}

		override public function mcHandler(target:Object):void
		{
			var _name:String=target.name;
			//panel事件
			if(_name.indexOf("cbtn")==-1){
				if(panel!=null) panel.mcHandler(target);
				return;
			}

			super.mcHandler(target);
			if(panel!=null&&panel.parent!=null)panel.parent.removeChild(panel);
			
			type=int(_name.replace("cbtn",""));
			switch(_name){
				case "cbtn1":
					//VIP(原来的至尊VIP Class name:ZhiZunVIP)
					panel=ZhiZunVIP.getInstance();
					break;
				case "cbtn2":
					//至尊VIP(新的至尊VIP) 
					panel=ZhiZunVIP_New.getInstance();
					break;
				default:
					break;
			}
			panel.x=0;
			panel.y=0;
			panel.type=childIndex;
			panel.init();
			this.mc["mc_content"].addChild(panel);
		}

		private var callBackFunc:Function=null;
		public function setType(v:int,must:Boolean=false,f:Function=null,childMenu:int=0):void{			
			type=v;
			callBackFunc=f;
			childIndex=childMenu;
			super.open(must);
		}
		
		override protected function windowClose():void{
			NewGuestModel.getInstance().handleNewGuestEvent(1064,4,null);
			super.windowClose();
			if(panel!=null)panel.windowClose();
			
		}

		override public function get width():Number
		{
			return 934;
		}

		override public function get height():Number
		{
			return 583;
		}
		
		public function getPanel():UIPanel{
			return panel;
		}


	}

}
