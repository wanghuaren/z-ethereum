package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取始皇魔窟经验
    */
    public class PacketSCGetDenExpValue implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29202;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *经验
        */
        public var exp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(exp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            exp = ar.readInt();
        }
    }
}
