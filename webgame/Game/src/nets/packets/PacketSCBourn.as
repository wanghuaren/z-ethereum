package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBourn2
    /** 
    *境界
    */
    public class PacketSCBourn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 27005;
        /** 
        *境界等级数据
        */
        public var arrItemdata:Vector.<StructBourn2> = new Vector.<StructBourn2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemdata.length);
            for each (var dataitem:Object in arrItemdata)
            {
                var objdata:ISerializable = dataitem as ISerializable;
                if (null!=objdata)
                {
                    objdata.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemdata= new  Vector.<StructBourn2>();
            var dataLength:int = ar.readInt();
            for (var idata:int=0;idata<dataLength; ++idata)
            {
                var objBourn:StructBourn2 = new StructBourn2();
                objBourn.Deserialize(ar);
                arrItemdata.push(objBourn);
            }
        }
    }
}
