package ui.view.view4.yunying
{
	import common.config.PubData;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.Queue;
	import common.utils.Random;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.setTimeout;
	
	import model.baifu.BaiFuModel;
	import model.yunying.XunBaoEvent;
	import model.yunying.XunBaoModel;
	
	import netc.Data;
	import netc.dataset.*;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.vip.ChongZhi;
	import ui.frame.FlyIcon;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;
	
	import world.WorldEvent;
	
	/**
	 * 寻宝抽奖主面板
	 * @author steven guo
	 * 
	 */	
	public class XunBaoChouJiang extends UIWindow
	{
		private static var m_instance:XunBaoChouJiang = null;
		
		/**
		 * 
		 * 	展示奖励展示中，必然包含了真实奖励的展示。
		 * 
				装备类：该序列根据掉落生成装备奖励展示。
				极品类：该序列根据掉落生成极品奖励展示。
				珍宝类：该序列根据掉落生成珍宝类奖励展示。
		 */
		
		//装备类
		private var  ZHUANG_BEI_DROP_ID:int = 60101551;
		private var m_Zhuang_Bei_Items:Vector.<Pub_DropResModel> = null;
		
		//极品类
		private var JI_PIN_DROP_ID:int = 60101552;
		private var m_Ji_Pin_Items:Vector.<Pub_DropResModel> = null;
		
		//珍宝类
		private var ZHEN_BAO_DROP_ID:int = 60101553;
		private var m_Zhen_Bao_Items:Vector.<Pub_DropResModel> = null;
		
		
		private var m_model:XunBaoModel = null;
		
		
		public function XunBaoChouJiang()
		{
			super(getLink(WindowName.win_xun_bao));
			
			m_model = XunBaoModel.getInstance();
		}
		
		public static function getInstance():XunBaoChouJiang
		{
			if(null == m_instance)
			{
				m_instance = new XunBaoChouJiang();
			}
			
			return m_instance;
		}
		
		private var m_mcHeight:int = 0 ;
		
		//override
//		protected function getSelfHeight():Number
//		{
//			if(m_mcHeight <= 0)
//			{
//				return this.height;
//			}
//			return m_mcHeight;
//		}
		override public function get height():Number{
			return 510;
		}

		
		override protected function init():void
		{
			super.init();
			if(BaiFuModel.instance.isBaiFuBegin)//是否有百服活动
			{
				ZHUANG_BEI_DROP_ID = 60101561;
				JI_PIN_DROP_ID = 60101562;
				ZHEN_BAO_DROP_ID = 60101563;
			}else{
				ZHUANG_BEI_DROP_ID = 60101551;
				JI_PIN_DROP_ID = 60101552;
				ZHEN_BAO_DROP_ID = 60101553;
			}
			m_Zhuang_Bei_Items = XmlManager.localres.getDropXml.getResPath2(ZHUANG_BEI_DROP_ID) as Vector.<Pub_DropResModel>;
			m_Ji_Pin_Items = XmlManager.localres.getDropXml.getResPath2(JI_PIN_DROP_ID) as Vector.<Pub_DropResModel>;
			m_Zhen_Bao_Items = XmlManager.localres.getDropXml.getResPath2(ZHEN_BAO_DROP_ID) as Vector.<Pub_DropResModel>;
			
			m_model.addEventListener(XunBaoEvent.XUN_BAO_EVENT,_processEvent);
			m_model.requestCSDiscoveringTreasureInfo();
			
			if(null != mc["tf_LingQu_jiangli"])
			{
				sysAddEvent(mc["tf_LingQu_jiangli"], TextEvent.LINK, _textLinkListener);
			}
			
			
			
			super.sysAddEvent(Data.beiBao, BeiBaoSet.XUN_BAO_CHOU_JIANG_ADD, _onAddListener);
			super.sysAddEvent(Data.myKing, MyCharacterSet.COIN_UPDATE,_coinUpdateListener);
			
			super.sysAddEvent(Data.beiBao, BeiBaoSet.XUN_BAO_CHOU_JIANG, _onCangKuChange);
			super.sysAddEvent(Data.beiBao, BeiBaoSet.BAG_UPDATE, _onCangKuChange);
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_FIVE_SECOND,_onGameClock);
			
			
			mc['tf_geren'].height =mc['tf_geren'].textHeight +10;
			mc['sp_geren'].source = mc['tf_geren'];
			
			mc['tf_quanfu'].height =mc['tf_quanfu'].textHeight +10;
			mc['sp_quanfu'].source = mc['tf_quanfu'];
			
			Lang.addTip(mc['btnXunBaoTu'], "XunBaoTu_Tip",120);
			
			
			//_repaint();
			
			
		}
		
		private function _onGameClock(event:WorldEvent):void
		{
			
			m_model.requestCSDiscoveringTreasureLog(5);
		}
		
		
		private function _onCangKuChange(ds:DispatchEvent=null):void
		{
			
			setTimeout(_TimeOut_CangKuChange,1000);
		}
		
		private function _TimeOut_CangKuChange():void
		{
			//仓库容量
			mc['tf_cangku_rongliang'].text = Data.beiBao.getXunBaoChangKuNum() +'/200';
			
		}
		
		private function _coinUpdateListener(ds:DispatchEvent=null):void
		{
			mc['tf_YB'].text = Data.myKing.coin3;
		}
		
		private var m_flyIcons:Array = null;
		private var m_flyIndex:int = 0;
		private var m_flyIndexMax:int = 10;
		private function _onAddListener(ds:DispatchEvent=null):void
		{

			if(null == m_flyIcons)
			{
				m_flyIcons = [];
				for(var i:int = 0 ; i < m_flyIndexMax ; ++i)
				{
					m_flyIcons[i] = new FlyIcon();
				}
			}
			
			var _item:StructBagCell2 = ds.getInfo as StructBagCell2;
			var _icon:FlyIcon = m_flyIcons[m_flyIndex];
			this.addChild(_icon);
			
			var _sx:int = mc['jp_pic_0'].x;
			var _sy:int = mc['jp_pic_0'].y;
			var _ex:int = ( mc['btnChangKu'].width >> 1) +  mc['btnChangKu'].x;
			var _ey:int = mc['btnChangKu'].y;
			
			_icon.setPath(_sx,_sy,_ex ,_ey);
			_icon.setIconURL(_item.icon);
			_icon.doFly();
			
			++m_flyIndex;
			if(m_flyIndex >= m_flyIndexMax)
			{
				m_flyIndex = 0;
			}
			
//			m_PersonInfo.add(_item);
//			
//			_repaintPersonInfo();
			
			mc['tf_cangku_rongliang'].text = Data.beiBao.getXunBaoChangKuNum() +'/200';            
			
			mc['mcEffect'].gotoAndPlay(2);
		}

		
		private function _processEvent(e:XunBaoEvent):void
		{
			var _sort:int = e.sort;
			
			switch(_sort)
			{
				case XunBaoEvent.DEFAULT_EVENT_SORT:
					_repaint();
					_repaintLucky();
					break;
				case XunBaoEvent.ALL_INFO_EVENT_SORT:
					_repaintAllInfo();
					_repaintLucky();
					break;
				case XunBaoEvent.HERO_INFO_EVENT_SORT:
					_repaintPersonInfo();
					break;
				default:
					break;
			}
			
			
		}
		
		private function _inList(list:Vector.<Pub_DropResModel>,itemID:int):Boolean
		{
			var _length:int = list.length;
			var _item:Pub_DropResModel = null;
			for(var i:int = 0 ; i < _length ; ++i)
			{
				_item = list[i];
				if(itemID == _item.drop_item_id)
				{
					return true;
				}
			}
			
			return false;
			
		}
		
		
//		private var m_seed:int = 0 ;
		/**
		 * 随机生成奖励物品列表 
		 * 
		 */		
		private function randomItems():void
		{
//			if( m_model.getSeed() == m_seed)
//			{
//			//	return ;
//			}
			
//			m_seed = m_model.getSeed();
			
			
			
			//这个值确定放入到那个分类中
			var _random3:int = 0;//Math.round( Math.random() * (3 - 1) );
//			var _discoveringItemID:int = m_model.getDiscoveringItemID();
//			if(_inList(m_Zhuang_Bei_Items,_discoveringItemID))
//			{
//				_random3 = 0;
//			}
//			else if(_inList(m_Ji_Pin_Items,_discoveringItemID))
//			{
//				_random3 = 1;
//			}
//			else if(_inList(m_Zhen_Bao_Items,_discoveringItemID))
//			{
//				_random3 = 2;
//			}
			
			//真实物品的位置 1~3对应界面上的3块位置
			var _discoveringItemPos:int = m_model.getDiscoveringItemPos();
			_random3 = _discoveringItemPos - 1;
			if(_random3 <0)
			{
				_random3 = 0;	
			}
			else if(_random3 > 2)
			{
				_random3 = 2;
			}
			
			
			//'洗牌'  不再随机了  2014年2月13日 14:24:54
		//	m_Zhuang_Bei_Items = _randomArray(m_Zhuang_Bei_Items);
		//	m_Ji_Pin_Items = _randomArray(m_Ji_Pin_Items);
			//m_Zhen_Bao_Items = _randomArray(m_Zhen_Bao_Items);
			
			
			
			var _random12:int = Math.round( Math.random() * (12 - 1) );
			var _drop_item_id:int = 0;
			
			
			var i:int = 0;
			var _Cell:StructBagCell2 = null;
			var _pic:String = null;
			
			for(i = 0; i < 12; ++i)
			{
				_Cell = new StructBagCell2();
				if(i>=m_Zhuang_Bei_Items.length)break;
					_Cell.itemid = m_Zhuang_Bei_Items[i].drop_item_id;
					_Cell.num = m_Zhuang_Bei_Items[i].drop_num;
//				}
//				else
//				{
//					_Cell.itemid = m_model.getDiscoveringItemID();
//					_Cell.num = m_model.getDiscoveringItemNum();
//				}
				Data.beiBao.fillCahceData(_Cell);
				_pic = 'zb_pic_'+i;
				mc[_pic]['txt_num'].text = StringUtils.changeToTenThousand(_Cell.num);
//				mc[_pic]['uil'].source=_Cell.icon;  
				ImageUtils.replaceImage(mc[_pic],mc[_pic]["uil"],_Cell.icon);
				mc[_pic]["data"]=_Cell;
				CtrlFactory.getUIShow().addTip(mc[_pic]);      
				ItemManager.instance().setEquipFace(mc[_pic],true);   
			}
			
			for(i = 0; i < 1; ++i)
			{
				_Cell = new StructBagCell2();
				
				if(1 != _random3 )
				{
					_Cell.itemid = m_Ji_Pin_Items[i].drop_item_id;
					_Cell.num = m_Ji_Pin_Items[i].drop_num;
				}
				else
				{
					_Cell.itemid = m_model.getDiscoveringItemID();
					_Cell.num = m_model.getDiscoveringItemNum();
				}
				
				Data.beiBao.fillCahceData(_Cell);
				_pic = 'jp_pic_'+i;
				mc[_pic]['txt_num'].text = StringUtils.changeToTenThousand(_Cell.num);
				ItemManager.instance().setToolTipByData(mc[_pic],_Cell,i==0?2:1);
			}
			
			for(i = 0; i < 12; ++i)
			{
				_Cell = new StructBagCell2();
				if(i>=m_Zhen_Bao_Items.length)break;
				if(2 != _random3 || _random12 != i)
				{
					_Cell.itemid = m_Zhen_Bao_Items[i].drop_item_id;
					_Cell.num = m_Zhen_Bao_Items[i].drop_num;
				}
				else
				{
					_Cell.itemid = m_model.getDiscoveringItemID();
					_Cell.num = m_model.getDiscoveringItemNum();
				}
			
				Data.beiBao.fillCahceData(_Cell);
				_pic = 'zhen_pic_'+i;
				mc[_pic]['txt_num'].text = StringUtils.changeToTenThousand(_Cell.num );
//				mc[_pic]['uil'].source=_Cell.icon;  
				ImageUtils.replaceImage(mc[_pic],mc[_pic]["uil"],_Cell.icon);
				mc[_pic]["data"]=_Cell;
				CtrlFactory.getUIShow().addTip(mc[_pic]);      
				ItemManager.instance().setEquipFace(mc[_pic],true);
				
			}
			
		}
		
		private function _repaintAllInfo():void
		{
			var _allInfo:Array =  m_model.getAllInfo();
			var _allInfoString:String = '';
			var _data:StructGetItemLog2 = null;
			var _toolItem:Pub_ToolsResModel= null;//GameData.getToolsXml().getResPath(bag.itemid);
			var _toolName:String = '';
			m_list2 = _allInfo;
			for(var i:int = 0 ; i < _allInfo.length; ++i)
			{
				_data = _allInfo[i] as StructGetItemLog2;
								
				_toolItem = XmlManager.localres.ToolsXml.getResPath(_data.ItemId) as Pub_ToolsResModel;
				
				_allInfoString += Lang.getLabel('40089_XunBaoChouJiang',[_data.PlayerName,
					_data.ItemNum,'#'+ResCtrl.instance().arrColor[_toolItem.tool_color],i,_toolItem.tool_name]) +'\n';
			}
			mc['tf_quanfu'].addEventListener(TextEvent.LINK,_onXunBao2TextLink);    
			mc['tf_quanfu'].htmlText = _allInfoString;
			mc['tf_quanfu'].height =mc['tf_quanfu'].textHeight +10;
			mc['sp_quanfu'].source = mc['tf_quanfu'];
			
			mc['sp_quanfu'].position = 100;
		}
		private var m_list2:Array;
		private function _onXunBao2TextLink(e:TextEvent):void
		{
			var pos:int = int(e.text);
			var obj:StructGetItemLog2 = m_list2[pos] as StructGetItemLog2;
			if(obj==null)return;
			var bag:StructBagCell2=new StructBagCell2();
			bag.itemid=obj.ItemId;
			Data.beiBao.fillCahceData(bag);
			//			sbc.arrItemattrs=data[0].arrItemequipattrs;
			//			sbc.equip_strongLevel=data[0].strongLevel;
			//			sbc.equip_usedCount=1;
			//			sbc.equip_fightValue=data[0].fightValue;
			//			sbc.arrItemevilGrains=data[0].arrItemevilGrains;
			//			sbc.colorLvl=data[0].colorLvl;
			//			sbc.identify=data[0].identify;
			var sprite:Sprite=ResCtrl.instance().getNewDesc(bag);
			var tip:Sprite=new Sprite;
			tip.name="tip_tool";
			tip.addChild(sprite);
			tip.addEventListener(MouseEvent.MOUSE_OUT, outMcHandler);
			PubData.mainUI.cartoon.addChild(tip);
			tip.x=this.x + mouseX - 6;
			tip.y=this.y + mouseY - sprite.height + 10;
			tip.mouseChildren=false;
		}
		//幸运奖励
		private function _repaintLucky():void
		{
			var _Cell:StructBagCell2 = null;
			_Cell = new StructBagCell2();
			_Cell.itemid = m_model.getLuckyItemID();
			_Cell.num = m_model.getLuckyItemNum();
			
			Data.beiBao.fillCahceData(_Cell);
			var _pic:String = null;
			_pic = 'jiangli_pic';
			mc[_pic]['txt_num'].text = StringUtils.changeToTenThousand(_Cell.num );
//			mc[_pic]['uil'].source=_Cell.icon;  
			ImageUtils.replaceImage(mc[_pic],mc[_pic]["uil"],_Cell.icon);
			mc[_pic]["data"]=_Cell;
			CtrlFactory.getUIShow().addTip(mc[_pic]);      
			ItemManager.instance().setEquipFace(mc[_pic],true);
			mc["tf_XunBaoJiFen"].text = String(m_model.getGrade());
			var _luckyLevel:int = m_model.getLuckyLevel();
			//全部领取完毕
			if(_luckyLevel >= 6)
			{
				mc[_pic].visible = false;
				//mc['tf_LingQu_jiangli'].visible = true;
				
				mc['btnLingQu'].visible = false;
				
				//mc['tf_LingQu_jiangli'].htmlText = Lang.getLabel("40089_XunBaoChouJiang_4");
			}
			else
			{
				mc[_pic].visible = true;
				
				
				if(null != mc['tf_LingQu_jiangli']){
					mc['tf_LingQu_jiangli'].visible = true;
				}
				//可以领取
				if(m_model.getLuckyFlag() == 1)
				{
//					if(null != mc['tf_LingQu_jiangli']){
//					mc['tf_LingQu_jiangli'].htmlText = Lang.getLabel("40089_XunBaoChouJiang_2");
//					}
					
					mc['btnLingQu'].visible = true;
				}
				//不可以领取
				else
				{
//					if(null != mc['tf_LingQu_jiangli']){
//					mc['tf_LingQu_jiangli'].htmlText = Lang.getLabel("40089_XunBaoChouJiang_3",[_luckyLevel]);
//					}
					
					mc['btnLingQu'].visible = false;
				}
			}
			
			
			var _num:int = Math.round( ( m_model.getlucky() / 10000) * 100 );
			
			if(_num <0 )
			{
				_num = 0;
			}
			else if(_num >100)
			{
				_num = 100;
			}
			
			mc['mcBar'].gotoAndStop(_num );
			mc['tf_Bar'].text = m_model.getlucky() +'/'+ 10000;
			
			
		}
		
		//个人寻宝信息
		private var m_PersonInfo:Queue = new Queue(50);
		private var m_list:Array;
		private function _repaintPersonInfo():void
		{
			var _item:StructHeroGetItemLog2 = null;
			//var _list:Array = m_PersonInfo.getList();
			var _list:Array = m_model.getHeroInfo();
			var _length:int = _list.length;
			var _stringInfo:String = '';
			var _toolItem:Pub_ToolsResModel= null;
			var _toolName:String = '';
			m_list = _list;
			for(var i:int = 0 ; i < _length; ++i)
			{
				_item = _list[i] as StructHeroGetItemLog2;
				//40089_XunBaoChouJiang_1
//				if(_item.addCount <= 0)
//				{
//					_stringInfo += Lang.getLabel('40089_XunBaoChouJiang_1',[_item.num,
//						'#'+ResCtrl.instance().arrColor[_item.toolColor-1],_item.itemname])+'\n';
//				}
//				else
//				{
//					_stringInfo += Lang.getLabel('40089_XunBaoChouJiang_1',[_item.addCount,
//						'#'+ResCtrl.instance().arrColor[_item.toolColor-1],_item.itemname])+'\n';
//				}
				
				_toolItem = XmlManager.localres.ToolsXml.getResPath(_item.ItemId) as Pub_ToolsResModel;
				//获得#param个<font color="#param">#param</font>
					_stringInfo += Lang.getLabel('40089_XunBaoChouJiang_1_1',[
						_item.ItemNum,'#'+ResCtrl.instance().arrColor[_toolItem.tool_color],i,_toolItem.tool_name]) +'\n';
				
			}
			mc['tf_geren'].addEventListener(TextEvent.LINK,_onXunBaoTextLink);    
			mc['tf_geren'].htmlText = _stringInfo;
			mc['tf_geren'].height =mc['tf_geren'].textHeight +10;
			mc['sp_geren'].source = mc['tf_geren'];
			mc['sp_geren'].position = 100;
		}

		private function _onXunBaoTextLink(e:TextEvent):void
		{
			var pos:int = int(e.text);
			var obj:StructHeroGetItemLog2 = m_list[pos] as StructHeroGetItemLog2;
			var bag:StructBagCell2=new StructBagCell2();
			bag.itemid=obj.ItemId;
			Data.beiBao.fillCahceData(bag);
//			sbc.arrItemattrs=data[0].arrItemequipattrs;
//			sbc.equip_strongLevel=data[0].strongLevel;
//			sbc.equip_usedCount=1;
//			sbc.equip_fightValue=data[0].fightValue;
//			sbc.arrItemevilGrains=data[0].arrItemevilGrains;
//			sbc.colorLvl=data[0].colorLvl;
//			sbc.identify=data[0].identify;
			var sprite:Sprite=ResCtrl.instance().getNewDesc(bag);
			var tip:Sprite=new Sprite;
			tip.name="tip_tool";
			tip.addChild(sprite);
			tip.addEventListener(MouseEvent.MOUSE_OUT, outMcHandler);
			PubData.mainUI.cartoon.addChild(tip);
			tip.x=this.x + mouseX - 6;
			tip.y=this.y + mouseY - sprite.height + 10;
			tip.mouseChildren=false;
		}
		private function outMcHandler(e:MouseEvent):void
		{
			if (e.target.name == "tip_tool")
			{
				//道具悬浮
				e.target.parent.removeChild(e.target as DisplayObject);
				e.target.removeEventListener(MouseEvent.MOUSE_OUT, outMcHandler);
			}
		}
		private function _repaint():void  
		{
			//随机生成奖励物品
			randomItems();
			
			mc['tf_YB'].text = Data.myKing.coin3;
			
			//仓库容量
			mc['tf_cangku_rongliang'].text = Data.beiBao.getXunBaoChangKuNum() +'/200';
		}
		
		override public function winClose():void
		{
			super.winClose();
			m_model.removeEventListener(XunBaoEvent.XUN_BAO_EVENT,_processEvent);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_FIVE_SECOND,_onGameClock);
			
		}
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			
			var _msg:String = '';
			
			switch(name)
			{
				case 'btnXunBao_1':
					m_model.requestCSDiscoveringTreasure(1);
					break;
				case 'btnXunBao_10':
					NEED_TIME += 1;
					m_model.requestCSDiscoveringTreasure(2);
					GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onChouJiangClockSecond);
					StringUtils.setUnEnable(XunBaoChangKu.getInstance().mc["btnQuanBuQuChu"]);
					break;
				case 'btnXunBao_50':
					NEED_TIME += 2;
					GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onChouJiangClockSecond);
					StringUtils.setUnEnable(XunBaoChangKu.getInstance().mc["btnQuanBuQuChu"]);
					m_model.requestCSDiscoveringTreasure(3);
					break;
				case 'btnLingQu_jiangli':
					m_model.requestCSDrawLuckyItem();
					break;
				case 'btnChangKu':
					XunBaoChangKu.getInstance().open();
					break;
				case "btnChongZhi":
					//YellowChongZhi.getInstance().open();
					ChongZhi.getInstance().open();
					break;
				case "btnLingQu":
					m_model.requestCSDrawLuckyItem();
					break;
				case "btnDaoJu":
					GameAutoPath.seek(30100060);
