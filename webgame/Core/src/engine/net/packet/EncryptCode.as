package engine.net.packet
{
	public class EncryptCode
	{
		// 3个随机数, 用于隐藏KEY。固定不变
		private static const AA:uint = 0x7E;
		private static const BB:uint = 0x33;
		private static const CC:uint = 0xA1;
		// 加解密用的Key
		private static const ENCRYPT_KEY1:uint = 0xa61fce5e; // A = 0x20, B = 0xFD, C = 0x07, first = 0x1F, key = a61fce5e
		private static const ENCRYPT_KEY2:uint = 0x443ffc04; // A = 0x7A, B = 0xCF, C = 0xE5, first = 0x3F, key = 443ffc04
		// 真正的Key
		public var m_bufEncrypt1:Array = new Array(256);
		public var m_bufEncrypt2:Array = new Array(256);
		
		public function EncryptCode()
		{
			Init();
		}
		
		private function Init():void
		{
			try
			{
				var a1:int = ((ENCRYPT_KEY1 >> 0) & 0xFF) ^ AA;
				var b1:int = ((ENCRYPT_KEY1 >> 8) & 0xFF) ^ BB;
				var c1:int = ((ENCRYPT_KEY1 >> 24)& 0xFF) ^ CC;
				var fst1:int =(ENCRYPT_KEY1 >> 16)& 0xFF;
				
				var a2:int = ((ENCRYPT_KEY2 >> 0) & 0xFF) ^ AA;
				var b2:int = ((ENCRYPT_KEY2 >> 8) & 0xFF) ^ BB;
				var c2:int = ((ENCRYPT_KEY2 >> 24)& 0xFF) ^ CC;
				var fst2:int =(ENCRYPT_KEY2 >> 16)& 0xFF;
				
				var i:int = 0;
				var nCode:int = fst1;
				for (i=0; i<256; i++)
				{
					m_bufEncrypt1[i] = nCode&0xFF;
					nCode = (a1*nCode*nCode + b1*nCode + c1) % 256;
				}
				
				nCode = fst2;
				for( i = 0; i < 256; i++)
				{
					m_bufEncrypt2[i] = nCode&0xFF;
					nCode = (a2*nCode*nCode + b2*nCode + c2) % 256;
				}
			}
			catch(e:Error)
			{
				
			}
		}
	}
}