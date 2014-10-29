package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *通知客户端地图事件发生
    */
    public class PacketSCWorldMapEvent implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 21003;
        /** 
        *事件类型
        */
        public var eventtype:int;
        /** 
        *参数1
        */
        public var param1:int;
        /** 
        *参数2
        */
        public var param2:int;
        /** 
        *参数3
        */
        public var param3:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(eventtype);
            ar.writeInt(param1);
            ar.writeInt(param2);
            ar.writeInt(param3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            eventtype = ar.readInt();
            param1 = ar.readInt();
            param2 = ar.readInt();
            param3 = ar.readInt();
        }
    }
}
