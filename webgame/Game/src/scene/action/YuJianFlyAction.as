package scene.action
{
	import common.managers.Lang;
	
	import flash.display.DisplayObject;
	
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;
	
	public class YuJianFlyAction
	{
		/**
		 * 御剑飞行-地图缩放比率
		 * 
		 * 0.5 , 0.75 
		 * 
		 */ 
		public  function get YuJianFlyRate():Number
		{			
			var arrYuJianFly_:Array = Lang.getLabelArr("arrYuJianFly");
		
			if(null == arrYuJianFly_)
			{
				return 0.5;
			}
			
			if(0 == arrYuJianFly_.length)
			{
				return 0.5;
			}
			
			return arrYuJianFly_[0];
		}
		
		
		
		/**
		 * 本人是否处于御剑飞行
		 */
		private var _yuJianFly:Boolean;
		
		
		
		public function YuJianFlyAction()
		{
			_yuJianFly = false;
		}
		
		/**
		 * buf 24
		 * 8388608
		 * 
		 */ 
		public function BuffUpdate(objid:uint,hasYuJianSword:Boolean,KP:King=null):void
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
			
			for(i =0;i<k.getSkin().foot.numChildren;i++)
			{
				d = k.getSkin().foot.getChildAt(i);	
				
				if(d as SkillEffect12)
				{
					if("yjf_sword" == (d as SkillEffect12).path)
					{
						hasEffect = true;
						break;
					}
				}
			}			
			
			//
			if(hasYuJianSword)
			{
				if(!hasEffect)
				{				
					se_sword = new SkillEffect12();
					se_sword.init();
					se_sword.setData(k.objid,"yjf_sword");
					SkillEffectManager.instance.send(se_sword);
				}
				
				//
				//GameMusic.playWave(WaveURL.ui_hun_release);
				
			}
			
			if(!hasYuJianSword)
			{
				if(hasEffect)
				{
					//-------------------------------------------------------------------
					for(i =0;i<k.getSkin().foot.numChildren;i++)
					{
						d = k.getSkin().foot.getChildAt(i);	
						
						if(d as SkillEffect12)
						{
							if("yjf_sword" == (d as SkillEffect12).path)
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
		
		public function get fly():Boolean
		{
			return _yuJianFly;
		}

		/**
		 * @private
		 */
		public function set fly(value:Boolean):void
		{
			_yuJianFly = value;
		}
	}
}