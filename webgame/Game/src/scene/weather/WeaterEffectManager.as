package scene.weather
{
	import com.bellaxu.res.ResMc;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.PathUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import scene.king.SkinBySkill;
	import scene.king.TargetInfo;
	
	import world.WorldFactory;
	import world.model.file.SkillFilePath;
	import world.type.WeaterType;
	
	public class WeaterEffectManager
	{
		private static var _instance:WeaterEffectManager; 
				
		public static const SOUL_MOVE_TIME_MIN:Number  = 0.5;//		
		public static const SOUL_MOVE_TIME:Number  = 0.75;//		
		public static const SOUL_MOVE_TIME_MAX:Number = 1.0;//
		
		public static const SOUL_MOVE_DISTANCE_MIN:int = 400;
		public static const SOUL_MOVE_DISTANCE:int = 600;
		public static const SOUL_MOVE_DISTANCE_MAX:int = 800;
		
		public function WeaterEffectManager()
		{
			
		}
		
		public static function get instance():WeaterEffectManager
		{
			if(!_instance)
			{
				_instance = new WeaterEffectManager();
			}
			
			return _instance;
		}
		
		public function send(se:IWeaterEffect):void
		{
			//list push
			
			
			//step1
			se.One_CreateEffect();
			
			//t = target
			se.Two_AddChild();
			
			//
			se.Three_Move();
			
			
		}
		
		public function getPoolByCloud(bfp:SkillFilePath):DisplayObject
		{
			var xmlUrl:String = PathUtil.getTrimPath(bfp.xml_path0);
			
			var d:DisplayObject = ResTool.getResMc(xmlUrl);
			
			if(null == d)
			{
				var sk:SkinBySkill = WorldFactory.createSkinBySkill();
				
				sk.setSkin(bfp);
				
				d = sk;
				
			}
			else
			{
				
//				(d as ResMc).play();	
				
			}
			
			return d;
		}
		
		/**
		 * 
		 */
		public function getPoolBySoul(bfp:SkillFilePath):DisplayObject
		{
			var xmlUrl:String = PathUtil.getTrimPath(bfp.xml_path0);
			
			var d:DisplayObject = ResTool.getResMc(xmlUrl);
			
			if(null == d)
			{
				var sk:SkinBySkill = WorldFactory.createSkinBySkill();
				
				sk.setSkin(bfp);
				
				d = sk;
				
			}
			else
			{
				
//				(d as ResMc).play();	
				
			}
			
			return d;
		}
		
		/**
		 * 打中怪物的1/2处
		 */ 
		public function AdjustEndXY(
			target_x:int,
			target_y:int,
			target_height:int,
			
			skill_effectX_width:Number,
			skill_effectX_height:Number,
			skill_effectX_as_Movie:Boolean):Point
		{
			if(skill_effectX_as_Movie)
			{
				return new Point(target_x,
						target_y - target_height * 0.5 + skill_effectX_height / 2);
			}
			return new Point(target_x,
						target_y - target_height * 0.5 - skill_effectX_height / 2);
		}
		
		public function createWeaterEffect3BySoul(targetInfo:TargetInfo):WeaterEffect3BySoul
		{							
			var we3BySoul:WeaterEffect3BySoul = WorldFactory.createWeater(WeaterType.SOUL) as WeaterEffect3BySoul;
			we3BySoul.setData(targetInfo);
									
			return we3BySoul;
		}
	}
}