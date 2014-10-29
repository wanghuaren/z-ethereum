package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSeekData2
    import netc.packets2.StructSeekData2
    /** 
    *自动寻路
    */
    public class PacketSCAutoSeek implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13006;
        /** 
        *终点
        */
        public var seek:StructSeekData2 = new StructSeekData2();
        /** 
        *中间点
        */
        public var arrItemdata:Vector.<StructSeekData2> = new Vector.<StructSeekData2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            seek.Serialize(ar);
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
            seek.Deserialize(ar);
            arrItemdata= new  Vector.<StructSeekData2>();
            var dataLength:int = ar.readInt();
            for (var idata:int=0;idata<dataLength; ++idata)
            {
                var objSeekData:StructSeekData2 = new StructSeekData2();
                objSeekData.Deserialize(ar);
                arrItemdata.push(objSeekData);
            }
        }
    }
}
