package common.utils
{
	
	
	import com.greensock.TweenLite;
	
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import ui.frame.FontColor;
	
	import world.WorldEvent;
	
	
	
	
	/**
	 * 
	 * @author hpt
	 * 右下角获得元宝 经验等消息显示
	 */
	public class youXiaJiaoMsg extends Sprite
	{
		private var spTxtContain:Sprite;
		private var zongTxtContain:Sprite;
		private static var m_instance:youXiaJiaoMsg;
		private var MaxNum : int = 3;//显示的最多条数
		public var NEED_TIME:int =20;
		public function youXiaJiaoMsg()
		{
			
			txtArr = new Array();
		}
		
		public function initDraw(_spTxtContain:Sprite):void
		{
			spTxtContain =_spTxtContain;
			
		}
		/**
		 *设置右下角 信息提示背景的高度 
		 * @param _h
		 * */
		public function setContainH(_h:int):void
		{
//			spTxtContain.getChildAt(0).height = _h;
		}
		public static function instance():youXiaJiaoMsg
		{
			if (m_instance == null)
			{
				m_instance=new youXiaJiaoMsg();
			}
			return m_instance;
		}
		public function drawRectContainTxt():void
		{
			
			
		}
		private var txtArr:Array
		public function addTxt(str:String):void
		{
//			spTxtContain.alpha =;
			if(spTxtContain ==null)return;
			var txt:TextField  = createTf();
			txt.htmlText = str;
				var _h:int = 0;
				var totalH:int = 100;
			if(txtArr.length<MaxNum){//如不够3条，逐条加高
				txtArr.push(txt);
				
				
 			}else if(txtArr.length>=MaxNum){///如果超过3条，第一条移除，下面的上移
				txtArr.shift()
				txtArr.push(txt);
			}
			var spNum:int = spTxtContain.numChildren;
			for(var kk:int=0;kk<spNum;kk++){
				spTxtContain.removeChildAt(0);
			}
			for(var i:int = txtArr.length-1;i>=0;i--){
				spTxtContain.addChild(txtArr[i]);
					_h+=txtArr[i].height+3;
					txtArr[i].y =100- _h;
				
				}
//				_h+=txtArr[i].height;
			
//			setContainH(_hBgH);
			spTxtContain.x = 121;
			TweenLite.to(spTxtContain, 0.3, {alpha:1});
			NEED_TIME =20;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
//			setTimeout(ffff,5000);
		}
		
		private function _onClockSecond(e:WorldEvent):void
		{
			if(NEED_TIME <= 0)
			{
				NEED_TIME =20;
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockSecond);
				TweenLite.to(spTxtContain, 3, {alpha:0,onComplete: onCompelte,onCompleteParams: [spTxtContain]});
				
			}
			NEED_TIME = NEED_TIME - 1;
		}
		/**txt容器alpha变为0  将txt移除
		 *  */
		private function onCompelte(obj:DisplayObject):void
		{
			TweenLite.killTweensOf(obj,true);
			spTxtContain.x = 2000;
			if(obj!=null&&obj.parent!=null){
				for(var kk:int=0;kk<spTxtContain.numChildren-1;kk++){
					spTxtContain.removeChildAt(1);
				}
				txtArr = [];
				
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
			tf.mouseEnabled = false;	
			tf.htmlText = "";
			//tf.textColor=0xe29e47;
			//2012-11-21  策划说调成白色
			tf.textColor=FontColor.YOU_XIA_JIAO_ENOUGH;
			
			var f:TextFormat =new TextFormat();
			f.leading=5;
			f.size = 12;
			
				f.font="NSimSun";
//			f.font=Lang.getLabel("pub_font");
			
			tf.defaultTextFormat = f;
			
			CtrlFactory.getUIShow().setfilters(tf);
			
			return tf;
		}
	}
}