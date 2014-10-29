package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得玩家pk列表数据
    */
    public class PacketCWGetPlayerPkList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20064;
        /** 
        *页数
        */
        public var page:int;
        /** 
        *阵营 2 太乙 3通天
        */
        public var camp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(page);
            ar.writeInt(camp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            page = ar.readInt();
            camp = ar.readInt();
        }
    }
}
