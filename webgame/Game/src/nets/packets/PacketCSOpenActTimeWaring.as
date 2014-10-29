package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家使用活动提示
    */
    public class PacketCSOpenActTimeWaring implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20039;
        /** 
        *活动id
        */
        public var act_id:int;
        /** 
        *活动tokenid
        */
        public var token:int;
        /** 
        *寻路id
        */
        public var seek_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(act_id);
            ar.writeInt(token);
            ar.writeInt(seek_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            act_id = ar.readInt();
            token = ar.readInt();
            seek_id = ar.readInt();
        }
    }
}
