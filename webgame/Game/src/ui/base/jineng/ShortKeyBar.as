package ui.base.jineng
{
	import engine.event.DispatchEvent;
	import flash.display.Sprite;
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import ui.base.mainStage.UI_index;

	public class ShortKeyBar
	{
		public function ShortKeyBar()
		{
		}

		public static function get mc():Sprite
		{
			return UI_index.indexMC_mrb;
		}

		public static function init():void
		{
			//
			Data.myKing.addEventListener(MyCharacterSet.SHORT_KEY_LOCK_UPD, shortKeyLockUpd);
			//
			shortKeyLockUpd();
		}

		public static function shortKeyLockUpd(e:DispatchEvent=null):void
		{
			var lock:int=Data.myKing.ShortKeyLock;
			if (null != mc['mcShortKeyLock'])
			{
				mc['mcShortKeyLock'].gotoAndStop((lock == 1 ? 2 : 1));
			}
			SkillShort.getInstance().resetAllKeyState();
		}
	}
}
