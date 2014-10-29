package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCardData2
    /** 
    *获取已有卡片
    */
    public class PacketSCGetCard implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38001;
        /** 
        *卡片信息数组
        */
        public var arrItemcard:Vector.<StructCardData2> = new Vector.<StructCardData2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemcard.length);
            for each (var carditem:Object in arrItemcard)
            {
                var objcard:ISerializable = carditem as ISerializable;
                if (null!=objcard)
                {
                    objcard.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemcard= new  Vector.<StructCardData2>();
            var cardLength:int = ar.readInt();
            for (var icard:int=0;icard<cardLength; ++icard)
            {
                var objCardData:StructCardData2 = new StructCardData2();
                objCardData.Deserialize(ar);
                arrItemcard.push(objCardData);
            }
        }
    }
}
