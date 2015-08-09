/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.jingjie
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import model.jingjie.JingjieModel;

	/**
	 * @author liuaobo
	 * @create date 2013-8-13
	 */
	public class JingJieArea2
	{
		private static var _instance:JingJieArea2 = null;
		
		private var mc:Sprite;
		
		// 境界丹药兑换商店编号
		private static const JING_JI_DAN_YAO_SHOP_ID:int = 70200001;
		
		private var dataList:Array = null;
		private var index:int = -1;
		/**
		 * 由境界强化等级上限-》境界球强化等级上限 
		 */
		private var indexChanged:Boolean = false;
		private var focusIndex:int = 0;
		private var jingjieStarList:Array = null;
		//星星强化等级上限
		private var starLimit:int = 0;
		private var ballEnabledArr:Array = [];
		private var ballStarLimitArr:Array = [];
		
		public function JingJieArea2(s:Sprite)
		{
			this.mc = s;
		}
		
		public static function getInstance():JingJieArea2{
			if (_instance == null){
				_instance = new JingJieArea2();
			}
			return _instance;
		}
		
		private function reset():void{
			var tempMC:MovieClip;
			var size:int = JingjieModel.LIMIT;
			var i:int = 0;
			while (i<size){
				tempMC = this.mc["_b"+(i+1)];
				tempMC.mouseChildren = false;
				tempMC["mcSelector"].visible = false;
				i++;
			}
		}
		
	}
}