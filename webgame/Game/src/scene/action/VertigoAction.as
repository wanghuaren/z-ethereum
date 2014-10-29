package scene.action
{
	import com.bellaxu.res.ResTool;

	import engine.load.GamelibS;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import scene.king.IGameKing;
	import scene.king.King;
	import scene.manager.SceneManager;

	public class VertigoAction
	{
		public function VertigoAction()
		{
		}

		public function BuffUpdate(objid:uint, hasBoss2:Boolean, KP:King=null):void
		{
			var k:IGameKing;
			if (null != KP)
			{
				k=KP as IGameKing;
			}

			if (null == k)
			{
				k=SceneManager.instance.GetKing_Core(objid);
			}
			if (null == k)
			{
				return;
			}
			var i:int;
			var d:DisplayObject;

			var hasEffect:Boolean=false;
			d=k.getSkin().rect;
			//  项目转换  var mcEffect:MovieClip = ResTool.getAppMc("Effect_XuanYun") as MovieClip;
			var mcEffect:MovieClip=GamelibS.getswflink("game_content", "BuffHead") as MovieClip;
			if (mcEffect != null)
				mcEffect.gotoAndStop(2);

			var container:Sprite=k.getSkin().effectUp;
			var len:int=container.numChildren - 1;
			var index:int=-1;
			while (len >= 0)
			{
				d=container.getChildAt(len);
				if (d is MovieClip && MovieClip(d).totalFrames > 1)
				{
					container.removeChild(d);
					index=len;
					break;
				}
				len--;
			}
			hasEffect == index != -1;
			if (hasBoss2)
			{
				if (!hasEffect && mcEffect != null)
				{
					if (mcEffect)
					{
						container.addChild(mcEffect);
						mcEffect.y=k.getSkin().getHeadName().y - mcEffect.height;
						mcEffect.x=k.getSkin().getHeadName().x ;
					}
				}
			}
			else
			{
				if (hasEffect && container.numChildren > index)
				{
					container.removeChildAt(index);
				}
			}
		}
	}
}
