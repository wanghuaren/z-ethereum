package scene.action
{
	import flash.display.DisplayObject;
	
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	public class YuBoatAction
	{
		/**
		 * 本人是否处于御剑飞行
		 */
		private var _yuBoat:Boolean;
		
		
		public function YuBoatAction()
		{
			_yuBoat = false;
		}
		
		/**
		 * buf 24
		 * 8388608
		 * 
		 */ 
		public function BuffUpdate(objid:uint,hasYuBoat:Boolean,KP:King=null):void
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
			
			for(i =0;i<k.getSkin().foot.numChildren;i++)
			{
				d = k.getSkin().foot.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("yu_boat" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			
			//
			if(hasYuBoat)
			{
				if(!hasEffect)
				{				
					//
					
					
					//	
					se_boat = new SkillEffect12();
					se_boat.setData(k.objid,"yu_boat");
					SkillEffectManager.instance.send(se_boat);
				
					//
					k.setKingAction(KingActionEnum.DJ);
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasYuBoat)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().foot.numChildren;i++)
					{
						d = k.getSkin().foot.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("yu_boat" == (d as SkillEffect12).path)
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
		
		
		public function get boat():Boolean
		{
			return _yuBoat;
		}
		
		/**
		 * @private
		 */
		public function set boat(value:Boolean):void
		{
			_yuBoat = value;			
			
		}
	}
}