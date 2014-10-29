package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructLimitData2
    /** 
    *角色限制数据
    */
    public class StructDBLimitData implements ISerializable
    {
        /** 
        *数据
        */
        public var arrItemlimitdata:Vector.<StructLimitData2> = new Vector.<StructLimitData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemlimitdata.length);
            for each (var limitdataitem:Object in arrItemlimitdata)
            {
                var objlimitdata:ISerializable = limitdataitem as ISerializable;
                if (null!=objlimitdata)
                {
                    objlimitdata.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlimitdata= new  Vector.<StructLimitData2>();
            var limitdataLength:int = ar.readInt();
            for (var ilimitdata:int=0;ilimitdata<limitdataLength; ++ilimitdata)
            {
                var objLimitData:StructLimitData2 = new StructLimitData2();
                objLimitData.Deserialize(ar);
                arrItemlimitdata.push(objLimitData);
            }
        }
    }
}
