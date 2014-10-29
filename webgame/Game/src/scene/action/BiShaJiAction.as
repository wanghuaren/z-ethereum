package scene.action
{
	import com.greensock.TweenLite;
	
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import com.bellaxu.res.ResMc;
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import scene.body.Body;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect11;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	import ui.base.mainStage.UI_index;
	
	import world.WorldEvent;
	
	public class BiShaJiAction
	{		
		
		public function BiShaJiAction()
		{
			
		}
		
		/**
		 */ 
		public function Update(objid:uint,hasBiShaJi:Boolean,isGaoJi:Boolean):void
		{
			var k:IGameKing = SceneManager.instance.GetKing_Core(objid);
			
			if(null == k)
			{
				return;
			}
			
			var pet_skillPath:String = "pet_skill1";
			
			if(isGaoJi)
			{
				pet_skillPath = "pet_skill2";
			}
			
						
			var se_boss2:SkillEffect12;
			var i:int;
			var d:DisplayObject;
			
			//剑特效
			var hasEffect:Boolean = false;
			
			for(i =0;i<k.getSkin().foot.numChildren;i++)
			{				
				d = k.getSkin().foot.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if(pet_skillPath == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			
			//
			if(hasBiShaJi)
			{
				if(!hasEffect)
				{				
					//
					
					
					//	
					se_boss2 = new SkillEffect12();
					se_boss2.setData(k.objid,pet_skillPath);
					SkillEffectManager.instance.send(se_boss2);
					
				}
			}
			
			if(!hasBiShaJi)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().foot.numChildren;i++)
					{
						d = k.getSkin().foot.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if(pet_skillPath == (d as SkillEffect12).path)
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
