package ui.base.huodong
{
	import common.config.GameIni;
	import common.managers.Lang;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.Data;
	
	import ui.frame.ImageUtils;
	
	import world.FileManager;
	
	public class OperatingActivityScrollPanelItem extends Sprite
	{
		private var m_ui:Sprite;
		private var m_value:Object;
		private var m_id:int;
		private var m_activity_id:int;
		
		public function OperatingActivityScrollPanelItem(ui:Sprite)
		{
			super();
			
			m_ui = ui;
			addChild(m_ui);
			
		}
		
		/**
		 * 更新数据 
		 * 
		 */		
		public function updata(value:Object = null):void
		{
			if(null != value)
			{
				m_value = value;
			}
			
			if(1 == m_id)
			{
				m_ui['effect_fang_song'].visible = true;
				m_ui['effect_fang_song'].gotoAndPlay(1);
			}
			else
			{
				m_ui['effect_fang_song'].visible = false;
				m_ui['effect_fang_song'].gotoAndStop(1);
			}
			
			
			var _url:String = FileManager.instance.getOperatingActivityItemIconById(m_value.res_id);
			
			if(m_ui["uil"].source != _url)
			{
//				m_ui["uil"].source = _url;
				ImageUtils.replaceImage(m_ui,m_ui["uil"],_url);
				if( 40005 == m_value.action_id && !Data.huoDong.isAtOpenActIds(40005))
				{
					m_ui["txt_name"].text = Lang.getLabel("40075_shenmi_huodong");
					m_ui["txt_dsc"].text = Lang.getLabel("pub_jingqing_qidai");
				}
				else
				{
					m_ui["txt_name"].text = m_value.action_name;
					m_ui["txt_dsc"].text = m_value.action_title;
				}
				
			}
			
		}
		
		
		
		public function setEffectFangSong(b:Boolean):void
		{
			m_ui['effect_fang_song'].visible = b;
		}
		
		public function setID(id:int):void
		{
			m_id = id;
		}
		
		public function getID():int
		{
			return m_id;
		}
		
		public function setActivityID(id:int):void
		{
			m_activity_id = id;
		}
		
		public function getActvityID():int
		{
			return m_activity_id;
		}
		
		public function setData(v:Object):void
		{
			m_value = v;
		}
		
		public function getData():Object
		{
			return m_value;
		}
		
		public function focus():void
		{
			m_ui["bg"].gotoAndStop(2);
		}
		
		public function unFocus():void
		{
			m_ui["bg"].gotoAndStop(1);
		}
		
		
	}
}


