package scene.acts
{
	import scene.ActBase;
	import scene.king.ActionDefine;
	import scene.king.King;

	public class ActRun extends ActBase
	{
		public var nDestX :int;
		public var nDestY :int;
		public function ActRun()
		{
		}
		override public function exec(king:King):void
		{
			king.move(nDestX,nDestY,true);
			king.moveActionCount--;
		}
				
	}
}