package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBourn2
    /** 
    *境界
    */
    public class StructBournList implements ISerializable
    {
        /** 
        *境界
        */
        public var arrItembourn:Vector.<StructBourn2> = new Vector.<StructBourn2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItembourn.length);
            for each (var bournitem:Object in arrItembourn)
            {
                var objbourn:ISerializable = bournitem as ISerializable;
                if (null!=objbourn)
                {
                    objbourn.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItembourn= new  Vector.<StructBourn2>();
            var bournLength:int = ar.readInt();
            for (var ibourn:int=0;ibourn<bournLength; ++ibourn)
            {
                var objBourn:StructBourn2 = new StructBourn2();
                objBourn.Deserialize(ar);
                arrItembourn.push(objBourn);
            }
        }
    }
}
