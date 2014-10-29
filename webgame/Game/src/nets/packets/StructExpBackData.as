package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructExpBackItem2
    /** 
    *经验找回
    */
    public class StructExpBackData implements ISerializable
    {
        /** 
        *活动经验
        */
        public var arrItemexpBackData:Vector.<StructExpBackItem2> = new Vector.<StructExpBackItem2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemexpBackData.length);
            for each (var expBackDataitem:Object in arrItemexpBackData)
            {
                var objexpBackData:ISerializable = expBackDataitem as ISerializable;
                if (null!=objexpBackData)
                {
                    objexpBackData.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemexpBackData= new  Vector.<StructExpBackItem2>();
            var expBackDataLength:int = ar.readInt();
            for (var iexpBackData:int=0;iexpBackData<expBackDataLength; ++iexpBackData)
            {
                var objExpBackItem:StructExpBackItem2 = new StructExpBackItem2();
                objExpBackItem.Deserialize(ar);
                arrItemexpBackData.push(objExpBackItem);
            }
        }
    }
}
