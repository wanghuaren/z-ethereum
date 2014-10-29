package scene.action
{
	import com.greensock.TweenLite;
	
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
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
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect11;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	import ui.base.mainStage.UI_index;
	
	import world.WorldEvent;
	
	public class SneakAction
	{
		public function SneakAction()
		{
		}
		
		
		/**
		 * GM命令 @gm-debug@execcall@21@1@1950@0@
		 */ 
		public function BuffUpdate(objid:uint,hasSneak:Boolean,KP:King=null):void
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
					if("sneak_effect" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			
			//
			if(hasSneak)
			{
				if(!hasEffect)
				{				
					//
					
					
					//	
					se_boss2 = new SkillEffect12();
					se_boss2.setData(k.objid,"sneak_effect");
					SkillEffectManager.instance.send(se_boss2);
					
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasSneak)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().effectUp.numChildren;i++)
					{
						d = k.getSkin().effectUp.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("sneak_effect" == (d as SkillEffect12).path)
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