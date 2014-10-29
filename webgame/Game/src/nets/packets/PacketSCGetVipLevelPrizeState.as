package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPrizeStateData2
    /** 
    *至尊VIP奖励状态返回
    */
    public class PacketSCGetVipLevelPrizeState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53603;
        /** 
        *第0~9个，所有等级的一次性奖励；10~18 已经领取每日奖励的VIP等级
        */
        public var arrItemprize_state:Vector.<StructPrizeStateData2> = new Vector.<StructPrizeStateData2>();
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemprize_state.length);
            for each (var prize_stateitem:Object in arrItemprize_state)
            {
                var objprize_state:ISerializable = prize_stateitem as ISerializable;
                if (null!=objprize_state)
                {
                    objprize_state.Serialize(ar);
                }
            }
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemprize_state= new  Vector.<StructPrizeStateData2>();
            var prize_stateLength:int = ar.readInt();
            for (var iprize_state:int=0;iprize_state<prize_stateLength; ++iprize_state)
            {
                var objPrizeStateData:StructPrizeStateData2 = new StructPrizeStateData2();
                objPrizeStateData.Deserialize(ar);
                arrItemprize_state.push(objPrizeStateData);
            }
            tag = ar.readInt();
        }
    }
}
