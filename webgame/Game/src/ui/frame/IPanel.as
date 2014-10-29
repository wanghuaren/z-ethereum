package ui.frame
{
	/**
	 *	2013-04-11 andy
	 *  窗体处理复杂多面板 
	 */
	public interface IPanel
	{
		function init():void;
		function mcHandler(target:Object):void;
		function mcDoubleClickHandler(target:Object):void;
		function windowClose():void;
	}
}