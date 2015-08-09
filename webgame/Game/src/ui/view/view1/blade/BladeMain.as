package ui.view.view1.blade
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view6.Alert;
	
	import world.WorldEvent;

	public class BladeMain extends UIWindow
	{
		public const MAX_ROW:int=5;

		private static var m_instance:BladeMain;

		public static function get instance():BladeMain
		{
			if (null == m_instance)
			{
				m_instance=new BladeMain();
			}
			return m_instance;
		}

		public const AutoRefreshSecond:int=60;
		private var _curAutoRefresh:int=0;
		private var _spContent:Sprite;

		protected function get spContent():Sprite
		{
			if (null == _spContent)
			{
				_spContent=new Sprite();
			}
			return _spContent;
		}

		public function BladeMain()
		{
			blmBtn=0;
			type=0;
			super(getLink(WindowName.win_zhao_huan_jian_ling));
		}



		override protected function init():void
		{
			if (PubData.isActived)
			{
				mc["btnActive"].visible=false;
			}
			else
			{
				mc["btnActive"].visible=true;
			}
			mc["txt_blade_point"].text="";

			for (var j:int=1; j <= MAX_ROW; j++)
			{
				mc['item_' + j]['txt_1'].text='';
				mc['item_' + j]['txt_2'].text='';
				mc['item_' + j]['txt_3'].text='';

				mc['item_' + j]['btnCallBlade'].visible=false;

			}

			XmlManager.localres.BladeXml;

			_regCk();
			_regPc();
			_regDs();
			//refresh();
			this.getData();

			//test
			//var p:PacketSCGetBladeState2 = new PacketSCGetBladeState2();
			//p.blade_value = 1000;
			//DataKey.instance.receive(p);
		}

		private function _regCk():void
		{
			_curAutoRefresh=0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
		}

		private function daoJiShi(e:WorldEvent):void
		{
			_curAutoRefresh++;
			if (_curAutoRefresh >= AutoRefreshSecond)
			{
				_curAutoRefresh=0;
				//你的代码
				this.getData();
			}
		}

		public function getData():void
		{
			var cs:PacketCSGetBladeState=new PacketCSGetBladeState();
			uiSend(cs);

		}

		private function _regPc():void
		{
			uiRegister(PacketSCGetBladeState.id, SCGetBladeState);
			uiRegister(PacketSCCallBlade.id, SCCallBlade);
			uiRegister(PacketSCActiveBlade.id, SCActiveBlade);
		}


		private var _p:PacketSCGetBladeState2=new PacketSCGetBladeState2();

		public function SCGetBladeState(p:PacketSCGetBladeState2):void
		{

			_p=p;

			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{

					this.refresh();

				}
				else
				{

				}

			}
		}

		public function SCCallBlade(p:PacketSCCallBlade2):void
		{
			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{

					this.getData();

				}
				else
				{

				}

			}
		}

		public function SCActiveBlade(p:PacketSCActiveBlade):void
		{
			if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					mc["btnActive"].visible=false;
					mc['item_5']['btnCallBlade'].visible=true;
				}
				else
				{

				}

			}
		}




		private function _regDs():void
		{
		}

		public function txt_focus_in(e:FocusEvent):void
		{
			//e.target.text = '';
		}


		public function refresh():void
		{
			_refreshTf();
			_refreshMc();
			_refreshSp();
			_refreshRb();
		}

		private function _refreshMc():void
		{
		}

		private function _refreshTf():void
		{

			mc['txt_blade_point'].text=Lang.getLabel("9000070_Blade", [_p.blade_value.toString()]);

			var m:Pub_BladeResModel;
			var myLvl:int=Data.myKing.level;

			//test
			//myLvl = 10;

			for (var j:int=1; j <= MAX_ROW; j++)
			{
				m=XmlManager.localres.BladeXml.getResPath(j) as Pub_BladeResModel;

				mc['item_' + j]['txt_1'].text=m.npc_name; //Lang.getLabel("9000071_Blade",[m.npc_id]);
				mc['item_' + j]['txt_2'].text=Lang.getLabel("9000072_Blade", [m.need_blade]);
				if (j == 5)
				{
					mc['item_' + j]['btnCallBlade'].visible=PubData.isActived;
					mc['item_' + j]['txt_1'].htmlText="<font color='#ff9600'>" + m.npc_name + "</font>";
				}else{
					mc['item_' + j]['btnCallBlade'].visible=true;
				}
				if (myLvl >= m.need_lv)
				{

					mc['item_' + j]['txt_3'].htmlText=Lang.getLabel("9000073_Blade_enough", [m.need_lv]);

					StringUtils.setEnable(mc['item_' + j]['btnCallBlade']);

				}
				else
				{
					mc['item_' + j]['txt_3'].htmlText=Lang.getLabel("9000073_Blade_not_enough", [m.need_lv]);

					StringUtils.setUnEnable(mc['item_' + j]['btnCallBlade']);

				}
			}

		}

		private function _refreshSp():void
		{
		}

		private function _refreshRb():void
		{
		}


		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			var target_parent_name:String;

			if (target.hasOwnProperty("parent"))
			{
				if (null != target.parent)
				{
					target_parent_name=target.parent.name;
				}
			}

			//元件点击
			switch (target_name)
			{
				case "btnCallBlade":
					var cs:PacketCSCallBlade=new PacketCSCallBlade();
					var m:Pub_BladeResModel;
					if ("item_1" == target_parent_name)
					{
						m=XmlManager.localres.BladeXml.getResPath(1) as Pub_BladeResModel;

					}
					else if ("item_2" == target_parent_name)
					{
						m=XmlManager.localres.BladeXml.getResPath(2) as Pub_BladeResModel;
					}
					else if ("item_3" == target_parent_name)
					{
						m=XmlManager.localres.BladeXml.getResPath(3) as Pub_BladeResModel;
					}
					else if ("item_4" == target_parent_name)
					{
						m=XmlManager.localres.BladeXml.getResPath(4) as Pub_BladeResModel;
					}
					else if ("item_5" == target_parent_name)
					{
						m=XmlManager.localres.BladeXml.getResPath(5) as Pub_BladeResModel;
					}

					cs.npc_id=m.npc_id;
					uiSend(cs);
					break;
				case "btnActive":
					Alert.instance.ShowMsg("确定要花费1000元宝激活吗?", 4, null, function():void
					{
						m=XmlManager.localres.BladeXml.getResPath(5) as Pub_BladeResModel;
						var m_cs:PacketCSActiveBlade=new PacketCSActiveBlade();
						m_cs.npc_id=m.npc_id;
						uiSend(m_cs);
					});

					break;
				default:
					break;
			}
		}

		override protected function windowClose():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND, daoJiShi);
			//_clearSp();
			super.windowClose();
		}


		override public function getID():int
		{
			return 0;
		}

	}
}
