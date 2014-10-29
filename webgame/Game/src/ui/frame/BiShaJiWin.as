/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.frame
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import netc.Data;
	
	/**
	 * @author liuaobo
	 * @create date 2013-8-3
	 */
	public class BiShaJiWin extends UIWindow
	{
		public static var Prof:int = 0;//职业，对应必杀技名称
		private static var _instance:BiShaJiWin = null;
		
		public static function getInstance():BiShaJiWin{
			if (_instance == null){
				_instance = new BiShaJiWin();
			}
			return _instance;
		}
		
		public function BiShaJiWin()
		{
			super(getLink("win_bi_sha_ji"));
		}
		
		override protected function init():void{
			super.init();
			this.x = 400;
			this.y = 200;
			if (Prof == 0){
				Prof = Data.myKing.king.metier;
			}
			MovieClip(mc).gotoAndPlay(2);
			mc["mc"].gotoAndStop(Prof);
		}
		
		override public function closeByESC():Boolean{ 
			return false;
		}
	}
}