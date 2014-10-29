package world
{
	/**
	 * 游戏场景
	 * 初始化游戏 ，选服，登陆，地面，切换场景
	 * 1111
	 * 是一个抽象描述，不涉及具体的场景名称
	 * AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	 * @Author : fux
	 * @Data : 2011/4/1
	 */
	public class WorldState
	{
		public static const init:String = "init";
		
		public static const login:String = "login";
		
		public static const role:String = "role";
		
		public static const selectRole:String = "selectRole";
		
		public static const ground:String = "ground";
		
		public static const changeGround:String = "changeGround";
	}
}