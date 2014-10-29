package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *Npc传送列表
    */
    public class StructNpcTrans implements ISerializable
    {
        /** 
        *NPC传送列表
        */
        public var list_id:int;
        /** 
        *地图
        */
        public var map_id:int;
        /** 
        *传送点
        */
        public var send_id:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(list_id);
            ar.writeInt(map_id);
            ar.writeInt(send_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            list_id = ar.readInt();
            map_id = ar.readInt();
            send_id = ar.readInt();
        }
    }
}
