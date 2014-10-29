package nets.packets
{
    import flash.utils.ByteArray;
    import nets.ipacket.ISerializable;
    import nets.ipacket.PacketFactory;
    /** 
    *��ɫ��Ϣ
    */
    public class StructVaraint implements ISerializable
    {
	/** 
        *
        */
	public var val:Object;


	public function Serialize(ar:ByteArray):void
	{
	}

        public function Deserialize(ar:ByteArray):void
        {
			var vt:int = ar.readByte();
			if (vt==1)
			{
				val = ar.readInt();
			}
			else if (vt==2)
			{
				var len:int = ar.readInt();
				val = ar.readMultiByte(len,PacketFactory.Instance.GetCharSet());
			}
        }
    }
}