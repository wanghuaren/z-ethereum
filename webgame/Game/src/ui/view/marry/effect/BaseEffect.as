package ui.view.marry.effect
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import world.FileManager;
	
	
	/**
	 * 
	 * @author hpt
	 * 
	 */
	public class BaseEffect extends Sprite implements IEffect
	{
		protected var _loader:Loader;
		protected var _msg:String;
		protected var isChanged:Boolean = false;
		protected var loaded:Boolean = false;
		
		public function BaseEffect(effectName:String)
		{
			this.mouseChildren = this.mouseEnabled = false;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			var url:String = FileManager.instance.getMarryEffectByType(effectName);
			_loader.load(new URLRequest(url));
		}
		
		private function onComplete(e:Event):void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			this.addChild(_loader.content);
			this.loaded = true;
			if (this.isChanged){
				playerEffect();
			}
		}
		
		public function update(value:String):void{
			this._msg = value;
			isChanged = true;
			playerEffect();
		}
		
		private function playerEffect():void{
			if (loaded){
				isChanged = false;
				var eff:MovieClip = (_loader.content as DisplayObjectContainer).getChildAt(0) as MovieClip;
				eff.gotoAndStop(1);
				
				eff.update(this._msg);
				eff.gotoAndPlay(2);
			}
		}
	}
}