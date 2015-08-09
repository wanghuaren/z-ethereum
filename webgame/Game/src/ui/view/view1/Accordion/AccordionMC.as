package ui.view.view1.Accordion
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import engine.load.GamelibS;

	/**
	 * @author suhang
	 */
	public final class AccordionMC extends MovieClip implements IAccordionMC
	{
		private var _targetMC:DisplayObject;
		private var _ty:int=0;
		private var _title:TextField;
		public var _btn:SimpleButton;
		public var _btn2:SimpleButton;
		public var titlePic:MovieClip;
		private var _index:int=0;
		private var _select:Boolean;
		private var instance:Sprite=null;

		public function AccordionMC():void
		{
			instance=GamelibS.getswflink("game_index", "mAccordionMC") as Sprite;
			instance.mouseChildren=true;
			instance.buttonMode=true;
			this.addChild(instance);
			_btn=instance["btn"];
			_btn2=instance["btn2"];
			_title=instance["title"];
			titlePic = instance["titlePic"];
			_title.mouseEnabled=false;
			_select=false;
		}

		public function set label(title:String):void
		{
			_title.htmlText=title;
			this.select=_select;
		}

		public function set targetMC(mc:DisplayObject):void
		{
			_targetMC=mc;
		}

		public function get targetMC():DisplayObject
		{
			return _targetMC;
		}

		public function get label():String
		{
			return _title.text;
		}

		public function moveToTarget():void
		{
			var time:Number=0.3;
			TweenLite.to(this, time, {y: this.ty});
			if (targetMC != null)
				TweenLite.to(targetMC, time, {y: this.ty+instance.height});
		}

		public function set index(n:int):void
		{
			_index=n;
		}

		public function get index():int
		{
			return _index;
		}

		public function set select(bo:Boolean):void
		{
			_select=bo;
			if(targetMC)targetMC.visible=bo;
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set ty(yy:int):void
		{
			_ty=yy;
		}

		public function get ty():int
		{
			return _ty;
		}
	}
}
