package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *宝石分解
    */
    public class PacketCSEvilGrainDisAssamble implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 34013;
        /** 
        *宝石位置数组
        */
        public var arrItemitemposs:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemitemposs.length);
            for each (var itempossitem:int in arrItemitemposs)
            {
                ar.writeInt(itempossitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitemposs= new  Vector.<int>();
            var itempossLength:int = ar.readInt();
            for (var iitemposs:int=0;iitemposs<itempossLength; ++iitemposs)
            {
                arrItemitemposs.push(ar.readInt());
            }
        }
    }
}
