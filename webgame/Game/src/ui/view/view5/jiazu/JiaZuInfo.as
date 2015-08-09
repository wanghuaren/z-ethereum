package ui.view.view5.jiazu
{
	import com.engine.utils.HashMap;
	
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	
	import flash.display.Sprite;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import netc.packets2.PacketWCGuildInfo2;
	import netc.packets2.StructGuildInfo2;
	import netc.packets2.StructGuildRequire2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	public class JiaZuInfo extends UIWindow
	{
		private static var _instance:JiaZuInfo;

		private var m_guildID:int=0;

		private var m_guildinfo:StructGuildInfo2;

		private var m_arrItemmemberlist:Vector.<StructGuildRequire2>;

		private var m_scrollList:Array;

		/**
		 * 滚动条内容面板
		 */
		private var mc_scrollPanel:Sprite;

		public static function getInstance():JiaZuInfo
		{
			if (null == _instance)
			{
				_instance=new JiaZuInfo();
			}

			return _instance;
		}

		public function JiaZuInfo()
		{
			super(getLink(WindowName.win_bang_pai));

			m_mapJiaZuInfoScrollPanelItem=new HashMap();
		}

		//面板初始化
		override protected function init():void
		{
			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT, jzEventHandler);
			JiaZuModel.getInstance().requestGuildInfo(m_guildID);


		}

		public function setID(guildID:int):void
		{
			m_guildID=guildID;
		}

		public function jzEventHandler(e:JiaZuEvent):void
		{
			var sort:int=e.sort;
			switch (e.sort)
			{
				case JiaZuEvent.JZ_GUILD_INFO_EVENT:
					var _info:PacketWCGuildInfo2=e.msg as PacketWCGuildInfo2;
					//====whr======
					if (_info.guildinfo.guildid != m_guildID)
					{
						return;
					}
					m_guildinfo=_info.guildinfo;
					m_arrItemmemberlist=_info.arrItemmemberlist;
					repaint();
					break;
				default:
					break;
			}


		}

		/**
		 * 将指定显示容器内的显示对象从显示列表中移除。
		 * @param mc
		 *
		 */
		private function _clearMcContent(mc:Sprite):void
		{
			if (null != mc)
			{
				while (mc.numChildren > 0)
					mc.removeChildAt(0);
			}
		}

		private function repaint():void
		{
			if (null == mc_scrollPanel)
			{
				mc_scrollPanel=new Sprite();
			}
			else
			{
				_clearMcContent(mc_scrollPanel);
			}

			if (null != m_guildinfo)
			{
				mc['txtGuildName'].text=m_guildinfo.name;
				mc['txtGuildLeader'].text=m_guildinfo.leader;
				mc['txtGuildSort'].text=m_guildinfo.sort;
				mc['txtGuildLvl'].text=m_guildinfo.level;
				mc['txtGuildMembers'].text=m_guildinfo.members;
				mc['txtGuildActive'].text=m_guildinfo.active;
				mc['txtGuildDes'].text=m_guildinfo.desc;
			}

			if (null != m_arrItemmemberlist)
			{
				m_scrollList=[];
				var _length:int=m_arrItemmemberlist.length;
				for (var i:int=0; i < _length; ++i)
				{
					m_scrollList[i]=_getJiaZuInfoScrollPanelItem(i);
					mc_scrollPanel.addChild(m_scrollList[i]);

					m_scrollList[i].setData(m_arrItemmemberlist[i]);
				}


				//进行布局
				CtrlFactory.getUIShow().showList2(mc_scrollPanel, 1, 292, 24);

				mc["sp2"].source=mc_scrollPanel;
			}

		}


		/**
		 * 缓存滚动条item对象
		 */
		private var m_mapJiaZuInfoScrollPanelItem:HashMap;

		/**
		 * 获得条目对象实例
		 */
		private function _getJiaZuInfoScrollPanelItem(id:int):Sprite
		{
			if (m_mapJiaZuInfoScrollPanelItem.containsKey(id))
			{
				return m_mapJiaZuInfoScrollPanelItem.get(id);
			}
			else
			{
				var c:Class=GamelibS.getswflinkClass("game_index", "item_zu_yuan2");
				var sp:Sprite=new c() as Sprite;

				var _item:JiaZuInfoScrollPanelItem=new JiaZuInfoScrollPanelItem(sp);
				//_item.setID(id);
				_item.mouseChildren=false;

				m_mapJiaZuInfoScrollPanelItem.put(id, _item);
				return _item;
			}
		}

	}

}



