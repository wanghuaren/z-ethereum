package ui.view.view5.jiazu
{
	import common.managers.Lang;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructGuildInfo2;
	import netc.packets2.StructGuildSimpleInfo2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.bangpai.BangPaiList;
	
	/**
	 * 家族列表信息
	 * @author 
	 * 
	 */	
	public class JiaZuList extends UIWindow
	{
		private static var _instance:JiaZuList;
		
		/**
		 * 每页显示的最大条目 
		 */		
		private static const MAX_PAGE_NUM:int = 10;
		
		public static function getInstance():BangPaiList
		{			
			return BangPaiList.instance;
		}
		
		public function JiaZuList()
		{
			super(getLink(WindowName.win_bang_pai_list));
		}
		
		//面板初始化
//		override protected function init():void 
//		{
//			JiaZuModel.getInstance();
//			
//			super.sysAddEvent(mc["mc_page"],MoreLessPage.PAGE_CHANGE,_changePageListener);
//			JiaZuModel.getInstance().addEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
//			
//			//向服务器请求所有家族列表
//			JiaZuModel.getInstance().requestGuildList(1);
//			
//			
//			Data.myKing.addEventListener(MyCharacterSet.GUILD_UPD,_onMe_guild_upd);
//			Data.myKing.addEventListener(MyCharacterSet.GUILD_NAME_UPD,_onMe_guild_upd);
//			Data.myKing.addEventListener(MyCharacterSet.GUILD_DUTY_UPD,_onMe_guild_upd);
//		}	
		
		private function _onMe_guild_upd(e:DispatchEvent):void
		{
			winClose();
			
			if(Data.myKing.Guild.GuildId > 0)
			{
				JiaZu.getInstance().open();
			}
			
		}
		
		override public function winClose():void
		{
			JiaZuModel.getInstance().removeEventListener(JiaZuEvent.JZ_EVENT,jzEventHandler);
			
			Data.myKing.removeEventListener(MyCharacterSet.GUILD_UPD,_onMe_guild_upd);
			Data.myKing.removeEventListener(MyCharacterSet.GUILD_NAME_UPD,_onMe_guild_upd);
			Data.myKing.removeEventListener(MyCharacterSet.GUILD_DUTY_UPD,_onMe_guild_upd);
			
			super.winClose();
			
		}
		
		
		
		private var _currentPageGuildReqIndex:int;
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			var _Duty:int;
			var _itemIndex:int;
			var _StructGuildInfo2:StructGuildInfo2 = null;
			switch(name)
			{
				case "btn_chuang_jian":
					JiaZuCreate.getInstance().open();
					
					break;
				
//				case "__id0_":
//					if("mc_shen_qing" == target.parent.name)
//					{
//						_itemIndex = int(target.parent.parent.name.substr(4));
//						//申请加入
//						if(null != m_currentPageData)
//						{
//							if(_itemIndex < m_currentPageData.length)
//							{
//								_StructGuildInfo2 = m_currentPageData[_itemIndex] as StructGuildInfo2;
//								Data.jiaZu.GuildReq = _StructGuildInfo2.guildid;
//								_currentPageGuildReqIndex = _itemIndex;
//								JiaZuModel.getInstance().requestGuildReq(_StructGuildInfo2.guildid);
//							}
//						}
//					}
//					break;
				case "mc_shen_qing_f1":
					_itemIndex = int(target.parent.parent.name.substr(4));
					//申请加入
					if(null != m_currentPageData)
					{
						if(_itemIndex < m_currentPageData.length)
						{
							_StructGuildInfo2 = m_currentPageData[_itemIndex] as StructGuildInfo2;
							Data.jiaZu.GuildReq = _StructGuildInfo2.guildid;
							_currentPageGuildReqIndex = _itemIndex;
							JiaZuModel.getInstance().requestGuildReq(_StructGuildInfo2.guildid);
							
						}
					}
					break;
				case "btn_cha_kan":
					
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
		
		private var m_currentPageSelect:int = 1;
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
			
			m_currentPageSelect = _cPage;
			
			m_currentPageData = [];
			
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
					mc['item'+i].visible = true;
					mc['item'+i]['txt_pai_ming'].text = _StructGuildInfo2.sort;
					mc['item'+i]['txt_ming_cheng'].text = _StructGuildInfo2.name;
					mc['item'+i]['txt_zu_zhang'].text = _StructGuildInfo2.leader;
					mc['item'+i]['txt_deng_ji'].text = _StructGuildInfo2.level;
					mc['item'+i]['txt_ren_shuo'].text = _StructGuildInfo2.members;
					
					//0011130: 家族排行榜数据显示优化  , 将【原战斗】列数据替换为【阵营】归属列。
					//太乙:2  , 通天:3
					//mc['item'+i]['txt_z_zhan_li'].text = _StructGuildInfo2.faight;
					
					//太乙:2
					if(2 == _StructGuildInfo2.campid)
					{
						mc['item'+i]['txt_z_zhan_li'].text = Lang.getLabel("pub_tai_yi");
					}
					//通天:3
					else if(3 == _StructGuildInfo2.campid)
					{
						mc['item'+i]['txt_z_zhan_li'].text = Lang.getLabel("pub_tong_tian");
					}
					
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
					
					
					//未申请
					if(0 == _StructGuildInfo2.state)
					{
						mc['item'+i]['mc_shen_qing'].gotoAndStop(1);
					}
					//申请中
					else
					{
						mc['item'+i]['mc_shen_qing'].gotoAndStop(2);
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
					_repaintPage(m_currentPageSelect,Data.jiaZu.GuildListData);
					break;
				case JiaZuEvent.JZ_GUILD_REQ_SUCCESS_EVENT:
					
					if(null != m_currentPageData && _currentPageGuildReqIndex < m_currentPageData.length)
					{
						var _StructGuildInfo2:StructGuildInfo2 = m_currentPageData[_currentPageGuildReqIndex] as StructGuildInfo2;
						_StructGuildInfo2.state = 1;
						_repaintPage(m_currentPageSelect,Data.jiaZu.GuildListData);
					}
					break;
				default:
					break;
			}
			
			
		}
		
	}
	
	
	
}





