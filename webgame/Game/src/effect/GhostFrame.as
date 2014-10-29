package effect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class GhostFrame
	{
		public var x:int;
		public var y:int;
		public var bmd:BitmapData;
		public var bmp:Bitmap;
		public var totalTime:int = 1000;
		public var currentTime:int = 0;
		
		public function GhostFrame(x:int,y:int,bmd:BitmapData,scaleX:Number)
		{
			this.x = x;
			this.y = y;
			this.bmd = bmd;
			this.bmp = new Bitmap(bmd);
			this.bmp.x = x;
			this.bmp.y = y;
			this.bmp.scaleX = scaleX;
		}
	}
}