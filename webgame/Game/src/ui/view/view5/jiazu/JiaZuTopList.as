package ui.view.view5.jiazu
{
	import common.managers.Lang;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.text.TextField;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import netc.Data;
	import netc.packets2.StructGuildInfo2;
	import netc.packets2.StructGuildSimpleInfo2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 * 家族排行版面板 
	 * @author 
	 * 
	 */	
	public class JiaZuTopList extends UIWindow
	{
		private static var _instance:JiaZuTopList;
		
		/**
		 * 每页显示的最大条目 
		 */		
		private static const MAX_PAGE_NUM:int = 10;
		
		
		public static function getInstance():JiaZuTopList
		{
			if(null == _instance)
			{
				_instance = new JiaZuTopList();
			}
			
			return _instance;
		}
		
		public function JiaZuTopList()
		{
			super(getLink(WindowName.win_jz_topList));
		}
		
		//面板初始化
		override protected function init():void 
		{
			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			JiaZuModel.getInstance().requestGuildList(2);
			
			if(null != mc)
			{
				super.sysAddEvent(mc["mc_page"],MoreLessPage.PAGE_CHANGE,_changePageListener);
			}
			
		}	
		
		override public function winClose():void
		{
			JiaZuModel.getInstance().removeEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			super.winClose();
			
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			var _itemIndex:int;
			var _StructGuildInfo2:StructGuildInfo2 = null;
			switch(name)
			{
				case "btnChaKan":
					_itemIndex = int(target.parent.name.substr(4));
					if(_itemIndex < m_currentPageData.length)
					{
						_StructGuildInfo2 = m_currentPageData[_itemIndex] as StructGuildInfo2;
						JiaZuInfo.getInstance().setID(_StructGuildInfo2.guildid);
						JiaZuInfo.getInstance().open();
					}
					break;
				default:
					break;
			}
		}
		
		
		private var m_currentPageSelect:int;
		/**
		 * 指定显示页面索引 
		 * @param cPage
		 * @param list
		 * 
		 */		
		private function _repaintPage(cPage:int,list:Vector.<StructGuildSimpleInfo2>):void
		{
			var _length:int = list.length;
			var _totalNum:int =Math.ceil( _length / MAX_PAGE_NUM);
			if(cPage > _totalNum)
			{
				cPage = _totalNum;
			}
			
			m_currentPageSelect = cPage;
			mc["mc_page"].setMaxPage(m_currentPageSelect,_totalNum);
		}
		
		private var m_currentPageIndex:int = 1;
		private var m_currentPageData:Array = null;
		private function _changePageListener(e:DispatchEvent=null):void
		{
			//当前页面索引值
			var _cPage:int = e.getInfo.count;
			var _guildListData:Vector.<StructGuildSimpleInfo2> = Data.jiaZu.GuildListData;
			var _StructGuildInfo2:StructGuildSimpleInfo2 = null;
			var _index:int;
			
			m_currentPageData = [];
			
			var _colorString:String = "#fff5d2";
			var _bLeftString:String = "";
			var _bRightString:String = "";
			
			for(var i:int = 1 ; i <= MAX_PAGE_NUM ; ++i)
			{
				_index = ((_cPage-1)*MAX_PAGE_NUM + i - 1);
				if(_cPage > 0 && _index < _guildListData.length )
				{
					_StructGuildInfo2 = _guildListData[_index];
					m_currentPageData[i] = _StructGuildInfo2;
				}
				else
				{
					_StructGuildInfo2 = null;
				}
				
				if(null != _StructGuildInfo2)
				{
					if(1 ==  _StructGuildInfo2.sort)
					{
						_colorString = "#FF9B10";
					}
					else if(2 ==  _StructGuildInfo2.sort)
					{
						_colorString = "#F74AFD";
					}
					else if(3 ==  _StructGuildInfo2.sort)
					{
						_colorString = "#0AA3D9";
					}
					else
					{
						_colorString = "#fff5d2";
					}
					
					mc['item'+i].visible = true;
					
					if(_StructGuildInfo2.sort <= 3)
					{
						_bLeftString = "<b>";
						_bRightString = "</b>";
					}
					else
					{
						_bLeftString = "";
						_bRightString = "";
					}
					
					//排行
					mc['item'+i]['tf_1'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.sort + _bRightString + "</font>";
					//家族名称
					mc['item'+i]['tf_2'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.name + _bRightString + "</font>";
					//族长
					mc['item'+i]['tf_3'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.leader + _bRightString + "</font>";
					//等级
					mc['item'+i]['tf_4'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.level + _bRightString + "</font>";
					//家族资金
					mc['item'+i]['tf_5'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.money  + _bRightString + "</font>";
					//家族繁荣度
					mc['item'+i]['tf_6'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.active + _bRightString + "</font>";
					//家族总战力值
					//mc['item'+i]['tf_7'].htmlText = "<font color='"+_colorString+"' >"+ _bLeftString + _StructGuildInfo2.faight + _bRightString + "</font>";
					
					//0011130: 家族排行榜数据显示优化  , 将【原战斗】列数据替换为【阵营】归属列。
					//太乙:2
					if(2 == _StructGuildInfo2.campid)
					{
						mc['item'+i]['tf_7'].text = Lang.getLabel("pub_tai_yi");
					}
					//通天:3
					else if(3 == _StructGuildInfo2.campid)
					{
						mc['item'+i]['tf_7'].text = Lang.getLabel("pub_tong_tian");
					}
					
					//130121 版本  ，暂时屏蔽  , 参考：0011130: 家族排行榜数据显示优化
					
					
					//族长VIP等级
					if(_StructGuildInfo2.vip <= 0)
					{
						mc['item'+i]['mc_vip'].visible = false;
					}
					else
					{
						mc['item'+i]['mc_vip'].visible = true;
						mc['item'+i]['mc_vip'].gotoAndStop(_StructGuildInfo2.vip);
					}
				}
				else
				{
					mc['item'+i].visible = false;
					//					mc['item'+i]['txt_pai_ming'].text = "";
					//					mc['item'+i]['txt_ming_cheng'].text = "";
					//					mc['item'+i]['txt_zu_zhang'].text = "";
					
				}
			}
		}
		
		public function jzEventHandler(e:JiaZuEvent):void
		{
			var sort:int = e.sort;
			switch(e.sort)
			{
				case JiaZuEvent.JZ_GUILD_LIST_UPD_EVENT:
					_repaintPage(1,Data.jiaZu.GuildListData);
					break;
				
				default:
					break;
			}
			
			
		}
		
	}
	
	
}





