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
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect11;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	import ui.base.mainStage.UI_index;
	
	import world.WorldEvent;
	
	public class Boss2EffectAction
	{		
		
		public function Boss2EffectAction()
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
					if("boss2_effect" == (d as SkillEffect12).path)
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
					//
					
					
					//	
					se_boss2 = new SkillEffect12();
					se_boss2.setData(k.objid,"boss2_effect");
					SkillEffectManager.instance.send(se_boss2);
					
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasBoss2)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().effectUp.numChildren;i++)
					{
						d = k.getSkin().effectUp.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("boss2_effect" == (d as SkillEffect12).path)
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
