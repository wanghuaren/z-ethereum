package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取寻宝信息
    */
    public class PacketSCDiscoveringTreasureInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43204;
        /** 
        *幸运度
        */
        public var lucky:int;
        /** 
        *抽奖物品类型ID
        */
        public var itemid1:int;
        /** 
        *抽奖物品数量
        */
        public var num1:int;
        /** 
        *幸运度物品类型ID
        */
        public var itemid2:int;
        /** 
        *幸运度物品数量
        */
        public var num2:int;
        /** 
        *幸运度领取阶数(1~6) 6:表示已全部领完
        */
        public var item2lvl:int;
        /** 
        *能否领取幸运度奖励
        */
        public var flag:int;
        /** 
        *真实物品的位置 1~3对应界面上的3块位置
        */
        public var pos:int;
        /** 
        *客户端随机用的种子
        */
        public var seed:int;
        /** 
        *积分
        */
        public var grade:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(lucky);
            ar.writeInt(itemid1);
            ar.writeInt(num1);
            ar.writeInt(itemid2);
            ar.writeInt(num2);
            ar.writeByte(item2lvl);
            ar.writeByte(flag);
            ar.writeByte(pos);
            ar.writeInt(seed);
            ar.writeInt(grade);
        }
        public function Deserialize(ar:ByteArray):void
        {
            lucky = ar.readInt();
            itemid1 = ar.readInt();
            num1 = ar.readInt();
            itemid2 = ar.readInt();
            num2 = ar.readInt();
            item2lvl = ar.readByte();
            flag = ar.readByte();
            pos = ar.readByte();
            seed = ar.readInt();
            grade = ar.readInt();
        }
    }
}
