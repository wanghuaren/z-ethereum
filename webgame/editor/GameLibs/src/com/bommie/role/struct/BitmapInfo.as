package com.bommie.role.struct
{
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	/**
	 * 位图信息
	 * @author Bommie
	 */
	public class BitmapInfo
	{
		private var _isDestroyed:Boolean=false;

		private var _texture:Texture=null;

		private var _x:int=0;
		private var _y:int=0;

		private var _mark:String=null;
		private var _center:int=0;
		private var _centerToFoot:int=0;
		private var _direction:int; //方向 F
		private var _originX:int=0;
		private var _originY:int=0;

		public function set texture(value:Texture):void
		{
			_texture=value;
			if (_texture != null)
			{
				if (m_nResLoadedDic != null)
				{
					var count:int=m_nResLoadedDic[_act] + 1;
					m_nResLoadedDic[_act]=count;
				}
			}
		}

		public function get texture():Texture
		{
			return _texture;
		}

		public function set center(value:int):void
		{
			_center=value;
		}

		public function get center():int
		{
			return _center;
		}

		public function get centerToFoot():int
		{
			return _centerToFoot;
		}

		public function set centerToFoot(value:int):void
		{
			_centerToFoot=value;
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction=value;
		}

		public function set originX(value:int):void
		{
			_originX=value;
		}

		public function get originX():int
		{
			return _originX;
		}
		private var _height:Number=0;

		public function set height(value:Number):void
		{
			_height=value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set originY(value:int):void
		{
			_originY=value;
		}

		public function get originY():int
		{
			return _originY;
		}

		public function set x(value:int):void
		{
			_x=value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set y(value:int):void
		{
			_y=value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set mark(value:String):void
		{
			_mark=value;
		}

		public function get mark():String
		{
			return _mark;
		}
		private var _tag:Object;

		public function get tag():Object
		{
			return _tag;
		}

		public function set tag(value:Object):void
		{
			_tag=value;
		}

		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}

		public function destory(gc:Boolean=false):void
		{
			_isDestroyed=true;
			if (this.texture != null)
			{
				this.texture.dispose();
			}
			this.texture=null;
			this.name=null;
			this.act="D1";
			this.mark=null;
			var key:String;
			key=null;
			this.m_nResLoadedDic=null;
			this.skillPoint.length=0;
			this.skillPoint=null;
			this.x=0;
			this.y=0;
			this.originX=0;
			this.originY=0;
			this.footX=0;
			this.footY=0;
			this.center=0;
			this.centerToFoot=0;
			this.jumpFrame=0;
		}
		private var _jumpFrame:int=1;

		public function get jumpFrame():int
		{
			return _jumpFrame;
		}

		public function set jumpFrame(value:int):void
		{
			_jumpFrame=value;
		}
		private var _footX:int=0;

		public function get footX():int
		{
			return _footX;
		}

		public function set footX(value:int):void
		{
			_footX=value;
		}

		private var _act:String="D1";

		public function get act():String
		{
			return _act;
		}

		public function set act(value:String):void
		{
			_act=value;
		}

		private var _footY:int=0;

		public function get footY():int
		{
			return _footY;
		}

		public function set footY(value:int):void
		{
			_footY=value;
		}

		private var _wingX:int=0;

		public function get wingX():int
		{
			return _wingX;
		}

		public function set wingX(value:int):void
		{
			_wingX=value;
		}

		private var _wingY:int=0;

		public function get wingY():int
		{
			return _wingY;
		}

		public function set wingY(value:int):void
		{
			_wingY=value;
		}
		private var _skillPoint:Vector.<int>;

		public function get skillPoint():Vector.<int>
		{
			return _skillPoint;
		}

		public function set skillPoint(value:Vector.<int>):void
		{
			_skillPoint=value;
		}

		private var _name:String;

		public function set name(value:String):void
		{
			_name=value;
		}

		public function get name():String
		{
			return _name;
		}

		private var m_nResLoadedDic:Dictionary;

		public function set resLoadedDic(value:Dictionary):void
		{
			this.m_nResLoadedDic=value;
		}
	}
}
