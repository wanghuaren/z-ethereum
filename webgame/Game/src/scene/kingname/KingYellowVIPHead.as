package scene.kingname
{
	
	
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.res.ResTool;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import world.WorldFactory;
	
	
	
	public class KingYellowVIPHead extends Sprite
	{
		private var _v:MovieClip;
		
		public function KingYellowVIPHead()
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
		
		public function get v():MovieClip
		{
			if(null == _v)
			{
			//��ʱ _v = ResTool.getMc(ResPathDef.GAME_CORE, "Head_YellowVip") as MovieClip;
				_v = GamelibS.getswflink("game_utils","mYellowVip") as MovieClip;
				if(_v)_v.mouseChildren = _v.mouseEnabled = false;
				this.mouseChildren = this.mouseEnabled = false;
			}
			
			return _v;
		}
	}
}