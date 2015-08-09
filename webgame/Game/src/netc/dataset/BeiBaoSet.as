package netc.dataset
{
	import com.engine.utils.HashMap;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.lib.TablesLib;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import engine.event.DispatchEvent;
	import engine.net.dataset.VirtualSet;
	import engine.support.IPacket;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.beibao.BeiBao;
	import ui.base.jineng.Jineng;
	import ui.frame.RightDownTip;
	import ui.frame.RightDownTipManager;
	import ui.frame.RightDownTipZB;
	import ui.view.jingjie.JingJie2Win;
	import ui.view.view2.liandanlu.LianDanLu;
	
	import world.FileManager;
	import world.WorldEvent;

	/**
	 *  位置编号
	 *	背包数据 1-108
	 *  任务数据 109－144
	 *  仓库数据 145- 288
	 *  装备数据 289－302 
	 */
	public class BeiBaoSet extends VirtualSet
	{
		private var _beiBaoData:Array=null;
		private var _cangKuData:Array=null;
		private var _zhuangBeiData:Array=null;
		public var stoneData:PacketSCGetGemInfo2=null;
		//寻宝仓库
		private var m_xunbao_changku:Array = null;
		
		//最大格数
		public static const BEIBAO_MAX:int=56;
		public static const CANGKU_MAX:int=144;
		public static const ZHUANGBEI_MAX:int=15;
		public static const XUNBAO_MAX:int=200;
		//起始位置
		public static const BEIBAO_INDEX:int=1;
		public static const BEIBAO_END_INDEX:int=BEIBAO_INDEX+BEIBAO_MAX-1;
		public static const CANGKU_INDEX:int=BEIBAO_END_INDEX+1;
		public static const CANGKU_END_INDEX:int=CANGKU_INDEX+CANGKU_MAX-1;
		/**
		 * 1 武器 2 
		 * */
		public static const ZHUANGBEI_INDEX:int=CANGKU_END_INDEX+1;
		public static const ZHUANGBEI_END_INDEX:int=ZHUANGBEI_INDEX+ZHUANGBEI_MAX-1;
		public static const XUN_BAO_INDEX:int = ZHUANGBEI_END_INDEX+1;                   //寻宝仓库
		public static const XUN_BAO_END_INDEX:int =  XUN_BAO_INDEX+XUNBAO_MAX-1;
		

		
		public const BAG_PAGE_COUNT:int=56;
		public static const STORE_PAGE_CELL_COUNT:int = 48;
		public static const STORE_FREE_COUNT:int = 48;//24;
		
		//分发事件
		public static const BAG_UPDATE:String="BAG_UPDATE";
		public static const STORE_UPDATE:String="STORE_UPDATE";		
		public static const ROLE_EQUIP_UPDATE:String="ROLE_EQUIP_UPDATE";
		public static const BAG_ADD:String="BAG_ADD";
		public static const GUAN_XING_TAI:String = "GUAN_XING_TAI"; 
		public static const XING_HUN_BAG:String = "XING_HUN_BAG"; 
		public static const XING_HUN_ZHUANG_BEI:String = "XING_HUN_ZHUANG_BEI";
		
		//寻宝抽奖事件
		public static const XUN_BAO_CHOU_JIANG:String = "XUN_BAO_CHOU_JIANG";
		public static const XUN_BAO_CHOU_JIANG_ADD:String = "XUN_BAO_CHOU_JIANG_ADD"
			
		public static const REPAINT_Tf_TISHI_CHAOLIANJIE:String = "REPAINT_Tf_TISHI_CHAOLIANJIE";
		
		
		//背包版本
		public var version:int=0;
		private var item:StructBagCell2;
		private var i:int=0;
		
		//物品分类的常量定义
		public static const ITEM_SORT_TASK:int = 1;       // 任务
		public static const ITEM_SORT_COWRY_BOX:int = 2;  // 宝箱
		public static const ITEM_SORT_LINGPAI:int = 3;    // 令牌
		public static const ITEM_SORT_CAILIAO:int = 4;    // 材料
		public static const ITEM_SORT_JUANZHOU:int = 5;   // 卷轴
		public static const ITEM_SORT_YAO:int = 9;        // 药品
		public static const ITEM_SORT_ZHUANGBEI:int = 13; // 装备
		public static const ITEM_SORT_CARD:int = 14;      // 卡片

		
		/**
		 * 限量魔纹礼包 
		 */
		public static const MO_WEN_GIFT:int = 12000001;
		
		/**
		 * 限量强化石宝箱 
		 */ 
		public static const QIANG_HUA_GIFT:int = 12000002;
		
		public function BeiBaoSet(pz:HashMap){
			refPackZone(pz);
			_beiBaoData=new Array();
			_cangKuData=new Array();
			_zhuangBeiData=new Array();
			
			m_xunbao_changku = [];
		}
		
		/**
		 * 重新构建寻宝仓库数据 
		 * 
		 */		
		public function reloadXunBaoData():void
		{
			var p:PacketSCPlayerActBank2=packZone.get(PacketSCPlayerActBank.id) as PacketSCPlayerActBank2;
			if(p==null)
			{
				return;
			}
			
			clearXunBaoGuo();  
			
			for each(var item:StructBagCell2 in p.arrItemitem_list)
			{
				fillCahceData(item);
				if(item.pos >= XUN_BAO_INDEX && item.pos <= XUN_BAO_END_INDEX)
				{
					m_xunbao_changku[item.pos-XUN_BAO_INDEX] = item;	
				}
			}
		}
		
		private function clearXunBaoGuo():void
		{
			if(this.m_xunbao_changku.length>0)
			{
				m_xunbao_changku.splice(0,m_xunbao_changku.length);
			}
		}
		
		/**
		 *	重新构造数据
		 *  客户端版本和服务端不一致时，重新请求回调 
		 */
		public function reloadData():void{
			var p:PacketSCPlayerBag2=packZone.get(PacketSCPlayerBag.id) as PacketSCPlayerBag2;
			if(p==null)return;		
			clearBaoGuo();
			//分开存数据
			for each(var item:StructBagCell2 in p.arrItemitem_list)
			{
				fillCahceData(item);
				if(item.pos>=1&&item.pos<=BEIBAO_END_INDEX){
					_beiBaoData.push(item);		
				}else if(item.pos>=CANGKU_INDEX&&item.pos<=CANGKU_END_INDEX){
					_cangKuData.push(item);
				}else if(item.pos>=ZHUANGBEI_INDEX && item.pos<=ZHUANGBEI_END_INDEX)
				{
					_zhuangBeiData.push(item);
				}

			}
		}
		
		/**
		 * 优化一下当大量物品加入背包中的性能问题 
		 */		
		private var m_queueChange:Vector.<StructBagCell2> = null;
		private var m_queue_isRealAdd:int = 0;
		public function queueBeiBaoDataChange(arrChange:Vector.<StructBagCell2>,v:int=0,isRealAdd:int=0):void
		{
			if((v-version)>1){
				//重新请求
				var bag:PacketCSPlayerBag=new PacketCSPlayerBag();
				DataKey.instance.send(bag);
				return;
			}
			version=v;
			
			if(arrChange.length <= 0)
			{
				return ;
			}
			if( JingJie2Win.getInstance().isOpen || arrChange.length < SESSION_QUEUE_CHANGE_MAX)
			{
				beiBaoDataChange(arrChange,isRealAdd);
				return ;
			}
			if(null == m_queueChange)
			{
				m_queueChange = new Vector.<StructBagCell2>();
			}
			
			var _length:int = arrChange.length;
			for(var i:int = 0; i < _length ; ++i)
			{
				m_queueChange.push(arrChange[i]);
			}
			m_queue_isRealAdd = isRealAdd;
			GameClock.instance.addEventListener(WorldEvent.CLOCK__SECOND200,_handleQueueChange);
		}
		
		
		private var m_sessionQueueChange:Vector.<StructBagCell2> = null;
		private static const SESSION_QUEUE_CHANGE_MAX:int = 8;
		private function _handleQueueChange(e:WorldEvent):void
		{
			if(null == m_queueChange || m_queueChange.length<=0)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK__SECOND200,_handleQueueChange);
				
				m_queue_isRealAdd = 0;
				return ;
			}

			m_sessionQueueChange = new Vector.<StructBagCell2>();
			var _temp_StructBagCell2:StructBagCell2 = null;
			//2013-11-12 andy 整理包裹时，没有界面显示一次搞定
			var excuteLength:int=SESSION_QUEUE_CHANGE_MAX;
			if(m_queue_isRealAdd==0){
				excuteLength=m_queueChange.length;
			}
			
			for(var i:int = 0; i<excuteLength ; ++i)
			{
				if(null == m_queueChange || m_queueChange.length<=0)
				{
					break;
				}
				_temp_StructBagCell2 = m_queueChange.shift();
				m_sessionQueueChange.push(_temp_StructBagCell2);
			}
			
			if(m_sessionQueueChange.length >= 1)
			{
				beiBaoDataChange(m_sessionQueueChange,m_queue_isRealAdd);
			}
		}
		
		
		/**
		 *	背包数据有变化 
		 *  @param arrChange 物品列表
		 *  @param isRealAdd 0.不是新增【整理包裹，包裹互换位置】1.新增 
		 */
		public function beiBaoDataChange(arrChange:Vector.<StructBagCell2>,isRealAdd:int=0):void
		{
			//UI_index.instance.repaintTf_tishi_chaolianjie();
			//2011-12-26
//			if((v-version)>1){
//				//重新请求
//				var bag:PacketCSPlayerBag=new PacketCSPlayerBag();
//				DataKey.instance.send(bag);
//				return;
//			}
//			version=v;
			var arr:Array=[];
			var isAdd:Boolean=false;
			var addCount:int=0;
			var arrEvent:Array=[0,0,0];
			
			var _isXinghun:Boolean = false;
			var _isXinghunStarIndex:int;
			
			var _isXunBaoCangKu:Boolean = false;
			var _isXunBaoCangKuStarIndex:int;
			
			for each(var item:StructBagCell2 in arrChange)
			{
				isAdd=true;
				
				
				
				if(item.pos>=1&&item.pos<=BEIBAO_END_INDEX){
					arr=_beiBaoData;
					arrEvent[0]=1;
				}else if(item.pos>=CANGKU_INDEX&&item.pos<=CANGKU_END_INDEX){
					arr=_cangKuData;
					arrEvent[1]=1;
				}else if(item.pos>=ZHUANGBEI_INDEX&&item.pos<=ZHUANGBEI_END_INDEX){
					arr=_zhuangBeiData;
					arrEvent[2]=1;
				}
				else if(item.pos >= XUN_BAO_INDEX && item.pos <= XUN_BAO_END_INDEX)
				{
					arr = m_xunbao_changku;
					arrEvent[6]=1; //寻宝仓库 事件
					
					_isXunBaoCangKu = true;
					_isXunBaoCangKuStarIndex = XUN_BAO_INDEX;
				}
				
				for each(var item2:StructBagCell2 in arr){
					if(null == item2)
					{
						continue;
					}
					//背包中已有物品
					if(item2.pos==item.pos){	
						if(item2.itemid==item.itemid&&item.num>0){
							addCount=item.num-item2.num;
							item2.num=item.num;
							item2.arrItemevilGrains=item.arrItemevilGrains;
							item2.arrItemattrs=item.arrItemattrs;
							item2.equip_fightValue=item.equip_fightValue;
							item2.para = item.para;
				
							item2.equip_strongLevel=item.equip_strongLevel;
							item2.strongFailed=item.strongFailed;
							item2.identify=item.identify;
							item2.colorLvl=item.colorLvl;
							//if(item2.colorLvl>0)item2.resetItemName();
							item2.arrItemsoulAttrs=item.arrItemsoulAttrs;
							item2.soulLvl=item.soulLvl;
							item2.ruler=item.ruler;
							//背包新增加物品
							if(item.pos<CANGKU_INDEX&&isRealAdd==1&&addCount>0)
							{
								dispatchEvent(new DispatchEvent(BAG_ADD,{itemid:item.itemid,itemname:item2.itemname,addCount:addCount,toolColor:item2.toolColor,icon:item2.icon}));
								_addItemEventHandlerChongfu(item);
							}
							
							//if(item.pos<CANGKU_INDEX&&isRealAdd==1&&addCount<0)
							//{
								//dispatchEvent(new DispatchEvent(BAG_SUB,{itemid:item.itemid,itemname:item2.itemname,addCount:addCount,toolColor:item2.toolColor,icon:item2.icon}));
							//}
							
							else if(_isXunBaoCangKu)
							{
								fillCahceData(item);
								arr[item.pos - _isXunBaoCangKuStarIndex] = item;    

								if(isRealAdd==1)
								{
									dispatchEvent(new DispatchEvent(BeiBaoSet.XUN_BAO_CHOU_JIANG_ADD,item));
								}
								
							}
							
						}else{

							if(!_isXinghun && !_isXunBaoCangKu)
							{
								arr.splice(arr.indexOf(item2),1);
							}
							else 
							{
								var _indexOf:int = arr.indexOf(item2);
								arr[_indexOf] = null;
								//delete arr[_indexOf];
							}
						}
						item2.itemid==item.itemid?isAdd=false:isAdd=true ;
						break;
					}
				}

				if(isAdd==true&&item.num>0){
					fillCahceData(item);
					if(_isXinghun)
					{
						//如果是星魂
												arr[item.pos - _isXinghunStarIndex] = item;
					}
					else if(_isXunBaoCangKu)
					{
						arr[item.pos - _isXunBaoCangKuStarIndex] = item;    

						if(isRealAdd==1)
						{
							dispatchEvent(new DispatchEvent(BeiBaoSet.XUN_BAO_CHOU_JIANG_ADD,item));
						}
						
					}
					else
					{
						arr.push(item);
						//背包新增加物品
						if(item.pos<CANGKU_INDEX&&isRealAdd==1)
						{
							dispatchEvent(new DispatchEvent(BAG_ADD,{itemid:item.itemid,itemname:item.itemname,addCount:item.num,toolColor:item.toolColor,icon:item.icon}));
							
							//当增加物品的时候调用该函数 
							_addItemEventHandler(item);
							_addItemEventHandlerChongfu(item);
						}
					}
				}
			}
			//分发事件
			if(arrEvent[0]==1)
			{
				dispatchEvent(new DispatchEvent(BAG_UPDATE,null));
			}
			if(arrEvent[1]==1)
			{
				dispatchEvent(new DispatchEvent(STORE_UPDATE,null));
			}
			if(arrEvent[2]==1)
			{
				dispatchEvent(new DispatchEvent(ROLE_EQUIP_UPDATE,null));
			}
			if(arrEvent[3]==1)
			{
				dispatchEvent(new DispatchEvent(BeiBaoSet.GUAN_XING_TAI,null));
			}
			if(arrEvent[4]==1)
			{
				dispatchEvent(new DispatchEvent(BeiBaoSet.XING_HUN_BAG,null));
			}
			if(arrEvent[5]==1)
			{
				dispatchEvent(new DispatchEvent(BeiBaoSet.XING_HUN_ZHUANG_BEI,null));
			}
			if(arrEvent[6]==1)
			{
				dispatchEvent(new DispatchEvent(BeiBaoSet.XUN_BAO_CHOU_JIANG,null));
			}
			if(arrEvent[7]==1)
			{
				//dispatchEvent(new DispatchEvent(BeiBaoSet.XIN_WU_UPDATE,null));
			}
			
			//UI_index.instance.repaintTf_tishi_chaolianjie();
			dispatchEvent(new DispatchEvent(BeiBaoSet.REPAINT_Tf_TISHI_CHAOLIANJIE,null));
			
		}
		
		/**获得物品时，调用该方法 可以被重复调用
		 * 当背包里有该物品时 _addItemEventHandler 不被调用。
		 * @param item
		 */
		private function _addItemEventHandlerChongfu(_item:StructBagCell2):void
		{
			if(null == _item || _item.num <= 0)
			{
				return ;
			}
			item = _item
			var cont:int = this.getBeiBaoCountById(item.itemid);
		}
		
		//刚获取的装备ID 主要用于武器
		public var updataItemId:int = -1;
		public static var isDuihuanGuest:Boolean = false;
		/**
		 * 当增加物品的时候调用该函数 
		 * @param 
		 * @param StructBagCell2
		 * 
		 */		
		private function _addItemEventHandler(item:StructBagCell2):void
		{
			if(null == item || item.num <= 0)
			{
				return ;
			}
			this.item = item;
			//当获得一个坐骑蛋时候 并且坐骑功能确认开启的时候 打开背包面板  //获得汗血宝马直接使用掉
			if(10601001 == item.itemid){
				var objzq:Object = new Object();
				objzq.name = "item"
				objzq.data = item;
				BeiBao.getInstance().clickMenuUse(objzq);
			}
			
			var _rightDownTip:RightDownTip = null;
			
			
			// --------- 以下代码由 王志祥 提供：------------
			
			var arrShowEquipTip:Array=Lang.getLabelArr("arrShowEquipTip");
			if(13 == item.sort && Data.myKing.level <RightDownTipZB.SHOW_EQUIP_LEVEL && 
				Data.myKing.level >=item.level &&
				(Data.myKing.metier==item.metier||item.metier==0)&&
				(Data.myKing.sex==item.sex||item.sex==0)&&
				compareEquipFightValue(item)
			)
			{
				_rightDownTip = RightDownTipManager.getInstance().getOneTipZB();
				_rightDownTip.setData(item.icon,item.itemname,item.desc);
				_rightDownTip.setDataByStructBagCell2(item);
				_rightDownTip.open();
				
			}
			// -------------------  end  ----------------------

			//2012-10-23 andy 获得技能书提示 
			else if(11 == item.sort)
			{
				var _skillID:int = Jineng.instance.checkSkillID(item.itemid);
				if(Data.skill.hasStudy(_skillID).hasStudy)
				{
					//已经学习过不提示
					
				}else{
					//自己职业的才显示
					if(item.metier!=Data.myKing.metier)return;
					_rightDownTip = RightDownTipManager.getInstance().getOneTipJNS();
					//_rightDownTip.setData(item.icon,item.itemname,item.desc);
					_rightDownTip.setDataByStructBagCell2(item);
					_rightDownTip.open();
				}
			}
			
			//新手引导 阵法技能学习引导 2012-10-24 技能书走同一学习装配，去掉此指引
			//if(11100001 == item.itemid)
			//{
			
			//}
			
		}
		private function compareEquipFightValue(getBag:StructBagCell2):Boolean{
			var ret:Boolean=false;
			var arr:Array=this.getRoleEquipByType(getBag.equip_type);
			if(arr!=null&&arr.length>0){
				for each(var bag:StructBagCell2 in arr){
					if(bag.equip_type==getBag.equip_type&&bag.equip_fightValue<getBag.equip_fightValue){
						ret=true;
					}
				}
			}else{
				ret=true;
			}
			return ret;
		}
		/****************背包数据处理**********************/
		/**
		 *	背包中所有数据 
		 */
		public function getBeiBaoData():Array{
			return _beiBaoData;
		}
		/**
		 *	根据背包页数获得背包数据
		 * 	@param page 页数 
		 */
		public  function getBeiBaoDataByPage(page:int=1):Array{
			return _beiBaoData;
		}
		
		/**
		 *	根据位置获得背包数据
		 * 	@param pos 全局位置  
		 */
		public function getBeiBaoDataByPos(pos:int=1):StructBagCell2{
			var _loc1:StructBagCell2=null;
			var　_loc2:Array=getBeiBaoData();
			for each(var item:StructBagCell2 in _loc2){
				if(item.pos==pos){
					_loc1=item;
					break;
				}
			}
			return _loc1;
		}
		/**
		 *	根据物品ID获得背包数据【全ID】
		 * 	物品可以出现叠加，所以返回数组
		 * 	@param id       物品编号 
		 *  @param andStore 是否包含仓库
		 */
		public function getBeiBaoDataById(id:int,andStore:Boolean=false):Array{
			var _loc1:Array=new Array();
			for each(item in _beiBaoData){
				if(item!=null&&item.itemid==id){
					_loc1.push(item);
				}
			}
			if(andStore){
				for each(item in _cangKuData){
					if(item!=null&&item.itemid==id){
						_loc1.push(item);
					}
				}
			}
			return _loc1;
		}
		/**
		 *	根据物品ID获得背包数据【ID一部分】
		 * 	物品可以出现叠加，所以返回数组
		 * 	@param id       物品编号 
		 *  @param andStore 是否包含仓库
		 */
		public function getBeiBaoDataByIdStr(id:String,andStore:Boolean=false):Array{
			var ret:Array=new Array();
			for each(item in _beiBaoData){
				if(item.itemid.toString().indexOf(id)==0&&item.lock==false){
					ret.push(item);
				}
			}
			if(andStore){
				for each(item in _cangKuData){
					if(item.itemid.toString().indexOf(id)==0){
						ret.push(item);
					}
				}
			}
			return ret;
		}
		/**
		 *	根据物品ID获得背包总
		 * 	@param id       物品编号
		 *  @param andStore 是否包含仓库 
		 */
		public function getBeiBaoCountById(id:int,andStore:Boolean=false):int{
			var ret:int=0;
			var arr:Array=getBeiBaoDataById(id,andStore);
			
			for each(var item:StructBagCell2 in arr){
				ret+=item.num;
			}
			return ret;
		}
		/**
		 *	根据全局位置计算背包格子位置 
		 */
		public function getBeiBaoCellPos(pos:int):int{
			var _loc2:int=(pos)%BAG_PAGE_COUNT;
			return _loc2==0?BAG_PAGE_COUNT:_loc2;
		}
		
		
		/**
		 *	 根据物品类型sort，获得背包里边的物品
		 *   @param sort      分类类型
		 * 	 @param andStore  是否包含仓库
		 *   @param limitType 装备操作限制类型
		 */
		public function getBeiBaoBySort(sort:int,andStore:Boolean=false,limitType:int=0):Array{
			var ret:Array=new Array();
			for each(item in _beiBaoData){
				if(item.sort==sort&&item.lock==false&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
					ret.push(item);
				}
			}
			if(andStore){
				for each(item in _cangKuData){
					if(item.sort==sort&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
						ret.push(item);
					}
				}
			}
			return ret;
		}
		/**
		 *	根据物品装备类型获得背包数据
		 * 	物品可以出现叠加，所以返回数组
		 * 	@param id       物品编号 
		 *  @param andStore 是否包含仓库
		 */
		public function getBeiBaoByEquipType(equip_type:int,andStore:Boolean=false,limitType:int=0):Array{
			var _loc1:Array=new Array();
			for each(item in _beiBaoData){
				if(item.equip_type==equip_type&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
					_loc1.push(item);
				}
			}
			if(andStore){
				for each(item in _cangKuData){
					if(item.equip_type==equip_type&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
						_loc1.push(item);
					}
				}
			}
			return _loc1;
		}
		
		
		public function getOneById(id:String,andStore:Boolean=false):StructBagCell2
		{
			var _ret:StructBagCell2 = null;
			for each(item in _beiBaoData){
				if(item.itemid.toString().indexOf(id)==0&&item.lock==false){
					_ret = item;
					break;
				}
			}
			return _ret;
		}
		
		/**
		 *	根据物品ID获得背包数据
		 * 	
		 * 	@param pos       物品编号 -1遍历所有物品【收摊用】
		 *  @param lock     上锁状态
		 */
		public function setBeiBaoLock(pos:int,lock:Boolean):void{
			for each(item in _beiBaoData){
				if(pos==-1){
					item.lock=lock;
					continue;
				}
					
				if(item.pos==pos){
					item.lock=lock;
				}
			}

		}
		/**
		 *	获得当前页数，第一个数据为空的pos
		 * 	@param page 页数 
		 */
		public  function getBeiBaoFirstEmpty(page:int):int{
			var arr:Array=getBeiBaoDataByPage(page);
			var _loc3:int=(page-1)*BAG_PAGE_COUNT;
			var _loc4:int=page*BAG_PAGE_COUNT;
			var have:Boolean=false;
			for(i=_loc3+1;i<=_loc4;i++){
				have=false;
				for each(item in arr){
					if(item.pos==i){
						have=true;
						break;
					}
				}
				if(have==false&&i<=Data.myKing.BagSize&&(i<=Data.myKing.BagStart||i>Data.myKing.BagEnd))return i;
			}
			
			return -1;
		}
		
		/****************仓库数据处理**********************/
		public function getStoreData():Array{
			return this._cangKuData;
		}
		public function getStoreCellPos(pos:int):int
		{
			var cellCount:int = STORE_PAGE_CELL_COUNT;
			
			var _loc2:int=(pos-BEIBAO_END_INDEX)%cellCount;
			return _loc2==0?cellCount:_loc2;
		}
		/**
		 *	获得仓库第一个数据为空的pos
		 * 	
		 */
		private var _cangKuDataFull:Array = [];
		private function getCangkuDataFullForEmpty(bankSize:int):Array
		{
			
			//check size
			if(_cangKuDataFull.length < bankSize)
			{
				_cangKuDataFull = [];
				var bankSize2:int = CANGKU_INDEX + bankSize;
				
				for(i=CANGKU_INDEX;i<bankSize2;i++)
				{
					var o:Object = {"pos":i,"empty":true};
					_cangKuDataFull.push(o);
				}
				
			}else
			{
				var len:int = _cangKuDataFull.length;
				for(i=0;i<len;i++)
				{
					_cangKuDataFull[i].empty = true;
				}
			}
			
			return _cangKuDataFull;
		}
		
		private function getCangKuFirstEmptySub(bankSize:int):Array
		{			
			var _loc1:Array=new Array();
			
			//
			_cangKuData.sortOn("pos",[Array.NUMERIC,Array.DESCENDING]);
			
			//0级 - 只找空闲格位
			//1级 - 可以合并
			var vacnciPosLvl:int = 0;
			
			var vacanciPos:int = -1;
			
			var i:int;
			var len:int;
			
				
			//--------------------------------------------------------------------
			var cangKuDataFull:Array = getCangkuDataFullForEmpty(bankSize);
				
			len = _cangKuData.length;
			var item:StructBagCell2;
			for(i=0;i<len;i++)
			{
				item = _cangKuData[i];
					
				if(0 == vacnciPosLvl)
				{	
					cangKuDataFull[item.pos - CANGKU_INDEX].empty = false;
				}
			}
				
			//--------------------------------------------------------------------
			
			return cangKuDataFull;
			
			
		}
		
		
		public  function getCangKuFirstEmpty(page:int,bankSize:int):int
		{
		
			var vacanciPosArr:Array = getCangKuFirstEmptySub(bankSize);
			
			var vacanciPos:int = -1;
			
			//--------------------------------------------------------
			var _loc3:int = CANGKU_INDEX +  (page-1) *BeiBaoSet.STORE_PAGE_CELL_COUNT;
			
			var i:int;
			var len:int = vacanciPosArr.length;
			for(i=0;i<len;i++)
			{
				if(vacanciPosArr[i].pos >= _loc3 &&
					vacanciPosArr[i].empty == true)
				{
					vacanciPos = vacanciPosArr[i].pos;
					break;
				}
			}
			
			
			if(-1 == vacanciPos)
			{
				for(i=0;i<len;i++)
				{
					if(vacanciPosArr[i].empty == true)
					{
						vacanciPos = vacanciPosArr[i].pos;
						break;
					}
				}
			}
				
			//--------------------------------------------------------
				
			return vacanciPos;
		}
		
		public function getBeiBaoVacanciPos(page:int=1):int
		{
			var _loc1:Array=new Array();
			//var _loc3:int=BEIBAO_INDEX;
			//var _loc4:int=BEIBAO_END_INDEX;
			
			var _loc3:int=this.BAG_PAGE_COUNT * (page-1);
			var _loc4:int=this.BAG_PAGE_COUNT * page;
			
			//
			_beiBaoData.sortOn("pos",[Array.NUMERIC,Array.DESCENDING]);
			
			//0级 - 只找空闲格位
			//1级 - 可以合并
			var vacnciPosLvl:int = 0;
			
			var vacanciPos:int = -1;
			
			var i:int = _loc3;
			var j:int;
			var len:int = _beiBaoData.length;
			
			if(0 == vacnciPosLvl)
			{	
				if(0 == len)
				{
					vacanciPos = _loc3 + 1;
					return vacanciPos;
				}
				
				for (j=0;j<len;j++)
				{
					var item:StructBagCell2 = _beiBaoData[j];
					
					i++;
					
					//if(item.pos>_loc3 &&item.pos<=_loc4)
					if(item.pos>_loc3 &&item.pos<=_loc4)
					{
						if(item.pos==i)
						{
							
						}else
						{
							vacanciPos = i;
							break;
						}						
					}//end if				
				}//end for
				
				
				if(-1 == vacanciPos)
				{
					if(i < _loc4)
					{
						vacanciPos = i + 1;
					}
				}
				
				
			}
			
			return vacanciPos;
		}
		
		public function getStoreDataByPage(page:int):Array
		{			
			var _loc1:Array=new Array();
			var _loc3:int=(page-1)* STORE_PAGE_CELL_COUNT;
			var _loc4:int=page*STORE_PAGE_CELL_COUNT;
			
			_loc3 += CANGKU_INDEX
			_loc4 += CANGKU_INDEX;
			
			
			for each(var item:StructBagCell2 in _cangKuData)
			{
								
				if(item.pos>=_loc3 && 
					//item.pos<=_loc4)
					item.pos<_loc4)
				{
					_loc1.push(item);
				}
			}
			return _loc1;
		}
		
		
		/**
		 *  根据物品类型，获得背包里边的物品 ,强行合并相同类型
		 * @param sort
		 * @param andStore
		 * @return 
		 * 
		 */		
		public function getBeiBaoByType_Merged(sort:int,andStore:Boolean=false):Array
		{
			var _ret:Array = [];
			var _list:Array = getBeiBaoBySort(sort,andStore);
			var _item:StructBagCell2 = null;;
			
			var _length:int = _list.length;
			for(var i:int = 0; i < _length ; ++i)
			{
				_item = _list[i] as StructBagCell2;
				if(null == _item)
				{
					continue;
				}
				
				if(null == _ret[_item.itemid])
				{
					_ret[_item.itemid] = {id:_item.itemid,num:_item.num};
				}
				else
				{
					_ret[_item.itemid].num += _item.num; 
				}
				
			}
			
			return _ret;
		}
		
		/**************** 玩家身上装备数据处理 **********************/
		/**
		 *	玩家身上装备列表【共计15件】
		 *  @param start
		 *  @param end     
		 *  @param limitType 装备操作限制类型
		 */
		public function getRoleEquipList(start:int=0,end:int=15,limitType:int=0):Array{
			var _loc1:Array=new Array();
			var _loc2:int=ZHUANGBEI_INDEX+start;
			var _loc3:int=ZHUANGBEI_INDEX+end;
			
			for each(var item:StructBagCell2 in _zhuangBeiData){
				if(item.pos>=_loc2&&item.pos<_loc3&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
					_loc1.push(item);
				}
			}
			_loc1.sortOn("pos",Array.NUMERIC);
			return _loc1;
		}
		/**
		 *	玩家身上装备
		 *  @param pos  
		 *  
		 */
		public function getRoleEquipByType(equip_type:int=0,limitType:int=0):Array{
			var ret:Array=[];
			for each(var item:StructBagCell2 in _zhuangBeiData){
				if(item.equip_type==equip_type&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
					ret.push(item);
				}
			}
			return ret;
		}
		/**
		 *	玩家身上装备
		 *  @param pos  
		 *  
		 */
		public function getRoleEquipByPos(pos:int=0,limitType:int=0):StructBagCell2{
			var ret:StructBagCell2=null;
			for each(var item:StructBagCell2 in _zhuangBeiData){
				if(item.pos==pos&&ResCtrl.instance().getEquipLimit(item.equip_limit,limitType)){
					ret=item;
				}
			}
			return ret;
		}
		
		/**
		 *	确认玩家身上是否有该装备
		 *  @param equip_id 装备id  
		 *  
		 */
		public function confirmRoleEquipById(equip_id:int=0):int{
			var ret:int=0;
			for each(var item:StructBagCell2 in _zhuangBeiData){
				if(item.itemid==equip_id){
					ret++;
				}
			}
			return ret;
		}

		/**
		 *	根据全局位置计算身上装备位置 
		 */
		public function getEquipPos(pos:int):int{
			var _loc1:int=pos-ZHUANGBEI_INDEX+1;
			var _loc2:int=_loc1%16;
			return _loc2==0?16:_loc2;
		}
		/***************宝石****************/
		/**
		 * 根据身上装备位置获得对应宝石列表 2014-05-14
		 *  @param equip_pos 身上显示位置
		 * 
		 */		
		public function getStoneByEquipPos(equip_pos:int):Vector.<StructGemInfo2>{
			if(this.stoneData==null)return null;
			var ret:Vector.<StructGemInfo2>=new Vector.<StructGemInfo2>();
			for each(var gem:StructGemInfoPos2 in this.stoneData.arrItemgems){
				if(gem.pos==equip_pos){
					ret=gem.arrItemitems;
					break;
				}
			}
			//当前界面只有3个孔，服务端给4个孔数据
			if(ret.length>3)ret.pop();
			return ret;
		}
		
		/***************内部调用****************/
		/**
		 *	因背包数据使用范围比较广泛
		 *  取得本地数据填到packet
		 * @param dataSource 对应的xml配置信息
		 */
		public function fillCahceData(bag:StructBagCell2,dataSource:Pub_ToolsResModel=null):void{
			if(bag==null||bag.itemid==0)return;
			var xml:Pub_ToolsResModel=null;
			if (dataSource==null){
				xml=XmlManager.localres.getToolsXml.getResPath(bag.itemid) as Pub_ToolsResModel;
			}
			else xml = dataSource;
			if(xml==null)return;
			bag.config = xml;
			bag.tool_icon=xml.tool_icon;
			bag.icon=FileManager.instance.getIconSById(xml.tool_icon);
			bag.iconBig=FileManager.instance.getIconXById(xml.tool_icon);
			bag.iconBigBig=FileManager.instance.getIconLById(xml.tool_icon);
			bag.itemname=xml.tool_name;
			bag.desc=xml.tool_desc;
			bag.sellprice=xml.sell_coin;
			bag.buyprice1=xml.tool_coin1;
			bag.buyprice3=xml.tool_coin3;
			bag.isused=xml.is_use;
			bag.sort=xml.tool_sort;
			bag.level=xml.tool_level;
			bag.sortName=xml.tool_sort_name;
			bag.cooldown_id=xml.cooldown_id;
			bag.gradeValue=xml.grade_value;
			bag.plie_num=xml.plie_num;
			bag.sort_para1=xml.sort_para1;
			bag.metier=xml.tool_metier;
			bag.toolColor=xml.tool_color;
			bag.isSale=xml.is_sale==0?false:true;
			bag.isBind=xml.is_bind;
			bag.effect=xml.effect;
			bag.is_autouse = xml.is_autouse;
			bag.dbsort=xml.dblclick_sort;
			bag.suit_id=xml.suit_id;

			bag.equip_strongLevelMax=xml.strong_maxlevel;
			bag.useMaxTimes=xml.use_maxtimes;
			bag.para_int=xml.para_int;
			bag.para_str=xml.para_str;
			bag.isBatch=xml.is_batch==0?false:true;
			bag.equip_limit=xml.equip_limit;
			bag.menu_limit=xml.menu_limit;
			bag.seek_id=xml.seek_id;
			//装备属性
			if(bag.sort==13){
				bag.equip_type=xml.tool_pos;
				bag.equip_typeName=XmlRes.GetEquipTypeName(bag.equip_type);
				bag.equip_jobName=XmlRes.GetJobNameById(bag.metier);
//				bag.equip_usedCountMax=xml.equip_wear;
				bag.strongId=xml.strong_id;
				bag.contribute=xml.contribute;
				bag.need_contribute=xml.need_contribute;
				bag.soar_lv=xml.soar_lv;
				bag.sex=xml.sex;
				if(bag.pos==0)bag.equip_strongLevel=xml.strong_level;
				//bag.itemname=XmlRes.getEquipColorFont(bag.toolColor)+"·"+xml.tool_name;
				if(bag.equip_att1==null)bag.equip_att1=new Vector.<StructItemAttr2>();
				while(bag.equip_att1.length>0)bag.equip_att1.shift();
				var att:StructItemAttr2=null;
				for(var i:int=1;i<=10;i++){
					if(xml["func"+i]!=null&&xml["func"+i]>0){
						att=new StructItemAttr2();
						att.attrIndex=xml["func"+i];
						att.attrValue=xml["value"+i];
						bag.equip_att1.push(att);
					}
				}
				
				//2014-08-19 附加属性客户端计算
				if(bag.arrItemattrs==null)bag.arrItemattrs=new Vector.<StructItemAttr2>();
				while(bag.arrItemattrs.length>0)bag.arrItemattrs.shift();
				for(var i:int=21;i<=30;i++){
					if(xml["func"+i]!=null&&xml["func"+i]>0){
						att=new StructItemAttr2();
						att.attrIndex=xml["func"+i];
						att.attrValue=xml["value"+i];
						bag.arrItemattrs.push(att);
					}
				}

				//2012-12-21 andy 装备可镶嵌魔纹孔数
				bag.equip_hole=xml.tool_hole%10;
				bag.equip_fightValue=LianDanLu.instance().getEquipFightValue(bag);
			}
		}
		/**
		 *	因背包数据使用范围比较广泛
		 *  清除临时structbagcell2，重复利用
		 */
		public function clearCahceData(bag:StructBagCell2):void{
			if(bag==null)return;
			bag.arrItemattrs=new Vector.<StructItemAttr2>;
			bag.equip_strongLevel=0;
			bag.equip_usedCount=0;
			bag.equip_fightValue=0;
			bag.arrItemevilGrains=new Vector.<StructEvilGrain2>;
		}
		
		/**
		 *	因背包数据使用范围比较广泛
		 *  取得服务端数据填到structbagcell
		 * @param dataSource 对应的xml配置信息
		 */
		public function fillServerData(bag:StructBagCell2,v:Object=null):void{
			if(bag==null||bag.itemid==0)return;
			
			if(v is StructBagCell2){
				var dataSource:StructBagCell2=v as StructBagCell2;
				//bag.arrItemattrs=dataSource.arrItemattrs;
				bag.equip_strongLevel=dataSource.equip_strongLevel;
				bag.strongFailed=dataSource.strongFailed;
				bag.arrItemevilGrains=dataSource.arrItemevilGrains;
				bag.equip_usedCount=dataSource.equip_usedCount;
				bag.colorLvl=dataSource.colorLvl;
				bag.ruler=dataSource.ruler;
			}else if(v is StructSCEquipTip2){
				var dataSource1:StructSCEquipTip2=v as StructSCEquipTip2;
				//bag.arrItemattrs=dataSource1.arrItemequipAttrs;
				bag.equip_strongLevel=dataSource1.strongLevel;
				bag.strongFailed=dataSource1.strongFailed;
				bag.arrItemevilGrains=dataSource1.arrItemevilGrains;
				bag.equip_usedCount=dataSource1.curDurPoint;
				bag.colorLvl=dataSource1.colorLvl;
				bag.ruler=dataSource1.ruler;
			}else if(v is Structequipidattrs2){
				var dataSource2:Structequipidattrs2=v as Structequipidattrs2;
				//bag.arrItemattrs=dataSource2.arrItemequipattrs;
				bag.equip_strongLevel=dataSource2.strongLevel;
				bag.strongFailed=dataSource2.strongFailed;
				bag.arrItemevilGrains=dataSource2.arrItemevilGrains;
				//bag.equip_usedCount=dataSource2;
				bag.colorLvl=dataSource2.colorLvl;
				bag.ruler=dataSource2.ruler;
			}else{
			
			}

		
		}	
		
		override public function sync(p:IPacket):void
		{
		
		}
		
		/**
		 * 是否属于该类型范围之内的
		 * @param itemID:int  当前物品的类型
		 * @param sorts     物品类型
		 * @param isOrther  其它 (程序中使用的 其它 类型，也就是说除去 装备，药品，材料 之外的物品)
		 * @return 
		 * 
		 */		
		public function isInSort(itemID:int , sorts:Array=null,isOrther:Boolean = false):Boolean
		{
			//获得该道具的配置信息
			var _Pub_ToolsResModel:Pub_ToolsResModel = _getBagItemConfig(itemID);
			
			//获得道具的类型
			var _itemType:int = _Pub_ToolsResModel.tool_sort;
			
			//查看该类型的道具是否需要捡取
			var _isInSort:Boolean = false; 
			
			//首先判断是否为 其它 类型
			if(ITEM_SORT_ZHUANGBEI != _itemType && ITEM_SORT_YAO != _itemType  && ITEM_SORT_CAILIAO != _itemType )
			{
				//该物品属于其它类型
				if(isOrther)
				{
					_isInSort = true;
				}
				else
				{
					_isInSort = false;
				}
			}
			else
			{
				//如果该物品不属于其它类型，那么就要根据 sorts 类型列表中判断
				if(null != sorts && sorts.length >=1 )
				{
					var _length:int = sorts.length;
					for(var i:int=0; i<_length;++i)
					{
						if(_itemType == sorts[i])
						{
							_isInSort = true;
							break;
						}
					}
				}
			}
			
			return _isInSort;
		}
		
		/**
		 * 背包是否已经满了 
		 * @return 
		 * 
		 */		
		public function isFull():Boolean
		{
			var _ret:Boolean;
			
			if(_beiBaoData.length < Data.myKing.BagSize-(Data.myKing.BagEnd-Data.myKing.BagStart) )
			{
				_ret = false;
			}
			else
			{
				_ret = true;
			}
			
			
			return _ret;
		}
		
		
		/**
		 * 前台预判断一个物品是否可以放入到背包,增加了物品的类型判断  add by Steven Guo
		 *  
		 * @param id
		 * @param num
		
		 * @return 
		 * 
		 */		
		public function isCanPutIn(id:int,num:int):Boolean
		{
			if(num <=0)
			{
				return true;
			}
			
			//获得该道具的配置信息
			var _Pub_ToolsResModel:Pub_ToolsResModel = _getBagItemConfig(id);
			
			
			//if(null == _beiBaoData || _beiBaoData.length < DataCenter.myKing.BagSize)
			if(null == _beiBaoData || !isFull())
			{
				return true;
			}
			else if( isFull())
			{
				
				//如果叠加小于等于1的话，立刻判断
				if(_Pub_ToolsResModel.plie_num <= 1)
				{
					return false;
				}
				
//				var _arrItems:Array =  getBeiBaoDataById(id);
//				for(var i:int=0;i<_arrItems.length;++i)
//				{
//					if((_arrItems[i].num + num) > _Pub_ToolsResModel.plie_num)
//					{
//						continue;
//					}
//					else
//					{
//						return true;
//					}
//				}
				
				var _itemNum:int = getBeiBaoCountById(id);
				
				if( (_itemNum%_Pub_ToolsResModel.plie_num) <=0 )
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			
			
			return false;
		}
		
		
		/**
		 * 通过一个物品的ID获得 add By Steven Guo
		 * @param id
		 * @return 
		 * 
		 */		
		private function _getBagItemConfig(id:int):Pub_ToolsResModel
		{
			var _ret:Pub_ToolsResModel = null;
			
			var _Pub_ToolsXml:TablesLib = XmlManager.localres.getToolsXml;
			
			_ret = _Pub_ToolsXml.getResPath(id) as Pub_ToolsResModel;
			
			return _ret;
		}
		
		/**
		 * 获得背包中的最大等级红药  add By Steven Guo
		 * @return 
		 * 
		 */		
		public function getHPItemByMaxLevel():StructBagCell2
		{
			
			var _hp:StructBagCell2 = null;

			//根据策划Excel表中的命名规则 当大于 10901000 并且 小于  10902000 为人物红药
			
			for each(var item:StructBagCell2 in _beiBaoData)
			{
				if(  item.itemid > 10901000 && item.itemid < 10902000)
				{
					if( ( Data.myKing.level >= item.level )  && (null == _hp || _hp.level < item.level) )
					{
						_hp = item;
					}
				}
			}
			
			return _hp;
		}
		
		
		/**
		 * 获得背包中的最大等级蓝药  add By Steven Guo
		 * @return 
		 * 
		 */		
		public function getMPItemByMaxLevel():StructBagCell2
		{
			var _mp:StructBagCell2 = null;
			
			//根据策划Excel表中的命名规则 当大于 10902000 并且 小于  10903000 为人物红药
			
			for each(var item:StructBagCell2 in _beiBaoData)
			{
				if(  item.itemid > 10902000 && item.itemid < 10903000)
				{
					if( ( Data.myKing.level >= item.level )  &&  (null == _mp || _mp.level < item.level) )
					{
						_mp = item;
					}
				}
			}
			
			return _mp;
		}
		
		/**
		 * 获得背包中的最大等级宠物(伙伴)红药  add By Steven Guo
		 * @return 
		 * 
		 */		
		public function getPetHpItemByMaxLevel():StructBagCell2
		{
			return null;
			
		}
		
		/**
		 * 获得背包中的最大等级宠物(伙伴)蓝药药  add By Steven Guo
		 * @return 
		 * 
		 */		
		public function getPetMpItemByMaxLevel():StructBagCell2
		{
			return null;
//			var _mp:StructBagCell2 = null;
//			
//			var _huoban:PacketSCPetData2 = Data.huoBan.getCurrentChuZhan();
//			
//			if(null == _huoban)
//			{
//				return null;
//			}
//			
//			//根据策划Excel表中的命名规则 当大于 10802000 并且 小于  10803000 为宠物红药
//			
//			for each(var item:StructBagCell2 in _beiBaoData)
//			{
//				if(  item.itemid > 10802000 && item.itemid < 10803000)
//				{
//					
//					if( ( _huoban.Level >= item.level ) &&   (null == _mp || _mp.level < item.level) )
//					{
//						_mp = item;
//					}
//				}
//			}
//			
//			return _mp;
		}
		
		/**
		 * 获得背包中的最大等级   境界 药品,但必须符合规则   --  add By Steven Guo
		 * 
		 * 
		 * @return 
		 * 
		 */		
		public function getJingjieItemByMaxLevel():StructBagCell2
		{
			return null;
		}
		/**
		 *把本来是背包中的 物品放回背包对应的格子 
		 * @param bagCell
		 * 
		 */
		public function setItemStructCell2(bagCell:StructBagCell2):void
		{
//			var item:MovieClip = bagCell.pos;
//			ItemManager.instance().setToolTipByData(child,item);
		}
		/**
		 * 获取当前境界对应的药品 
		 * @param itemId
		 * @return 
		 * 
		 */
		public function getJingJieItemByMinLevel(itemId:int):StructBagCell2{
			var _cell:StructBagCell2 = null;
			var item:StructBagCell2 = null;
			for each(item in _beiBaoData)
			{
				if(item.itemid == itemId){
					_cell = item;
				}
			}
			if (_cell==null){
				for each(item in _cangKuData)
				{
					if(item.itemid == itemId){
						_cell = item;
					}
				}
			}
			return _cell;
		}
		
		public function getJingJieItemCanUse(itemId:int):StructBagCell2{
			var _cell:StructBagCell2 = null;
			var item:StructBagCell2 = null;
//			getJingJieItemByMinLevel(itemId);
//			if (_cell==null) return null;
//			var _cell:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(itemId);
			for each(item in _beiBaoData)
			{
				if(  item.itemid >= 10701001 && item.itemid <= 10701007)
				{
					if (item.itemid>itemId){
						_cell = item;
						break;
					}
				}
			}
			if (_cell==null){
				for each(item in _cangKuData)
				{
					if(  item.itemid >= 10701001 && item.itemid <= 10701007)
					{
						if (item.itemid>itemId){
							_cell = item;
							break;
						}
					}
				}
			}
			return _cell;
		}
		


		/**
		 * 寻宝仓库数据 
		 * @return 
		 * 
		 */		
		public function getXunbao_changku():Array
		{
			return this.m_xunbao_changku;
		}
		
		/**
		 * 获得  寻宝仓库 已经使用的格子数量
		 * @return 
		 * 
		 */		
		public function getXunBaoChangKuNum():int
		{
			var _ret:int = 0;
			var _length:int = m_xunbao_changku.length;
			var _item:StructBagCell2 = null;
			for(var i:int = 0 ;i < _length ; ++i )
			{
				_item = m_xunbao_changku[i] as StructBagCell2;
				if(null != _item)
				{
					_ret++;
				}
			}
			
			return _ret;
		}

		
		/**
		 *	获得过期时间 
		 *  @param v 例如：20120717 
		 */
		public function getExpiredDate(v:int):String{
			if(v==0)return "";
			var ret:String= v.toString();
			
			return Lang.getLabel("10084_bao_guo")+": "+ret.substr(0,2)+Lang.getLabel("pub_nian")+ret.substr(2,2)+Lang.getLabel("pub_yue")+ret.substr(4,2)+Lang.getLabel("pub_ri")+ret.substr(6,2)+Lang.getLabel("pub_shi");
		}

		/**
		 *	清除包裹数据【包裹数据与服务端不一致时，重新请求】 
		 *   andy 2012-04-18
		 *   
		 */
		private function clearBaoGuo():void{
			//while(this._beiBaoData.length>0)this._beiBaoData.pop();
			//while(this._cangKuData.length>0)this._cangKuData.pop();
			//while(this._zhuangBeiData.length>0)this._zhuangBeiData.pop();
			//while(this.m_guanXingTai.length>0)this.m_guanXingTai.pop();
			//while(this.m_xinghunBag.length>0)this.m_xinghunBag.pop();
			//while(this.m_xinghunZhuanBei.length>0)this.m_xinghunZhuanBei.pop();
			
			if(this._beiBaoData.length>0)_beiBaoData.splice(0,_beiBaoData.length);
			if(this._cangKuData.length>0)_cangKuData.splice(0,_cangKuData.length);
			if(this._zhuangBeiData.length>0)_zhuangBeiData.splice(0,_zhuangBeiData.length);

			
		}
		
		/**
		 * 获取技能选择框里可以装配的物品列表 
		 * @filterItemIds 过滤的物品id配置
		 * @return 
		 * 
		 */
		public function getItemsForSkillShort(filterItemIds:String = ""):Vector.<StructBagCell2>
		{
			var list:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
			var userLv:int = Data.myKing.king.level;
			var cell:StructBagCell2 = null;
			for each(var item:StructBagCell2 in _beiBaoData){
				if (filterItemIds.indexOf(item.itemid.toString())!=-1){
					if (item.level<=userLv){
						var exist:Boolean = false;
						for each (var c:StructBagCell2 in list){
							if (c.itemid == item.itemid){
								exist = true;
								c.num = c.num + item.num;
								break;
							}
						}
						if (exist==false){
							cell = new StructBagCell2();
							cell.itemid = item.itemid;
							cell.num = item.num;
							Data.beiBao.fillCahceData(cell);
							list.push(cell);
						}
					}
				}
			}
			return list;
		}
		
		/**
		 *	看角色身上是否有某件装备
		 *  2013-09-18 andy 
		 */
		public function isRoleHave(equipId:int=0):Boolean{
			var ret:Boolean=false;
			var arr:Array=this.getRoleEquipList();
			for each(var equip:StructBagCell2 in arr){
				if(equip.itemid==equipId){
					ret=true;
					break;
				}
			}
			return ret;
		}
	}
}




