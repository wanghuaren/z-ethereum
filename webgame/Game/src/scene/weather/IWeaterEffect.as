package scene.weather
{	
	import scene.king.IGameKing;
	import scene.skill2.ISkillEffect;
	
	import world.IWorld;
	
	public interface IWeaterEffect extends IWorld
	{				
	
		function One_CreateEffect():void;
		
		//t = target
		function Two_AddChild():void;
		
		
		//
		function Three_Move():void;
		
	}
	
}