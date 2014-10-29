package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *物品试穿
    */
    public class PacketCSTreasureShopTryOn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51505;
        /** 
        *物品IDs
        */
        public var arrItemitemids:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemitemids.length);
            for each (var itemidsitem:int in arrItemitemids)
            {
                ar.writeInt(itemidsitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitemids= new  Vector.<int>();
            var itemidsLength:int = ar.readInt();
            for (var iitemids:int=0;iitemids<itemidsLength; ++iitemids)
            {
                arrItemitemids.push(ar.readInt());
            }
        }
    }
}
