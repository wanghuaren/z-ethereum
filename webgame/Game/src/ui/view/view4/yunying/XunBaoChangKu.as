package ui.view.view4.yunying
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.drag.MainDrag;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import model.yunying.XunBaoModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.beibao.BeiBao;
	import ui.base.beibao.Store;
	import ui.base.npc.NpcShop;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;
	
	
	/**
	 * 寻宝仓库
	 * @author steven guo
	 * 
	 */	
	public class XunBaoChangKu extends UIWindow
	{
		private static var m_instance:XunBaoChangKu = null;
		
		private var m_model:XunBaoModel = null;
		
		public function XunBaoChangKu()
		{
			blmBtn = 2;
			super(getLink(WindowName.win_xunbao_cangku));
			doubleClickEnabled = true;
			m_model = XunBaoModel.getInstance();
		}
		
		public static function getInstance():XunBaoChangKu
		{
			if(null == m_instance)
			{
				m_instance = new XunBaoChangKu();
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			mcHandler({name: "cbtn1"});
			
			super.sysAddEvent(Data.beiBao, BeiBaoSet.XUN_BAO_CHOU_JIANG, showPackage);
			
			super.sysAddEvent(Data.beiBao, BeiBaoSet.BAG_UPDATE, showPackage);
			super.sysAddEvent(PubData.mainUI.stage, MainDrag.DRAG_UP, dragUpHandler);
		}
		
		/**
		 *	背包物品拖拽弹起事件
		 */
		private function dragUpHandler(e:DispatchEvent):void
		{
			var start:Object=MainDrag.currTarget;
			var startData:StructBagCell2=start.data;
			var end:Object=e.getInfo;
			
			if (start != null && start.parent == mc)
			{
//				if(end.parent == mc)
//				{

//				}
				//仓库内交换位置
				if (end.parent == mc && end.name.indexOf("item_") == 0)
				{

					if (start.data == null)
						return;
					var _loc1:int=startData.pos;
					var _loc2:int=(m_selectIndex - 1) * 100 + int(end.name.replace("item_", "")) + BeiBaoSet.XUN_BAO_INDEX;
					if (_loc1 == _loc2)
					{
						return;
					}
					var p:PacketCSMoveItem=new PacketCSMoveItem();
					p.srcindex=_loc1;
					p.destindex=_loc2;
					uiSend(p);
					CtrlFactory.getUIShow().closeCurrentTip(); 
					return;
					
				}
				else if(CtrlFactory.getUICtrl().checkParent(end, WindowName.win_bao_guo))
				{

					if (start.data == null)
						return;
					var _loc1:int=startData.pos;
					var _loc2:int=(BeiBao.getInstance().type - 1) * 36 + int(end.name.replace("item", ""));
					if (_loc1 == _loc2)
					{
						return;
					}
					var p:PacketCSMoveItem=new PacketCSMoveItem();
					p.srcindex=_loc1;
					p.destindex=_loc2;
					uiSend(p);
					CtrlFactory.getUIShow().closeCurrentTip(); 
					return;
				}
				else if(CtrlFactory.getUICtrl().checkParent(end, WindowName.win_cang_ku))
				{

					var i:int=int(end.name.replace("item", ""));
					if (i == 0)
						return;
					
					var cangku_pos:int=i + BeiBaoSet.STORE_PAGE_CELL_COUNT * (Store.getInstance().type - 1);
					
					cangku_pos=cangku_pos + (BeiBaoSet.CANGKU_INDEX - 1);
					
					storeOnByDrag(startData.pos, cangku_pos);
				}
			}
		}
		
		/**
		 *	存东西到仓库
		 */
		private function storeOnByDrag(pos:int, cangku_pos:int):void
		{
			var p:PacketCSMoveItem=new PacketCSMoveItem();
			p.srcindex=pos;
			p.destindex=cangku_pos;
			uiSend(p);
			
			
		}
		
		override protected function mcDoubleClickHandler(target:Object):void
		{
			
			
			var name:String=target.name;
			if(name.indexOf("item_")>=0)
			{
				if(!BeiBao.getInstance().isOpen)
				{
					BeiBao.getInstance().open(true);
					return ;
				}
				
				
				var bag:StructBagCell2=target.data as StructBagCell2;
				if(bag==null)
				{
					return;
				}
				
				//var vacanciPos:int = DataCenter.beiBao.getBeiBaoVacanciPos(BeiBao.type);
				var vacanciPos:int = Data.beiBao.getBeiBaoFirstEmpty(BeiBao.getInstance().type);		
				
				
				if(-1 == vacanciPos)
				{
					//背包当前页满
					
					for(var j:int =1;j<=3;j++)
					{
						vacanciPos = Data.beiBao.getBeiBaoFirstEmpty(j);
						if(-1 != vacanciPos)
						{
							break;
						}
						
					}
				}
				beibaoOn(bag.pos,vacanciPos);
			}
			
			
		}
		
		/**
		 *	存东西到背包
		 */
		private function beibaoOn(pos:int,beibao_pos:int):void
		{
			if(BeiBao.getInstance().type==4)
			{
				return;
			}
			
			//增加判断
			if(beibao_pos==-1){
				
				if(Data.myKing.BagSize<BeiBaoSet.BEIBAO_END_INDEX){
					//有位置需要扩充
					BeiBao.getInstance().mcHandler({name:"btnShengJi"});
				}else{
					//满
					Lang.showMsg(Lang.getClientMsg("10024_bao_guo"));
				}
				return;
			}
			
			
			var p:PacketCSMoveItem=new PacketCSMoveItem();
			p.srcindex=pos;
			p.destindex=beibao_pos;
			uiSend(p);
		}
		
		private var m_selectIndex:int = 1;
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			switch (target.name)
			{
				case "cbtn1":
					
					m_selectIndex = 1;
					_repaint();
					break;
				case "cbtn2":
					m_selectIndex = 2;
					_repaint();
					break;
				case "btnZhengLi":
					m_model.requestCSTrimActBank();
					break;
				case "btnQuanBuQuChu":
					m_model.requestCSActBankTakeAll();
					break;
				default:
					break;
			}
			
			
		}
		
		private function showPackage(ds:DispatchEvent=null):void
		{
			mcHandler({name: "cbtn" + m_selectIndex});
		}
		
		private function _repaint():void
		{
			var _data:Array = Data.beiBao.getXunbao_changku();
			
			//TODO  用于测试
			//var _data:Array = Data.beiBao.getBeiBaoData();
			
			if(null == _data)
			{
				return ;
			}
			
			var _startIndex:int = (m_selectIndex - 1) * 100;
			var _endIndex:int = m_selectIndex * 100;
			var _picName:String = null;
			var _Cell:StructBagCell2 = null;
			
			var i:int = 0;
			for(i = 0; i  <  100; ++i)
			{
				_picName = 'item_'+i;
				mc[_picName].mouseChildren = false;
			
				
				_Cell = _data[(_startIndex + i)] as StructBagCell2;
				if(null != _Cell)
				{
					Data.beiBao.fillCahceData(_Cell );
					
					mc[_picName]['txt_num'].text = StringUtils.changeToTenThousand(_Cell.num);
//					mc[_picName]['uil'].source=_Cell.icon;  
					ImageUtils.replaceImage(mc[_picName],mc[_picName]["uil"],_Cell.icon);
					mc[_picName]["data"]=_Cell;
					CtrlFactory.getUIShow().addTip(mc[_picName]);      
					ItemManager.instance().setEquipFace(mc[_picName],true);
					MainDrag.getInstance().regDrag(mc[_picName]);
					
					mc[_picName].mouseChildren = false;
				}
				else
				{
					ItemManager.instance().setEquipFace(mc[_picName],false);
					ItemManager.instance().removeToolTip(mc[_picName]);
				}
			}
			
		}
		
		
		override public function getID():int
		{
			return 1086;
		}
		
		
	}
	
	
}

