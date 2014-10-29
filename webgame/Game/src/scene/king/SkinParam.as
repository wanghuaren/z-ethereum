package scene.king
{
	import common.managers.Lang;

	public class SkinParam
	{
		//12是血条上加了数字
		public static const HEAD_DISTANCE:int = 20;//15 //25;//20;
		
		/**
		 * 人物往下挪点，看起画面更居中
		 */ 
		public static const HUMAN_SKIN_DOWN:int = 10;//30;//80
		
		/**
		 * movie.rideHeight 
		 * 上马后整体上移
		 */ 
		public static const RIDE_UP:int = 40;
		
		
		public static const contentHeightByNPC:int = 110;
		/**
		 * 
		 */ 
		public static function contentHeight(metier:int):int
		{
			if(0 == metier)
			{
				return 102;
			
			}else if (1 == metier)
			{
				
				return 102;				
			}
			else if (2 == metier)
			{
				
				return 110;				
			}
			else if (3 == metier)
			{
				
				return 112;				
			}
			else if (4 == metier)
			{
				//法师
				return 110;
				
			}
			else if (5 == metier)
			{
				
				return 110;	
				
			}
			else if (6 == metier)
			{
				
				return 97;
				
			}
			
			return 110;
		}
		
		//
		public static const PKKING_RES:int = 31000074;
		
		public static const PK_KING_IN_FB_RES:int = 20202;
		
		//
		//public static const XI_YOU_FOLLOW_SKIN_LIST:Array = [31000031,31000029,31000030,31000028];
		public static function get XI_YOU_FOLLOW_SKIN_LIST():Array
		{
			
			var list:Array = Lang.getLabelArr("xi_you_follow_list");
			
			if(null == list || list.length == 0)
			{
				return [31000020,31000021,31000022,31000023];
			}
			
			return list;
		}
		
		
		public static function get XI_YOU_LEADER():int
		{
			
			var list:Array = Lang.getLabelArr("xi_you_leader");
			
			if(null == list || list.length == 0)
			{
				return 31000019;
			}
			
			return list[0];
		}
		
		
		public static function get XI_YOU():int
		{
			
			var list:Array = Lang.getLabelArr("xi_you");
			
			if(null == list || list.length == 0)
			{
				return 31000019;
			}
			
			return list[0];
		}
		
	}
}