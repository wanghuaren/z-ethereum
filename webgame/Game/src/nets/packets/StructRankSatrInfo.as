package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructStarItemData2
    /** 
    *星魂排行榜数据
    */
    public class StructRankSatrInfo implements ISerializable
    {
        /** 
        *开启数量
        */
        public var number:int;
        /** 
        *伙伴ID，或者角色ID
        */
        public var pet_id:int;
        /** 
        *星魂
        */
        public var arrItempet_star:Vector.<StructStarItemData2> = new Vector.<StructStarItemData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(number);
            ar.writeInt(pet_id);
            ar.writeInt(arrItempet_star.length);
            for each (var pet_staritem:Object in arrItempet_star)
            {
                var objpet_star:ISerializable = pet_staritem as ISerializable;
                if (null!=objpet_star)
                {
                    objpet_star.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            number = ar.readInt();
            pet_id = ar.readInt();
            arrItempet_star= new  Vector.<StructStarItemData2>();
            var pet_starLength:int = ar.readInt();
            for (var ipet_star:int=0;ipet_star<pet_starLength; ++ipet_star)
            {
                var objStarItemData:StructStarItemData2 = new StructStarItemData2();
                objStarItemData.Deserialize(ar);
                arrItempet_star.push(objStarItemData);
            }
        }
    }
}
