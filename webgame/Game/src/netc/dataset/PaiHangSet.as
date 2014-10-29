package netc.dataset
{
	import common.config.xmlres.XmlRes;
	
	import engine.net.dataset.VirtualSet;
	import netc.packets2.PacketWCRankList2;
	import netc.packets2.StructServerRank2;
	
	import engine.utils.HashMap;

	/**
	 *  排行数据
	 *  andy 2012-04-07
	 */
	public class PaiHangSet extends VirtualSet
	{
		private var map_paiHang:HashMap;
		private var item:StructServerRank2;
		private var i:int=0;
		//排行榜数据凌晨更新数据，客户端跟着更新
		public var arrIsUpdate:Array=[0,0,0,0,0,0,0,0,0,0,0,0,0];
		public function PaiHangSet(pz:HashMap)
		{
			refPackZone(pz);
			map_paiHang=new HashMap();
		}
		/**
		 *	设置数据 
		 */
		public function setData(p:PacketWCRankList2):void{
			arrIsUpdate[p.sort]=1;
			for each(item in p.arrItemdata){
				item.jobName=XmlRes.GetJobNameById(int(item.metier));
			}
			map_paiHang.put(p.sort,p.arrItemdata);
		}
		
		/**
		 * 
		 *	获得数据 
		 *  2013-01-30 andy 增加职业
		 */
		public function getData(sort:int,page:int=0,metier:String=""):Vector.<StructServerRank2>{
			page=page>10?10:page;
			var all:Vector.<StructServerRank2>=map_paiHang.get(sort);
			var allReal:Vector.<StructServerRank2>=null;
			//需要职业的挑出来
			if(metier!=""){
				allReal=new Vector.<StructServerRank2>;
				for each(item in all){
					if(item.metier==metier){
						allReal.push(item);
					}
				}
			}else{
				allReal=all;
			}
			if(page==0){
				return allReal;
			}else{			
				var ret:Vector.<StructServerRank2>=new Vector.<StructServerRank2>;
				var start:int=(page-1)*10;
				var end:int=page*10;
				if(allReal.length<end)end=allReal.length;
				for(var i:int=start;i<end;i++){
					ret.push(allReal[i]);
				}

				return ret;
			}
			
			
		}
	}
}