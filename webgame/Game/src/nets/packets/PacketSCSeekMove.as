package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *指定路径移动
    */
    public class PacketSCSeekMove implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39925;
        /** 
        *1表示开始移动，0表示停止移动
        */
        public var flag:int;
        /** 
        *路径id
        */
        public var path:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
            ar.writeInt(path);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
            path = ar.readInt();
        }
    }
}
