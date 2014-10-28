package engine.net.packet
{
	
	public class EncryptPacket
	{
		private static const m_cGlobalEncrypt:EncryptCode = new EncryptCode();
		private var m_nPos1:int = 0;
		private var m_nPos2:int = 0;
		
		public function EncryptPacket()
		{
		}
		
		public function Encrypt(data:int):int
		{
			try
			{
				data ^= m_cGlobalEncrypt.m_bufEncrypt1[m_nPos1];
				data ^= m_cGlobalEncrypt.m_bufEncrypt2[m_nPos2];
				if(++m_nPos1 >= 256)
				{
					m_nPos1 = 0;
					if(++m_nPos2 >= 256)
						m_nPos2 = 0;
				}
			}
			catch(e:Error)
			{
			}
			
			return data;
		}
	}
}