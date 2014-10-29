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
    import common.config.xmlres.server.Pub_SkillResModel;
    
    import nets.packets.StructShortKey;
    
    import world.FileManager;

    /** 
    *存储过程执行结果提示
    */
    public class StructShortKey2  extends StructShortKey
    {
		/** 
		 *是否是删除
		 */
		public var del:Boolean;
		/**
		 *	是否新的
		 */
		public　var isNew:Boolean=false;		
		
		
		public function get icon():String
		{
			if(0 == type){
				return FileManager.instance.getSkillIconSById(this.skillModel.icon);
			}
			
			return "";
		}
		
		public function get skillModel():Pub_SkillResModel
		{
			return XmlManager.localres.getSkillXml.getResPath(this.id) as Pub_SkillResModel;
		}
		
		
		
    }
}
