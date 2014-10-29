package scene.king
{
	import scene.event.KingActionEnum;
	import scene.utils.MapCl;

	public class XiulianSkinByWin extends SkinByWin
	{
		public function XiulianSkinByWin()
		{
			super();
		}
		
		
		override public function setAction():void
		{
			if(null == this.getRole())
			{
				return;
			}
			
			var i:int;
			
			var ZT:String  = KingActionEnum.XL;
			
			var FX:String ="F1";
			
//			if(hasHorse)
//			{
//				ZT=KingActionEnum.ZOJ_DJ;
//				FX="F2";
//			}
			
			//只用设主显示
			MapCl.setFangXiang(this.getRole(), ZT, FX, null,0,null);
		}
	}
}