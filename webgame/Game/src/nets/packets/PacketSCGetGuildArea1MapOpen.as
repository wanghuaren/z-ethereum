package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取工会领地争夺地图开启情况返回
    */
    public class PacketSCGetGuildArea1MapOpen implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52214;
        /** 
        *地图id
        */
        public var arrItemmapid:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemmapid.length);
            for each (var mapiditem:int in arrItemmapid)
            {
                ar.writeInt(mapiditem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemmapid= new  Vector.<int>();
            var mapidLength:int = ar.readInt();
            for (var imapid:int=0;imapid<mapidLength; ++imapid)
            {
                arrItemmapid.push(ar.readInt());
            }
        }
    }
}
