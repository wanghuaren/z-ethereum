package scene.acts
{
	import scene.action.PathAction;
	import scene.human.GameHuman;
	import scene.king.King;
	import scene.utils.MapCl;
	
	import world.WorldPoint;

	public class ActRunSpeed extends ActRun
	{
		public var moveGrids:int;
		public var isFighter:Boolean;
		public function ActRunSpeed()
		{
			super();
		}
		
		override public function exec(king:King):void
		{
//			var fx_:String = "F" + MapCl.getDirEx(king.nDestX,king.nDestY,nDestX,nDestY);
//			var dir:int = 1;
//			if (king.roleFX != fx_)
//			{
//				dir = -1;
//			}
//			king.nActionPlayTime = 100;
//			king.move(nDestX,nDestY,true,dir);
//			king.stopAction();
			if (isFighter && (king is GameHuman))//怪物不做残影特效
			{
				king.createEffectForSpeedRun(moveGrids);
			}
			var m_po:WorldPoint=WorldPoint.getInstance().getItem(nDestX, nDestY, nDestX, nDestY);
			PathAction.moveToByDirection(king,m_po);
		}
	}
}