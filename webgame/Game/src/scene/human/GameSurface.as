package scene.human
{
	
	import scene.king.King;
	
	/**
	 * @author lab
	 * @date 2014-11-20 下午1:47:33
	 */	
	public class GameSurface extends King
	{
		public function GameSurface()
		{
			super();
			mouseChildren = mouseEnabled = false;
		}
	}
}