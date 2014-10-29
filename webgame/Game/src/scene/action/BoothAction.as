package scene.action
{
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	
	import ui.view.UIMessage;

	public class BoothAction
	{
		public function BoothAction()
		{
			
		}
		
//		public function CanOn():Boolean
//		{
//			return false;
//		
//		}
		
		
		public function BoothUpdate(objid:uint,exercise:int):void
		{
			var k:IGameKing = SceneManager.instance.GetKing_Core(objid);
			
			if(null == k)
			{
				return;
			}
			
			//
			var hasBooth:Boolean = false;
			
			if(5 == exercise)
			{
				hasBooth = true;
			}
			
			 
			var se_booth_area:SkillEffect12;
			var i:int;
			var d:DisplayObject;
			
			//spa特效
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().foot.numChildren;i++)
			{
				d = k.getSkin().foot.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("booth_area" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			
			
			//
			if(hasBooth)
			{
				
				if(5 == exercise)
				{
					//
					if(!hasEffect)
					{				
						se_booth_area = new SkillEffect12();
						se_booth_area.setData(k.objid,"booth_area");
						SkillEffectManager.instance.send(se_booth_area);
					}	
					
					//
					if(k.isMe)
					{
						UIMessage.showState(6);
					
						//test
						//setTimeout(UIMessage.showState,5000,6);
					}
					
				}				
				
				
				
			}//end if
						
			//
			if(!hasBooth)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					
					for(i =0;i<k.getSkin().foot.numChildren;i++)
					{
						d = k.getSkin().foot.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("booth_area" == (d as SkillEffect12).path)
							{
								(d as SkillEffect12).Four_MoveComplete();
								//break;
							}
						}
					}
					
					//---------------------------------------------------------------------
					
				}
				
				//
				if(k.isMe)
				{
					UIMessage.deleteState(6);
					
				}
				
				
				
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		}		
		
		
		
		
		
		
	}
}