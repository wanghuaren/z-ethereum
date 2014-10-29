package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPetDBInfo2
    /** 
    *伙伴数据信息
    */
    public class Structpets implements ISerializable
    {
        /** 
        *当前出战宠物
        */
        public var curfight:int;
        /** 
        *3个伙伴栏状态
        */
        public var petslot:int;
        /** 
        *伙伴信息
        */
        public var arrItempets:Vector.<StructPetDBInfo2> = new Vector.<StructPetDBInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(curfight);
            ar.writeInt(petslot);
            ar.writeInt(arrItempets.length);
            for each (var petsitem:Object in arrItempets)
            {
                var objpets:ISerializable = petsitem as ISerializable;
                if (null!=objpets)
                {
                    objpets.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            curfight = ar.readInt();
            petslot = ar.readInt();
            arrItempets= new  Vector.<StructPetDBInfo2>();
            var petsLength:int = ar.readInt();
            for (var ipets:int=0;ipets<petsLength; ++ipets)
            {
                var objPetDBInfo:StructPetDBInfo2 = new StructPetDBInfo2();
                objPetDBInfo.Deserialize(ar);
                arrItempets.push(objPetDBInfo);
            }
        }
    }
}
