// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "script/lib/SMSDeployer.sol";
import "script/lib/Create3Deployer.sol";

import "src/SMS.sol";
import "src/MMS.sol";
import "src/SMSOmnichainAdapter.sol";
import "src/SMSDataHub.sol";
import "src/extensions/Base.sol";

import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

import "test/_utils/LayerZeroDevtoolsHelper.sol";

contract BaseSetup is LayerZeroDevtoolsHelper {
    using SMSDeployer for address;

    uint96 public constant MINT_AMOUNT = 1e6;
    uint32 public constant ROUND_BP = 1e4;

    bytes public constant mockData = "mock";

    address public create3Factory;

    SMS public sms;
    MMS public mms;
    SMSDataHubMainChain public smsDataHub;
    SMSOmnichainAdapter public adapter;

    address public create3Factory2;

    SMS public sms2;
    SMSDataHub public smsDataHub2;
    SMSOmnichainAdapter public adapter2;

    address public user = makeAddr("user");

    uint32 twabPeriodLength = 1 days;

    function setUp() public virtual override {
        super.setUp();

        _beforeSetUp();
        _setUp();
        _afterSetUp();
    }

    function _setUp() internal virtual {
        create3Factory = Create3Deployer._deploy_create3Factory("SMS.CREATE3Factory");
        create3Factory2 = Create3Deployer._deploy_create3Factory("SMS.CREATE3Factory2");

        smsDataHub = SMSDataHubMainChain(
            create3Factory.deploy_SMSDataHubMainChain(address(this), address(this))
        );
        sms = SMS(create3Factory.deploy_SMS(address(smsDataHub)));
        mms = MMS(
            create3Factory.deploy_MMS(
                address(smsDataHub), twabPeriodLength, uint32(block.timestamp), ROUND_BP, 100 days
            )
        );
        adapter = SMSOmnichainAdapter(
            create3Factory.deploy_SMSOmnichainAdapter(address(smsDataHub), address(endPointA))
        );

        smsDataHub.setSMS(address(sms));
        smsDataHub.setMMS(address(mms));
        smsDataHub.setOmnichainAdapter(address(adapter));

        smsDataHub2 = SMSDataHub(create3Factory2.deploy_SMSDataHub(address(this), address(this)));
        sms2 = SMS(create3Factory2.deploy_SMS(address(smsDataHub2)));
        adapter2 = SMSOmnichainAdapter(
            create3Factory2.deploy_SMSOmnichainAdapter(address(smsDataHub2), address(endPointB))
        );

        smsDataHub2.setSMS(address(sms2));
        smsDataHub2.setOmnichainAdapter(address(adapter2));

        address[] memory adapters = new address[](2);
        adapters[0] = address(adapter);
        adapters[1] = address(adapter2);

        wireOApps(adapters);

        vm.deal(address(this), 1 ether);
        vm.deal(address(adapter), 1 ether);
        vm.deal(address(adapter2), 1 ether);

        sms.mint(address(this), MINT_AMOUNT, mockData);
        sms2.mint(address(this), MINT_AMOUNT, mockData);

        sms.approve(address(adapter), type(uint256).max);
        sms2.approve(address(adapter2), type(uint256).max);
        sms.approve(address(mms), type(uint256).max);

        // All tests math rely on ROUND_BP = x2 per round
        if (ROUND_BP != mms.BP_PRECISION()) {
            assertEq(ROUND_BP, mms.BP_PRECISION(), "ROUND_BP is not equal to MMS.BP_PRECISION");
        }
    }

    function _setLabels() internal {
        vm.label(address(sms), "SMS");
        vm.label(address(mms), "MMS");
        vm.label(address(smsDataHub), "SMSDataHub");
        vm.label(address(adapter), "SMSOmnichainAdapter");
        vm.label(address(endPointA), "EndPointA");
        vm.label(address(endPointB), "EndPointB");
        vm.label(address(this), "THIS");
        vm.label(address(user), "USER");

        vm.label(address(sms2), "SMS2");
        vm.label(address(smsDataHub2), "SMSDataHub2");
        vm.label(address(adapter2), "SMSOmnichainAdapter2");
    }

    function _beforeSetUp() internal virtual {}

    function _afterSetUp() internal virtual {}
}
