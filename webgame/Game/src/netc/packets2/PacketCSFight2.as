package netc.packets2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;

	import nets.packets.PacketCSFight;

	import scene.king.King;

	public class PacketCSFight2 extends PacketCSFight
	{
		private static var _instance:PacketCSFight2;

		public static function getInstance():PacketCSFight2
		{
			if (_instance == null)
			{
				_instance=new PacketCSFight2();
			}
			return _instance;
		}

		public function PacketCSFight2()
		{
		}
		private var vectorPoolItems:Vector.<PacketCSFight2>=new Vector.<PacketCSFight2>();

		public var srcKing:King=null;

		public var skillPlayTime:int=300; //技能施法时间

		public function get getItem():PacketCSFight2
		{
			if (vectorPoolItems.length < 1)
			{
				for (var i:int=0; i < 200; i++)
				{
					vectorPoolItems.push(new PacketCSFight2());
				}
			}
			return vectorPoolItems.pop();
		}

		public function get isMagic():Boolean
		{
//项目转换			var skillModel:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var skillModel:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			if (skillModel.skill_action == 1 && skillModel.skill_action_id == 4)
				return true;
			return false;
		}
	}
}
