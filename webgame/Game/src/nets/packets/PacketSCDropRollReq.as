package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *掉落拾取Roll点
    */
    public class PacketSCDropRollReq implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14043;
        /** 
        *拾取包id
        */
        public var objid:int;
        /** 
        *物品信息
        */
        public var itemtype:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(itemtype);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            itemtype = ar.readInt();
        }
    }
}
