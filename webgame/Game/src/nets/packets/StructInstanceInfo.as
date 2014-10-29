package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructInstanceData2
    /** 
    *副本信息列表
    */
    public class StructInstanceInfo implements ISerializable
    {
        /** 
        *副本信息数据
        */
        public var arrIteminstancedata:Vector.<StructInstanceData2> = new Vector.<StructInstanceData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrIteminstancedata.length);
            for each (var instancedataitem:Object in arrIteminstancedata)
            {
                var objinstancedata:ISerializable = instancedataitem as ISerializable;
                if (null!=objinstancedata)
                {
                    objinstancedata.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrIteminstancedata= new  Vector.<StructInstanceData2>();
            var instancedataLength:int = ar.readInt();
            for (var iinstancedata:int=0;iinstancedata<instancedataLength; ++iinstancedata)
            {
                var objInstanceData:StructInstanceData2 = new StructInstanceData2();
                objInstanceData.Deserialize(ar);
                arrIteminstancedata.push(objInstanceData);
            }
        }
    }
}
