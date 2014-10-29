package com.bellaxu.def
{
	import flash.display.Sprite;

	/**
	 * 游戏层定义
	 * @author BellaXu
	 */
	public class LayerDef
	{
		//===============================================主层===============================================//
		/** 地表层  **/
		public static var mapLayer:Sprite = new Sprite();mapLayer.name = "mapLayer";
		/** 界面层  **/
		public static var viewLayer:Sprite = new Sprite();viewLayer.name = "viewLayer";
		//===========================================mapLayer子层===========================================//
		/** 格子层  **/
		public static var gridLayer:Sprite = new Sprite();gridLayer.name = "gridLayer";
		/** 掉落层 **/
		public static var dropLayer:Sprite = new Sprite();dropLayer.name = "dropLayer";
		/** body层  **/
		public static var bodyLayer:Sprite = new Sprite();bodyLayer.name = "bodyLayer";
		/** 特效层  **/
		public static var effectLayer:Sprite = new Sprite();effectLayer.name = "effectLayer";
		//===========================================viewLayer子层===========================================//
		/** 天气层  **/
		public static var weatherLayer:Sprite = new Sprite();weatherLayer.name = "weatherLayer";
		/** ui层 **/
		public static var uiLayer:Sprite = new Sprite();uiLayer.name = "uiLayer";
		/** 弹出层2 **/
		public static var alertLayer:Sprite = new Sprite();alertLayer.name = "alertLayer";
		/** 提示层    **/
		public static var tipLayer:Sprite = new Sprite();tipLayer.name = "tipLayer";
		/** 加载层  **/
		public static var loadLayer:Sprite = new Sprite();loadLayer.name = "loadLayer";
		/** 剧情层 **/
		public static var storyLayer:Sprite = new Sprite();storyLayer.name = "storyLayer";
		//==============================================层定义结束==============================================//
	}
}