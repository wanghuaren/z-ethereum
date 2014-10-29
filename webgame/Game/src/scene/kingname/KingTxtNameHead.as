package scene.kingname
{
	
	
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.res.ResTool;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import world.WorldFactory;

	public class KingTxtNameHead extends Sprite
	{
		private var _v:MovieClip;
		
		public function KingTxtNameHead()
		{
		}
		
		public function init():void
		{
			
			if(null != v && !this.contains(v))
			{
				this.addChild(v);
			}
			
			if(null != v)v.gotoAndStop(1);
						
			//				
			if(null != v)v["Kname"].autoSize=TextFieldAutoSize.CENTER;
			
			//
			if(null != v)v["Kname"].htmlText = "";
			
			//性能优化
			if(null != v)
				v["Kname"].cacheAsBitmap = true;
			
			//--------------------------
			if(null != v)v["KnameVipVip"].gotoAndStop(1);
			
			this.x = 0;
			this.y = 0;
			
			//
			this.removeEventListener(Event.REMOVED_FROM_STAGE, 
				WorldFactory.TXTNAME_HEAD_REMOVED_FROM_STAGE);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, 
				WorldFactory.TXTNAME_HEAD_REMOVED_FROM_STAGE);
			
		}		
		
		public function gotoAndStop(frame:Object):void
		{
			v.gotoAndStop(frame);
		}
		
		public function gotoAndPlay(frame:Object):void
		{
			v.gotoAndPlay(frame);
		}
		
		//get 
		
		public function get v():MovieClip
		{
			if(null == _v)
			{
			//项目转换 _v = ResTool.getMc(ResPathDef.GAME_CORE, "Head_Name") as MovieClip;
				//_v = GamelibS.getswflink("game_login","mKingHeadName") as MovieClip;
				_v = GamelibS.getswflink("game_utils","TxtHead") as MovieClip;
				if(_v)_v.mouseChildren = _v.mouseEnabled = false;
				this.mouseChildren = this.mouseEnabled = false;
			}
			return _v;
		}
	}
}