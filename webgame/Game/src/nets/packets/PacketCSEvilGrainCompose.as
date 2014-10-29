package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *宝石合成
    */
    public class PacketCSEvilGrainCompose implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34001;
        /** 
        *0不花元宝，1花元宝
        */
        public var type:int;
        /** 
        *合成id
        */
        public var makeId:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(makeId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            makeId = ar.readInt();
        }
    }
}
