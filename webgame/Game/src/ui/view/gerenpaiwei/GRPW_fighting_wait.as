package ui.view.gerenpaiwei
{
	import common.utils.CountDownTool;
	import common.utils.StringUtils;
	
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import model.gerenpaiwei.GRPW_Event;
	import model.gerenpaiwei.GRPW_Model;
	
	import netc.DataKey;
	import netc.packets2.StructSHFightUserInfo2;
	
	import nets.packets.PacketSCCallBack;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	
	/**
	 * 战斗过程中的双方玩家信息
	 * @author steven guo
	 * 
	 */	
	public class GRPW_fighting_wait extends UIWindow
	{
		private static var m_instance:GRPW_fighting_wait;
		
		private var m_model:GRPW_Model = null;
		
		public function GRPW_fighting_wait()
		{
			super(getLink(WindowName.win_GRPW_fighting_wait));
			m_model = GRPW_Model.getInstance();
			
			canDrag = false;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		
		public static function getInstance():GRPW_fighting_wait
		{
			if (null == m_instance)
			{
				m_instance= new GRPW_fighting_wait();
			}
			return m_instance;
		}
		
		override public function winClose():void
		{
			super.winClose();
			
//			if (null != this.m_countDownTool)
//			{
//				this.m_countDownTool.stop();
//			}
		}
		
		public function Stage_resize(event:Event=null):void
		{
			replace();
		}
		
		
		override protected function init():void 
		{
			super.init();
//			m_model.addEventListener(GRPW_Event.GRPW_EVENT,_processEvent);
			
			this.stage.addEventListener(Event.RESIZE, this.Stage_resize);
			
			replace();
			
			//_repaintTime();
			
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		public function replace():void
		{
			
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x = (mc.stage.stageWidth - mc.width ) >> 1 ;
				m_gPoint.y = 30;//mc.stage.stageHeight - 230;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y+60;
			}
		}
		
		
		private function _processEvent(e:GRPW_Event):void
		{
			
			var _sort:int = e.sort;
			switch(_sort)
			{
				case GRPW_Event.GRPW_EVENT_SORT_FIGHTING:
					
					//_repaint();
					break;
				
				default:
					break;
			}
			
		}
		
		
		
		//倒计时工具对象
		private var m_countDownTool:CountDownTool=null;
		
		
		private function _repaint():void
		{
			var i:int = 0;
			var n:int = 3;
			
			var _item:* = null;
			var _mcHp:* = null;
			var _tf_name:TextField = null;
			var _team:Vector.<StructSHFightUserInfo2> = null;
			var _info:StructSHFightUserInfo2 = null;
			
			var _url:String = "";
			
			var _barMaxW:int = 51;
			
			_team = m_model.getFightingTeam_1();
			if(null == _team)
			{
				_team = new Vector.<StructSHFightUserInfo2>();
			}

			for(i = 0; i < n ; ++i)
			{
				_item = mc['L_item_'+i];
				_mcHp = mc['mcHp_l_'+i];
				_tf_name = mc['tf_name_l_'+i] as TextField;
				
				if(i >= _team.length)
				{
					_item.visible = false;
					_mcHp.visible = false;
					_tf_name.visible = false;
				}
				else
				{
					_item.visible = true;
					_mcHp.visible = true;
					_tf_name.visible = true;
					
					_info = _team[i];
					
					//头像是否为灰色 ，由服务器发消息决定。
					if(_info.isdead == 1)
					{
						StringUtils.setUnEnable( ( _item as DisplayObject ));
						StringUtils.setUnEnable( ( _mcHp as DisplayObject ));
						StringUtils.setUnEnable( ( _tf_name as DisplayObject ));
					}
					else
					{
						StringUtils.setEnable( ( _item as DisplayObject ));
						StringUtils.setEnable( ( _mcHp as DisplayObject ));
						StringUtils.setEnable( ( _tf_name as DisplayObject ));
					}
					
					
					
					_url = FileManager.instance.getHeadIconById(_info.icon);
					
					if(_url != _item['uil'].source)
					{
//						_item['uil'].source =_url;
						ImageUtils.replaceImage(_item,_item["uil"],_url);
					}
					
					_mcHp['mcMask'].width = int( _info.per/100*_barMaxW);
					_tf_name.text = _info.name;
				}
			}
			
			
			_team = m_model.getFightingTeam_2();
			if(null == _team)
			{
				_team = new Vector.<StructSHFightUserInfo2>();
			}
			for(i = 0; i < n ; ++i)
			{
				_item = mc['R_item_'+i];
				_mcHp = mc['mcHp_r_'+i];
				_tf_name = mc['tf_name_r_'+i] as TextField;
				
				if(i >= _team.length)
				{
					_item.visible = false;
					_mcHp.visible = false;
					_tf_name.visible = false;
				}
				else
				{
					_item.visible = true;
					_mcHp.visible = true;
					_tf_name.visible = true;
					
					_info = _team[i];
					
					
					_url = FileManager.instance.getHeadIconById(_info.icon);
					
					if(_url != _item['uil'].source)
					{
//						_item['uil'].source =_url;
						ImageUtils.replaceImage(_item,_item["uil"],_url);
					}
					
					
					_mcHp['mcMask'].width = int( _info.per/100*_barMaxW);
					_tf_name.text = _info.name;
				}
			}
			
			
			
		}
		
		
		private function _repaintTime(t:int=0):void
		{
//			if (null != this.m_countDownTool)
//			{
//				this.m_countDownTool.stop();
//			}
			
			var _t:int = t;
			 
			if (null == this.m_countDownTool)
			{
				this.m_countDownTool=new CountDownTool(mc['tf_remainderTime']);
			}
			if (!this.m_countDownTool.isRunning())
			{
				this.m_countDownTool.start(_t);
			}
			this.m_countDownTool.updata(_t);
		}
		
		
		
	}
	
	
}








