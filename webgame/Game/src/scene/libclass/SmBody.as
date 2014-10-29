package scene.libclass{
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.res.ResTool;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class SmBody extends Sprite{
		
		private var mc:MovieClip;

		private var _objid:uint;
		
		public function SmBody():void{
		//��ʱ mc=ResTool.getMc(ResPathDef.GAME_CORE, "smallmap_self") as MovieClip;
			mc=GamelibS.getswflink("game_utils","mSmBody") as MovieClip;
			//this.mouseEnabled = false;
			this.mouseChildren = false;
			mc["txt_name"].visible=false;
			this.addChild(mc);
		}
		
		public function get objid():uint
		{
			return _objid;
		}
		
		public function reset():void
		{
			_objid = 0;
		}
		
		public function setObjid(value:uint):void
		{
			_objid = value;
		}

		public function setRoleName(objid_:uint,nm:String):void{
			
			_objid = objid_;
			mc["txt_name"].text=nm;
		}
		public function showName(v:Boolean=false):void{
			mc["txt_name"].visible=v;
		}
		public function gotoAndStop(frame:int):void{
			mc.gotoAndStop(frame);
		}

		public function get totalFrames():int{
			return mc.totalFrames;
		}

	}
}
