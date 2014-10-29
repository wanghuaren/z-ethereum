package scene.event {

	public class HumanEvent {
		//精灵开始移动
		public static const Clickme : String = "Clickme";
		//精灵停止移动
		public static const OnStop : String = "OnStop";
		
		//
		public static const LEVEL_UPDATE:String = "LEVEL_UPDATE";
		
		/**
		 * 寻路完成事件
		 * 整个的寻路完成，如被打断也算
		 */ 
		public static const Arrived : String = "Arrived";
		
		public static const Teleport : String = "Teleport";
		
		//精灵死亡
		public static const DropRes : String = "DropRes";
		
		//精灵单个删除
		public static const RemoveThis : String = "RemoveThis";
		
		
		
		//精灵全部删除
		public static const RemoveAll : String = "RemoveAll";
		//精灵加入显示
		public static const AddShowToMap : String = "AddShowToMap";
		
		public static const AddShowToMapByMonsterSkill : String = "AddShowToMapByMonsterSkill";
	}
}
