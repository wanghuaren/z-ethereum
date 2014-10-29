package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	public class SwordAction
	{
		public function SwordAction()
		{
		}
		
		public function BuffUpdate(objid:uint,hasSword:Boolean,KP:King=null):void
		{
			
			var k:IGameKing;
			
			if(null != KP)
			{
				k = KP as IGameKing;
			}
			
			if(null == k){
				k = SceneManager.instance.GetKing_Core(objid);
				
			}
			
			if(null == k)
			{
				return;
			}
			
			var se_sword:SkillEffect12;
			var i:int;
			var d:DisplayObject;
			
			//剑特效
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().effectUp.numChildren;i++)
			{
				d = k.getSkin().effectUp.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("sword" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			for(i =0;i<k.getSkin().effectDown.numChildren;i++)
			{
				d = k.getSkin().effectDown.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("sword" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}
			
			if(hasSword)
			{
				if(!hasEffect)
				{				
					se_sword = new SkillEffect12();
					se_sword.setData(k.objid,"sword");
					SkillEffectManager.instance.send(se_sword);
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasSword)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().effectUp.numChildren;i++)
					{
						d = k.getSkin().effectUp.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("sword" == (d as SkillEffect12).path)
							{
								(d as SkillEffect12).Four_MoveComplete();
								//break;
							}
						}
					}
					
					for(i =0;i<k.getSkin().effectDown.numChildren;i++)
					{
						d = k.getSkin().effectDown.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("sword" == (d as SkillEffect12).path)
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