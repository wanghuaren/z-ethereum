package ui.view.view3.jiFenDuiHuanXunBao
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import display.components.CmbArrange;
	
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import model.yunying.XunBaoModel;
	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 *寻宝 积分兑换 
	 * @author Administrator
	 * 
	 */
	public class JiFenDuiHuan extends UIWindow
	{
		
		private static var _instance:JiFenDuiHuan;
		
		public function JiFenDuiHuan(DO:DisplayObject=null)
		{
			super(this.getLink(WindowName.win_ji_fen_dui_huan));
		}
		public static function instance():JiFenDuiHuan{
			if(_instance==null){
				_instance=new JiFenDuiHuan();
			}
			return _instance;
		}
		override protected function openFunction():void
		{
			init();
			
		}
		private var jifenDuihuanArr:Array ;
		override protected  function init():void{
			mc["txt_grade"].htmlText = Lang.getLabel("5010_xunBaoJiFen",[Data.myKing.xunBaovalue]);
//			XunBaoModel.getInstance().getGrade();
			jifenDuihuanArr = Lang.getLabelArr("arrJiFenDuihuan");
			
			var str1:String;
			var str1Arr:Array;
			for(var i:int=0;i<jifenDuihuanArr.length;i++){
				str1=jifenDuihuanArr[i];
				str1Arr = str1.split("_");
				var text:TextField = createTf();
				mc.addChild(text);
				text.x = mc["zhongleimc"].x;
				text.y =  mc["zhongleimc"].y+i*25;
				text.htmlText = str1Arr[0];
				text.addEventListener(TextEvent.LINK,_onTextLink);    
					
			}
//			mcHandler({name:"wuqi"})
		}
		private function _onTextLink(e:TextEvent):void
		{
			var _arr:Array=e.text.split("@");
			var idx:int = -1; 
			var str1:int = int(e.text);
			if(1== _arr[1])
			{
				JiFenDuiHuanList.instance().setType(_arr[0],true,true);
				JiFenDuiHuanList.instance().setDuiHuanName(e.target.text);
			}else{
				JiFenDuiHuanList.instance().setType(_arr[0],true,false);
				JiFenDuiHuanList.instance().setDuiHuanName(e.target.text);
			}
			
		}
		
		private function createTf():TextField
		{
			var tf:TextField = new TextField();
			
			tf.width = 196;
			tf.height = 16;
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.autoSize = "left";
			//			tf.maxChars = 13;
			tf.mouseWheelEnabled = false;				
//			tf.mouseEnabled = false;	
			tf.htmlText = "";
			//tf.textColor=0xe29e47;
			//2012-11-21  策划说调成白色
//			tf.textColor=0x8afd5c;
			
			var f:TextFormat =new TextFormat();
			f.leading=5;
			f.size = 14;
			
			f.font="NSimSun";
			//			f.font=Lang.getLabel("pub_font");
			
			tf.defaultTextFormat = f;
			
			CtrlFactory.getUIShow().setfilters(tf);
			
			return tf;
		}
		public function setXunBaoValue():void
		{
			mc["txt_grade"].htmlText = Lang.getLabel("5010_xunBaoJiFen",[XunBaoModel.getInstance().getGrade()]);
		}
		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			var str1:String;
			var str1Arr:Array;
			switch(name){
//				case "wuqi":
//					str1=jifenDuihuanArr[0];
//					str1Arr = str1.split("_");
//					JiFenDuiHuanList.instance().setType(str1Arr[1],true);
//					JiFenDuiHuanList.instance().setDuiHuanName(str1Arr[0]);
//					
//					break;
//				case "fushi":
//					str1=jifenDuihuanArr[1];
//					str1Arr = str1.split("_");
//					JiFenDuiHuanList.instance().setType(str1Arr[1],true);
//					JiFenDuiHuanList.instance().setDuiHuanName(str1Arr[0]);
//					break;
//				case "daoju":
//					str1=jifenDuihuanArr[2];
//					str1Arr = str1.split("_");
//					JiFenDuiHuanList.instance().setType(str1Arr[1],true);
//					JiFenDuiHuanList.instance().setDuiHuanName(str1Arr[0]);
//					break;
				default :
					break;
			}
			
		}
		override protected function windowClose():void{
			super.windowClose();
		}
		
		override public function getID():int
		{
			return 1083;
		}
	}
}