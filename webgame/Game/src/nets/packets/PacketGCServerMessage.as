package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *到网关的消息测试
    */
    public class PacketGCServerMessage implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 201;
        /** 
        *数据部分
        */
        public var arrItemdata:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemdata.length);
            for each (var dataitem:int in arrItemdata)
            {
                ar.writeInt(dataitem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemdata= new  Vector.<int>();
            var dataLength:int = ar.readInt();
            for (var idata:int=0;idata<dataLength; ++idata)
            {
                arrItemdata.push(ar.readInt());
            }
        }
    }
}
