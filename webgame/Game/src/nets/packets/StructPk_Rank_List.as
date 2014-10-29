package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPk_Rank_Info2
    /** 
    *pk列表
    */
    public class StructPk_Rank_List implements ISerializable
    {
        /** 
        *玩家排名列表
        */
        public var arrItemrank_list:Vector.<StructPk_Rank_Info2> = new Vector.<StructPk_Rank_Info2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemrank_list.length);
            for each (var rank_listitem:Object in arrItemrank_list)
            {
                var objrank_list:ISerializable = rank_listitem as ISerializable;
                if (null!=objrank_list)
                {
                    objrank_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemrank_list= new  Vector.<StructPk_Rank_Info2>();
            var rank_listLength:int = ar.readInt();
            for (var irank_list:int=0;irank_list<rank_listLength; ++irank_list)
            {
                var objPk_Rank_Info:StructPk_Rank_Info2 = new StructPk_Rank_Info2();
                objPk_Rank_Info.Deserialize(ar);
                arrItemrank_list.push(objPk_Rank_Info);
            }
        }
    }
}
