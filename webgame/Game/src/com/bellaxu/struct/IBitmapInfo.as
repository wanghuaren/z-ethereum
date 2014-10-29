package com.bellaxu.struct
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * @author  WangHuaRen
	 * @version 2011-10-31
	 */
	public interface IBitmapInfo
	{
		/**
		 * 是否被销毁
		 */
		function get isDestroyed():Boolean;
		/**
		 * 获取名字
		 */
		function get name():String;
		/**
		 * 设置名字
		 */
		function set name(value:String):void;
		/**
		 * 设置位图信息
		 * */
		function set bitmapData(value:BitmapData):void;
		/**
		 * 取得位图信息
		 * */
		function get bitmapData():BitmapData;
		/**
		 * 取得重心点
		 * */
		function set center(value:int):void;
		/**
		 * 取得重心点
		 * */
		function get center():int;
		
		function get centerToFoot():int;
		function set centerToFoot(value:int):void;
		function get direction():int;
		function set direction(value:int):void;
		/**
		 * 设置绝对偏移量X
		 * */
		function set originX(value:int):void;
		/**
		 * 取得绝对偏移量X
		 * */
		function get originX():int;
		/**
		 * 设置绝对偏移量Y
		 * */
		function set originY(value:int):void;
		/**
		 * 取得绝对偏移量Y
		 * */
		function get originY():int;
		/**
		 * 设置高度
		 * */
		function set height(value:Number):void;
		/**
		 * 取得高度
		 * */
		function get height():Number;
		/**
		 * 设置相对偏移X
		 * */
		function set x(value:int):void;
		/**
		 * 取得相对位移X
		 * */
		function get x():int;
		/**
		 * 设置相对偏移Y
		 * */
		function set y(value:int):void;
		/**
		 * 取得相对偏移Y
		 * */
		function get y():int;
		/**
		 * 取得当前的动作方向
		 * */
		function set mark(value:String):void;
		/**
		 * 设置当前的位置方向
		 * */
		function get mark():String;
		/**
		 * 把自身拷贝出来一份
		 * */
		//function get clone():IBitmapInfo;
		/**
		 * 销毁
		 * */
		function destory(gc:Boolean=false):void;
		function get tag():Object;
		function set tag(vale:Object):void;
		/**
		 * 跳帧数
		 * */
		function get jumpFrame():int;
		/**
		 * 跳帧数
		 * */
		function set jumpFrame(value:int):void;

		/**
		 * 脚底光环X
		 * */
		function get footX():int;
		/**
		 * 脚底光环X
		 * */
		function set footX(value:int):void;

		/**
		 * 脚底光环Y
		 * */
		function get footY():int;
		/**
		 * 脚底光环Y
		 * */
		function set footY(value:int):void;

		/**
		 * 翅膀位置X
		 * */
		function get wingX():int;
		/**
		 * 翅膀位置X
		 * */
		function set wingX(value:int):void;

		/**
		 * 翅膀位置Y
		 * */
		function get wingY():int;
		/**
		 * 翅膀位置Y
		 * */
		function set wingY(value:int):void;
		
		/**
		 * 技能位置，由16个值组成，代表8个序列点，每个点对应一个方向。技能只有动作D3
		 * */
		function get skillPoint():Vector.<int>;
		/**
		 * 技能位置，由16个值组成，代表8个序列点，每个点对应一个方向。技能只有动作D3
		 * */
		function set skillPoint(value:Vector.<int>):void;
		/**
		 * 当前动作 D1待机 D2 修炼 D3 攻击1 D4 技能攻击 D5 跑步 D6  受伤 D7 死亡 D8 采集 D9 攻击2 D10 坐骑待机 D11 坐骑跑步 D12 坐骑攻击 D13 坐骑死亡
		 * */
		function get act():String;
		/**
		 * 当前动作 D1待机 D2 修炼 D3 攻击1 D4 技能攻击 D5 跑步 D6  受伤 D7 死亡 D8 采集 D9 攻击2 D10 坐骑待机 D11 坐骑跑步 D12 坐骑攻击 D13 坐骑死亡
		 * */
		function set act(value:String):void;
		/**
		 * 资源初始化计数 
		 */
		function set resLoadedDic(value:Dictionary):void;
	}
}
