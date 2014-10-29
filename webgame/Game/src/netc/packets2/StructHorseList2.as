/**
 * 要加什么属性自已加，但是不可覆写父类的方法
 * 如 父类有个job整数属性，此类可加个job_ch字符串属性
 * 复杂类型用继承，并在类名后加2，比如StructPlayerInfo2，然后自已加需要的属性，传到上层逻辑，减少上层编码量 
 * 这些加的属性所需要的数据在该类的process中进行处理和赋值
 *  
 */ 
package netc.packets2
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Sitzup_UpResModel;
	import common.config.xmlres.server.Pub_ToolsResModel;
	
	import nets.packets.StructHorseList;

	/** 
	 *
	 */
	public class StructHorseList2 extends StructHorseList
	{
				
		public function get horsepos():int
		{
			return this.pos;
		}
		

		public function get max_skin_level():int
		{
			return maxStrong / 10;
		}
		
		public function get curStrong():int
		{
			return this.strong_level;
		}
		public function get nextStrong():String
		{			
			if(this.strong_level < maxStrong)
			{
				return (this.strong_level + 1).toString();
			}
		
			return "";
		}
		public function get maxStrong():int
		{
			var m_strong:Pub_Sitzup_UpResModel = XmlManager.localres.SitzUpUpXml.getResPath(this.strong_level) as Pub_Sitzup_UpResModel;
			
			if(null == m_strong)
			{
				return 100;
			}
			
			return m_strong.max_strong_lv;
		}
		
		public function get max_jie():int
		{
			var ret:int=Math.floor(maxStrong/10)-1;
			return ret;
		}
	}
}
