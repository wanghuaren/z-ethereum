package scene.acts
{
	import scene.ActBase;
	import scene.king.King;
	
	public class ActionHit extends ActBase
	{
		public function ActionHit()
		{
			super();
		}
		
		override public function exec(king:King):void
		{
			king.hit();
		}
	}
}