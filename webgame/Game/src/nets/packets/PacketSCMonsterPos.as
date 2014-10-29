package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取当前场景怪位置
    */
    public class PacketSCMonsterPos implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14037;
        /** 
        *坐标x
        */
        public var posx:int;
        /** 
        *坐标y
        */
        public var posy:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(posx);
            ar.writeInt(posy);
        }
        public function Deserialize(ar:ByteArray):void
        {
            posx = ar.readInt();
            posy = ar.readInt();
        }
    }
}
