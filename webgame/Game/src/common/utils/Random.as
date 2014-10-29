package common.utils
{
	
	public class Random
	{
		private const MAX_RATIO:Number = 1 / uint.MAX_VALUE;
		private var r:uint;
		
		public function Random(seed:uint)
		{
			r = seed;
		}
		
		public function getNext():Number
		{
			r ^= (r<<21);
			r ^= (r>>>35);
			r ^= (r<<4);
			return (r*MAX_RATIO);
		}
	}
	
	
}