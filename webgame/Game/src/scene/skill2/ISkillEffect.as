package scene.skill2
{
	import scene.king.IGameKing;
	import scene.king.TargetInfo;
	
	import world.IWorld;

	public interface ISkillEffect extends IWorld
	{
		function One_CreateEffect():void;

		//t = target
		function Two_AddChild():void;

		//
		function Three_Move():void;

		//
		function Four_MoveComplete():void;

		//
		function get target_info():TargetInfo;
		function get isMe():Boolean;
		function get isMePet():Boolean;
		function get isMeMon():Boolean;
		function get skillModelId():int;
	}
}
