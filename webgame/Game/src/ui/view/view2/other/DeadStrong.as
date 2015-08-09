package ui.view.view2.other{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Interface_ClewResModel;
	import common.utils.CtrlFactory;
	
	import flash.events.TextEvent;
	import flash.net.*;
	
	import netc.Data;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.view2.liandanlu.LianDanLu;
	
	import world.FileManager;


	/**
	 * 死亡后如何强大【主界面右下】
	 * @author andy
	 * @date   2012-06-18
	 */
	public final class DeadStrong extends UIWindow {
		//快速回城卷轴
		private var vec:Vector.<Pub_Interface_ClewResModel>;
		private var arrTip:Array=[0,0,0,0,0,0,0];
		
		public static const MIN_LEVEL:int=1000;//13;
		public static const MAX_LEVEL:int=8000;//80;
		
		
		private static var _instance:DeadStrong;
		public static function getInstance():DeadStrong{
			if(_instance==null)
				_instance=new DeadStrong();
			return _instance;
		}
		
		public static function hasInstance():Boolean
		{
			return _instance==null?false:true;
		}
		
		public function DeadStrong() {
			super(getLink("win_dead_strong"));
		}

		override protected function init():void {
			super.init();
			this.x=GameIni.MAP_SIZE_W-50-mc.width;
			this.y=GameIni.MAP_SIZE_H-50-mc.height;
			//2012-11-01 强化装备远离死亡
			var level:int=Data.myKing.level;

			if(vec==null){
				vec=XmlManager.localres.getInterfaceClewXml.getResPath_BySort(2) as Vector.<Pub_Interface_ClewResModel>;	
			}	
			if(vec==null||vec.length==0)return;
			
			mc["txt_link"].removeEventListener(TextEvent.LINK,textLink);
			mc["txt_link"].addEventListener(TextEvent.LINK,textLink);
			
			
			curPage=1;
			var arr:Array;
			for each(var item:Pub_Interface_ClewResModel in vec){
				arr=item.para3.split(",");
				if(arr!=null&&arr.length>0){
					//2012-11-01 死亡提示根据人物等级区间显示
					if(level>=arr[0]&&level<=arr[1]){
						this.curPage=item.skip;
						//每天第一次提示有黄色箭头
						if(arrTip[curPage]==0){
							arrTip[curPage]=1;
						}
						break;
					}
				}
			}
			this.total=vec.length;
			setData();
			
		}
		

		override public function mcHandler(target:Object):void {
			switch(target.name) {
				case "btnL":
					if(curPage>1){
						curPage--;
						setData();
					}
					break;
				case "btnR":
					if(curPage<this.total){
						curPage++;
						setData();
					}
					break;
			}			
		}
		
		private function setData():void{
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnL"],curPage>1);
			CtrlFactory.getUIShow().setBtnEnabled(mc["btnR"],curPage<this.total);
		
			if(vec!=null&&vec.length>0){
				var item:Pub_Interface_ClewResModel=vec[curPage-1];
//				mc["uil"].source=FileManager.instance.getDeadStrongId(item.res_id);
				ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getDeadStrongId(item.res_id));
				mc["txt_name"].text=item.interface_name;
				mc["txt_desc"].text=item.para1;
				mc["txt_link"].htmlText="<a href='event:"+item.interface_id+"'>"+item.para2+"</a>";
			}
		}
		
		/**
		 *	点击文字 
		 */
		private function textLink(te:TextEvent):void{
			var tp:int=int(te.text);
			switch(tp){
				case 2001:LianDanLu.instance().setType(1,true);break;
				case 2002:LianDanLu.instance().setType(2,true);break;
				case 2003:LianDanLu.instance().setType(4,true);break;
				case 2004:JingJie2Win.getInstance().open(true);break;
				case 2005:LianDanLu.instance().setType(3,true);break;
				//case 2006:GuanXingTaiWindow.getInstance().open(true);break;
				default:break;
			}
		}
		
		
	}
}




