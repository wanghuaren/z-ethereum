package com.bellaxu.avatar
{
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 人物头顶显示
	 * @author BellaXu
	 */
	public class AvatarHead extends Sprite
	{
		private var _nameTxt:TextField;
		
		public function AvatarHead()
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
	}
}