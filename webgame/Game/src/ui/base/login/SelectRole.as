package ui.base.login
{
	import common.config.GameIni;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.load.Gamelib;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import netc.packets2.StructDCRoleList2;
	
	import world.FileManager;

	public class SelectRole extends Sprite
	{

		public static const ROLE_MAX_NUM:int=4;


		private static var m_instance:SelectRole=null;
		private var m_gamelib:Gamelib;
		private var m_ui:MovieClip=null;
		private var m_panel:MovieClip=null;
		public var m_rolelist:Vector.<StructDCRoleList2>=null;

		private var m_panelW:int=-1;
		private var m_panelH:int=-1;

		public function SelectRole()
		{
			super();

			m_gamelib=new Gamelib();
		}

		public static function getInstance():SelectRole
		{
			if (null == m_instance)
			{
				m_instance=new SelectRole();
			}
			return m_instance;
		}

		public function init():void
		{
			if (null == m_ui)
			{
				m_ui=m_gamelib.getswflink("game_SelectRole", "mc_select_role") as MovieClip;
			}
			if (null == m_panel)
			{
				m_panel=m_ui['mcPanel'];
				m_panelW=m_panel.width;
				m_panelH=m_panel.height;
			}
			this.addEventListener(Event.ADDED_TO_STAGE, addStageHandler);

			for (var i:int=0; i < ROLE_MAX_NUM; ++i)
			{
				m_panel['RoleItem_' + i].visible=false;
				m_panel['RoleItem_' + i]['mcSelectRect'].visible=false;
				m_panel['RoleItem_' + i]['btnGaiMing'].visible=false;
				m_panel['RoleItem_' + i]['btnGaiMing'].addEventListener(MouseEvent.MOUSE_DOWN, _onMouseReName);
				m_panel['RoleItem_' + i].mouseChildren=false;
				m_panel['RoleItem_' + i].addEventListener(MouseEvent.MOUSE_DOWN, _onMouseSelected);
			}
			this.addChild(m_panel);

			_repaint();
			_replace();
		}

		private function addStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addStageHandler);
			this.stage.addEventListener(Event.RESIZE, _onResize);
		}

		public function setRoleList(rolelist:Vector.<StructDCRoleList2>):void
		{
			m_rolelist=rolelist;
			_repaint();
		}

		private function _repaint():void
		{
			var mc_roleList:Array=[];
			var widthAllMC:int=0;

			if (null == m_rolelist || null == m_panel)
			{
				return;
			}

			var _role:StructDCRoleList2=null;
			var _max:int=0;
			var _leave_date:int=0;
			for (var i:int=0; i < ROLE_MAX_NUM; ++i)
			{

				if (i >= m_rolelist.length)
				{
					m_panel['RoleItem_' + i].visible=false;
					m_panel['RoleItem_' + i]['mcSelectRect'].visible=false;
					m_panel['RoleItem_' + i].mouseChildren=false;
					m_panel['RoleItem_' + i].addEventListener(MouseEvent.MOUSE_DOWN, _onMouseSelected);

					continue;
				}
				_role=m_rolelist[i];
				if (null == _role)
				{
					continue;
				}
				mc_roleList.push(m_panel['RoleItem_' + i]);
				widthAllMC+=215;

				m_panel['RoleItem_' + i].visible=true;

				m_panel['RoleItem_' + i]['tf_name'].text=_role.king_name;
				m_panel['RoleItem_' + i]['tf_level'].text=Lang.getLabel("pub_job" + _role.king_metier);
				m_panel['RoleItem_' + i]['tf_metier'].text=_role.king_level+"级";

				m_panel['RoleItem_' + i]['btnJiaoSe']['uil'].source=FileManager.instance.getWindowSkinUrl(_role.s0, _role.s1, _role.s2, _role.s3, _role.king_sex, _role.king_metier, _role.userid);
				
				if (1 == _role.can_changename)
				{
					m_panel['RoleItem_' + i]['btnGaiMing'].visible=true;
				}
				else
				{
					m_panel['RoleItem_' + i]['btnGaiMing'].visible=false;
				}


				//根绝玩家角色最大一个离线时间选出一个默认
				//_max
				if (_role.leave_date > _leave_date)
				{
					_leave_date=_role.leave_date;
					_max=i;
				}
			}
			var m_x:int=m_panel["btnEnter"].x + m_panel["btnEnter"].width / 2 - widthAllMC / 2;
			for (i=0; i < mc_roleList.length; i++)
			{
				mc_roleList[i].x=i * 215 + m_x;
			}
			_selected(_max);
		}


		private var m_currSelected:int=0;

		public function getCurrSelected():int
		{
			return m_currSelected;
		}


		/**
		 * 选择一个角色
		 * @param idx
		 *
		 */
		private function _selected(idx:int):void
		{
			m_currSelected=idx;
			for (var i:int=0; i < ROLE_MAX_NUM; ++i)
			{
				if (i == idx)
				{
					m_panel['RoleItem_' + i]['mcSelectRect'].visible=true;
//					var gl:GlowFilter=new GlowFilter(0xffa800, .75, 16, 16, 2, BitmapFilterQuality.LOW, false, false);
//					m_panel['RoleItem_' + i]['btnJiaoSe']['uil'].filters=[gl];
					CtrlFactory.getUIShow().setColor(m_panel['RoleItem_' + i],1);
				}
				else
				{
					m_panel['RoleItem_' + i]['mcSelectRect'].visible=false;
//					m_panel['RoleItem_' + i]['btnJiaoSe']['uil'].filters=null;
					CtrlFactory.getUIShow().setColor(m_panel['RoleItem_' + i]);
				}
			}
		}

		private function _onMouseSelected(e:MouseEvent=null):void
		{
			var _name:String=e.target.name;
			var _head:String="RoleItem_";

			if (0 != _name.indexOf(_head))
			{
				return;
			}

			var _idx:int=int(_name.substr(_head.length, 1));
			_selected(_idx);
		}

		private function _onResize(e:Event=null):void
		{
			_replace(true);
		}

		private function _onMouseReName(e:MouseEvent=null):void
		{
			var _name:String=e.target.parent.name;
			var _role:StructDCRoleList2=null;
			switch (_name)
			{
				case "RoleItem_0":
					_role=m_rolelist[0];
					break;
				case "RoleItem_1":
					_role=m_rolelist[1];
					break;
				case "RoleItem_2":
					_role=m_rolelist[2];
					break;
				case "RoleItem_3":
					_role=m_rolelist[3];
					break;
				default:
					break;
			}

			if (null != _role)
			{
				ReNameWindow.getInstance().setUserID(_role.userid);
				ReNameWindow.getInstance().setReName(_role.king_name);
				ReNameWindow.getInstance().setCallback(_renameCallback);
				ReNameWindow.getInstance().open();
			}
		}

		public function close():void
		{
			if (null != this.parent)
			{
				this.parent.removeChild(this);
			}
		}

		private var m_isFirstReplace:Boolean=true;

		private function _replace(isResize:Boolean=false):void
		{
			if (!m_isFirstReplace && !isResize)
			{
				return;
			}
			m_isFirstReplace=false;
			m_panel.x=(GameIni.MAP_SIZE_W - m_panelW) >> 1;
			m_panel.y=(GameIni.MAP_SIZE_H - m_panelH) >> 1;
		}

		/**
		 * 合服修改玩家名字成功回调函数
		 * @param userid
		 * @param rename
		 *
		 */
		private function _renameCallback(userid:int, rename:String):void
		{
			if (null == m_rolelist)
			{
				return;
			}

			for each (var role:StructDCRoleList2 in m_rolelist)
			{
				if (role.userid == userid)
				{
					role.king_name=rename;
					role.can_changename=0;
					break;
				}
			}

			_repaint();
		}
	}
}
