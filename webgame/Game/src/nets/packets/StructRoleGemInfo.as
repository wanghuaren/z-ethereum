package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGemInfoPos2
    /** 
    *宝石信息
    */
    public class StructRoleGemInfo implements ISerializable
    {
        /** 
        *宝石列表
        */
        public var arrItemgems:Vector.<StructGemInfoPos2> = new Vector.<StructGemInfoPos2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemgems.length);
            for each (var gemsitem:Object in arrItemgems)
            {
                var objgems:ISerializable = gemsitem as ISerializable;
                if (null!=objgems)
                {
                    objgems.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemgems= new  Vector.<StructGemInfoPos2>();
            var gemsLength:int = ar.readInt();
            for (var igems:int=0;igems<gemsLength; ++igems)
            {
                var objGemInfoPos:StructGemInfoPos2 = new StructGemInfoPos2();
                objGemInfoPos.Deserialize(ar);
                arrItemgems.push(objGemInfoPos);
            }
        }
    }
}
