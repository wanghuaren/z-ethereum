package ui.frame
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	/**
	 * @author wanghuaren
	 *create:2011-1-3
	 */
	public interface IView
	{
		//面板事件添加
		function addObjToStage(cmc:Sprite, type:Boolean=true):void;
//
//		//面板初始化
//		function init():void;
//
		//面板点击事件
		function mcHandler(target:Object):void;
//
//		//鼠标双击事件
//		function mcDoubleClickHandler(target:Object):void;
//
//		//窗口关闭事件
//		function windowClose():void;
//
		//关闭面板
		function winClose():void;
//
//		//面板类型 true--可拖动,活动面板 false--不被删除,固定面板
//		function get viewType():Boolean;
//
//		//设置窗体的构筑UI--设置此属性后,当前窗体主UI编号为0
//		function multiUI(... displayObject):void;
//
//		//取得窗体的构筑UI--传入编号-
//		function getMultiUI(UINum:int):DisplayObject;
	}
}
