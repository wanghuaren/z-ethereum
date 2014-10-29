package scene.acts
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	
	import netc.packets2.PacketSCFightTarget2;
	
	import scene.ActBase;
	import scene.king.King;
	
	public class ActFightTarget extends ActBase
	{
		public var target:PacketSCFightTarget2;
		public function ActFightTarget()
		{
			super();
		}
		
		override public function exec(king:King):void
		{
//项目转换			var skillModel:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, target.skill.toString());
			var skillModel:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath( target.skill) as Pub_SkillResModel;
			if(!skillModel)
				return;
			if (skillModel.skill_action==1 && skillModel.skill_action_id == 4)
			{
				king.magic(target);
			}
			else
			{
				king.attack(target);
			}
			
		}
	}
}