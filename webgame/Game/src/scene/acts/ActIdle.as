package scene.acts
{
	import scene.ActBase;
	import scene.king.King;
	
	public class ActIdle extends ActBase
	{
		public function ActIdle()
		{
			super();
		}
		
		override public function exec(king:King):void
		{
			king.idle();
		}
		
	}
}