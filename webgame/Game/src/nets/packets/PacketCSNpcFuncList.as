package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *NPC功能列表
    */
    public class PacketCSNpcFuncList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 7000;
        /** 
        *NPC的实例ID
        */
        public var npcid:int;
        /** 
        *页数
        */
        public var page:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(npcid);
            ar.writeInt(page);
        }
        public function Deserialize(ar:ByteArray):void
        {
            npcid = ar.readInt();
            page = ar.readInt();
        }
    }
}
