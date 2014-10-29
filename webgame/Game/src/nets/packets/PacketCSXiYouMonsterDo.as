package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *西游降魔
    */
    public class PacketCSXiYouMonsterDo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38127;
        /** 
        *1表示终极妖怪，0表示普通妖怪
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
