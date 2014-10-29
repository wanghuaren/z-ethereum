package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *使用道具传送
    */
    public class PacketCSTeleportByUseItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53102;
        /** 
        *序号
        */
        public var index:int;
        /** 
        *标记，1表示使用道具，否则表示从NPC处传送
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
            flag = ar.readInt();
        }
    }
}
