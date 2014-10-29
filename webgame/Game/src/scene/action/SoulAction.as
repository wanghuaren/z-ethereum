package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	public class SoulAction
	{
		public function SoulAction()
		{
		}
		
		
		public function BuffUpdate(objid:uint,hasSoul:Boolean):void
		{
			//绝对没有战魂释放
			return;
			
			var k:IGameKing = SceneManager.instance.GetKing_Core(objid);
			
			if(null == k)
			{
				return;
			}
			
			var se_soul:SkillEffect12;
			var i:int;
			var d:DisplayObject;
			
			//魂特效
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().effectUp.numChildren;i++)
			{
				d = k.getSkin().effectUp.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("soul" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			if(hasSoul)
			{
				if(!hasEffect)
				{				
					se_soul = new SkillEffect12();
					se_soul.setData(k.objid,"soul");
					SkillEffectManager.instance.send(se_soul);
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasSoul)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().effectUp.numChildren;i++)
					{
						d = k.getSkin().effectUp.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("soul" == (d as SkillEffect12).path)
							{
								(d as SkillEffect12).Four_MoveComplete();
								//break;
							}
						}
					}
					
					
					//---------------------------------------------------------------------
				
				}
			
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		}
		
		
		
		
		
		
		
	}
}