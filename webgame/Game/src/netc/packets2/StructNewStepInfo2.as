package netc.packets2
{
	import flash.utils.ByteArray;
	
	import nets.packets.StructNewStepInfo;
	
	public class StructNewStepInfo2 extends StructNewStepInfo
	{
		
		//表示 1000 - 1031
		public var data1:int ;
		
		//表示 1032 - 1063
		public var data2:int ;
		
		//表示 1064 - 1095
		public var data3:int ;
		
		//表示 1096 - 1127
		public var data4:int ;

		public function StructNewStepInfo2()
		{
			super();

		}
		
		override public function Serialize(ar:ByteArray):void
		{
			commid = data1;
			commstep = data2;
			specint = data3;
			specstep = data4;
			
			super.Serialize(ar);
			
		}
		
		
		override public function Deserialize(ar:ByteArray):void
		{
						
			super.Deserialize(ar);
			
			data1 = commid;
			data2 = commstep;
			data3 = specint;
			data4 = specstep;
		}
	}
}