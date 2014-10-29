package model.chengjiu
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.managers.Lang;
	
	import flash.events.EventDispatcher;
	
	import netc.DataKey;
	import netc.packets2.StructActInfo2;
	import netc.packets2.StructActRecInfo2;
	
	import nets.packets.PacketCSArList;
	import nets.packets.PacketCSGetArPrize;
	import nets.packets.PacketSCArChange;
	import nets.packets.PacketSCArList;
	import nets.packets.PacketSCGetArPrize;
	import nets.packets.StructActRecInfo;
	
	import ui.view.view4.chengjiu.Chengjiu_Change;

	/**
	 *<packet id="24002" name="CSArList" desc="获取成就列表" sort="1">
      <prop name="ar_type" type="3" length="0" desc=""/>
    </packet>

    
 
	 * @author Administrator
	 * 
	 */
	public class ChengjiuModel extends EventDispatcher
	{
		private var pubArr1:Array;
		private var pubArr2:Array;
		private var pubArr3:Array;
		private var pubArr4:Array;
		private var pubArr5:Array;
		private var pubMode:Pub_AchievementResModel;
		private static const NUM:int = 5;
		private static var m_instance:ChengjiuModel;
		public function ChengjiuModel()
		{
			DataKey.instance.register(PacketSCArList.id, chengjiuSCArList);
			DataKey.instance.register(PacketSCArChange.id, chengjiuSCArChange);
			var p:PacketCSArList = new PacketCSArList();
			p.ar_type =0;
			DataKey.instance.send(p);
			initZhanPao();
		}
		
	
///////////////////////////////////////////战袍数据//////////////////////////////////////////////////////////////////////////////////////////
		private var m_chengjiuzhanpaoArr:Array;
		private function initZhanPao():void
		{
			m_chengjiuzhanpaoArr = XmlManager.localres.getPubComposeXml.getzhanpaoByGroup(3)	as Array;
		}
		public function get chengjiuzhanpaoArr():Array
		{
			return m_chengjiuzhanpaoArr;
		}
		
		public function set chengjiuzhanpaoArr(value:Array):void
		{
			m_chengjiuzhanpaoArr = value;
		}
		/////////////////////////////////////以上     战袍数据////////////////////////////////////////////////////////////////////////////////////////////////////////
		public static function getInstance():ChengjiuModel
		{
			if(null == m_instance)
			{
				m_instance = new ChengjiuModel();
			}
			
			return m_instance;
		}

		public function getReward(idx:int):void
		{
			DataKey.instance.register(PacketSCGetArPrize.id,scGetArPrize);
			var p:PacketCSGetArPrize = new PacketCSGetArPrize();
			p.arid = idx;
			DataKey.instance.send(p);
		}
		private function scGetArPrize(p:PacketSCGetArPrize):void
		{
			var _p:PacketSCGetArPrize = p as PacketSCGetArPrize;
			
			if(0 != _p.tag)
			{
				Lang.showResult(_p);
				return ;
			}
		}
	/**	<packet id="24003" name="SCArList" desc="获取成就列表返回" sort="2">
			<prop name="actlist" type="126" length="32" desc="取成就列表返回"/>

		  </packet>*/
		private function chengjiuSCArList(p:PacketSCArList):void
		{
			var _p:PacketSCArList=p as PacketSCArList;
			arList = _p.actlist;
			rank  = _p.rank;
		}
		public function get hadChengjiuNum():int
		{
			var ix:int = 0;
			for(var n:int = 0;n<arList.arrItemactrecinfo.length;n++)
			{
				var ar:StructActRecInfo = arList.arrItemactrecinfo[n];
				if(ar.para1==1)
				{
					ix++;
				}
			}
			return ix;
		}
		private function chengjiuSCArChange(p:PacketSCArChange):void
		{
			var _p:PacketSCArChange=p as PacketSCArChange;
			info2 = p.info;
			if(arList==null)return;
			var　have:Boolean=false;
			for(var n:int = 0;n<arList.arrItemactrecinfo.length;n++)
			{
				var ar:StructActRecInfo = arList.arrItemactrecinfo[n];
				if(ar.arid ==info2.arid )
				{
					arList.arrItemactrecinfo[n]= info2;
					have=true;
					break;
				}
			}
			if(have==false){
				arList.arrItemactrecinfo.push(info2);
			}
			
			var _e:ChengjiuEvent = new ChengjiuEvent(ChengjiuEvent.CHENG_JIU_EVENT);
			_e.sort = ChengjiuEvent.CHENG_IUE_UPDATA;
			dispatchEvent(_e);
			
//			var hasValue:Boolean=false;
//			var hasValueIndex:int=0;
			
//			var len:int=arList.arrItemactrecinfo.length;
			if(info2.para1==1)
			{
				var parm:Pub_AchievementResModel=XmlManager.localres.AchievementXml.getResPath(info2.arid) as Pub_AchievementResModel;
				Chengjiu_Change.getInstance().chengjiuChangData(parm);
			}

			
			
		}
		private var m_info2:StructActRecInfo2;

		/***********成就信息******************/
		private var m_arList:StructActInfo2;
		public function get arList():StructActInfo2
		{
			return m_arList;
		}
		
		public function set arList(value:StructActInfo2):void
		{
			
			m_arList = value;
			var _e:ChengjiuEvent = new ChengjiuEvent(ChengjiuEvent.CHENG_JIU_EVENT);
			_e.sort = ChengjiuEvent.SET_MAIN_JIEMIAN;
			dispatchEvent(_e);
		}
		/**
		 *  
		 * @param arid
		 * @return 
		 * 
		 */		
		public function  getArById(arid:int):StructActRecInfo
		{
			if(arList==null)return null;
			var ret:StructActRecInfo=null;
			for each(var itemAct:StructActRecInfo in arList.arrItemactrecinfo)
			{
				if(itemAct.arid == arid)
				{
					ret=itemAct;
					break;
				}
			}
			return ret;
		}
		/*******************成就排名**************************/
		private var m_rank:int;
		public function get rank():int
		{
			return m_rank;
		}
		
		public function set rank(value:int):void
		{
			m_rank = value;
		}
		public function get info2():StructActRecInfo2
		{
			return m_info2;
		}
		
		public function set info2(value:StructActRecInfo2):void
		{
			m_info2 = value;
		}
	}
}