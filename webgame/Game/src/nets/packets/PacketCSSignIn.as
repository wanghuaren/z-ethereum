package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *签到
    */
    public class PacketCSSignIn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37001;
        /** 
        *0：签到 1补签
        */
        public var type:int;
        /** 
        *第几天
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            index = ar.readInt();
        }
    }
}
