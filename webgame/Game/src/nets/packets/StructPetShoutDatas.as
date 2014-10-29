package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPetShoutData2
    /** 
    *宠物喊话时间和类型
    */
    public class StructPetShoutDatas implements ISerializable
    {
        /** 
        *喊话开始时间
        */
        public var arrItemdatas:Vector.<StructPetShoutData2> = new Vector.<StructPetShoutData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemdatas.length);
            for each (var datasitem:Object in arrItemdatas)
            {
                var objdatas:ISerializable = datasitem as ISerializable;
                if (null!=objdatas)
                {
                    objdatas.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemdatas= new  Vector.<StructPetShoutData2>();
            var datasLength:int = ar.readInt();
            for (var idatas:int=0;idatas<datasLength; ++idatas)
            {
                var objPetShoutData:StructPetShoutData2 = new StructPetShoutData2();
                objPetShoutData.Deserialize(ar);
                arrItemdatas.push(objPetShoutData);
            }
        }
    }
}
