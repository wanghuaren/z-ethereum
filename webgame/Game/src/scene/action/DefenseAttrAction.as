package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;

	public class DefenseAttrAction
	{
		public function DefenseAttrAction()
		{
		}
		
		/**
		 */ 
		public function BuffUpdate(objid:uint,hasBoss2:Boolean,KP:King=null):void
		{
			var k:IGameKing;
			if(null != KP)
			{
				k = KP as IGameKing;
			}
			
			if(null == k)
			{
				k = SceneManager.instance.GetKing_Core(objid);
			}
			if(null == k)
			{
				return;
			}
			var se_boss2:SkillEffect12;
			var i:int;
			var d:DisplayObject;
			
			//剑特效
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().effectUp.numChildren;i++)
			{				
				d = k.getSkin().effectUp.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(BuffActionEnum.Defense_Attr == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			//
			if(hasBoss2)
			{
				if(!hasEffect)
				{				
					se_boss2 = new SkillEffect12();
					se_boss2.setData(k.objid,BuffActionEnum.Defense_Attr);
					SkillEffectManager.instance.send(se_boss2);
					
				}
				//GameMusic.playWave(WaveURL.ui_hun_release);
			}
			
			if(!hasBoss2)
			{
				if(hasEffect)
				{
					for(i =0;i<k.getSkin().effectUp.numChildren;i++)
					{
						d = k.getSkin().effectUp.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if(BuffActionEnum.Defense_Attr == (d as SkillEffect12).path)
							{
								(d as SkillEffect12).Four_MoveComplete();
								//break;
							}
						}
					}
				}
			}
		}
	}
}