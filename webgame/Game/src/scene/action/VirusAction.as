package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	public class VirusAction
	{
		public function VirusAction()
		{
		}
		
		
		
		public function BuffUpdate(objid:uint,hasSoul:Boolean,KP:King=null):void
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
					if("virus" == (d as SkillEffect12).path)
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
					se_soul.setData(k.objid,"virus");
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
							if("virus" == (d as SkillEffect12).path)
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