package model.Chibang
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_WingResModel;
	
	import flash.events.EventDispatcher;
	
	import netc.Data;

	public class ChibangModel extends EventDispatcher
	{
		private static var m_instance:ChibangModel;
		
		private var m_wingArr:Array;
		private var m_wingXmlLen:int;
		private var m_maxSort:int;
		private var m_sortMaxM:Pub_WingResModel;
		public function ChibangModel()
		{
			init();
		}

	
		public static function getInstance():ChibangModel
		{
			if(null == m_instance)
			{
				m_instance = new ChibangModel();
			}
			
			return m_instance;
		}
	
		private function init():void
		{
			
			wingXmlLen =XmlManager.localres.getWingXml.xmlLength;
			wingArr= new Array();
			for (var t:int = 0;t<wingXmlLen;t++)
			{
				wingArr.push(XmlManager.localres.getWingXml.getResPath(t) as Pub_WingResModel);
			}
			
			getMaxSort();
		}
		private function getMaxSort():void
		{
			maxSort = wingArr[wingArr.length-1].wing_sort;
		}
		/**
		 *计算一阶中最大的等级 
		 * @param _sort
		 * @return 
		 */		
		public function getSortMaxModel(_sort:int):Pub_WingResModel
		{
			var arr:Array  = getSortArr(_sort);
			return arr[arr.length-1];
		}
		public function getNumOfStarLight(_wing:Pub_WingResModel):int
		{
			var arr:Array =  getSortArr(_wing.wing_sort);
			var k:int = 0;
			for each(var m:Pub_WingResModel in arr )
			{
				if(_wing.wing_lv>=m.wing_lv)
				{
					k++;
				}
			}
			if(_wing.wing_sort==1) k--;
			return k;
		}
		public function getSortArr(_sort:int):Array
		{
			var arr:Array = [];
			for each(var m:Pub_WingResModel in wingArr )
			{
				if(_sort==m.wing_sort){
					arr.push(m);
				}
			}
			return arr;
		}
		
		
		
		public function get wingArr():Array
		{
			return m_wingArr;
		}
		
		public function set wingArr(value:Array):void
		{
			m_wingArr = value;
		}
		public function get maxSort():int
		{
			return m_maxSort;
		}
		
		public function set maxSort(value:int):void
		{
			m_maxSort = value;
		}
		
		public function get wingXmlLen():int
		{
			return m_wingXmlLen;
		}
		
		public function set wingXmlLen(value:int):void
		{
			m_wingXmlLen = value;
		}


	}
}