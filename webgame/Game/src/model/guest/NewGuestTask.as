package model.guest
{
	import common.managers.Lang;
	import netc.Data;
	import netc.packets2.PacketSCTaskAwardList2;
	import ui.base.renwu.Renwu;
	import ui.view.view2.NewMap.GameAutoPath;
	import ui.view.view4.guide.NewGuideUI;
	import ui.view.view6.GameAlert;

	public class NewGuestTask
	{
		/**
		 *	@2012-07-13 改为单例
		 */
		private static var _instance:NewGuestTask;

		public static function getInstance():NewGuestTask
		{
			if (_instance == null)
				_instance=new NewGuestTask();
			return _instance;
		}

		public function NewGuestTask()
		{
		}

		/**
		 * 任务完成【达成】
		 * @param taskId
		 *
		 */
		public function taskCanSubmit(taskId:int, _sort:int=-1):void
		{
			switch (taskId)
			{
				case 50200216:
					//2012-11-21 andy 升级引导
					NewGuideUI.getInstance().setUI("yunlong");
					NewGuideUI.getInstance().open(true);
					break;
				case 50100085:
					NewGuestModel.getInstance().handleNewGuestEvent(1005, 0, null);
					break;
				default:
					break;
			}
			//2014-07-01 65级提示
			var taskAward:PacketSCTaskAwardList2=Data.npc.getTaskAwardList();
			if (Data.myKing.level < 65 && taskAward != null && taskAward.arrItemtasklist.length > 0 && taskAward.arrItemtasklist[0].taskid == taskId)
			{
				new GameAlert().ShowMsg(Lang.getLabel("10194_newguest", [Renwu.getChuanSongText(30100547)]), 4, null, callBack);
			}
		}

		private function callBack():void
		{
			//GameAutoPath.chuan(30100091);
			GameAutoPath.chuan(30100547);
		}

		/**
		 * 任务完成【领取奖励】
		 * @param taskId
		 *
		 */
		public function SCTaskComplete(taskId:int):void
		{
			switch (taskId)
			{
				case 50100067:
					NewGuestModel.getInstance().handleNewGuestEvent(1017, 0, null);
					break;
				
				default:
					break;
			}
		}

		/**
		 * 已接任务列表【新增】
		 * @param taskId
		 *
		 */
		public function onNextTask(taskId:int):void
		{
			switch (taskId)
			{
				case 50100084:
					NewGuestModel.getInstance().handleNewGuestEvent(1063, 0, null);
					break;
				
				
				default:
					break;
			}
		}
	}
}
