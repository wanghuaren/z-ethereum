package ui.base.jineng
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_DataResModel;
	
	import engine.event.DispatchEvent;
	
	import netc.Data;
	import netc.DataKey;
	
	import nets.packets.PacketSCStudySkill;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	//获得新技能控制类
	public class SkillTipManage
	{
		public var newSkill:Array;
		//private var first:Boolean = true;
		private static var _instance : SkillTipManage = null;
		
		public static function get instance() : SkillTipManage {
			if (null == _instance)
			{
				_instance=new SkillTipManage();
			}
			return _instance;
		}
		
		public function SkillTipManage()
		{
			newSkill = new Array();
			DataKey.instance.register(PacketSCStudySkill.id,SCStudySkill);
			//Data.huoBan.addEventListener(HuoBanSet.SKILL_UPDATE_PET,SCStudySkillPet);
		}
		/**
		 *	人物技能开启 
		 */
		private function SCStudySkill(p:PacketSCStudySkill) : void {
			
			var arr:Array = Jineng.skillDataList.values();
			
			var myLvl:int = Data.myKing.level;
			
			for each(var psdrm:Pub_Skill_DataResModel in arr)
			{
				
				if(psdrm.skill_id == p.skillitem.skillId && 
					//myLvl > 4)
					myLvl >= 20)
				{
					
					//屏蔽各个职业15级第一个被动技能
					//skill_id="401007" skill_name="战意
					//skill_id="401059" skill_name="怒符决" 
					//skill_id="401033" skill_name="连射"
					
					if(p.skillitem.skillId != 401007 &&
						p.skillitem.skillId != 401059 &&
						p.skillitem.skillId != 401033)
					{
						new SkillTip(psdrm.skill_id,p.skillitem.skillLevel);
						newSkill.push(psdrm.skill_id);
						GameMusic.playWave(WaveURL.ui_skill_up);
					}
					
				}
				
				
			}
			
		}
		
		/**
		 *	伙伴技能开启 
		 *  2012-08-23 andy
		 */
		private function SCStudySkillPet(e:DispatchEvent) : void {
//			var arrSkill:Array=XmlManager.localres.getPetSkillXml.getResPath2(e.getInfo["PetId"])
//			if(arrSkill==null)return;
//			var skillNo:int=Data.huoBan.getPetById(e.getInfo["PetId"]).skillNo;
//			var skillId:int=arrSkill[skillNo-1]["skill_id"];
//		
//			new SkillTip(skillId,1);
//		
//			GameMusic.playWave(WaveURL.ui_skill_up);
			
		}
	}
}