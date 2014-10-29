package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *播放特效
    */
    public class PacketSCPlayEffect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39920;
        /** 
        *播放特效
        */
        public var effectid:int;
        /** 
        *1表示开始，0表示停止
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(effectid);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            effectid = ar.readInt();
            flag = ar.readInt();
        }
    }
}
