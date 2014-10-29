package scene.kingname
{
	import flash.geom.Point;
	
	/**
	 * 指定在数组中的数组索引
	 * 不可重复哦
	 */ 
	public class KingNameParam
	{
		public static const GongNengHeadIndex:int = 0;
		
		public static const AutoPathHeadIndex:int = 1;
		
		public static const AutoFightHeadIndex:int = 2;		
		
		public static const TeamFlagHeadIndex:int = 3;
		
		public static const TaskHeadIndex:int = 4;
		
		public static const ShopHeadIndex:int = 5;
		
		public static const ChengHaoHeadIndex:int = 6;
		
		//public static const VipHeadIndex:int = 7;
		public static const YellowVipHeadIndex:int = 7;
		
		public static const BuffHeadIndex:int = 8;
		
		public static const BloodHeadIndex:int = 9;
		
		public static const ChatHeadIndex:int = 10;
		
		public static const PkHeadIndex:int = 11
		
		public static const LoadingHeadIndex:int = 12;
		
		
		public static function get TxtNameHeadIndex():int
		{
			return 13;
		}
		
		//默认坐标
		public static const GongNengHeadPoint:Point = new Point(0,-62);		
		public static const AutoPathHeadPoint:Point = new Point(-45,-53);//(-48,-38);
		public static const AutoFightHeadPoint:Point = new Point(-96,-60);//-68);//
		public static const TeamFlagHeadPoint:Point = new Point(0,-42);		
		public static const TaskHeadPoint:Point = new Point(-50,-128);		
		public static const ShopHeadPoint:Point = new Point(0,-14);		
		//public static const ChengHaoHeadPoint:Point = new Point(-70,-70);		
		//public static const ChengHaoHeadPoint:Point = new Point(-70,-36);		
		
		//
		//public static const ChengHaoHeadPoint:Point = new Point(-65,-56);	
		public static const ChengHaoHeadPoint:Point = new Point(-65,-5);
		
		//public static const TxtNameHeadPoint:Point = new Point(0,-30);
		//因为是底，所以坐标0,0，上面都是相对于TxtNameHeadPoint
		public static const VipHeadPoint:Point = new Point(3,-122);	
		public static const BuffHeadPoint:Point = new Point(0,-50);	
		
		//如图，人物头顶血条偏上
		
		//预期：调整人物头顶血条及名称位置
		//public static const BloodHeadPoint:Point = new Point(-20,2);	
		public static const BloodHeadPoint:Point = new Point(-20,6);	
		
		public static const ChatHeadPoint:Point = new Point(0,-80);
		public static const TxtNameHeadPoint:Point = new Point(0,0);
		
		public static const LoadingHeadPoint:Point = new Point(0,-68);
		
		public static const MenuHeadPoint:Point = new Point(0,-20);		
		
		/**
		 * 血条默认宽度
		 */ 
		public static const BLOOD_RED_BAR_WIDTH:int = 56;//66;//70		
		public static const BLOOD_RED_BAR_BOSS_WIDTH:int = 100;
		
		/**
		 * 总数
		 */ 
		public static function get total_count():int
		{
			return TxtNameHeadIndex;
		}
		
		
	}
}