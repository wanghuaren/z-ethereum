package ui.base.bangpai
{
	import common.config.xmlres.server.*;
	import common.utils.clock.GameClock;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import flash.display.Sprite;
	
	import model.qq.YellowDiamond;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;

	public class BangPaiList extends UIWindow
	{

		private static var m_instance:BangPaiList;

		public static function get instance():BangPaiList
		{
			if (null == m_instance)
			{
				m_instance=new BangPaiList();
			}
			return m_instance;
		}

		/**
		 * 每页显示的最大条目
		 */
		private static const MAX_PAGE_NUM:int=10;
		private var m_currentPage:int=1;

		public const AutoRefreshSecond:int=30;
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

		public function BangPaiList()
		{
			blmBtn=0;
			type=0;
			super(getLink(WindowName.win_bang_pai_list));
		}



		override protected function init():void
		{
			m_currentPage=1;

			var j:int;
			var jLen:int=MAX_PAGE_NUM;
			for (j=1; j <= jLen; j++)
			{
				mc["item" + j.toString()].visible=false;
			}

			mc["mc_page"].visible=false;

			//
			_regCk();
			_regPc();
			_regDs();

			//
			this.getData();
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


		private function _regPc():void
		{

			uiRegister(PacketWCGuildList.id, SCGuildList);
			uiRegister(PacketWCGuildReq.id, SCGuildReq);

		}

		public function getData():void
		{
			//请求家族列表信息 ,或者查看家族排行榜 
			//@param type  1:家族申请界面2.家族排行榜			 
			var _p:PacketCSGuildList=new PacketCSGuildList();
			_p.type=1;
			uiSend(_p);

		}



		private function _regDs():void
		{


			this.sysAddEvent(Data.myKing, MyCharacterSet.GUILD_UPD, _onMe_guild_upd);
			this.sysAddEvent(Data.myKing, MyCharacterSet.GUILD_NAME_UPD, _onMe_guild_upd);
			this.sysAddEvent(Data.myKing, MyCharacterSet.GUILD_DUTY_UPD, _onMe_guild_upd);


			this.sysAddEvent(mc["mc_page"], MoreLessPage.PAGE_CHANGE, mc_page_change);

		}

		private function mc_page_change(e:DispatchEvent=null):void
		{
			this.m_currentPage=e.getInfo.count;

			_refreshSp();
		}

		public function refresh():void
		{


			try
			{
				_refreshTf();
				_refreshMc();
				_refreshSp();
				_refreshRb();
			}
			catch (exd:Error)
			{
				trace('BangPaiList:', exd.message);
			}
		}

		private function _refreshMc():void
		{
			//
			var listLen:int=this.guildList.arrItemguildlist.length;

			var j:int;
			var jLen:int=MAX_PAGE_NUM;

			//
			var _totalNum:int=Math.ceil(listLen / MAX_PAGE_NUM);

			if (0 == _totalNum)
			{
				m_currentPage=0;
			}

			if (m_currentPage > _totalNum)
			{
				m_currentPage=_totalNum;
			}

			mc["mc_page"].setMaxPage(m_currentPage, _totalNum);

			mc["mc_page"].visible=true;



		}

		private function _refreshTf():void
		{
		}


		/**
		 * 对数组进行分页，返回数组
		 *
		 * 参数1：全部的数据
		 *    2：当前页数
		 *    3：每页显示的行数
		 */
		public static function pageing(list:Vector.<StructGuildSimpleInfo2>, curPage:int, lineNum:int):Vector.<StructGuildSimpleInfo2>
		{

			var totalNum:int=Math.ceil(list.length / lineNum);

			if (curPage <= 0)
			{
				curPage=1;
			}

			var start:int=lineNum * (curPage - 1);

			//
			var end:int=start + lineNum;

			if (end > list.length)
			{
				end=list.length;
			}

			//
			var arr:Vector.<StructGuildSimpleInfo2>=new Vector.<StructGuildSimpleInfo2>();
			var j:int;
			for (j=start; j < end; j++)
			{
				arr.push(list[j]);

			}

			return arr;


		}

		private function _refreshSp():void
		{
			//
			var j:int;
			var jLen:int=MAX_PAGE_NUM;


			//
			//			
			var list:Vector.<StructGuildSimpleInfo2>=pageing(this.guildList.arrItemguildlist, m_currentPage, MAX_PAGE_NUM);

			//
			for (j=1; j <= jLen; j++)
			{

				if (list.length >= j)
				{
					mc["item" + j.toString()].visible=true;

					//mc['item' + j.toString()]['txt_pai_ming'].text=list[j - 1].sort;
					mc['item' + j.toString()]['txt_ming_cheng'].text=list[j - 1].name;
					mc['item' + j.toString()]['txt_zu_zhang'].text=list[j - 1].leader;
					mc['item' + j.toString()]['txt_deng_ji'].text=list[j - 1].level;
					mc['item' + j.toString()]['txt_ren_shuo'].text=list[j - 1].members;

					//
					//mc['item' + j.toString()]['txt_z_zhan_li'].text=list[j - 1].faight;

					//族长VIP等级
//					if (list[j - 1].vip <= 0)
//					{
//						mc['item' + j.toString()]['mc_vip'].visible=false;
//
//					}
//					else
//					{
//						mc['item' + j.toString()]['mc_vip'].visible=true;
//						mc['item' + j.toString()]['mc_vip'].gotoAndStop(list[j - 1].vip);
//					}
					
					//mcQQYellowDiamond
					YellowDiamond.getInstance().handleYellowDiamondMC2(mc['item' + j.toString()]['mcQQYellowDiamond'], list[j - 1].qqyellowvip);

					//未申请
					if (0 == list[j - 1].state)
					{
						mc['item' + j.toString()]['mc_shen_qing'].gotoAndStop(1);
					}
					else
					{
						mc['item' + j.toString()]['mc_shen_qing'].gotoAndStop(2);
					}
					mc['item' + j.toString()].data=list[j - 1];

				}
				else
				{
					mc["item" + j.toString()].visible=false;

					//mc['item' + j.toString()]['txt_pai_ming'].text='';
					mc['item' + j.toString()]['txt_ming_cheng'].text='';
					mc['item' + j.toString()]['txt_zu_zhang'].text='';
					mc['item' + j.toString()]['txt_deng_ji'].text='';
					mc['item' + j.toString()]['txt_ren_shuo'].text='';

					//
					//mc['item' + j.toString()]['txt_z_zhan_li'].text='';

					mc['item' + j.toString()]['mc_vip'].visible=false;
					mc['item' + j.toString()]['mc_vip'].gotoAndStop(1);
					//
					mc['item' + j.toString()]['mc_shen_qing'].gotoAndStop(1);

					mc['item' + j.toString()].data=null;
				}



			}
		}

		private function _refreshRb():void
		{
		}

		private var guildList:PacketWCGuildList2=new PacketWCGuildList2();

		public function SCGuildList(p:PacketWCGuildList2):void
		{
			//
			guildList=p;

						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{

				}
				else
				{

				}

			}

			//
			this.refresh();
		}

		public function SCGuildReq(p:PacketWCGuildReq2):void
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

		private function _onMe_guild_upd(e:DispatchEvent):void
		{
			winClose();

			if (Data.myKing.Guild.GuildId > 0)
			{
				BangPaiMain.instance.open();
			}

		}

		//public static var shen_qing_ing:HashMap = new HashMap();
		//public static var curGuildReqGuildId:int = 0;
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;

			//元件点击
			switch (target_name)
			{
				case "mc_shen_qing_f1":

					if (null != target.parent.parent.data)
					{
						// 申请加入家族
						var _p:PacketCSGuildReq=new PacketCSGuildReq();
						_p.guildid=(target.parent.parent.data as StructGuildSimpleInfo2).guildid;
						uiSend(_p);
					}

					break;
				case "btn_cha_kan":

					if (null != target.parent.data)
					{
						BangPaiInfo.selectdItemData=(target.parent.data as StructGuildSimpleInfo2);

						BangPaiInfo.instance.open();
					}

					break;

				case 'btn_chuang_jian':
										BangPaiCreate.instance.open()
					break;

				case 'btn_cha_kan':
										BangPaiInfo.selectdItemData=target.parent.data;
					BangPaiInfo.instance.open()
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
