package ui.view.view5.jiazu
{
	import ui.frame.UIMovieClip;
	
	import engine.event.DispatchEvent;
	
	import fl.containers.UILoader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import common.utils.StringUtils;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import common.managers.Lang;
	
	public final class JiaZuCreate extends UIWindow
	{
		private static var _instance:JiaZuCreate;
		
		//创建家族的最大字符数 
		private static const MAX_NAME_CHAR_NUMHER:int = 12;
		
		//创建家族的最小字符数 
		private static const MIN_NAME_CHAR_NUMHER:int = 2;
		
		//创建家族时输入的名称
		private var m_inputMame:String = '';
		
		public static function getInstance():JiaZuCreate
		{
			if(null == _instance)
			{
				_instance = new JiaZuCreate();
			}
			
			return _instance;
		}
		
		public function JiaZuCreate()
		{
			super(getLink(WindowName.win_bang_pai));
		}
		
		//面板初始化
		override protected function init():void 
		{
			//JiaZuModel.getInstance();
			
			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			
			super.sysAddEvent(mc["txtGuild"],FocusEvent.FOCUS_IN,clearGuild);
			
			mc['txtGuild'].addEventListener(Event.CHANGE,_onTxtGuildChangeListener)
			
			clearGuild();
		}	
		
		private function _onTxtGuildChangeListener(e:Event):void
		{
			var _tf:TextField = e.target as TextField; 
			var _input:String = _tf.text;
			var _length:int = StringUtils.getStringLengthByChar(_input);
			
			if(_length > MAX_NAME_CHAR_NUMHER)
			{
				_tf.text = m_inputMame;
			}
			else
			{
				m_inputMame = _input;
			}
			
		}
		override public function winClose():void
		{
			JiaZuModel.getInstance().removeEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			super.winClose();
		}
		
		public function clearGuild(e:FocusEvent=null):void
		{
			mc["txtGuild"].text= "";
			m_inputMame = "";
		}
		
		
		override public function mcHandler(target:Object):void
		{
			var target_name:String = target.name;
			
			switch(target_name)
			{
				case "btnSubmit":
					m_inputMame = StringUtils.trim( mc["txtGuild"].text );
					var _length:int = StringUtils.getStringLengthByChar(m_inputMame);
					if(_length >= MIN_NAME_CHAR_NUMHER && _length <= MAX_NAME_CHAR_NUMHER)
					{
						JiaZuModel.getInstance().requestGuildCreate(m_inputMame);
					}
					else
					{
						//飘字
						Lang.showMsg(Lang.getClientMsg("40002_jiazu_chuangjian"));
					}
					
					break;
				case "btnCancel":
					winClose();
					break;
				default:
					break;
			}
		}
		
		public function jzEventHandler(e:JiaZuEvent):void
		{
			var sort:int = e.sort;
			switch(e.sort)
			{
				case JiaZuEvent.JZ_CREATE_SUCCESS_EVENT:
					winClose();
					break;
			
			}
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
}