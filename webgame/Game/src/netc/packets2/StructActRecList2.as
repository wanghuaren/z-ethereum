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
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	
	import flash.utils.ByteArray;
	
	import engine.support.IPacket;
	import engine.support.ISerializable;
	import engine.net.packet.PacketFactory;
	import nets.packets.StructActRecList;
	
	public class StructActRecList2 extends StructActRecList
	{
		private var m_mod:Pub_AchievementResModel = null;
		
		public var change_type:int;
		
		
		public function get cur_num():int
		{
			return this.count;
		}
		
		public function get limit_id():int
		{
			if(null == m_mod)
			{
				m_mod = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			}
			
			if(null == m_mod)
			{
				return 0;
			}
			
			return m_mod.limit_id;
		}
		
		public function get max_count():int
		{
			if(null == m_mod)
			{
				m_mod = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			}
			
			if(null == m_mod)
			{
				return 0;
			}
			
			return m_mod.max_count;
		}
		
		public function get ar_completeByChengJiu():Boolean
		{
			
			if(null == m_mod)
			{
				m_mod = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			}
			
			if(null == m_mod)
			{
				return false;
			}
			
			return this.count >= m_mod.max_count?true:false;
		
		}
		
		public function get ar_complete():Boolean
		{
			
			if(null == m_mod)
			{
				m_mod = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			}
			
			if(null == m_mod)
			{
				return false;
			}
			
			var model2:Pub_Limit_TimesResModel = XmlManager.localres.limitTimesXml.getResPath(m_mod.limit_id) as Pub_Limit_TimesResModel;
						
			var limitCount:int;
			
			if(null == model2)
			{
				limitCount = 0;
				
			}else
			{
				limitCount = model2.max_times;
			}			
			
			//
			if(limitCount == this.count)
			{
				return true;
			}
			
			return false;
		}

		public function get ar_desc():String
		{			
			var _model:Pub_AchievementResModel = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			
			if(null == _model)
			{
				return "";
			}
			
			return _model.ar_desc;
			
		}
		
		
		public function get target_desc():String
		{
			var m:Pub_AchievementResModel = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			
			if(null == m)
			{
				return "";
			}
			
			return m.target_desc;
		}
		
		
		public function get active_desc():String
		{
			var m:Pub_AchievementResModel = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			
			if(null == m)
			{
				return "";
			}
			
			return m.active_desc;
		}
		
		
		public function get window_type():int
		{
		
			var m:Pub_AchievementResModel = XmlManager.localres.AchievementXml.getResPath(this.arid) as Pub_AchievementResModel;
			
			if(null == m)
			{
				return 0;
			}
			
			return m.window_type;
			
		}
		
		
		
		
		
		
	}
}
