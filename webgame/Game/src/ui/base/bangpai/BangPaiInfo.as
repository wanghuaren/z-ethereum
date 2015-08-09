package ui.base.bangpai
{
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.*;
	import common.utils.CtrlFactory;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	public class BangPaiInfo extends UIWindow
	{
		
		private static var m_instance:BangPaiInfo;
		public static function get instance():BangPaiInfo
		{
			if (null == m_instance)
			{
				m_instance= new BangPaiInfo();
			}
			return m_instance;
		}
		
		public static var selectdItemData:StructGuildSimpleInfo2;
		
		public const AutoRefreshSecond:int = 30;
		private var _curAutoRefresh:int=0;
		private var _spContent:Sprite;
		protected function get spContent():Sprite
		{
			if(null == _spContent)
			{
				_spContent = new Sprite();
			}
			return _spContent;
		}
		
		public function BangPaiInfo()
		{
			blmBtn = 0;
			type = 0;
			super(getLink(WindowName.win_bang_pai_info));
		}
		
		
		
		override protected function init():void
		{
			
			mc['txtGuildName'].text  = '';
			mc['txtGuildLeader'].text= '';
			mc['txtGuildSort'].text  = '';
			mc['txtGuildLvl'].text  = '';
			mc['txtGuildMembers'].text = '';
			mc['txtGuildActive'].text = '';
			
			_regCk();
			_regPc();
			_regDs();
			
			this.getData();
		}
		
		private function _regCk():void
		{
			_curAutoRefresh = 0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShi);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,daoJiShi);
		}
		
		private function daoJiShi(e:WorldEvent):void
		{
			_curAutoRefresh++;
			if(_curAutoRefresh >=AutoRefreshSecond)
			{
				_curAutoRefresh=0;
				//你的代码
				this.getData();
			}
		}
		
		
		private function _regPc():void
		{
			uiRegister(PacketWCGuildInfo.id,SCGuildInfo);
		}	
		
		public function getData():void	
		{
			
			//
			//通过 guild ID 查询某个家族的信息
			//@param gid
			var _p:PacketCSGuildInfo=new PacketCSGuildInfo();
			_p.guildid=selectdItemData.guildid;
			uiSend(_p);

		}
		
		
		private var memberList:PacketWCGuildInfo2 = new PacketWCGuildInfo2();
		
		public function SCGuildInfo(p:PacketWCGuildInfo2):void
		{
			memberList = p;
			
						if(p.hasOwnProperty('tag'))
			{
				if(super.showResult(p)){
					
				}else{
					
				}
				
			}
			
			//
			this.refresh();
		}
		
		private function _regDs():void
		{
		}
		
		
		
		public function refresh():void
		{
			
			try{
				_refreshTf();
				_refreshMc();
				_refreshSp();
				_refreshRb();}
			catch(exd:Error){trace('BangPaiInfo:',exd.message);}
		}
		
		private function _refreshMc():void
		{
		}
		
		private function _refreshTf():void
		{
			if (null != selectdItemData)
			{
				mc['txtGuildName'].text  = selectdItemData.name;
				mc['txtGuildLeader'].text= selectdItemData.leader;
				mc['txtGuildSort'].text  = selectdItemData.sort;
				mc['txtGuildLvl'].text   = selectdItemData.level;
				mc['txtGuildMembers'].text = selectdItemData.members;
				//mc['txtGuildActive'].text  = selectdItemData.active;				
				mc['txtGuildActive'].text  = selectdItemData.money;
				
				mc['txtGuildDes'].text = memberList!=null?memberList.GuildDesc:"";
			}
		}
		
		private function _refreshSp():void
		{
			
				_clearSp();
				memberList.arrItemmemberlist.forEach(callbackMemberList);
				CtrlFactory.getUIShow().showList2(spContent, 1, 280, 20);
				this.mc['sp2'].source = spContent;
				this.mc['sp2'].position = 0;
				this.mc['sp2'].visible = true;
				var firstItem:DisplayObject = spContent.getChildByName('item'+(0 + 1).toString());
				this.itemSelected(firstItem);
				this.itemSelectedOther(firstItem);
			
			
		}
		
		private function _refreshRb():void
		{
		}
		
		private function callbackMemberList(itemData:StructGuildRequire2, index:int, itemDataList:Vector.<StructGuildRequire2>):void
		{
			var d:DisplayObject=ItemManager.instance().getitem_zu_yuan2(index+1);
			super.itemEvent(d as Sprite, itemData, true);
			d.name = 'item' + (index + 1);
			if(d.hasOwnProperty('bg')){d['bg'].mouseEnabled=false;}
			//文本
			
			d['txt1'].text = itemData.name;
			d['txt2'].text = XmlRes.GetGuildDutyName(itemData.job);
			d['txt3'].text = itemData.level
			d['txt4'].text = XmlRes.GetJobNameById(itemData.metier);
			//d['txt5'].text = itemData.faight;
			
			if(null != d['txt5'])
			{
				d['txt5'].text = '';
			}
			
			if(itemData.vip <= 0)
			{
				d['mc_vip'].visible = false;
				d['mc_vip'].gotoAndStop(1);
			}
			else
			{
				d['mc_vip'].visible = true;
				d['mc_vip'].gotoAndStop(itemData.vip);
			}
			
			
			spContent.addChild(d);
			//d[''].removeEventListener(MouseEvent.CLICK, btnXClick);
			//d[''].addEventListener(MouseEvent.CLICK, btnXClick);
			//悬浮信息
			//Lang.addTip(d,'yours_tip');
			//d.tipParam=[,]
		}	
		
		public function itemSelectedOther(targetItem:DisplayObject):void
		{
			
		}	
		
		private function _clearSp():void
		{
			while(spContent.numChildren > 0){
				spContent.removeChildAt(0);
			}
		}	
		
		public function viewSort(a:Object, b:Object):int
		{
			//战力
			//if (a.faight >= b.faight)
			//{
			//return -1;
			//}
			//if (a.faight < b.faight)
			//{
			//	return 1;
			//}
			//原样排序
			return 0;
		}
		
		
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var target_name:String=target.name;
			
			//元件点击
			switch (target_name)
			{
				default:
					break;
			}
		}
		
		override protected function windowClose():void
		{
			_clearSp();
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,daoJiShi);
			//_clearSp();
			super.windowClose();
		}
		
		
		override public function getID():int
		{
			return 0;
		}
		
	}
}