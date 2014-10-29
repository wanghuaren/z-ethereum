package world.map.eidiot{
	import flash.display.MovieClip;
	public class Tile extends MovieClip {
		private var _w : int;
		private var _h : int;
		private var _Obj : Object;
		private var _class : int;//当前路点类型 0=不可通过，1=可通过，2=可通过+透明
		private var 阻碍区:uint=0x0000FF;
		private var 行走区:uint=0xCCCCCC;
		private var 透明区:uint=0x00FFFF;
		public function Tile(p_color : uint = 0xCCCCCC, p_w : int = 10, p_h : int = 10) {
			_Obj={};
			_w=p_w;
			_h=p_h;
			Tcolor=p_color;
		}
		public function set Tcolor(p_color) {
			with (this.graphics) {
				clear();
				lineStyle(1, 0x666666);
				beginFill(p_color,0.9);
				drawRect(0, 0, _w, _h);
				endFill();
			}
		}
		public function set Obj(obj:Object) {
			_Obj=obj;
		}
		public function get Obj():Object {
			return _Obj;
		}
		public function set myclass(Tclass:int) {
			_class=Tclass;
			var p_color:uint=0;
			switch (Tclass) {
				case 0 :
					Tcolor=阻碍区;
					break;
				case 1 :
					Tcolor=行走区;
					break;
				case 2 :
					Tcolor=透明区;
					break;
				default:
					break;
			}
		}
		public function get myclass():int {
			return _class;
		}
	}
}