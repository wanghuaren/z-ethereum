package scene.acts
{
	import netc.packets2.PacketSCFightDamage2;
	
	import scene.ActBase;
	import scene.action.Action;
	import scene.king.King;
	
	public class ActFightDemage extends ActBase
	{
		public var demage:PacketSCFightDamage2;
		public function ActFightDemage()
		{
			super();
		}
		
		override public function exec(king:King):void{
			king.damage(demage);
		}
	}
}