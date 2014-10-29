package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSkillItem2
    /** 
    *技能数据的数组
    */
    public class StructSkillList implements ISerializable
    {
        /** 
        *技能数组
        */
        public var arrItemskillItemList:Vector.<StructSkillItem2> = new Vector.<StructSkillItem2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemskillItemList.length);
            for each (var skillItemListitem:Object in arrItemskillItemList)
            {
                var objskillItemList:ISerializable = skillItemListitem as ISerializable;
                if (null!=objskillItemList)
                {
                    objskillItemList.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemskillItemList= new  Vector.<StructSkillItem2>();
            var skillItemListLength:int = ar.readInt();
            for (var iskillItemList:int=0;iskillItemList<skillItemListLength; ++iskillItemList)
            {
                var objSkillItem:StructSkillItem2 = new StructSkillItem2();
                objSkillItem.Deserialize(ar);
                arrItemskillItemList.push(objSkillItem);
            }
        }
    }
}
