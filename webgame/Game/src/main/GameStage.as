package main
{
	import ui.base.mainStage.UI_index;

	public class GameStage
	{
		public function GameStage()
		{
			ShowIndexUI();
		}
		public function ShowIndexUI():void
		{
			UI_index.instance.open(true, false);
			UI_index.instance.init2();
		}
	}
}