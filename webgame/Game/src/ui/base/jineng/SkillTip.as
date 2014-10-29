package ui.base.jineng
{
	import com.greensock.TweenLite;
	
	import common.config.GameIni;
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_DataResModel;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import ui.frame.ImageUtils;
	
	import world.FileManager;

	/**
	 * 获得新技能提示
	 * 2012-08-24 andy 加入伙伴技能提示
	 */
	public class SkillTip
	{
		private var mc:DisplayObject;
		private var isHuoBan:Boolean=false;
		
		private var m_skillLevel:int = 0;
				
		private var m_pub_skill_data:Array = null;
		
		/**
		 * 构造函数 
		 * @param skillId
		 * @param skillLevel
		 * 
		 */		
		public function SkillTip(skillId:int,skillLevel:int)
		{
			
			mc = GamelibS.getswflink("game_index", "win_newskill");
			m_skillLevel = skillLevel;
			if(mc==null)return;
			isHuoBan=isHuoBan;
			PubData.mainUI.AlertUI.addChild(mc);
			mc.x = GameIni.MAP_SIZE_W - mc.width - 10 -230;
			mc.y = GameIni.MAP_SIZE_H;
			
			
//			mc["skillIcon"]["icon"].source = FileManager.instance.getSkillIconSById(skillId);
			ImageUtils.replaceImage(mc["skillIcon"],mc["skillIcon"]["icon"],FileManager.instance.getSkillIconSById(skillId));
			var skill:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skillId) as Pub_SkillResModel;
			mc["tf_2"].text = skill.skill_name;
			
			mc["skillIcon"].data=skill;
			mc["skillIcon"].mouseChildren = false;
			isHuoBan= skillId.toString().indexOf("402")==0;
			
			var _psdr_id:int = skillId * 100 + skillLevel - 1;
			var _psdr_next_id:int = _psdr_id + 1;
			var psdr:Pub_Skill_DataResModel= null;
			var psdr_next:Pub_Skill_DataResModel=null;
			
			if(null == m_pub_skill_data)
			{
				m_pub_skill_data = XmlManager.localres.getSkillDataXml.contentData.contentXml;
			}
			
			
			//2012-08-23 andy 伙伴技能也通知
			if(isHuoBan){
				//主动技能
				mc["tf_1"].htmlText =  "<font color='#00ff00'>"+Lang.getLabel("20089_JiNing")+"</font>";
				mc["btnSubmit"].label=Lang.getLabel("20091_JiNing");
			}else if(0 == skill.passive_flag  && skillLevel <= 1)
			{
				//主动技能
				mc["tf_1"].htmlText = Lang.getLabel("20080_JiNing");
				mc["btnSubmit"].label=Lang.getLabel("20090_JiNing");
			}
			else if(0 == skill.passive_flag  && skillLevel > 1)
			{
				psdr = m_pub_skill_data[(_psdr_id)];
				psdr_next = m_pub_skill_data[(_psdr_next_id)];
				
				////技能升级 最高等级
				if(null == psdr_next)
				{
					mc["tf_1"].htmlText = Lang.getLabel("20080_JiNing_Shengji",[skill.skill_name,skillLevel]);
					mc["tf_2"].htmlText = Lang.getLabel("20080_JiNing_Shengji_max"); 
					mc["btnSubmit"].label=Lang.getLabel("20091_JiNing");
				}
				else
				{
					
					mc["tf_1"].htmlText = Lang.getLabel("20080_JiNing_Shengji",[skill.skill_name,skillLevel]);
					mc["tf_2"].htmlText = Lang.getLabel("20080_JiNing_Shengji_next",[psdr_next.study_level]); 
					mc["btnSubmit"].label=Lang.getLabel("20080_JiNing_Shengji_nuli");
				}
				
			}
			else
			{
				//被动技能
				mc["tf_1"].htmlText = Lang.getLabel("20081_JiNing");
				mc["btnSubmit"].label=Lang.getLabel("20090_JiNing");
				
			}
			
			CtrlFactory.getUIShow().addTip(mc["skillIcon"]);
			
			
			//TweenLite.to(mc, 1.5, {y:GameIni.MAP_SIZE_H-mc.height+60});
			TweenLite.to(mc, 1.5, {y:225});
			
			mc.addEventListener(MouseEvent.CLICK,clickHander);
		}
		
		private function clickHander(e:MouseEvent):void
		{
			switch(e.target.name){
				case "btnSubmit":
					if(isHuoBan==false && m_skillLevel <= 1)
					{
						Jineng.instance.open(true);
					}
					
					winClose();
					
					break;
				case "btnClose":
					winClose();
					break;
			}
		}
		
		private function winClose():void
		{
			mc.removeEventListener(MouseEvent.CLICK,clickHander);
			mc.parent.removeChild(mc);
			mc = null;
		}
	}
}