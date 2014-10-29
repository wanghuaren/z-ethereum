package scene.kingname
{
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	
	public class KingPkHead extends Sprite
	{
		private var _v:MovieClip;
		
		public function KingPkHead()
		{
			
		}
		
		public function init():void
		{
			if(null != v && !this.contains(v))
			{
				this.addChild(v);
			}
			
			if(null != v)v.gotoAndStop(1);
			
			this.x = 0;
			this.y = 0;
		}		
		
		public function gotoAndStop(frame:Object):void
		{
			if(null != v)v.gotoAndStop(frame);
		}
		
		public function gotoAndPlay(frame:Object):void
		{
			if(null != v)v.gotoAndPlay(frame);
		}
		
		//get 
		
		public function get v():MovieClip
		{
			if(null == _v)
			{
				_v = GamelibS.getswflink("game_utils","PkHead") as MovieClip;
				if(_v)_v.mouseChildren = _v.mouseEnabled = false;
				this.mouseChildren = this.mouseEnabled = false;
			}
			
			return _v;
		}
	}
}