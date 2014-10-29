package scene.kingname
{
	import com.bellaxu.res.ResTool;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import world.WorldFactory;
	
	public class KingBloodHead extends Sprite
	{
		private var _v:MovieClip;
		
		public function KingBloodHead():void
		{
		}
		
		public function init():void
		{
			if(null != v && !this.contains(v))
			{
				this.addChild(v);
			}			
			
			//
			if(null != v)v.gotoAndStop(1);
			
			//
			if(null != v)v["redBar"].mask = v["maskBar"];
			
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
				_v = GamelibS.getswflink("game_utils","BloodHead") as MovieClip;
				if(_v)_v.mouseChildren = _v.mouseEnabled = false;
				this.mouseChildren = this.mouseEnabled = false;
			}
			
			return _v;
		}
	}
}