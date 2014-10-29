package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *资源名称刷新
    */
    public class PacketSCResNameUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39607;
        /** 
        *对象id
        */
        public var resid:int;
        /** 
        *新名称
        */
        public var newname:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(resid);
            PacketFactory.Instance.WriteString(ar, newname, 64);
        }
        public function Deserialize(ar:ByteArray):void
        {
            resid = ar.readInt();
            var newnameLength:int = ar.readInt();
            newname = ar.readMultiByte(newnameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
