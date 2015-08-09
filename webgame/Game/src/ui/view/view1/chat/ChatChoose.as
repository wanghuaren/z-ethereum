package ui.view.view1.chat
{

	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import common.config.PubData;
	
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.bit.BitUtil;
	import common.utils.component.ButtonGroup;
	
	import ui.frame.UIWindow;

	/**
	 *@author suhang
	 *@version 2011-12
	 */
	public class ChatChoose extends UIWindow
	{
		public static var show:uint=3;
		public static var bg:ButtonGroup;
		private var Clist:Sprite;
		//private var max:int = 3;   //最大选择数
		//2012-11-29 andy  按钮间隔
		public static const BUTTON_PADDING:int=1;
		
		public function ChatChoose()
		{
			super(getLink("pop_chuang_jian"));
		}

		private static var _instance:ChatChoose=null;

		public static function get instance():ChatChoose
		{
			if (null == _instance)
			{
				_instance=new ChatChoose();
			}
			return _instance;
		}

		// 面板初始化
		override protected function init():void
		{
			super.init();
			mc["check1"].selected=BitUtil.getOneToOne(show, 3, 3) == 1 ? true : false;
			mc["check2"].selected=BitUtil.getOneToOne(show, 4, 4) == 1 ? true : false;
			mc["check3"].selected=BitUtil.getOneToOne(show, 5, 5) == 1 ? true : false;
			mc["check4"].selected=BitUtil.getOneToOne(show, 6, 6) == 1 ? true : false;
			mc["check5"].selected=BitUtil.getOneToOne(show, 7, 7) == 1 ? true : false;
			mc["check6"].selected=BitUtil.getOneToOne(show, 8, 8) == 1 ? true : false;
			checkButton();
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			if(target.name.indexOf("check")==0){
				target.selected = !target.selected;
				checkButton();
			}
			switch (target.name)
			{
				case "btnSubmit":
					show=CtrlFactory.getUICtrl().twoTOten([1,1,mc["check1"].selected ? 1 : 0, mc["check2"].selected ? 1 : 0, mc["check3"].selected ? 1 : 0, mc["check4"].selected ? 1 : 0, mc["check5"].selected ? 1 : 0, mc["check6"].selected ? 1 : 0]);
					winClose();
					
					setButton();
					break;
			}
		}
		
		private function checkButton():void{
			var num:int=0;
			mc["check1"].selected?num++:"";
			mc["check2"].selected?num++:"";
			mc["check3"].selected?num++:"";
			mc["check4"].selected?num++:"";
			mc["check5"].selected?num++:"";
			mc["check6"].selected?num++:"";
			if(num>2){
				for(var i:int=1;i<7;i++){
					if(mc["check"+i].selected==false){
						StringUtils.setUnEnable(mc["check"+i]);
						StringUtils.setUnEnable(mc["txt"+i]);
					}
				}
			}
			if(num<3){
				for(var j:int=1;j<7;j++){
					StringUtils.setEnable(mc["check"+j]);
					StringUtils.setEnable(mc["txt"+j]);		
				}
			}
		}
		
		private function setButton():void{
			//聊天显示区域
			Clist = PubData.chat.mc["Clist"];
			while(Clist.numChildren>1){
				Clist.removeChildAt(1);
			}
			var num:int=0;
			var disO:MovieClip;
			for(var j:int=1;j<9;j++){
				if(BitUtil.getOneToOne(show, j, j) == 1){
					disO = getLink("messageType"+j) as MovieClip;
					disO.name = "messageType"+j;
					disO.x = (disO.width+BUTTON_PADDING)*(num);
					disO.gotoAndStop(1);
					Clist.addChild(disO);
					num++;
				}
			}
			if(disO!=null){
				Clist["chooseBtn"].x = (disO.width+BUTTON_PADDING)*num;
			}else{
				Clist["chooseBtn"].x = 0;
			}
			
			var arrBtn:Array = new Array;
			for(var z:int=1;z<Clist.numChildren;z++){
				arrBtn.push(Clist.getChildAt(z));
			}
			if(arrBtn.length>0){
				bg = new ButtonGroup(arrBtn,1);
				sysAddEvent(bg, DispatchEvent.EVENT_DOWN_HANDER, downHander);
				downHander(new DispatchEvent("",{name:"messageType1"}));
			}
		}
		
		public static function downHander(e:DispatchEvent):void {
			switch(e.getInfo.name) {
				case "messageType1":
					PubData.chat.btnClick(1);
					break;
				case "messageType2":
					PubData.chat.btnClick(2);
					break;
				case "messageType3":
					PubData.chat.btnClick(3);
					break;
				case "messageType4":
					PubData.chat.btnClick(4);
					break;
				case "messageType5":
					PubData.chat.btnClick(5);
					break;
				case "messageType6"://交易
					PubData.chat.btnClick(6);
					break;
				case "messageType7":
					PubData.chat.btnClick(7);
					break;
				case "messageType8":
					PubData.chat.btnClick(8);
					break;
			}
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
		}
	}
}