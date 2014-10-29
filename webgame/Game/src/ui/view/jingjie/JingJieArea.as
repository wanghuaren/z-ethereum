/**
 * Copyright the company of XiHe, all rights reserved.
 */
package ui.view.jingjie
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 境界区 青龙-白虎-朱雀-玄武四大境界
	 * @author liuaobo
	 * @create date 2013-5-15
	 */
	public class JingJieArea
	{
		/**
		 * 目标元件 
		 */
		protected var mc:Sprite;
		/**
		 * 境界等级对应的点集合 
		 */
		protected var points:Vector.<MovieClip> = null;
		/**
		 *  
		 */
		private static const SIZE:int = 7;
		
		public function JingJieArea(target:Object)
		{
			this.mc = target as Sprite;
			this.init();
		}
		
		/**
		 * 控件初始化 
		 */
		protected function init():void{
			this.points = new Vector.<MovieClip>();
			var index:int = 1;
			var p:MovieClip;
			while (index<=SIZE){
				p = this.mc["mc_point"+index] as MovieClip;
				this.points.push(p);
				index++;
			}
		}
		
		/**
		 * 境界等级开启
		 * 
		 */
		public function open(list:Array):void{
			var index:int = 0;
			while (index<SIZE){
				var p:MovieClip = this.points[index] as MovieClip;
				var frame:int = list[index]>0?2:1;//强化星级大于0则开启
				p.gotoAndStop(frame);
				index++;
			}
		}
		
		/**
		 * 清除引用 
		 * 
		 */
		public function dispose():void{
			this.mc = null;
			while (this.points.length>0){
				this.points.pop();
			}
			this.points = null;
		}
	}
}