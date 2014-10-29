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
    import common.config.xmlres.server.*;
    
    import nets.packets.StructNpcFunc;

    /** 
    *NPC功能
    */
    public class StructNpcFunc2 extends StructNpcFunc
    {
		public var func_id:int=0;
        public var icon:int=0;
		//按钮 点击继续.. -1表示膜拜播放烟花特效
		public var button:int=0;
		public var talking:String="";
		public var completeclose:int=0;
		public var not_open:int=0;
		public var prize:int=0;
				
		public function get double():Boolean
		{
			
			var m:Pub_Npc_TalkResModel = XmlManager.localres.getNpcTalkXml.getResPath(this.index) as Pub_Npc_TalkResModel;
			
			if(m.exp_double > 0)
			{
				return true;
			}
		
			return false;
		}
		
    }
	
	
	
	
	
	
	
	
	
	
}
