package world.model.file
{
	import com.bellaxu.data.GameData;

	public class SkillFilePath
	{
		/**
		 * .swf相对路径
		 * .xml相对路径
		 */ 
		public var swf_path0:String;
		public var xml_path0:String;
		
		/**
		 * 动画循环播放的帧索引
		 */
		public var loopFrame:int = 0;
		/**
		 * 技能动画播放时间 (ms:毫秒)
		 */
		public var playTime:int = -1;
		
		public var skillId:int;
		
		private var m_direction:int = 1;
		
		public function get direction():int
		{
			return m_direction;
		}
		
		public function set direction(value:int):void
		{
			if (value!=m_direction)
			{
				m_direction = value;
//				swf_path0 = swf_path0.replace(".swf","D"+value+".swf");
			}
		}
		
		public function SkillFilePath(s0:String="",x0:String="")
		{
//			s0=GameIni._http0+"NPC/Test.swf";
//			x0=GameIni._http0+"NPC/Testxml.xml";
			this.swf_path0 = s0;this.xml_path0 = x0;
		}
		
		/**
		 * 比较差异，决定是否重新加载
		 */ 
		public function compare(fresh:SkillFilePath):Array
		{
			var path_0_changed:Boolean = false;
						
			if(this.swf_path0  != fresh.swf_path0 ||
				this.xml_path0 != fresh.xml_path0)
			{
				path_0_changed = true;
				
				this.swf_path0  = fresh.swf_path0;
				this.xml_path0 = fresh.xml_path0;
			}
			
			return [path_0_changed];
		}
		
		public function clone():SkillFilePath
		{
			return new SkillFilePath(swf_path0,xml_path0);
		}
		
	}
}