// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSOmnichainAdapter.Setup.t.sol";

contract BridgePing is SMSOmnichainAdapterSetup {
    function testFuzz_ShouldBridgeSMSFromAtoB(uint256 amount) public {
        _checkFuzzAssumptions(amount);

        uint256 balanceBeforeA = sms.balanceOf(address(this));
        uint256 balanceBeforeB = sms2.balanceOf(address(this));
        uint256 totalSupplyABefore = sms.totalSupply();
        uint256 totalSupplyBBefore = sms2.totalSupply();

        _bridge(endPointB, adapter2, amount);

        uint256 balanceAfterA = sms.balanceOf(address(this));
        uint256 balanceAfterB = sms2.balanceOf(address(this));
        uint256 totalSupplyAAfter = sms.totalSupply();
        uint256 totalSupplyBAfter = sms2.totalSupply();

        assertEq(balanceAfterA, balanceBeforeA - amount);
        assertEq(balanceAfterB, balanceBeforeB + amount);
        assertEq(totalSupplyAAfter, totalSupplyABefore - amount);
        assertEq(totalSupplyBAfter, totalSupplyBBefore + amount);
    }

    function test_RevertIfCriticalPaused() public {
        Message memory bridgePayload = Message(addressToBytes32(address(1)), uint64(1));
        MessagingFee memory fee = MessagingFee(1, 1);

        smsDataHub.setPauseLevel(PauseLevel.Critical);
        vm.expectRevert(Base.Paused.selector);
        adapter.bridgePing(bridgePayload, LzMessageMetadata(1, "", address(1), fee));
    }

    function test_ShouldEmitEvent() public {
        Message memory message = Message(addressToBytes32(address(this)), uint64(1));
        MessagingFee memory fee =
            adapter.quoteSend(endPointB.eid(), message, adapter.defaultLzOptions(), false);
        LzMessageMetadata memory metadata =
            LzMessageMetadata(endPointB.eid(), adapter.defaultLzOptions(), address(this), fee);

        vm.expectEmit(false, false, false, false);
        emit ISMSOmnichainAdapter.BridgePing(bytes32(0), address(0), message, metadata);
        adapter.bridgePing{value: fee.nativeFee}(message, metadata);
    }
}
