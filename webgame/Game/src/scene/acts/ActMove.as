package scene.acts
{
	import netc.Data;
	
	import scene.ActBase;
	import scene.king.King;

	public class ActMove extends ActBase
	{
		public var nDestX :int;
		public var nDestY :int;
		public function ActMove()
		{
		}
		override public function exec(king:King):void
		{
			king.move(nDestX,nDestY,false);
			king.moveActionCount--;
		}
	}
}