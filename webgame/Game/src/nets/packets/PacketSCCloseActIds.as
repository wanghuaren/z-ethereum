package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *查询活动开启状态返回
    */
    public class PacketSCCloseActIds implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38302;
        /** 
        *关闭的的运营活动编号
        */
        public var arrItemids:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemids.length);
            for each (var idsitem:int in arrItemids)
            {
                ar.writeInt(idsitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemids= new  Vector.<int>();
            var idsLength:int = ar.readInt();
            for (var iids:int=0;iids<idsLength; ++iids)
            {
                arrItemids.push(ar.readInt());
            }
        }
    }
}
