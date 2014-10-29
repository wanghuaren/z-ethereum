package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	public class SuduAction
	{		
		
		public function SuduAction()
		{
			
		}
		
		/**
		 * buf 16 加速
		 * 
		 * @gm-debug@execcall@21@1@13430@0@
		 */ 
		public function BuffUpdate(objid:uint,hasJiaSu:Boolean,KP:King=null):void
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
			
			var se_boat:SkillEffect12;
			var i:int;
			var d:DisplayObject;
			
			//剑特效
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().effectUp.numChildren;i++)
			{				
				d = k.getSkin().effectUp.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("sudu" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			
			//
			if(hasJiaSu)
			{
				if(!hasEffect)
				{				
					//
					
					
					//	
					se_boat = new SkillEffect12();
					se_boat.setData(k.objid,"sudu");
					SkillEffectManager.instance.send(se_boat);
					
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasJiaSu)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().effectUp.numChildren;i++)
					{
						d = k.getSkin().effectUp.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("sudu" == (d as SkillEffect12).path)
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
