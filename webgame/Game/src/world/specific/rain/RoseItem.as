package world.specific.rain
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class RoseItem
	{
		public var x:int=0;
		public var y:int=0;
		public var bitmapData:BitmapData;
		public var speed:int=0;
		public var rotation:int=0;
		private var _matrix:Matrix=new Matrix();
		private var pi:Number=Math.PI / 180;

		public function RoseItem()
		{
		}

		public function get matrix():Matrix
		{
			_matrix.a=1;
			_matrix.b=0;
			_matrix.c=0;
			_matrix.d=1;
			_matrix.rotate(rotation * pi);
			_matrix.tx=x;
			_matrix.ty=y;
			return _matrix;
		}
	}
}