//					MissionMain.instance.findPahtByTaskID(30100060);//宝藏使者
					break;
				default:
					break;
			}
			
		}
		public var NEED_TIME:int = 2;
		private function _onChouJiangClockSecond(e:WorldEvent):void
		{
			if(NEED_TIME <= 0)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onChouJiangClockSecond);
				StringUtils.setEnable(XunBaoChangKu.getInstance().mc["btnQuanBuQuChu"]);
				NEED_TIME  = 2;
			}
			NEED_TIME = NEED_TIME - 1;
		}
		/**
		 * 数组“洗牌”程序 
		 * @param source
		 * @return 
		 * 
		 */		
		private function _randomArray(source:Vector.<Pub_DropResModel>):Vector.<Pub_DropResModel>
		{
			if(null == source || source.length <= 0)
			{
				return source;
			}
			
			var _randomIndex:int = 0 ; 
			var _length:int = source.length;
			var _t0:* = null;
			var _t1:* = null;
			var _Random:Random =new Random( m_model.getSeed() );

			var _randomNum:Number = 0;
			
			for(var i:int = 0; i < _length ; ++i)
			{
				_t0 = source[i];
				if(null == _Random)
				{
					_randomIndex = Math.round( Math.random() * (_length - 1) );
				}
				else
				{
					_randomNum = _Random.getNext();
					_randomIndex = Math.round( _randomNum * (_length - 1) );

				}
				_t1 = source[_randomIndex];
				
				source[i] = _t1;
				source[_randomIndex] = _t0;
			}
			
			return source;
		}

		private function _textLinkListener(e:TextEvent):void
		{
			switch (e.text)
			{
				case "0@click":   //领取
					m_model.requestCSDrawLuckyItem();
					break;
				default:
					break;
			}
		}
		override public function getID():int
		{
			return 1085;
		}
		
		
	}
}



