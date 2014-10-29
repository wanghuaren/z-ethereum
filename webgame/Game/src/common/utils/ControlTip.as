package common.utils
{	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.XmlConfig;
	import common.managers.Lang;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import main.Main;
	
	import ui.base.mainStage.UI_index;

	/**
	 *  界面元件悬浮信息控制
	 *	@author andy 
	 *  @date   2011-10-28
	 *   
	 */
	public final class ControlTip
	{
		private var _dicTip:Dictionary=null;
		private var arrLen:int=0;
		private var dicTarget:Dictionary=null;
		//悬浮文本四周间距
		private const padding:int=6;
		//悬浮
		private var mcTip:Sprite=null;
		//悬浮父类
		private var mc_parent:Sprite=null;
		//文本样式
		private var tf:TextFormat=null;
		//
		private var target:DisplayObject=null;
		
		/**
		 *	主界面按钮悬浮宽度 
		 */
		public static const INDEX_TIP_WIDTH:int=120;
		private static var _instance:ControlTip;
		public static function getInstance():ControlTip{
			if(_instance==null)
				_instance=new ControlTip();
			return _instance;
		}
		public function ControlTip()
		{
			initTipWord();
		}
		
		public function init():void{
			initTip();
			
		}
		
		/**
		 *	@param dp       悬浮对象
		 *  @param key      悬浮文字编号
		 *  @param txtWidth 悬浮文本宽度 
		 */
		public function addTip(dp:DisplayObject,key:String="",txtWidth:int=100):void{
			if(dp==null)return;
			if(key=="")return;
			if(!_dicTip.hasOwnProperty(key))return;
			removeTip(dp);
//			dp.addEventListener(MouseEvent.ROLL_OVER,overHandle,false,0,true);
//			dp.addEventListener(MouseEvent.ROLL_OUT,outHandle,false,0,true);
//			dp.addEventListener(MouseEvent.MOUSE_MOVE,moveHandle,false,0,true);
			
			dp.addEventListener(MouseEvent.ROLL_OVER,overHandle);
			dp.addEventListener(MouseEvent.ROLL_OUT,outHandle);
			dp.addEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
			
			dicTarget[dp]={key:key,txtWidth:txtWidth};
		}
		/**
		 *  移除监听
		 *	@param dp       悬浮对象
		 */
		public function removeTip(dp:DisplayObject):void{
			if(dp==null)return;
			dp.removeEventListener(MouseEvent.ROLL_OVER,overHandle);
			dp.removeEventListener(MouseEvent.ROLL_OUT,outHandle);
			dp.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandle);
			if(dicTarget!=null)
			delete dicTarget[dp];
		}
		/**
		 *	强制不显示【突发失去焦点，悬浮无法消失】
		 *  并未移除监听 
		 */
		public function notShow():void{
			if(mcTip!=null&&mcTip.parent!=null)
				mcTip.parent.removeChild(mcTip);
		}
		/**
		 *	重置悬浮
		 **/
		public function resetOver():void
		{
			if (this.target != null )
			{
				target.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			}
		}
		private var timerIndex:int
		private function overHandle(me:MouseEvent):void{
			timerIndex=setTimeout(
			overHandle2,200,me)
		}
		private function overHandle2(me:MouseEvent):void{
		
			
			var key:String=String(dicTarget[me.target]["key"]);
			var w:int=int(dicTarget[me.target]["txtWidth"])
			var word:String=_dicTip[key];
			target=me.target as DisplayObject;
			//替换有参数
			if(me.target.hasOwnProperty("tipParam")&&me.target.tipParam!=null&&me.target.tipParam is Array){
				var arrParam:Array=me.target.tipParam as Array;
				var lenParam:int=arrParam.length;
				
				for(var k:uint=0;k<lenParam;k++){
					word=word.replace("#param",arrParam[k]);
				}
			}
			
			if(null != mcTip){
			var item:TextField=(mcTip.getChildByName("txt") as TextField);
			item.width=w;
			item.htmlText=word;
			item.setTextFormat(tf);
			//flash player 某些播放器存在高度赋值问题，赋值两次
			item.height=item.textHeight+5;
			item.height=item.textHeight+5;

			mcTip.getChildByName("shape").width=item.width+padding*2;
			mcTip.getChildByName("shape").height=item.height+padding*2;
			moveHandle(me);	
			mc_parent.addChild(mcTip);
			}
		}
		private function outHandle(me:MouseEvent):void{
			clearTimeout(timerIndex)
			timerIndex=0
			if(mcTip!=null&&mcTip.parent!=null)
				mcTip.parent.removeChild(mcTip);
		}
		private function moveHandle(me:MouseEvent):void{
			setPostion(me);
		}
		
		private function setPostion(me:MouseEvent):void{
			var p:Point=new Point(me.stageX,me.stageY);
			
			if(null == mcTip)
			{
				return;
			}
			
			mcTip.x=p.x+5;
			mcTip.y=p.y+5;
			if(mc_parent==null)mc_parent=PubData.AlertUI;
			if(mc_parent==null)return;
			if((mcTip.x+mcTip.width)>=mc_parent.stage.stageWidth){
				mcTip.x=p.x-mcTip.width-5;
			}
			
			if((mcTip.y+mcTip.height)>=mc_parent.stage.stageHeight){
				mcTip.y=p.y-mcTip.height-5;
			}
			
		}
		
		private function initTip():void{
			mcTip=new Sprite();
			mcTip.name="pubTip";
			//悬浮容器父类
			mc_parent=PubData.mainUI.Layer5;//PubData.mainUI;
			//悬浮背景
			var shape:*=GamelibS.getswflink("game_utils","xuan_fu_kuang");
			if(shape==null){
				shape=new Shape();
				shape.graphics.lineStyle(0,0xebebeb,.5);
				shape.graphics.lineTo(0,0);
				shape.graphics.lineTo(100,0);
				shape.graphics.lineTo(100,50);
				shape.graphics.lineTo(0,50);
				shape.graphics.lineTo(0,0);
				shape.graphics.beginFill(0x000000);
				shape.graphics.drawRect(0,0,100,50);
				shape.graphics.endFill();
				shape.alpha = 0.9;
			}
			
			shape.name="shape";
			mcTip.addChild(shape);
			
			var txt:TextField=null;
			txt=new TextField();
			txt.name="txt";
			txt.multiline=true;
			txt.wordWrap=true;
			txt.width=100;
			txt.height=30;
			txt.textColor=0xfff5d2;
			txt.x=padding;
			txt.y=padding;
			
			tf=new TextFormat();
			tf.leading=4;
			tf.font="SimSun";
//			tf.font="Microsoft YaHei";
			
			var gf:GlowFilter=new GlowFilter();
			gf.blurX=2;gf.blurY=2;gf.strength=8;gf.color=0x000000;
			txt.filters=[gf];
			
			mcTip.addChild(txt);

			
			
		}
		
		/**
		 *	arrTip[0]=["<font color='#00ff00'>属性</font><br/>快捷键：C<br/>显示你的角色的基本信息"]; 
		 */
		private function initTipWord():void{
			_dicTip=new Dictionary();
			var tips:XML=XML(XmlConfig.LANGXML.tips);
			var tip:XML;
			var key:String;

			for each(tip in tips.t){
				key=String(tip.@k);
				var _tip:String = tip.toString();
				if (GameIni.pf() == GameIni.PF_3366)
				{
					_tip=_tip.replace(/\$2000/g, "蓝钻");
				}
				else
				{
					_tip=_tip.replace(/\$2000/g, "黄钻");
				}
				_dicTip[key]=_tip;
				arrLen++;
			}
			dicTarget=new Dictionary();
		}
		
		public function get dicTip():Dictionary{
			return _dicTip;
		}
	}
}