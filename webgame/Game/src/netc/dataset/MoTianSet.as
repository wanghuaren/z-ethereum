package netc.dataset
{
	import common.utils.bit.BitUtil;
	
	import engine.net.dataset.VirtualSet;
	import engine.utils.HashMap;
	
	import netc.packets2.PacketSCInstanceRank2;
	import netc.packets2.StructInstanceRankPlayerInfo2;
	
	public class MoTianSet extends VirtualSet
	{
		/**
		 * 魔天阶数
		 */ 
		public const STEPS_NUM:int = 6;
		
		public const STEPS_OPEN_LVL:Array =  [
																				20,
																				40,
																				50,
																				60,
																				70,
																				80				
																			];
		
		//
		private var _list:MoTianInfo;
		
		private var _listStar:Array;
		
		private var _listInfo:Array;
		
		private var _npcId:int;
		
		/**
		 * 副本排行数据
		 */ 
		private var _instanceRankList:Vector.<PacketSCInstanceRank2>;
		
		public function MoTianSet(pz:HashMap)
		{
			refPackZone(pz);
			
			_listStar  = [];
			
			_listInfo = [];
			
			_list = new MoTianInfo(STEPS_NUM);
			
		}		
		
		public function mapStep(myLvl:int):int 
		{
			return _list.mapStep(myLvl,STEPS_OPEN_LVL);
		
		}
		
		//避免歧义，正常
		public function getStepInfoByStep(step:int):MoTianStepInfo
		{
		
			return _list.stepList.get(step) as MoTianStepInfo;	
			
		}
		
		
		public function getStarByStep(step:int):Array
		{ 
			var starArr:Array;
			var k:int;			
			
			for(k=0;k<_listStar.length;k++)
			{
				if(_listStar[k].req_step == step)
				{					
					var starK:int = _listStar[k].star;
					
															
					 starArr = [
						
						BitUtil.getOneToOne(starK,1,4),
						BitUtil.getOneToOne(starK,5,8),
						BitUtil.getOneToOne(starK,9,12),
						BitUtil.getOneToOne(starK,13,16),
						BitUtil.getOneToOne(starK,17,20),
						BitUtil.getOneToOne(starK,21,24),
						BitUtil.getOneToOne(starK,25,28),
					
					];
					
					return starArr;
				}
			}
			
			//
			starArr = [];
			for(k=0;k<7;k++)
			{
				starArr.push(0);
			}
			
			return starArr;
		}
		
		
		public function getInfoByStep(step:int):Array
		{ 
			var infoArr:Array;
			var k:int;			
			
			for(k=0;k<_listInfo.length;k++)
			{
				if(_listInfo[k].req_step == step)
				{	
					var fo:int = _listInfo[k].info;
					
					var foArr:Array = BitUtil.convertToBinaryArr(fo);
					
					infoArr = [
						
						foArr[0],
						foArr[1],
						foArr[2],
						foArr[3],
						foArr[4],
						foArr[5],
						foArr[6]
						
					];
					
					return infoArr;
				}
			}
			
			//
			infoArr = [];
			for(k=0;k<7;k++)
			{
				infoArr.push(0);
			}
			
			return infoArr;
		}

		public function get npcId():int
		{
			return _npcId;
		}

		public function set setNpcId(value:int):void
		{
			_npcId = value;
		}

		//------------------------------------------------
		
		
		
		//---------------------------------------------------
		
		public function get resetnum():int
		{
			return _list.resetnum;
		}
		
		//---------------------------------------------------------------------
		public function setStep(step_:int,level_:int):void
		{
			var value:MoTianStepInfo = new MoTianStepInfo();
			value.step = step_;
			value.level = level_;
			
			_list.stepList.put(step_,value);
		}

		public function set setResetnum(value:int):void
		{
			_list.resetnum= value;
		}
		
		public function setStar(step:int,star:int):void
		{
			for(var k:int=0;k<_listStar.length;k++)
			{
				if(_listStar[k].req_step == step)
				{
					_listStar[k].star = star;
					return;
				}
			}
			
			_listStar.push({"req_step":step,"star":star});		
		}
		
		
		public function setInfo(step:int,info:int):void
		{
			for(var k:int=0;k<_listInfo.length;k++)
			{
				if(_listInfo[k].req_step == step)
				{
					_listInfo[k].info = info;
					return;
				}
			}
			
			_listInfo.push({"req_step":step,"info":info});		
		}
		
		
		
		//------------------------------------------------------------------------------------------------
		
		/**
		 * 副本排行
		 */ 
		public function getInstanceRankList():Vector.<PacketSCInstanceRank2>
		{
			if(null == _instanceRankList)
			{
				_instanceRankList = new Vector.<PacketSCInstanceRank2>();
			}
			
			return _instanceRankList;
			
		}
				
		public function syncByInstanceRankList(p:PacketSCInstanceRank2):void
		{
			var i:int;
			var len:int;
			
			if(null == _instanceRankList)
			{
				_instanceRankList = new Vector.<PacketSCInstanceRank2>();
			}
			
			len = _instanceRankList.length;
			
			var find:Boolean = false;
			var Itemlist:Vector.<StructInstanceRankPlayerInfo2>;
			
			for(i=0;i<len;i++)
			{
				if(_instanceRankList[i].instanceid == p.instanceid)
				{
					Itemlist = new Vector.<StructInstanceRankPlayerInfo2>();
					
					_instanceRankList[i].arrItemlist = Itemlist.concat(p.arrItemlist);
					//_instanceRankList[i].camp.point1 = p.camp.point1;
					//_instanceRankList[i].camp.point2 = p.camp.point2;
					_instanceRankList[i].index = p.index;
					find = true;
					
					break;
				}
				
			}
			
			
			//
			if(!find)
			{
				var scp:PacketSCInstanceRank2 = new PacketSCInstanceRank2();
				scp.instanceid = p.instanceid;
				Itemlist = new Vector.<StructInstanceRankPlayerInfo2>();
				scp.arrItemlist = Itemlist.concat(p.arrItemlist);
				//scp.camp.point1 = p.camp.point1;
				//scp.camp.point2 = p.camp.point2;
				scp.index = p.index;
				
				_instanceRankList.push(scp);
			}
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}