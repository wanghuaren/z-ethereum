package scene.libclass{
	import com.bellaxu.res.ResTool;
	
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author shuiyue
	 */
	public class MenuList extends MovieClip
	{
		public var index:int;
		public var txtTitle:TextField;
		public var btnButton:SimpleButton;
		private var textFarmat:TextFormat =new TextFormat();
		private var instance:Sprite =null;

		public function MenuList():void
		{
//项目转换			instance=ResTool.getAppMc("mMenuList") as Sprite;
			instance=GamelibS.getswflink("game_index","mMenuList") as Sprite;
			this.addChild(instance);
			txtTitle=instance["txt"];
			btnButton=instance["btn"];
			txtTitle.mouseEnabled=false;
			btnButton.addEventListener(MouseEvent.MOUSE_OVER,MOUSE_OVER);
			btnButton.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_OUT);
			addEventListener(Event.REMOVED_FROM_STAGE,REMOVED_FROM_STAGE);
			textFarmat.color=0xfff5d2;
			txtTitle.setTextFormat(textFarmat);
		}

		private function REMOVED_FROM_STAGE(e:Event):void{
			btnButton.removeEventListener(MouseEvent.MOUSE_OVER,MOUSE_OVER);
			btnButton.removeEventListener(MouseEvent.MOUSE_OUT,MOUSE_OUT);
			removeEventListener(Event.REMOVED_FROM_STAGE,REMOVED_FROM_STAGE);
		}

		private function MOUSE_OVER(e:MouseEvent):void{
			textFarmat.color=0xf8e37f;
			txtTitle.setTextFormat(textFarmat);
		}

		private function MOUSE_OUT(e:MouseEvent):void{
			textFarmat.color=0xfff5d2;
			txtTitle.setTextFormat(textFarmat);
		}

		public function setEnabled(bo:Boolean):void{
			CtrlFactory.getUIShow().setBtnEnabled(this,bo);
		}
	}
}
