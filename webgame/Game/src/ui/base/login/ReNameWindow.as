package ui.base.login
{
	import com.greensock.TweenLite;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import engine.support.IPacket;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import netc.DataKey;
	import nets.packets.PacketCDRoleRename;
	import nets.packets.PacketDCRoleRename;
	import ui.view.UIMessage;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view6.GameAlert;

	/**
	 * 合服修改名字
	 * @author steven guo
	 *
	 */
	public class ReNameWindow extends UIWindow
	{
		private static var m_instance:ReNameWindow=null;
		private var m_userid:int=0;
		private var m_name:String=null;
		private var m_callback:Function=null;

		public function ReNameWindow()
		{
			super(getLink(WindowName.win_he_fu, "game_SelectRole"));
			_initMsgListener();
		}

		private function _initMsgListener():void
		{
			DataKey.instance.register(PacketDCRoleRename.id, _DCRoleRename);
		}

		public static function getInstance():ReNameWindow
		{
			if (null == m_instance)
			{
				m_instance=new ReNameWindow();
			}
			return m_instance;
		}

		override protected function init():void
		{
			super.init();
			mc['tf_name'].text=this.m_name;
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			switch (name)
			{
				case "btnOK":
					var _rename:String=mc['tf_name'].text;
					var _len:int=StringUtils.getStringLengthByChar(_rename);
					if (_len > 12)
					{
						(new GameAlert).ShowMsg(Lang.getLabel("20012_NewRole"), 2);
					}
					else if (_len < 2)
					{
						(new GameAlert).ShowMsg(Lang.getLabel("20007_NewRole"), 2);
					}
					else
					{
						this.m_name=_rename;
						_CDRoleRename(this.m_userid, this.m_name);
					}
					break;
				case "btnCancel":
					this.winClose();
					break;
				default:
					break;
			}
		}

		public function setUserID(id:int):void
		{
			this.m_userid=id;
		}

		public function setReName(rename:String):void
		{
			this.m_name=rename;
		}

		public function setCallback(fn:Function):void
		{
			m_callback=fn;
		}

		/*
		<packet id="135" name="CDRoleRename" desc="角色改名" sort="1">
		<prop name="rolename" type="7"  length="128" desc="角色信息"/>
		<prop name="userid" type="3"  length="0" desc="userid"/>
		</packet>
		<packet id="136" name="DCRoleRename" desc="角色改名" sort="2">
		<prop name="tag" type="3"  length="0" desc="结果"/>
		<prop name="msg" type="7"  length="50" desc="提示"/>
		</packet>
		*/
		private function _CDRoleRename(userid:int, name:String):void
		{
			var _p:PacketCDRoleRename=new PacketCDRoleRename();
			_p.userid=userid;
			_p.rolename=name;
			DataKey.instance.send(_p);
		}

		private function _DCRoleRename(p:IPacket):void
		{
			var _p:PacketDCRoleRename=p as PacketDCRoleRename;
			if (508 == _p.tag)
			{
				_showResult(_p);
			}
			if (0 != _p.tag)
			{
				//Lang.showResult(_p);
				return;
			}
			if (null != m_callback)
			{
				m_callback(m_userid, m_name);
			}
			this.winClose();
		}
		private var m_showResultTF:TextField=null;

		private function _showResult(p:Object):void
		{
			removeText();
			m_showResultTF=UIMessage.createTFByMessage3();
			m_showResultTF.htmlText="角色名称不合法请重新填写!";
			m_showResultTF.x=(this.stage.width - m_showResultTF.width) / 2 - 250;
			m_showResultTF.y=this.stage.stageHeight / 2 + 50;
			m_showResultTF.alpha=1;
			m_showResultTF.cacheAsBitmap=true;
			this.stage.addChild(m_showResultTF);
			TweenLite.to(m_showResultTF, 2.5, {alpha: 0, y: m_showResultTF.y - m_showResultTF.height, delay: 1, onComplete: removeText, onCompleteParams: [m_showResultTF]});
		}

		private function removeText(tf:TextField=null):void
		{
			if (null != m_showResultTF && m_showResultTF.parent)
			{
				m_showResultTF.parent.removeChild(m_showResultTF);
			}
		}
	}
}
