package model.pkmatch
{
	import engine.utils.HashMap;
	import common.utils.Queue;
	
	/**
	 * PK 赛战报队列
	 * @author steven guo
	 * 
	 */	
	public class PKZhanBaoQueue
	{
		
		private var m_queue:Queue;
		
		private static const MAX_PK_NEWS_NUM:int = 20;
		
		//最新消息做一次缓存
		private var m_hashmap:HashMap;
		
		public function PKZhanBaoQueue(maxLength:int)
		{
			m_queue = new Queue(maxLength);
		}

		public function add(userid:int,username:String,oppid:int,oppname:String,coin:int,renown:int,msg_id:int,win:int):void
		{
			var _pkNews:PkNews = _getOneNewsObj();
			_pkNews.userid = userid;
			_pkNews.username = username;
			_pkNews.oppid = oppid;
			_pkNews.oppname = oppname;
			_pkNews.coin = coin;
			_pkNews.renown = renown;
			_pkNews.msg_id = msg_id;
			_pkNews.win = win;
			
			m_queue.add(_pkNews);
		}
		
		public function getList():Array
		{
			return m_queue.getList();
		}
		
		//当前对象ID
		private var _currentObjID:int = 0;
		private function _getOneNewsObj():PkNews
		{
			var _ret:PkNews = null;
			if(_currentObjID > MAX_PK_NEWS_NUM)
			{
				_currentObjID = 0;
			}
			
			_ret = _getOneNews(_currentObjID);
			
			++_currentObjID;
			
			return _ret;
		}

		private function _getOneNews(id:int):PkNews
		{
			if(null == m_hashmap)
			{
				m_hashmap = new HashMap();
			}
			
			if(m_hashmap.containsKey(id)){
				return m_hashmap.get(id);
			}else{
				var _item:PkNews = new PkNews();

				m_hashmap.put(id,_item);
				return _item;
			}
		}
		
	}
}


