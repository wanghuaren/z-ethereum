package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructAr_Sub_Point2
    /** 
    *成就分类点数数据
    */
    public class StructAr_Point implements ISerializable
    {
        /** 
        *成就点数
        */
        public var arrItemar_sub_point:Vector.<StructAr_Sub_Point2> = new Vector.<StructAr_Sub_Point2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemar_sub_point.length);
            for each (var ar_sub_pointitem:Object in arrItemar_sub_point)
            {
                var objar_sub_point:ISerializable = ar_sub_pointitem as ISerializable;
                if (null!=objar_sub_point)
                {
                    objar_sub_point.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemar_sub_point= new  Vector.<StructAr_Sub_Point2>();
            var ar_sub_pointLength:int = ar.readInt();
            for (var iar_sub_point:int=0;iar_sub_point<ar_sub_pointLength; ++iar_sub_point)
            {
                var objAr_Sub_Point:StructAr_Sub_Point2 = new StructAr_Sub_Point2();
                objAr_Sub_Point.Deserialize(ar);
                arrItemar_sub_point.push(objAr_Sub_Point);
            }
        }
    }
}
