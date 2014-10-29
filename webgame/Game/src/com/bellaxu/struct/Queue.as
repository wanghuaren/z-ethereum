package com.bellaxu.struct
{
	public class Queue
	{
		private var m_list:Array;
		
		//队列最大长度
		private var m_max:int;
		
		public function Queue(maxLength:int)
		{
			m_list = [];
			
			m_max = maxLength;
		}
		
		public function add(obj:Object):void
		{
			var _length:int = m_list.length;
			if(_length >= m_max)
			{
				m_list.shift();
			}
			
			m_list.push(obj);
		}
		
		public function getList():Array
		{
			return m_list;
		}
		
		public function clean():void
		{
			var _length:int = m_list.length;
			for(var i:int = 0 ;  i<_length ; ++i)
			{
				m_list[i] = null;
				delete m_list[i];
			}
			
			m_list = [];
		}
	}
}


