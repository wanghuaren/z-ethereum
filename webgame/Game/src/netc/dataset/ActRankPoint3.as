package netc.dataset
{
	public class ActRankPoint3
	{
		
		/** 
		 *活动当前总积分
		 */
		public var cur_point_total:int;
		/** 
		 *活动昨天总积分
		 */
		public var prev_point_total:int;
		
		/**
		 * 各个分活动的数据
		 */ 
		public var pointList:Array;
		
		
		public function ActRankPoint3()
		{
			pointList = [];
			
			for(var j:int=1;j<=HuoDongSet.ACT_NUM;j++)
			{
				var p31:ActRankPoint31 = new ActRankPoint31();
				p31.actid = j;
				
				pointList.push(p31);
			}
			
		}
		
		public function getPrevPointByActId(act_id:int):int
		{
			var prev_point_by_actid:int;
			
			var len:int = pointList.length;
			for(var j:int =0;j<len;j++)
			{
				var actid_:int = pointList[j].actid;
				
				if(actid_ == act_id)
				{
					prev_point_by_actid = pointList[j].prev_point;
					
					break;
				}
			}
			
			return prev_point_by_actid;
			
		}
		
		public function getCurPointByActId(act_id:int):int
		{
			var cur_point_by_actid:int;
			
			var len:int = pointList.length;
			for(var j:int =0;j<len;j++)
			{
				if(pointList[j].actid == act_id)
				{
					cur_point_by_actid = pointList[j].cur_point;
				}
			}
			
			return cur_point_by_actid;
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
}