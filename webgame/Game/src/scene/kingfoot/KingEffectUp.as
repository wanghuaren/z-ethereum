package scene.kingfoot
{
	import flash.display.Sprite;

	public class KingEffectUp extends Sprite
	{
		private static var instanceHash:Array=[]
		
		private var _v:Sprite;
		
		public function KingEffectUp()
		{
			
		}
		
		public function init():void
		{
			if(!this.contains(v))
				this.addChild(v);
			this.x = 0;
			this.y = 0;
		}	
		
		public function get v():Sprite
		{
			if(null == _v)
			{
				_v = new Sprite();
				_v.name = "EffectUpContainer";
				_v.mouseChildren = _v.mouseEnabled = false;
				this.mouseChildren = this.mouseEnabled = false;
			}
			return _v;
		}
		
		public static function getKingEffectUp():KingEffectUp{
			if(instanceHash.length)
				return instanceHash.pop();
			return null
		}
		public function recover():void
		{
			if(_v)
			{
				while(_v.numChildren)
				{
					_v.removeChildAt(_v.numChildren-1);
				}
			}
			while(numChildren)
			{
				this.removeChildAt(numChildren-1);
			}
			instanceHash.push(this)
		}
		
		public function reset():void
		{
			
		}
	}
}