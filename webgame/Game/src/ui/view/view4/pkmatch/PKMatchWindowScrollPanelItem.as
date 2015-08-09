package ui.view.view4.pkmatch
{
	import flash.display.Sprite;
	
	import model.pkmatch.PkNews;
	
	import common.managers.Lang;
	
	public class PKMatchWindowScrollPanelItem extends Sprite
	{
		private static const MAX_SCROLLPANEL_NUM:int = 10;
		
		private static const NEWS_SORT_BYE:int = 1;           //轮空
		private static const NEWS_SORT_WIN:int = 2;           //获胜
		private static const NEWS_SORT_LOST:int = 3;          //失败
		private static const NEWS_SORT_ALL_WIN:int = 4;       //连胜
		private static const NEWS_SORT_FLEE:int = 5;          //逃跑
		private static const NEWS_SORT_NO_OPP_WIN:int = 6;    //平局
		
		private var m_ui:Sprite;
		
		private var m_value:PkNews = null;
		
		public function PKMatchWindowScrollPanelItem(ui:Sprite)
		{
			super();
			
			m_ui = ui;
			addChild(m_ui);
		}
		
		public function setPKNews(data:PkNews):void
		{
			m_value = data;
			var _arrWord:Array = Lang.getLabelArr("arrPKMatch");
			var _str:String =  "["+m_value.username+"]"+_arrWord[12];
			
			
			
			
			switch(m_value.msg_id)
			{
				case NEWS_SORT_BYE:
					_str += _arrWord[1];
					break;
				case NEWS_SORT_WIN:
					_str += _arrWord[2];
					break;
				case NEWS_SORT_LOST:
					_str += _arrWord[3];
					break;
				case NEWS_SORT_ALL_WIN:
					//谁谁 击败了 谁谁 ，连胜 X 次
					_str += _arrWord[13]+m_value.oppname+","+ _arrWord[4] + m_value.win + _arrWord[0];
					break;
				case NEWS_SORT_FLEE:
					_str += _arrWord[5];
					break;
				case NEWS_SORT_NO_OPP_WIN:
					_str += _arrWord[6];
					break;
				default:
					break;
			}
			
			//获得银两
			if(m_value.coin >= 1)
			{
				_str += "，"+_arrWord[14]+""+m_value.coin+_arrWord[15];
			}
			
			//获得声望
			if(m_value.renown >= 1)
			{
				_str += "，"+_arrWord[14]+""+m_value.renown+_arrWord[16];
			}
			
			m_ui['tf'].htmlText =_str;
			
					}
		
		
		
	}
}

