package scene.action
{
	import com.bellaxu.def.FilterDef;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;
	import scene.skill2.SkillEffect12;
	import scene.skill2.SkillEffectManager;

	public class PoisonAction
	{
		private var filters:Array = null;
		private var cmf:ColorMatrixFilter;
		public function PoisonAction()
		{
			if (filters == null)
			{
				cmf = FilterDef.getColorMatrixFilterByColor(0x009900);
				filters = [cmf];
			}
		}
		
		public function BuffUpdate(objid:uint,hasBoss2:Boolean,KP:King=null):void
		{
			var k:IGameKing;
			if(null != KP)
			{
				k = KP as IGameKing;
			}
			
			if(null == k)
			{
				k = SceneManager.instance.GetKing_Core(objid);
			}
			if(null == k)
			{
				return;
			}
			var i:int;
			var d:DisplayObject;
			
			var hasEffect:Boolean = false;
			d = k.getSkin().rect;
			if (d.filters && d.filters.length>0)
			{
				for each (var f:Object in d.filters)
				{
					if (f is ColorMatrixFilter)
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
					d.filters = filters;
				}
			}
			else
			{
				if(hasEffect)
				{
					d.filters = [];
				}
			}
		}
	}
}